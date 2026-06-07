# MB-S5 Read-Once Manifest

## Lease

- Active lease while producing this file: `LEASE_SNAPSHOT`.
- Snapshot files were read once during Phase 0. Later phases should rely on
  this manifest and read only their leased files.

## Repository Workflow Facts

- `docs/Workflow.md` requires Mathlib-first reuse, one concept cluster only,
  focused examples/tests, placeholder-free Lean proofs, and passing
  `lake build` / `lake test`.
- `docs/Status.md` still says current stage is `Stage MB-S4` and current task
  is `Matrix exponential PSD bridge closeout`.
- `docs/Status.md` records MB-S4 complete and states that matrix Laplace,
  trace-mgf inequalities, Golden-Thompson, Lieb, and matrix Bernstein remain
  unproved.
- `docs/Status.md` next safe task is already MB-S5: matrix Laplace upper-tail
  proof attempt over existing quadratic-form tail and trace-exp vocabulary.
- `docs/MatrixBernsteinProofPlan.md` records:
  - `matrixLaplaceTransformStatement` and
    `matrixLaplaceTransformLIntegralStatement` are typed `Prop`, unproved.
  - `traceExpMomentBoundStatement` and
    `traceExpVarianceProxyBoundStatement` are typed `Prop`, unproved.
  - Golden-Thompson, Lieb, and trace-mgf product/control theorem are
    documentation-only TODOs.
  - MB-S4 proves `matrixExp_posSemidef_of_selfAdjoint`,
    `traceMatrixExp_nonneg_of_selfAdjoint`,
    `traceExpIntegrand_nonneg_of_randomSelfAdjoint`, and
    `traceExpMoment_nonneg_of_randomSelfAdjoint`.
- `docs/BranchRegistry.md` and `docs/LeafPlan.md` already list the RandomMatrix
  next safe task as MB-S5 matrix Laplace upper-tail bridge over existing
  quadratic-form tail and trace-exp vocabulary.

## Existing Trace-Exp APIs

Source: `HighDimProb/RandomMatrix/TraceExp.lean`.

- `matrixExp_posSemidef_of_selfAdjoint_statement`: line 79.
- `matrixExp_posSemidef_of_selfAdjoint`: line 93.
- Private fallback `matrixExp_posSemidef_of_selfAdjoint_square`: line 107; not
  public API and not part of MB-S5.
- `traceExpIntegrand`: line 142.
- `traceExpMomentLIntegral`: line 161.
- `traceMatrixExp_nonneg_of_selfAdjoint_statement`: line 171.
- `traceMatrixExp_nonneg_of_selfAdjoint`: line 176.
- `traceExpMoment_nonneg_of_randomSelfAdjoint`: line 213.
- `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`: line 241.

Existing coverage:

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks and examples cover the
  MB-S4 PSD and trace nonnegativity bridges.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` checks downstream-style use
  of the same declarations.

## Existing Laplace APIs

Source: `HighDimProb/RandomMatrix/Laplace.lean`.

- `matrixLaplaceRHS`: line 19.
- `matrixLaplaceRHSLIntegral`: line 25.
- `matrixLaplaceTransformStatement`: line 35; typed `Prop`, unproved.
- `matrixLaplaceTransformLIntegralStatement`: line 44; typed `Prop`, unproved.
- `matrixChernoffFromTraceExpStatement`: line 54; typed `Prop`, unproved.
- `matrixChernoffFromTraceExpLIntegralStatement`: line 66; typed `Prop`,
  unproved.
- `selfAdjointOperatorNormLaplaceRHSLIntegral`: line 77.
- `selfAdjointOperatorNormLaplaceStatement`: line 89; typed `Prop`, unproved.
- `selfAdjointOperatorNormLaplaceLIntegralStatement`: line 104; typed `Prop`,
  unproved.

Existing coverage:

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean` checks current RHS and typed
  statements.
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` checks downstream-style
  current RHS and typed statements.

## Existing Spectral / Event APIs

Source: `HighDimProb/RandomMatrix/Spectral.lean`.

- `quadraticFormUpperTailEvent`: line 98.
- `SelfAdjointOperatorNormTailEvent`: line 114.
- `twoSidedQuadraticFormTailEvent`: line 128.
- `quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent`: line
  133.
- `quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent`: line
  142.
- `selfAdjointOperatorNormTailViaQuadraticFormStatement`: line 154; typed
  `Prop`, unproved.
- `lambdaMax_le_iff_quadraticForm_le_statement`: line 163; typed `Prop`,
  unproved.

## Scalar Markov / Chernoff Pattern Facts

Source: `HighDimProb/Concentration/Markov.lean`.

- Imports `Mathlib.MeasureTheory.Integral.Lebesgue.Markov`.
- `markov_inequality_nonneg` uses
  `MeasureTheory.meas_ge_le_lintegral_div` with:
  - `h_meas : AEMeasurable (fun omega => ENNReal.ofReal (X omega)) P`;
  - nonzero threshold via `ENNReal.ofReal_ne_zero_iff.mpr`;
  - finite threshold proof by `simp`;
  - event equality after converting `ENNReal.ofReal` inequalities;
  - `lintegral_ofReal_eq_ofReal_expect` and `ENNReal.ofReal_div_of_pos`.
- `markov_inequality_ae_nonneg` uses the same lintegral Markov theorem but
  supports a.e. nonnegativity for the real/lintegral bridge.

Sources: `HighDimProb/Concentration/Hoeffding.lean` and
`HighDimProb/Concentration/Bernstein.lean`.

- Chernoff-style proofs define an ENNReal exponential integrand, prove
  `AEMeasurable`, invoke `MeasureTheory.meas_ge_le_lintegral_div`, prove an
  event subset using monotonicity of multiplication/exponential, and then
  simplify ENNReal division/product forms.
- Reusable local pattern: proving a conditional matrix Laplace bound should
  prefer the same lintegral Markov call and a separate explicit event-subset
  hypothesis for the missing matrix/spectral comparison.

## FSM Facts

- The external FSM is advisory; repository docs win on conflicts.
- Relevant states for MB-S5 are:
  `QUEUED`, `REUSE_SOURCE_VALIDATING`, `TRANSLATING`, `COMPILING`,
  `COMPILE_ERROR`, `FIXING`, `REVIEWING`, `VERIFYING`, `INTEGRATING`,
  `INTEGRATED`, and `BLOCKED_CLEAN`.
- Transition guard from reuse/source validation to translation requires
  Mathlib reuse report, existing declaration search, source validation report,
  action classification, and no Lean generation before the gate.

## MB-S5 Action Classification

- Full `matrixLaplaceTransformStatement` is blocked by the missing event-subset
  bridge:
  `quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t`.
- It is safe to survey and, if Lean confirms, add:
  - `traceExpThresholdEvent`;
  - a division-normal-form RHS
    `matrixLaplaceRHSLIntegralDiv`;
  - a conditional Markov theorem for the trace-exp threshold event;
  - a conditional quadratic-form theorem explicitly assuming the event subset.
- Product-RHS theorem against `matrixLaplaceRHSLIntegral` is optional and only
  safe if ENNReal algebra compiles cleanly.

## Next Safe Task

- Run `LEASE_MB_S4_CLOSEOUT_DOCS` to synchronize stale MB-S4 closeout docs, then
  run `LEASE_MB_S5_SURVEY`.
