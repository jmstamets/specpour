namespace SpecPour.Modules.Catalog.Domain;

/// <summary>
/// data-model.md Category (curator-managed taxonomy, FR-019): multi-valued serving
/// style/format (buck, collins, fizz, cooler, colada, daisy, punch, etc.) on Recipe,
/// joined via <see cref="RecipeCategory"/>.
/// </summary>
public sealed class Category
{
    public required Guid Id { get; init; }

    public required string NameKey { get; init; }

    public required string Definition { get; set; }
}
