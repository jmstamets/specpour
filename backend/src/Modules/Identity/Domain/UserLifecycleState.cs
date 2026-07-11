namespace SpecPour.Modules.Identity.Domain;

/// <summary>
/// data-model.md User.lifecycle_state: active -> deactivated -> deleted, plus a
/// staff-driven active &lt;-&gt; suspended branch (FR-062). Deactivation/deletion
/// scheduling lands in T052; suspend/reinstate actions land in T083.
/// </summary>
public enum UserLifecycleState
{
    Active,
    Deactivated,
    Suspended,
    Deleted,
}
