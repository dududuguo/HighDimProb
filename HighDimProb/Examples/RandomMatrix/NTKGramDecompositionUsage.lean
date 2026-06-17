import HighDimProb.Examples.RandomMatrix.NTKGramUsage

/-!
# NTK Gram decomposition usage example

This examples-only file expands `NTKGramUsage` with an explicit finite
Jacobian-feature decomposition. It does not prove feature-level hypotheses,
neural tangent kernel initialization, training dynamics, or new Matrix
Bernstein infrastructure.
-/

namespace HighDimProb.Examples.RandomMatrix.NTKGramDecompositionUsage

open MeasureTheory
open HighDimProb.Examples.RandomMatrix.NTKGramUsage

noncomputable section

/-- A finite table of Jacobian-feature coordinates.

`J a i` is the `a`-th parameter/feature coordinate evaluated on data point `i`. -/
abbrev JacobianFeatureTable (width n : Nat) :=
  Fin width -> NTKFeatureVector n

/-- Extract the vector over data points associated with one feature coordinate. -/
def jacobianFeatureVector {width n : Nat}
    (J : JacobianFeatureTable width n) (a : Fin width) :
    NTKFeatureVector n :=
  J a

@[simp]
theorem jacobianFeatureVector_apply {width n : Nat}
    (J : JacobianFeatureTable width n) (a : Fin width)
    (i : Fin (n + 1)) :
    jacobianFeatureVector J a i = J a i := by
  rfl

/-- Rank-one Gram contribution for one Jacobian-feature coordinate. -/
def jacobianGramContribution {width n : Nat}
    (J : JacobianFeatureTable width n) (a : Fin width) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  ntkGramOuter (jacobianFeatureVector J a)

@[simp]
theorem jacobianGramContribution_apply {width n : Nat}
    (J : JacobianFeatureTable width n) (a : Fin width)
    (i j : Fin (n + 1)) :
    jacobianGramContribution J a i j = J a i * J a j := by
  rfl

/-- Empirical NTK Gram matrix as a sum of rank-one Jacobian Gram contributions. -/
def empiricalNTKGram {width n : Nat}
    (J : JacobianFeatureTable width n) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  Finset.univ.sum fun a : Fin width => jacobianGramContribution J a

/-- Optional width-normalized empirical NTK Gram matrix. -/
def normalizedEmpiricalNTKGram {width n : Nat}
    (J : JacobianFeatureTable width n) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  SMul.smul (1 / (width : Real)) (empiricalNTKGram J)

/-- The empirical NTK Gram is definitionally the sum of rank-one contributions. -/
theorem empiricalNTKGram_eq_sum_rankOne {width n : Nat}
    (J : JacobianFeatureTable width n) :
    empiricalNTKGram J =
      Finset.univ.sum fun a : Fin width => jacobianGramContribution J a := by
  rfl

@[simp]
theorem empiricalNTKGram_apply {width n : Nat}
    (J : JacobianFeatureTable width n) (i j : Fin (n + 1)) :
    empiricalNTKGram J i j =
      Finset.univ.sum fun a : Fin width => J a i * J a j := by
  simpa [empiricalNTKGram, jacobianGramContribution, jacobianFeatureVector,
    ntkGramOuter] using
    (Matrix.sum_apply i j Finset.univ
      (fun a : Fin width => jacobianGramContribution J a))

@[simp]
theorem normalizedEmpiricalNTKGram_apply {width n : Nat}
    (J : JacobianFeatureTable width n) (i j : Fin (n + 1)) :
    normalizedEmpiricalNTKGram J i j =
      (1 / (width : Real)) *
        Finset.univ.sum fun a : Fin width => J a i * J a j := by
  rw [normalizedEmpiricalNTKGram]
  change (1 / (width : Real)) * empiricalNTKGram J i j = _
  rw [empiricalNTKGram_apply]

/-- A random finite Jacobian-feature table. -/
abbrev RandomJacobianFeatureTable (Omega : Type*) [MeasurableSpace Omega]
    (width n : Nat) :=
  Omega -> JacobianFeatureTable width n

/-- The random feature vector for one feature coordinate. -/
def randomJacobianFeatureVector {Omega : Type*} [MeasurableSpace Omega]
    {width n : Nat} (J : RandomJacobianFeatureTable Omega width n)
    (a : Fin width) :
    RandomNTKFeatureVector Omega n :=
  fun omega => jacobianFeatureVector (J omega) a

@[simp]
theorem randomJacobianFeatureVector_apply {Omega : Type*}
    [MeasurableSpace Omega] {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n) (a : Fin width)
    (omega : Omega) (i : Fin (n + 1)) :
    randomJacobianFeatureVector J a omega i = J omega a i := by
  rfl

/-- Family of random Jacobian feature vectors indexed by feature coordinate. -/
def randomJacobianFeatureVectorFamily {Omega : Type*} [MeasurableSpace Omega]
    {width n : Nat} (J : RandomJacobianFeatureTable Omega width n) :
    Fin width -> RandomNTKFeatureVector Omega n :=
  randomJacobianFeatureVector J

@[simp]
theorem randomJacobianFeatureVectorFamily_apply {Omega : Type*}
    [MeasurableSpace Omega] {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n) (a : Fin width) :
    randomJacobianFeatureVectorFamily J a = randomJacobianFeatureVector J a := by
  rfl

/-- Random rank-one Gram contribution from one Jacobian-feature coordinate. -/
def randomJacobianGramContribution {Omega : Type*} [MeasurableSpace Omega]
    {width n : Nat} (J : RandomJacobianFeatureTable Omega width n)
    (a : Fin width) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  ntkGramContribution (randomJacobianFeatureVector J a)

@[simp]
theorem randomJacobianGramContribution_apply {Omega : Type*}
    [MeasurableSpace Omega] {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n) (a : Fin width)
    (omega : Omega) (i j : Fin (n + 1)) :
    randomJacobianGramContribution J a omega i j =
      J omega a i * J omega a j := by
  rfl

/-- Random empirical NTK Gram matrix. -/
def randomEmpiricalNTKGram {Omega : Type*} [MeasurableSpace Omega]
    {width n : Nat} (J : RandomJacobianFeatureTable Omega width n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  fun omega => empiricalNTKGram (J omega)

@[simp]
theorem randomEmpiricalNTKGram_apply {Omega : Type*}
    [MeasurableSpace Omega] {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n) (omega : Omega)
    (i j : Fin (n + 1)) :
    randomEmpiricalNTKGram J omega i j =
      Finset.univ.sum fun a : Fin width => J omega a i * J omega a j := by
  simp [randomEmpiricalNTKGram]

/-- Centered random Jacobian Gram contribution for one feature coordinate.

This reuses the NTK-facing centered rank-one adapter; feature-level analytic
assumptions remain explicit in the Matrix Bernstein structures below. -/
def centeredJacobianGramContribution {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n) (a : Fin width) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  centeredNTKGramContribution (P := P) (randomJacobianFeatureVector J a)

/-- Centered Jacobian Gram summand family for Matrix Bernstein. -/
def centeredJacobianGramSummands {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n) :
    Fin width -> RandomMatrix Omega (n + 1) (n + 1) :=
  centeredNTKGramSummands (P := P) (randomJacobianFeatureVectorFamily J)

/-- Example-local adapter from a concrete Jacobian decomposition to the abstract
summand family used by Matrix Bernstein.

This adapter is semantic glue only; it is not a proof that arbitrary
neural-network Jacobians satisfy Matrix Bernstein hypotheses. -/
def IsCenteredJacobianGramSummandFamily {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1)) : Prop :=
  A = centeredJacobianGramSummands (P := P) J

/-- Jacobian-decomposition assumptions plus the existing NTK Gram Matrix
Bernstein assumptions.

The `centeredJacobianAdapter` field records the concrete decomposition. The
`matrixBernsteinReady` field exposes all analytic Matrix Bernstein assumptions
through the existing `NTKGramUsage` structure. -/
structure NTKJacobianGramMatrixBernsteinAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R sigmaSq : Real) : Prop where
  centeredJacobianAdapter : IsCenteredJacobianGramSummandFamily (P := P) J A
  matrixBernsteinReady :
    NTKGramMatrixBernsteinAssumptions
      (P := P) (randomJacobianFeatureVectorFamily J) A theta R sigmaSq

/-- Jacobian-decomposed NTK Gram quadratic-form upper-tail bound with the
normalized scalar Matrix Bernstein RHS. -/
theorem ntkJacobianGram_quadraticForm_tail_scalar_exp_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R t sigmaSq : Real)
    (h : NTKJacobianGramMatrixBernsteinAssumptions
      (P := P) J A theta R sigmaSq) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(theta * t) + bernsteinMGFCoeff theta R * sigmaSq)) := by
  exact
    ntkGram_quadraticForm_tail_scalar_exp_under_primitives
      (P := P) (randomJacobianFeatureVectorFamily J) A theta R t sigmaSq
      h.matrixBernsteinReady

/-- Jacobian-decomposed NTK Gram quadratic-form upper-tail bound with the
trace-exponential Matrix Bernstein RHS. -/
theorem ntkJacobianGram_quadraticForm_tail_traceExp_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R t sigmaSq : Real)
    (h : NTKJacobianGramMatrixBernsteinAssumptions
      (P := P) J A theta R sigmaSq) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp
            (SMul.smul (bernsteinMGFCoeff theta R)
              (matrixVarianceProxy P A))) := by
  exact
    ntkGram_quadraticForm_tail_traceExp_under_primitives
      (P := P) (randomJacobianFeatureVectorFamily J) A theta R t sigmaSq
      h.matrixBernsteinReady

/-- Jacobian-decomposition assumptions plus the optimized NTK Gram Matrix
Bernstein assumptions.

The `centeredJacobianAdapter` field records the concrete decomposition. The
`matrixBernsteinReady` field exposes all optimized analytic Matrix Bernstein
assumptions through the existing `NTKGramUsage` structure. -/
structure NTKJacobianGramOptimizedMatrixBernsteinAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (R t sigmaSq : Real) : Prop where
  centeredJacobianAdapter : IsCenteredJacobianGramSummandFamily (P := P) J A
  matrixBernsteinReady :
    NTKGramOptimizedMatrixBernsteinAssumptions
      (P := P) (randomJacobianFeatureVectorFamily J) A R t sigmaSq

/-- Jacobian-decomposed NTK Gram quadratic-form upper-tail bound with the
optimized scalar Matrix Bernstein RHS. -/
theorem ntkJacobianGram_quadraticForm_tail_optimized_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {width n : Nat}
    (J : RandomJacobianFeatureTable Omega width n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (R t sigmaSq : Real)
    (h : NTKJacobianGramOptimizedMatrixBernsteinAssumptions
      (P := P) J A R t sigmaSq) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      matrixBernsteinOptimizedScalarTailRHS (n + 1) R t sigmaSq := by
  exact
    ntkGram_quadraticForm_tail_optimized_under_primitives
      (P := P) (randomJacobianFeatureVectorFamily J) A R t sigmaSq
      h.matrixBernsteinReady

end

end HighDimProb.Examples.RandomMatrix.NTKGramDecompositionUsage
