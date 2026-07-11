using SpecPour.Modules.Glossary.Infrastructure.AutoLink;

namespace SpecPour.Tests.Unit.Modules.Glossary;

/// <summary>T039: unit coverage for the pure matching core (see GlossaryAutoLinkService.ResolveMatches's doc comment for why it's separated from the DB-touching method).</summary>
public sealed class GlossaryAutoLinkServiceTests
{
    [Fact]
    public void LongerOverlappingTermWinsOverShorterOne()
    {
        var agricole = Guid.NewGuid();
        var rhum = Guid.NewGuid();
        var terms = new List<CandidateTerm> { new(rhum, "Rhum"), new(agricole, "Rhum Agricole") };

        var matches = GlossaryAutoLinkService.ResolveMatches(terms, "This recipe uses Rhum Agricole from Martinique.");

        var match = Assert.Single(matches);
        Assert.Equal(agricole, match.TermId);
        Assert.Equal("Rhum Agricole", match.Term);
    }

    [Fact]
    public void OnlyTheFirstOccurrenceOfATermIsLinked()
    {
        var termId = Guid.NewGuid();
        var terms = new List<CandidateTerm> { new(termId, "orgeat") };

        var matches = GlossaryAutoLinkService.ResolveMatches(terms, "Orgeat is an almond syrup. Add orgeat last.");

        var match = Assert.Single(matches);
        Assert.Equal(0, match.Start);
    }

    [Fact]
    public void PartialWordMatchesAreNotLinked()
    {
        // "rum" must not match inside "serum" — word-boundary matching, not substring.
        var terms = new List<CandidateTerm> { new(Guid.NewGuid(), "rum") };

        var matches = GlossaryAutoLinkService.ResolveMatches(terms, "The bitters have a serum-like texture.");

        Assert.Empty(matches);
    }

    [Fact]
    public void MatchingIsCaseInsensitive()
    {
        var termId = Guid.NewGuid();
        var terms = new List<CandidateTerm> { new(termId, "muddle") };

        var matches = GlossaryAutoLinkService.ResolveMatches(terms, "MUDDLE the mint gently.");

        var match = Assert.Single(matches);
        Assert.Equal(termId, match.TermId);
    }

    [Fact]
    public void NonOverlappingTermsBothMatch()
    {
        var shakeId = Guid.NewGuid();
        var strainId = Guid.NewGuid();
        var terms = new List<CandidateTerm> { new(shakeId, "shake"), new(strainId, "strain") };

        var matches = GlossaryAutoLinkService.ResolveMatches(terms, "Shake well, then strain into a chilled glass.");

        Assert.Equal(2, matches.Count);
        Assert.Equal(shakeId, matches[0].TermId);
        Assert.Equal(strainId, matches[1].TermId);
    }
}
