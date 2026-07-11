namespace SpecPour.Modules.Glossary.Application.AutoLink;

/// <summary>
/// T039/FR-027: glossary auto-linking is computed at render time from the live
/// term list — never stored (matches LinkOverride's own doc comment: "Auto-links
/// themselves are computed at render, not stored").
/// </summary>
public interface IGlossaryAutoLinkService
{
    /// <summary>
    /// Resolves auto-link matches within <paramref name="content"/>.
    /// <paramref name="context"/> identifies the page/content this text belongs to
    /// (matches <c>LinkOverride.Context</c>) so curator suppress/force overrides
    /// scoped to that specific page apply, not just globally.
    /// </summary>
    Task<IReadOnlyList<AutoLinkMatch>> ResolveLinksAsync(string context, string content, CancellationToken cancellationToken);
}
