namespace SpecPour.Modules.Inventory.Domain;

/// <summary>data-model.md InventoryItem.source (FR-029/FR-030): how the item entered inventory.</summary>
public enum InventorySource
{
    PhotoRecognition,
    Barcode,
    Manual,

    /// <summary>Prep-sourced items link to a PrepItem and expire with it (US10-2) — not built by T066.</summary>
    Prep,
}
