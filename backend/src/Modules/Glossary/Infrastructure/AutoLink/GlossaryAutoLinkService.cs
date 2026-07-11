using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using SpecPour.Modules.Glossary.Application.AutoLink;
using SpecPour.Modules.Glossary.Domain;

namespace SpecPour.Modules.Glossary.Infrastructure.AutoLink;

/// <summary>
/// T039's implementation: first occurrence per page, longest-match, curator
/// overrides honored (FR-027). Best-effort automated matching — curator override
/// is the escape hatch for anything the algorithm gets wrong, per FR-027's own
/// wording ("matching is best-effort automated with curator override").
/// </summary>
public sealed class GlossaryAutoLinkService(GlossaryDbContext db) : IGlossaryAutoLinkService
{
    public async Task<IReadOnlyList<AutoLinkMatch>> ResolveLinksAsync(string context, string content, CancellationToken cancellationToken)
    {
        var overrides = await db.LinkOverrides.Where(o => o.Context == context).ToListAsync(cancellationToken);
        var suppressedTermIds = overrides.Where(o => o.Action == LinkOverrideAction.Suppress).Select(o => o.TermId).ToHashSet();

        // Force doesn't need special-case matching logic: it's the mirror image of
        // Suppress (a curator saying "yes, definitely link this term here" rather
        // than "never link this term here"), and every non-suppressed term is
        // already a matching candidate — there's no separate manual-authoring path
        // to force a link that the automated pass structurally couldn't find
        // (FR-027: "users never manually create links"). It's tracked here purely
        // so a future stricter matching heuristic (e.g. a minimum-confidence
        // threshold) has an explicit "always include" override point to consult.
        var candidateTerms = await db.GlossaryTerms
            .Where(t => !suppressedTermIds.Contains(t.Id) && t.Term.Length > 0)
            .Select(t => new CandidateTerm(t.Id, t.Term))
            .ToListAsync(cancellationToken);

        return ResolveMatches(candidateTerms, content);
    }

    /// <summary>
    /// The pure matching algorithm (longest-match-wins, first-occurrence-per-term),
    /// separated from <see cref="ResolveLinksAsync"/>'s database I/O so it's
    /// unit-testable without a real Postgres instance.
    /// </summary>
    public static IReadOnlyList<AutoLinkMatch> ResolveMatches(IReadOnlyList<CandidateTerm> candidateTerms, string content)
    {
        var claimedSpans = new List<(int Start, int End)>();
        var matches = new List<AutoLinkMatch>();

        foreach (var term in candidateTerms.OrderByDescending(t => t.Term.Length))
        {
            var regex = WordBoundaryRegex(Regex.Escape(term.Term));
            var match = regex.Match(content);
            if (!match.Success)
            {
                continue;
            }

            var start = match.Index;
            var end = start + match.Length;
            if (claimedSpans.Any(span => start < span.End && end > span.Start))
            {
                // Overlaps a longer term's already-claimed span — longest-match wins.
                continue;
            }

            claimedSpans.Add((start, end));
            matches.Add(new AutoLinkMatch(start, match.Length, term.Id, term.Term));
        }

        return [.. matches.OrderBy(m => m.Start)];
    }

    private static Regex WordBoundaryRegex(string escapedTerm) =>
        new($@"(?<![\p{{L}}\p{{N}}]){escapedTerm}(?![\p{{L}}\p{{N}}])", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
}

/// <summary>A term eligible to be auto-linked, stripped of everything but what the matching algorithm needs.</summary>
public sealed record CandidateTerm(Guid Id, string Term);
