<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan:
`specs/001-specpour-v1/plan.md` (with research.md, data-model.md,
contracts/api-v1-surface.md, and quickstart.md alongside it). The project
constitution is at `.specify/memory/constitution.md` (v1.6.0).

## Working conventions

- **Review-freeze / one-branch-per-batch (recorded 2026-07-18, T192; tightened
  2026-07-19 after the PR #8 incident).** Each directive batch gets its own
  branch and PR, cut from a freshly-synced `main`; it does NOT stack on an
  unmerged predecessor branch. **Ready-for-review is frozen, no exceptions,
  regardless of merge status.** The instant a PR is marked ready for review
  (`gh pr ready`, no longer draft), that branch takes no further commits from
  Claude — not a small fix, not a "this rides the same batch" follow-up, not
  a same-session review-round reply. It makes no difference whether the PR
  has actually merged yet: a handed-off PR is handed off. A follow-up
  directive, however small, gets a fresh branch off freshly-synced `main`,
  exactly as if the predecessor had already merged — because from the
  workflow's perspective, marking ready IS the handoff point, not the merge.
  John — never Claude — merges PRs (solo-dev merge model; the merge
  classifier blocks Claude self-merges, correctly).
  **Precedent 1 (the PR #3/#4 incident, 2026-07-17):** during the T184–T186
  batch, PR #3 merged mid-flight and GitHub auto-deleted its branch, so the
  in-progress work had to be re-pushed as a fresh PR #4 off the newly merged
  `main`.
  **Precedent 2 (the PR #8 incident, 2026-07-19):** PR #8 was marked ready
  for review, then a follow-up directive batch (T196/T197) was pushed as two
  more commits onto that same, already-ready branch — reasoned in the moment
  as "an open, not-yet-merged PR isn't a stacking risk," which is exactly the
  reading this convention now closes off. PR #8 had not actually merged when
  this happened, so no work was destroyed and nothing needs re-basing — but
  the convention held only by luck (John hadn't merged yet), not by design.
  Both precedents point the same direction: work on a fresh branch off
  current `main` per batch, always, so a batch never depends on the exact
  timing of a predecessor's merge.
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
     already-manually-verified commit, not as a general bypass — and see the
     escape-hatch disclosure convention below: state the bypass and the
     manual verification that justified it in the commit message itself.
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
- **Coverage baselines come from CI, never local computation (recorded
  2026-07-19, T198).** Every number in `coverage-baseline.json` must be
  sourced from CI's own coverage artifact — download the coverage-report
  run's `coverage-backend-*`/`coverage-frontend` artifacts (`gh run download
  <id>`), merge them with the ratchet script, and commit those numbers. Never
  baseline from a local `dotnet test`/`flutter test --coverage` run: the
  environment that ENFORCES the baseline (CI) must be the one that PRODUCES
  it. Local and CI measurements genuinely differ — **precedent (T198):** a
  locally-set 74.4% backend baseline (3229/4339 covered) tripped the ratchet
  on the first CI run, which measured 3228/4339 (74.3%) on identical code —
  same denominator, one background-timer-dependent line apart. **No
  epsilon/tolerance** is ever added to the ratchet to paper over this
  (explicitly rejected): a small drop is the ratchet working at full
  sensitivity; the escape valve for a *justified* drop is a documented,
  reviewed baseline update in its own commit — deliberate and visible — never
  a standing fuzz band that lets regressions accumulate silently.
- **Nondeterministic-coverage flake, pre-armed (recorded 2026-07-19, T200).**
  The T198 incident's root cause — a single line whose coverage depends on
  wall-clock timing — is a latent flake that can recur between any two CI
  runs, not just local-vs-CI. **A ratchet failure within ~1 line of baseline
  (a fraction-of-a-percent swing on a denominator in the thousands) is
  investigated as suspected nondeterministic coverage FIRST**, before
  assuming a real regression or reflexively re-baselining: compare the
  failing run's artifact against the last-passing run's (same production
  code, if any) — a same-denominator few-line delta is the signature. If
  confirmed, the fix is making the line deterministically covered (a test
  that reliably exercises it) or explicitly excluding it (with a comment
  explaining why) — never an epsilon on the ratchet, still rejected per the
  bullet above. Two candidate mechanisms (unconfirmed as of T200, see
  `scripts/check-coverage-ratchet.sh`'s own header for detail):
  `OutboxDispatcherBackgroundService` and `AccountLifecycleBackgroundService`
  — both poll on a wall-clock timer and race their own branch coverage
  against test-host shutdown.
- **Escape-hatch disclosure in the commit message itself (recorded
  2026-07-19).** Any use of a gate-bypass or escape hatch — `SKIP_LOCAL_CI_GATE=1`
  is the current example, but this applies to any future one — must be
  declared in the commit message that uses it, not only reported in the
  session/chat. State which bypass was used, exactly what was skipped, and
  the manual verification that justified it (suite-by-suite counts, not just
  "verified manually"), the same way `e131141`'s commit message did it. A
  session report is not durable; the commit message is the audit trail that
  survives context loss, a new session, or someone auditing `git log` months
  later with no memory of this conversation. If a commit doesn't disclose
  its own bypass, treat that as the record being wrong, not the bypass being
  undocumented — fix the record.
<!-- SPECKIT END -->
