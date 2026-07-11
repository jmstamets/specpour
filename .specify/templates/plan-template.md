# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]

**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]

**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]

**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]

**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]

**Project Type**: [e.g., library/cli/web-service/mobile-app/compiler/desktop-app or NEEDS CLARIFICATION]

**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]

**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]

**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Verify compliance with `.specify/memory/constitution.md` (v1.4.0). Mark each gate PASS,
FAIL (with justification in Complexity Tracking), or N/A:

- [ ] **I. Test-First (ATDD)**: Given/When/Then acceptance criteria agreed before
      implementation; failing-first acceptance tests planned; CI gates on acceptance,
      unit, integration, and contract tests.
- [ ] **II. Contract-First API**: OpenAPI contract defined/updated and reviewed before
      implementation; Dart SDK generated, not hand-written; contract tests planned;
      breaking changes get a new API version.
- [ ] **III. Modular Monolith & Clean Architecture**: Feature maps to a module with
      explicit internal contracts; no cross-module persistence access; no cross-module
      transactions (domain events for cross-module consistency); extraction path
      preserved; every external integration behind a port/adapter pair with contract
      tests per port; no vendor SDK referenced from domain/application code.
- [ ] **IV. Offline-First Client**: Client-facing reading/reference workflows work
      offline per the user's offline profile; sync/conflict handling addressed for
      user-authored content.
- [ ] **V. AI Abstraction**: Any AI functionality sits behind the provider abstraction,
      is individually toggleable, degrades gracefully, labels output, and versions its
      prompts.
- [ ] **VI. Tiers & Roles (three axes)**: New features declared in the
      capability/entitlement map; no tier logic hard-coded in feature branches; tiers,
      platform-staff roles, and scope-bound roles kept independent; tier identifiers
      stable, display names localizable.
- [ ] **VII. i18n**: No hard-coded user-facing strings; locale-aware formatting; unit
      conversion through the single conversion service.
- [ ] **VIII. Long-Horizon Rule**: Shortcuts vs. planned roadmap needs resolved toward
      lower long-term TCO, or an ADR documents the deviation (identity module, rating
      events, search port, geospatial readiness honored).
- [ ] **IX. Domain Language**: Terminology follows professional craft-cocktail
      convention / the project glossary.
- [ ] **X. Multi-Sided Boundaries**: Constituency concerns in separate modules; shared
      domain concepts owned by exactly one module; recipe vs. beverage product never
      conflated; establishment identity/verification separate from establishment
      content.
- [ ] **XI. Communications**: Any user/subscriber communication flows through the
      single notifications module (inbox default; email/SMS/push opt-in per channel;
      platform-enforced anti-abuse; auditable).
- [ ] **XII. Geolocation Privacy**: Location use is consent-gated and purpose-specific;
      coarse by default; raw coordinates not retained; client-side geofencing where
      feasible; graceful degradation without consent.
- [ ] **XIII. Regulated-Industry Posture**: Jurisdiction-aware age gating on consumer
      social/discovery surfaces; responsible-consumption messaging;
      alcohol-marketing compliance controls where establishments reach patrons;
      engagement/notification mechanics volume-neutral — never rewarding consumption
      quantity/frequency, never prompting additional in-session drinking.
- [ ] **XIV. Trust & Content Integrity**: Verification, review-integrity, moderation,
      and dispute workflows built as reusable services; verification evidence handled
      as sensitive data; rating computation deterministic, versioned, auditable; all
      staff/administrative actions append-only audit-logged; platform-scoped roles
      require mandatory MFA and explicit administrative grant (never signup/tier).
- [ ] **XV. Analytics & Ingestion**: External operational data enters only via
      adapters into the ingestion module; provenance-tagged end-to-end; platform never
      the financial system of record.
- [ ] **Technology & Standards**: Stack constraints (C#/.NET LTS, PostgreSQL, Flutter,
      S3-compatible media, cloud-agnostic) and engineering standards (observability,
      security, WCAG 2.1 AA, semver, ADRs) upheld; sensitive PII (DOB, verification
      documents) classified with heightened controls — column-level encryption,
      derived-predicate access, log/analytics exclusion, audited access, non-retention
      of failed/ineligible attempts.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
