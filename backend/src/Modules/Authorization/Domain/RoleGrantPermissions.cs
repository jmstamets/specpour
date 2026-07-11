namespace SpecPour.Modules.Authorization.Domain;

/// <summary>data-model.md RoleGrant.permissions — granular per-grant permission set.</summary>
[Flags]
public enum RoleGrantPermissions
{
    None = 0,
    View = 1 << 0,
    Edit = 1 << 1,
    Delete = 1 << 2,
    Publish = 1 << 3,
}
