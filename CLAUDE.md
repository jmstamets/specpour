<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan:
`specs/001-specpour-v1/plan.md` (with research.md, data-model.md,
contracts/api-v1-surface.md, and quickstart.md alongside it). The project
constitution is at `.specify/memory/constitution.md` (v1.6.0).

## Working conventions

- **Review-freeze / one-branch-per-batch (recorded 2026-07-18, T192).** Each
  directive batch gets its own branch and PR, cut from a freshly-synced `main`;
  it does NOT stack on an unmerged predecessor branch. John — never Claude —
  merges PRs (solo-dev merge model; the merge classifier blocks Claude
  self-merges, correctly). **Precedent (the PR #3/#4 incident):** during the
  T184–T186 batch, PR #3 merged mid-flight and GitHub auto-deleted its branch,
  so the in-progress work had to be re-pushed as a fresh PR #4 off the newly
  merged `main`. Working on a fresh branch off current `main` per batch avoids
  building on a branch that can vanish or drift under you.
- **File directives as tasks first (T-IDs before work).** On any numbered
  directive batch, first file each item as a task ID in
  `specs/001-specpour-v1/tasks.md` and echo the assignments back, before
  starting — unfiled directives have decayed to prose and been lost more than
  once (fail-open sweep, SMTP test, and the three items T190–T192 reconcile).
<!-- SPECKIT END -->
