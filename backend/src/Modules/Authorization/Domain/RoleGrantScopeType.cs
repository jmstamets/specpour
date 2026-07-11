namespace SpecPour.Modules.Authorization.Domain;

/// <summary>data-model.md RoleGrant.scope_type. V1 issues platform-scope grants only (FR-063); venue scope is modeled for the future.</summary>
public enum RoleGrantScopeType
{
    Platform,
    Venue,
}
