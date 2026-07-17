# ADR-0006: Solo-developer review gate — human review of AI changes (or higher-tier AI review of human changes) substitutes for peer review

**Status**: Accepted (codifies practice already in effect)
**Date**: 2026-07-17
**Decided during**: T177 docs batch (C1), reconciling the generated constitution against a source `docs/constitution-statement.md` revision.

## Context

The constitution's Engineering Standards originally read "peer review required
for all merges" — written assuming a team of human developers exists to review
each other's work. This project's actual operating mode is solo-developer:
John is the sole human, working with Claude as the primary author of most
changes. Literal peer review (a second human colleague) is structurally
impossible in this mode, which left the constitution describing a gate the
project could never actually satisfy — exactly the kind of drift a
`/speckit-analyze` pass exists to catch (finding C1).

The practice that had already emerged in this project (see the "Solo-dev
merge model" convention: Claude opens PRs on branches, John reviews and
merges, branch protection blocks direct pushes to `main`) is a real review
gate, just not a peer-to-peer one. This ADR codifies that practice as the
constitutional standard rather than leaving the written principle silently
unenforceable.

## Decision

Amend the Engineering Standards "Code quality" bullet: all merges require
review independent of the author — human peer review where a team exists; in
solo-developer operation, documented human review of AI-authored changes (or
independent, higher-tier AI review of human-authored changes) plus the full
CI gate set satisfies this. **Unreviewed direct merges are prohibited in
either mode.**

"Independent of the author" is the load-bearing phrase: the reviewer (human
or AI) must not be the same actor that produced the change, and must have
genuine authority to reject it, not merely rubber-stamp.

## Consequences

- The constitution now describes an enforceable, actually-satisfiable gate
  for this project's real operating mode, instead of a peer-review clause
  that solo operation could never meet.
- Branch protection (no direct pushes to `main`, required status checks) is
  the mechanical backstop; this ADR is the policy backstop explaining *why*
  that setup satisfies the constitution's review requirement.
- Does not lower the bar: a human-authored change still needs independent
  review (by John or a higher-tier AI reviewer) before merge — this amendment
  legitimizes the AI-authored-change/human-review direction the project
  already runs, it does not create a new way to skip review entirely.
- If the project ever grows beyond solo operation, the human-peer-review
  clause remains the standard the moment a second human contributor exists —
  this amendment is additive, not a permanent lowering of the bar.

## Alternatives considered

- **Require literal external peer review**: rejected — no second human
  developer exists on this project; would block all progress indefinitely,
  which is a worse outcome than a codified, disclosed solo-dev alternative.
- **Drop the review requirement entirely for solo operation**: rejected —
  removes a real safety net (this project's own history includes findings
  like the `RateLimitingTests` isolation gap and the `TestTimeProvider`
  cookie-auth interaction, both caught by review-shaped scrutiny after the
  fact) for no compensating benefit.
- **Mandatory paid external contractor review**: rejected as disproportionate
  cost for V1's solo-developer phase — a Long-Horizon-Rule-shaped call, not
  worth revisiting unless the project's stakes materially change.
