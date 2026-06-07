# MB-S9-foundation Plan

## FSM Path
- QUEUED
- SOURCE_READING
- API_AUDITING
- ABSTRACTION_PLANNING

## Existing API Surface

### TraceExp / TraceMGF
- `traceExpIntegrand {Omega} [MeasurableSpace Omega] {n} (Y : RandomMatrix Omega n n) (theta : Real) : RealRandomVariable Omega`
- `traceExpMoment (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta : Real) : Real`
- `traceExpMomentLIntegral (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta : Real) : ENNReal`
- `traceExpMomentLIntegral_eq_ofReal_traceExpMoment` proves the lintegral/raw expectation bridge under explicit integrability and pointwise nonnegativity.
- `traceExpMoment_nonneg_of_randomSelfAdjoint` proves raw trace-exp moment nonnegativity for random self-adjoint matrices.
- `traceExpMomentBoundStatement` and `traceExpVarianceProxyBoundStatement` are existing typed targets, but their names do not expose a reusable semantic predicate.

### Laplace
- `TraceExpDominatesUpperBound` is the deterministic trace-exp dominance predicate.
- `TraceExpDominatesQuadraticFormUpperTail` is the event-subset dominance predicate.
- `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint` is proved.
- `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint` and `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint` are proved concrete lintegral wrappers.
- Real RHS / raw expectation bridge remains unproved.

### VarianceProxy
- `matrixVarianceProxy` and compatibility alias `MatrixVarianceProxy` define the deterministic matrix proxy `sum_i E[A_i^2]`.
- `matrixVarianceProxyBound` and `MatrixVarianceProxyBound` bound a deterministic matrix proxy by a scalar multiple of identity.
- `matrixVarianceProxyNorm` gives the deterministic operator-norm scalar proxy of `matrixVarianceProxy`.
- PSD structure for squares, second moments, and matrix variance proxy is proved under explicit self-adjointness and square-integrability assumptions.
- Missing: semantic predicates saying a random family has a prescribed matrix/norm variance proxy bound.

### ConcentrationStatements
- `matrixBernsteinStatement` and `matrixBernsteinSelfAdjointStatement` remain typed statement targets.
- `matrixBernsteinLaplacePrerequisitesStatement` records current Laplace-route prerequisites.
- Missing: typed statement isolating the trace-mgf provider step from the final Matrix Bernstein statement.

## Current Problems
- duplicated assumptions: trace-mgf typed targets repeat random self-adjoint and nonnegative theta assumptions without a semantic bound predicate.
- low-level concrete coupling: future theorems would depend directly on `traceExpMoment` inequalities instead of named trace-mgf predicates.
- missing semantic predicate: no `TraceMGFBound` / `TraceMGFBoundLIntegral` layer exists.
- missing typed statement: no Matrix Bernstein trace-mgf provider target isolated from the full Bernstein theorem.
- docs/test/judge drift: docs index old typed targets but not the intended semantic trace-mgf layer.
- future hard theorem blockers: Golden-Thompson/Lieb or equivalent noncommutative mgf machinery is still needed for trace-mgf provider proofs.

## Proposed Semantic Abstractions

### TraceMGFBound
- proposed kind: def
- proposed signature:
  `def TraceMGFBound {Omega : Type*} [MeasurableSpace Omega] {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta rhs : Real) : Prop`
- meaning:
  `traceExpMoment P Y theta <= rhs`
- current declarations it subsumes:
  the conclusion of `traceExpMomentBoundStatement`
- downstream use:
  real trace-mgf assumptions can feed future Chernoff/Laplace wrappers without exposing the raw expectation implementation.

### TraceMGFBoundLIntegral
- proposed kind: def
- proposed signature:
  `def TraceMGFBoundLIntegral {Omega : Type*} [MeasurableSpace Omega] {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta : Real) (rhs : ENNReal) : Prop`
- meaning:
  `traceExpMomentLIntegral P Y theta <= rhs`
- current declarations it subsumes:
  the assumption of `matrixChernoffFromTraceExpLIntegralStatement`
- downstream use:
  lintegral trace-mgf bounds can feed the already proved lintegral Laplace wrappers.

### VarianceProxyBound
- proposed kind: def
- proposed signature:
  `def MatrixVarianceProxyUpperBound {Omega : Type*} [MeasurableSpace Omega] {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega) (A : I -> RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real) : Prop`
- meaning:
  `MatrixLE (matrixVarianceProxy P A) V`
- current declarations it subsumes:
  a family-level wrapper around `matrixVarianceProxy`
- downstream use:
  future trace-mgf provider theorems can assume a semantic matrix proxy bound without unpacking `sum_i E[A_i^2]`.

### MatrixBernsteinTraceMGFStatement
- proposed kind: typed statement
- proposed signature:
  `abbrev matrixBernsteinTraceMGF_statement ... : Prop`
- meaning:
  independent centered self-adjoint summands with visible integrability/boundedness hypotheses provide a `TraceMGFVarianceProxyBound` for their random sum.
- hard theorem dependencies:
  Golden-Thompson/Lieb or equivalent matrix mgf machinery, independence mgf factorization, and variance-proxy comparison.

## Generic Bridge Theorems
- name: none added in this stage beyond possible definition-folding examples
- proposed signature: not applicable
- proof status: typed statement only
- dependencies: hard trace-mgf provider dependencies remain unproved

## Explicit Non-Goals
- Golden-Thompson: not proved.
- Lieb: not proved.
- trace-mgf master theorem: not proved.
- Matrix Bernstein: not proved.

## Safety Decision
- FOUNDATION_READY
