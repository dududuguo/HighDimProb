# Automation Policy

Automation is part of API design. If a proof is fragile, slow, or requires large tactic scripts, treat that as feedback about wrappers, normal forms, and missing bridge lemmas.

## Simp Policy

- Use targeted `simp only` when broad `simp` loops or rewrites too much.
- Add `[simp]` lemmas only when they are safe normal forms.
- Prefer definitional apply lemmas and transparent wrappers for object-layer APIs.
- Record dangerous or surprisingly powerful simp lemmas in this document before relying on them widely.

Currently recorded dangerous simp lemmas:

- none

## Proof Failure Feedback

When a proof pilot fails, do not force the proof with brittle automation. Record the blocker in `docs/maintainers/AbstractionLog.md` and add missing bridge lemmas to `docs/maintainers/TODO.md`.

## Future Tactics

`HighDimProb/Tactic.lean` is reserved for lightweight project tactics. Future candidates:

- `highdim_prob`
- local tactic wrappers for unfolding HighDimProb object-layer definitions
- local proof-search helpers for finite sums, matrix extensionality, and measurable finite sums

No tactic should hide unproved mathematics or turn theorem statements into fake proofs.

## Proof Pilot Lessons

- P1 metric proof succeeded: Mathlib metric separated/cover APIs matched the HighDimProb wrappers.
- P2 matrix proof needed targeted simplification around matrix entries and identity entries.
- P3 coordinate centeredness was essentially definitional and worked with function extensionality.
- P4 expectation/integrability proof succeeded, confirming the scalar expectation wrapper can support small analytic proofs under explicit integrability assumptions.
- P5 tail monotonicity succeeded with direct set inclusion and measure monotonicity.
