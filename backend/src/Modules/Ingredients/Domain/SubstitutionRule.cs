namespace SpecPour.Modules.Ingredients.Domain;

/// <summary>
/// data-model.md SubstitutionRule (FR-013): a curated, ONE-WAY suitability note —
/// <see cref="FromIngredientId"/> is the originally-specified/required ingredient,
/// <see cref="ToIngredientId"/> is what a curator says may stand in for it (e.g.
/// From=Wray &amp; Nephew 17, To=Smith &amp; Cross: Smith &amp; Cross approximates the
/// discontinued Wray 17, not the reverse). **Directional, never symmetric** — a row
/// does not imply its own reverse; a genuinely bidirectional pair needs two rows,
/// each with its own (possibly different) <see cref="SuitabilityNote"/>, since
/// suitability is rarely equally good both ways. Enforced in the matcher's
/// traversal: <c>IIngredientLookupPort.GetSubstitutesForAsync</c> queries only by
/// <see cref="FromIngredientId"/>, never <see cref="ToIngredientId"/> — see
/// <c>MakeabilityCalculatorSubstitutionDirectionTests</c> for the one-way-doesn't-
/// match-backward proof.
///
/// Distinct from hierarchy-implied matching (descendant satisfies ancestor,
/// resolved at read time from <see cref="Ingredient.ParentId"/>, never stored here):
/// per statement §2's match-quality ladder, a descendant satisfying its ancestor is
/// a TRUE MATCH (class-satisfied), never a substitution — this table is only for
/// curated sideways/upward substitution between otherwise-unrelated ingredients.
/// </summary>
public sealed class SubstitutionRule
{
    public required Guid Id { get; init; }

    public required Guid FromIngredientId { get; init; }

    public required Guid ToIngredientId { get; init; }

    public required string SuitabilityNote { get; set; }
}
