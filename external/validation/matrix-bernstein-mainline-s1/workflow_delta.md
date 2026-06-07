# Workflow Delta

Status: updated for MB-S1.

Initial observation:
- The FSM already contains a `REUSE_SOURCE_VALIDATING` gate before translation.
- Continuous-learning already asks for Mathlib reuse, source validation, action classification, and KG correction artifacts.

Learned proof pattern:
- Matrix PSD proof stages should run before analytic matrix concentration
  stages.
- In the current HighDimProb matrix layer, structural PSD proofs should use the
  explicit `matrixQuadraticForm` normal form rather than spectral theory.
- The reusable chain is:
  `matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint` ->
  `isPSD_matrixSquare_of_selfAdjoint` ->
  `matrixQuadraticForm_matrixExpect` ->
  `isPSD_matrixSecondMoment_of_selfAdjoint` ->
  `isPSDMatrix_sum` ->
  `isPSD_matrixVarianceProxy_of_selfAdjoint`.

Statement-honesty update:
- If a statement assumption can now be derived from proved infrastructure,
  prefer exposing the primitive assumptions in the proof-ready statement and
  deriving the structural fact in the proof plan.
- MB-S1 applies this by replacing the separate PSD variance-proxy hypothesis in
  `matrixBernsteinSelfAdjointStatement` with per-summand square integrability.

Workflow/FSM learning applied:
- Added a "matrix finite-sum PSD algebra" proof pattern to
  `external/multi-agent-system/workflows/formalize-concept.md`.
- Added a domain-prerequisite growth trigger to
  `external/multi-agent-system/fsm/growth.md` requiring structural PSD stages
  before matrix Laplace / trace-exponential translation.
- Kept the existing statement-honesty guard against theorem-like
  `Prop := True` declarations.
