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
- **Story checkpoint cycle (recorded 2026-07-19, ruling on T056).** For a
  multi-task story whose first deliverable is its own failing acceptance
  test (ATDD, constitution Principle I) — e.g. a User Story's `T0xx`
  acceptance-test task followed by the tasks that implement it green — the
  always-green commit/push gate scopes to **merges and handoffs, not to
  feature-branch commits**. No contradiction with the review-freeze or
  never-commit-red rules; this is the explicit exception both were always
  read too broadly against. The cycle, one branch for the whole story:
  1. **Commit the story's failing acceptance tests first**, on the story's
     own feature branch. This red commit *is* the constitutionally-required
     proof of test-first — but every *other* suite must be green in it (zero
     regressions elsewhere); only the new story's own scenarios may be red.
     Verify this directly (run every suite, confirm the count/shape of what's
     red matches exactly the new scenarios, nothing else) before committing —
     the local gate's own automated check can't tell "expected new red" from
     "something I broke," so it will legitimately block this commit; use its
     documented `SKIP_LOCAL_CI_GATE=1` escape hatch for this one, specific,
     already-manually-verified commit, not as a general bypass.
  2. **Open a draft PR immediately** after pushing that commit. Required
     checks will run and show red on the new scenarios — that is the
     expected state of a draft, not a failure to fix before proceeding.
     Draft status is what distinguishes "in construction" from "handed off";
     review-freeze is untouched because a handoff is marked ready, and ready
     means green.
  3. **Implement to green**, committing incrementally on the same branch
     until every suite (including the story's own acceptance scenarios)
     passes.
  4. **Mark the PR ready**, hold for review/merge as usual — this is the
     actual handoff, and it must be green, no exception.
  **Squash-merging story branches is prohibited** — it destroys the
  red-then-green commit history that is the whole evidentiary point of the
  cycle; merge with history preserved (a real merge commit, or rebase-merge
  keeping each commit intact).
  If a story's checkpoint proves too large for one sitting, the draft PR —
  at any red-but-committed point — is the safe parking state; stop there and
  report, rather than rushing or silently narrowing scope.
<!-- SPECKIT END -->
