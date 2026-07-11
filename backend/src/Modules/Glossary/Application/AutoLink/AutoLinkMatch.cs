namespace SpecPour.Modules.Glossary.Application.AutoLink;

/// <summary>
/// One resolved auto-link (T039/FR-027): <see cref="Start"/>/<see cref="Length"/>
/// locate the matched span in the content string the caller supplied, so the
/// client can render an anchor there and — since it already has the departure
/// position — implement "return navigation to the exact departure point" (FR-027)
/// without the server needing to track navigation state.
/// </summary>
public sealed record AutoLinkMatch(int Start, int Length, Guid TermId, string Term);
