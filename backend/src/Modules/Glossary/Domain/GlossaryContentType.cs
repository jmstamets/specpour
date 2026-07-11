namespace SpecPour.Modules.Glossary.Domain;

/// <summary>
/// The three content kinds a <see cref="GlossaryTermContentLink"/> or
/// <see cref="ArticleContentLink"/> can point at (FR-025/FR-026): recipes, ingredients,
/// and equipment, each in its own module schema. A single polymorphic link table per
/// source (rather than three separate join tables per link direction) keeps the
/// table count down while still being a real relational join, not an array (ADR-0001).
/// </summary>
public enum GlossaryContentType
{
    Recipe,
    Ingredient,
    Equipment,
}
