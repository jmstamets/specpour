namespace SpecPour.BuildingBlocks.Library;

/// <summary>
/// data-model.md's recurring "visibility (private/public, reversible toggle)" shape,
/// shared by Recipe, Ingredient, and Equipment (ADR-0001). Named
/// <c>ContentVisibility</c> rather than <c>Visibility</c> to avoid colliding with the
/// many framework/BCL types already named "Visibility".
/// </summary>
public enum ContentVisibility
{
    Private,
    Public,
}
