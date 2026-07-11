namespace SpecPour.Tools.Seeder;

/// <summary>
/// Extensibility seam for the curated launch-content ingestion pipeline (T025's
/// second deliverable). No content module exists yet (Catalog/Ingredients/Equipment/
/// Glossary land T032-T035), so <see cref="Program.ContentImporters"/> is empty today
/// — a correct, honest state, not a stub. T040 ("Curated seed content pack") adds the
/// first real importer plus the actual content files once those entity types exist.
/// </summary>
public interface IContentImporter
{
    /// <summary>What this importer loads (e.g. "recipes", "ingredients") — used only for logging.</summary>
    string ContentType { get; }

    Task ImportAsync(string contentDirectory, CancellationToken cancellationToken);
}
