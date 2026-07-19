using SpecPour.Modules.Catalog.Contracts;
using SpecPour.Modules.Ingredients.Contracts;
using SpecPour.Modules.Inventory.Application.Makeability;

namespace SpecPour.Tests.Unit.Modules.Inventory;

/// <summary>
/// T067 closeout (John's 2026-07-19 confirmation request): proves curated
/// substitution is genuinely one-way — a <c>SubstitutionRule</c> row (From=A, To=B)
/// lets a held B satisfy a recipe requiring A, but a held A must NOT satisfy a
/// recipe requiring B, since no reverse rule exists. See
/// <see cref="SpecPour.Modules.Ingredients.Domain.SubstitutionRule"/>'s own doc
/// comment for the direction convention this asserts.
/// </summary>
public sealed class MakeabilityCalculatorSubstitutionDirectionTests
{
    [Fact]
    public async Task AForwardSubstitutionRuleSatisfiesTheRequiredIngredient()
    {
        var (requiredIngredient, substituteIngredient) = (Guid.NewGuid(), Guid.NewGuid());
        var calculator = new MakeabilityCalculator(new FakeIngredientLookupPort(requiredIngredient, substituteIngredient));

        var heldSubstitute = new List<(Guid, Guid)> { (Guid.NewGuid(), substituteIngredient) };
        var recipeRequiringOriginal = new RecipeMakeabilityInfo(
            Guid.NewGuid(), "Requires the original", [new RecipeIngredientLineInfo(requiredIngredient, 1m, "oz")]);

        var result = await calculator.ComputeAsync(heldSubstitute, [recipeRequiringOriginal], CancellationToken.None);

        var makeable = Assert.Single(result.Makeable);
        Assert.Equal("substitution", makeable.MatchQuality);
        Assert.Empty(result.NearMiss);
    }

    [Fact]
    public async Task AOneWaySubstitutionRuleDoesNotMatchBackward()
    {
        var (requiredIngredient, substituteIngredient) = (Guid.NewGuid(), Guid.NewGuid());
        var calculator = new MakeabilityCalculator(new FakeIngredientLookupPort(requiredIngredient, substituteIngredient));

        // Held item is the ORIGINAL (the "From" side); recipe requires the
        // SUBSTITUTE (the "To" side) — the reverse of the curated rule. Since no
        // rule for (From=substitute, To=original) exists, this must NOT resolve.
        var heldOriginal = new List<(Guid, Guid)> { (Guid.NewGuid(), requiredIngredient) };
        var recipeRequiringSubstitute = new RecipeMakeabilityInfo(
            Guid.NewGuid(), "Requires the substitute", [new RecipeIngredientLineInfo(substituteIngredient, 1m, "oz")]);

        var result = await calculator.ComputeAsync(heldOriginal, [recipeRequiringSubstitute], CancellationToken.None);

        Assert.Empty(result.Makeable);
        // Missing exactly one (of one) line — within the near-miss threshold, so it
        // surfaces as a near-miss naming the still-unsatisfied line, not silently
        // absent — which is itself proof the reverse direction found no match.
        var nearMiss = Assert.Single(result.NearMiss);
        var line = Assert.Single(nearMiss.Lines);
        Assert.Equal("missing", line.MatchQuality);
        Assert.Null(line.SatisfiedByIngredientId);
    }

    /// <summary>Only descendant-of-self (no hierarchy) so the class-satisfied path never fires — isolates this test to the curated-substitution path alone.</summary>
    private sealed class FakeIngredientLookupPort(Guid requiredIngredient, Guid substituteIngredient) : IIngredientLookupPort
    {
        public Task<IReadOnlyDictionary<Guid, IngredientSummary>> GetSummariesAsync(IReadOnlyCollection<Guid> ingredientIds, CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyDictionary<Guid, IngredientSummary>>(new Dictionary<Guid, IngredientSummary>());

        public Task<IReadOnlyList<Guid>> GetDescendantIdsAsync(Guid ingredientId, CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<Guid>>([ingredientId]);

        public Task<IReadOnlyList<SubstitutionCandidate>> GetSubstitutesForAsync(Guid requiredIngredientId, CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<SubstitutionCandidate>>(
                requiredIngredientId == requiredIngredient
                    ? [new SubstitutionCandidate(substituteIngredient, "Test-only one-way rule.")]
                    : []);
    }
}
