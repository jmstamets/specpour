# ADR-0004: Data Protection key custody — Azure Key Vault, gated launch criterion

**Status**: Decided, not yet implemented (T139)
**Date**: 2026-07-13
**Decided during**: Phase 4 (US2), T162/T164 security audit follow-up.

## Context

T050/T164 built the identity module's two sensitive-PII ciphers (DOB, MFA TOTP
secret) on .NET Data Protection configured for AES-256-GCM
(`IdentityModule.RegisterServices`). T162's retroactive security audit (John,
2026-07-13) verified the AEAD mechanics themselves are sound — fresh
per-operation nonces, the platform `AesGcm` primitive, per-row key IDs enabling
rotation without a flag day, and (after T162/T164's fixes) per-user GCM
associated data preventing cross-row ciphertext swaps.

The audit also surfaced what it *didn't* fix: the key ring's master keys
persist via

```csharp
services.AddDataProtection()
    .SetApplicationName("SpecPour.Identity")
    .PersistKeysToDbContext<IdentityDbContext>()
    .UseCryptographicAlgorithms(...)
```

with no `ProtectKeysWith*` call. Data Protection's default behavior when no
key-encryption-at-rest is configured is to store the key ring **unwrapped** —
XML-serialized key material sitting in the same PostgreSQL database as the
ciphertexts it protects. One database compromise (a leaked backup, a
misconfigured replica, an over-privileged credential) yields both the
ciphertext and the key to open it. This posture has existed since Phase 2's
DOB cipher (T017) and was carried forward unchanged into T050's MFA cipher —
neither introduced it; T162 is what first named it.

A local cert-based wrap was considered and rejected as a *complete* fix: `.
ProtectKeysWithCertificate(cert)` moves the plaintext-exposure problem one hop
— the certificate's private key now needs its own storage, and a
password-protected `.pfx` with the password in an environment variable is the
same unwrapped-secret-next-to-what-it-protects shape, just relabeled.

## Decision

**A real secrets/KMS port**, per the constitution's Principle III adapter
pattern (the same shape as every other cross-boundary integration in this
codebase — e.g. `IEmailChannelAdapter`, `ILegalDrinkingAgePort`):

- An `IXmlEncryptor`-backed key-custody adapter behind that port.
- **Azure Key Vault** is the production implementation — Azure is the
  platform's expected deployment target, and Key Vault's `IXmlEncryptor`
  integration (`Azure.Extensions.AspNetCore.DataProtection.Keys`) is a
  first-party, actively maintained Microsoft package (R6).
- **Local dev** gets an explicit, clearly-dev-mode fallback: either a
  deployment-supplied certificate, or an unwrapped key ring with a loud
  startup warning — selected by configuration, never silently.
- **Production refuses to start** without a real custody adapter configured.
  This is the load-bearing part of the decision: an operator who forgets to
  configure Key Vault in a production deployment must get a startup failure,
  not a silently-degraded security posture that looks identical to the
  correctly-configured case from the outside.

Rotation and per-row key-ID plumbing need no further work — T162 already
confirmed those are satisfied by Data Protection's own payload format
(`magicHeader ‖ keyId ‖ ...`) and are orthogonal to how the key ring itself is
protected at rest. This ADR is scoped to custody only.

## Acceptance criterion (T139)

> Master key material is never persisted unwrapped in the same trust domain
> as the ciphertexts it protects; Production refuses to start otherwise.

Scheduled as a **launch-gating criterion** on T139's hardening pass, elevated
from an informational rider — not required before continuing feature work on
Identity or any other module, but required before any non-local deployment.

## Consequences

- New dependency: `Azure.Extensions.AspNetCore.DataProtection.Keys` (and the
  Azure Identity SDK for authenticating to Key Vault) when T139 lands.
- New cross-cutting secrets/KMS port — the first of its kind in this
  codebase; other modules with their own sensitive-data-at-rest needs (none
  currently) would reuse it rather than each inventing their own custody
  story.
- `ASPNETCORE_ENVIRONMENT=Production` becomes a real behavioral gate at
  startup, not just a logging/diagnostics flag — the host must fail fast
  (not degrade) when custody isn't configured.
- Known-plaintext window: from T017 (DOB cipher's introduction) until T139
  lands, the key ring is unwrapped in every environment this codebase has run
  in, including local dev and this repository's own CI/test runs. No
  production data has ever existed under this posture (no deployment has
  happened yet), so there is nothing to remediate retroactively — this ADR
  exists to make sure that stays true until T139 closes it.

## Alternatives considered

- Certificate-based wrap with the cert distributed via deployment
  infrastructure (not env-embedded password): a legitimate alternative for
  non-Azure or hybrid deployments, and still a viable local-dev fallback
  under this decision — but Key Vault is the primary path since Azure is the
  expected platform, and a bespoke cert-distribution mechanism would be
  additional infrastructure to build and operate for no benefit over using
  the platform's own KMS.
- Doing nothing until closer to launch: rejected — the gap is already
  identified and cheap to fix later exactly because rotation/key-ID
  plumbing is already in place; recording the decision now means T139
  is a known, scoped, drop-in task rather than a rediscovery.
