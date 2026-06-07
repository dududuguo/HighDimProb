# MB-S6 Blackboard

## Current FSM State

- `INTEGRATED`

## Active Agent

- Manager / Integrated

## Active File Lease

- none

## Allowed Files

### `LEASE_SNAPSHOT`

Read-only:

- Existing repository source/test/judge/docs needed for exact signatures.
- Existing MB-S4/MB-S5 validation notes.
- `external/` source materials.

Write-only:

- `external/validation/matrix-bernstein-mainline-mb-s6/BLACKBOARD.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/READ_ONCE_MANIFEST.md`

Future leases must be recorded here before any worker edits leased files.

### `LEASE_SOURCE_BOOK`

Read-only:

- Everything under `external/` that appears to contain source book material,
  proof plans, theorem sources, matrix concentration references, or prior
  validation notes.
- Existing source files only through `READ_ONCE_MANIFEST.md`.

Write-only:

- `external/validation/matrix-bernstein-mainline-mb-s6/SOURCE_DIGEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/source_lookup_log.md`

### `LEASE_MB_S6_CONSTRUCTION_API`

Read-only:

- `external/validation/matrix-bernstein-mainline-mb-s6/READ_ONCE_MANIFEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/SOURCE_DIGEST.md`
- `HighDimProb/RandomMatrix/Laplace.lean`
- Compiler error locations only

Write-only:

- `HighDimProb/RandomMatrix/Laplace.lean`
- `external/validation/matrix-bernstein-mainline-mb-s6/API_CONTRACT.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/construction_log.md`

### `LEASE_MB_S6_PROOF`

Read-only:

- `external/validation/matrix-bernstein-mainline-mb-s6/READ_ONCE_MANIFEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/SOURCE_DIGEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/API_CONTRACT.md`
- `HighDimProb/RandomMatrix/Laplace.lean`
- Compiler error locations only

Write-only:

- `HighDimProb/RandomMatrix/Laplace.lean`
- `external/validation/matrix-bernstein-mainline-mb-s6/proof_log.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/proof_blocker.md`

### `LEASE_MB_S6_EXAMPLE_JUDGE`

Read-only:

- `external/validation/matrix-bernstein-mainline-mb-s6/API_CONTRACT.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/proof_log.md`
- `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- Compiler error locations only

Write-only:

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- `external/validation/matrix-bernstein-mainline-mb-s6/example_log.md`

### `LEASE_MB_S6_REVIEW`

Read-only:

- `git diff`
- `external/validation/matrix-bernstein-mainline-mb-s6/SOURCE_DIGEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/API_CONTRACT.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/proof_log.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/example_log.md`
- Changed Lean, test, judge, and validation files

Write-only:

- `external/validation/matrix-bernstein-mainline-mb-s6/review.md`

### `LEASE_FINAL_DOCS`

Read/write:

- `docs/Status.md`
- `docs/MatrixBernsteinProofPlan.md`
- `docs/MatrixConcentrationPlan.md`
- `docs/TheoremAtlas.md`
- `docs/TermMap.md`
- `docs/TODO.md`
- `docs/TestPlan.md`
- `docs/JudgeSystem.md`
- `docs/BookProgress.md`
- `docs/BranchRegistry.md`
- `docs/LeafPlan.md`

## Forbidden Files

- Scalar concentration source files.
- Full Matrix Bernstein proof files.
- `HighDimProb/RandomMatrix/TraceExp.lean` unless explicitly leased in a later
  stage, which MB-S6 currently does not plan to do.
- `HighDimProb/RandomMatrix/Spectral.lean` unless explicitly leased in a later
  stage, which MB-S6 currently does not plan to do.
- Scalar concentration source files and RandomMatrix proof source files during
  final docs integration.

## Source Theorem References Found In `external/`

- `external/theory-roadmap/sources/High-Dimensional_Probability.md`,
  Section 5.4.3, Step 1: largest-eigenvalue event is reduced to
  `E tr exp(lambda S)` using Markov and
  `lambda_max(exp(lambda S)) <= tr exp(lambda S)`.
- `external/theory-roadmap/sources/High-Dimensional_Probability.md`,
  Section 4.1.2, Theorem 4.1.6: min-max theorem for eigenvalues.
- `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`,
  Theorems 1.3.1 and 1.3.2: spectral theorem and Courant-Fischer min-max
  theorem.
- Source digest recommendation: `USE_EXPLICIT_HYPOTHESIS`.

## API Contract Status

- API ready: explicit dominance predicate, typed statement, conditional subset
  theorem, and conditional Laplace wrappers added.

## Proof Status

- Proof ready: conditional consequences proved under explicit dominance
  hypothesis. Direct spectral/Rayleigh dominance remains unproved.

## Example/Judge Status

- Example/judge coverage ready.

## Command Results

- `lake build HighDimProb.RandomMatrix.Laplace`: pass
- `python scripts/judge_policy_check.py`: pass
- `lake build HighDimProbTest.RandomMatrixLaplaceAPI`: pass
- `lake build HighDimProbJudge.RandomMatrix.LaplaceUse`: pass
- `python scripts/judge_policy_check.py`: pass
- `lake build`: pass
- `lake test`: pass
- `lake build HighDimProbJudge`: pass
- `python scripts/judge_policy_check.py`: pass
- `git diff --check`: pass, with existing CRLF normalization warnings

## Merge Decision

- MERGE. MB-S6 source/test/judge/docs integration complete.

## Exactly One Next Safe Task

- Stage MB-S7 source/API survey for a direct proof of
  `TraceExpDominatesQuadraticFormUpperTail Y theta t` from Rayleigh/min-max,
  lambda-max, and trace-exponential spectral facts under explicit hypotheses.
