import HighDimProb.RandomMatrix.ConcentrationStatements
import HighDimProb.RandomVector

/-!
# NTK-style Gram matrix concentration usage example

This file is an application-style example. It does not prove neural tangent
kernel initialization, random-feature subGaussianity, training stability, or
the Matrix Bernstein primitives. It only shows how an NTK/random-feature Gram
matrix concentration statement can be expressed using the existing RandomMatrix
Matrix Bernstein API under explicit assumptions.
-/

namespace HighDimProb.Examples.RandomMatrix.NTKGramUsage

open MeasureTheory

noncomputable section

/-- A feature/Jacobian vector evaluated on a finite dataset of size `n + 1`. -/
abbrev NTKFeatureVector (n : Nat) :=
  Fin (n + 1) -> Real

/-- A random NTK feature vector. The feature index itself is supplied separately. -/
abbrev RandomNTKFeatureVector (Omega : Type*) [MeasurableSpace Omega] (n : Nat) :=
  RandomVector Omega (n + 1)

/-- Rank-one Gram contribution `v v^T` from one feature/Jacobian vector. -/
def ntkGramOuter {n : Nat} (v : NTKFeatureVector n) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  fun i j => v i * v j

@[simp]
theorem ntkGramOuter_apply {n : Nat} (v : NTKFeatureVector n)
    (i j : Fin (n + 1)) :
    ntkGramOuter v i j = v i * v j := by
  rfl

/-- Random rank-one Gram contribution from one random feature. -/
def ntkGramContribution {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (J : RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  fun omega => ntkGramOuter (J omega)

@[simp]
theorem ntkGramContribution_apply {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (J : RandomNTKFeatureVector Omega n) (omega : Omega)
    (i j : Fin (n + 1)) :
    ntkGramContribution J omega i j = J omega i * J omega j := by
  rfl

/-- Centered rank-one Gram contribution for one feature.

The expectation is entrywise, using the existing `matrixExpect` API. -/
def centeredNTKGramContribution {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (J : RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  fun omega => ntkGramContribution J omega - matrixExpect P (ntkGramContribution J)

/-- The centered NTK Gram summand family indexed by finite random features. -/
def centeredNTKGramSummands {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) :
    Fin width -> RandomMatrix Omega (n + 1) (n + 1) :=
  fun a => centeredNTKGramContribution (P := P) (J a)

/-- Example-local adapter tying an arbitrary Matrix Bernstein summand family to
centered NTK/random-feature Gram contributions.

This is intentionally an assumption-level adapter. Future core support could
derive self-adjointness, measurability, integrability, and centering from
feature-level hypotheses, but this example keeps those facts explicit. -/
def IsCenteredNTKGramSummandFamily {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1)) : Prop :=
  A = centeredNTKGramSummands (P := P) J

/-- Assumptions needed to use the existing Matrix Bernstein API for an
NTK/random-feature Gram matrix.

The `ntkAdapter` field is semantic glue only. It records that the summands are
the centered NTK Gram contributions. The remaining fields are exactly the
Matrix Bernstein assumptions consumed by the existing theorem. -/
structure NTKGramMatrixBernsteinAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R sigmaSq : Real) : Prop where
  ntkAdapter : IsCenteredNTKGramSummandFamily (P := P) J A
  centered : CenteredSelfAdjointRandomMatrixFamily P A
  independentSelfAdjoint : IndependentSelfAdjointRandomMatrices P A
  integrable : forall a, IntegrableRandomMatrix P (A a)
  squareIntegrable : forall a, IntegrableRandomMatrix P (randomMatrixSquare (A a))
  expIntegrable :
    forall a,
      IntegrableRandomMatrix P
        (fun omega => matrixExp (SMul.smul theta (A a omega)))
  traceExpIntegrable :
    IntegrableRealRandomVariable P
      (traceExpIntegrand (randomMatrixSum A) theta)
  operatorNormBound : PointwiseOperatorNormBound A R
  radiusNonneg : 0 <= R
  thetaRange : abs theta * R < 3
  thetaPositive : 0 < theta
  varianceProxyNormBound : MatrixVarianceProxyNormBound P A sigmaSq
  cfcPrimitive :
    forall a omega,
      bernsteinMatrixExp_le_quadratic_statement (A a omega) theta R
  troppPrimitive :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P) A
      (fun a => SMul.smul (bernsteinMGFCoeff theta R)
        (matrixSecondMoment P (A a)))
      (matrixVarianceProxy P A) theta R

/-- NTK-style quadratic-form upper-tail bound with the normalized scalar RHS.

The conclusion is stated for the centered NTK Gram deviation
`randomMatrixSum A`; the adapter field records that `A` is the centered
rank-one NTK/random-feature Gram summand family. -/
theorem ntkGram_quadraticForm_tail_scalar_exp_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R t sigmaSq : Real)
    (h : NTKGramMatrixBernsteinAssumptions
      (P := P) J A theta R sigmaSq) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(theta * t) + bernsteinMGFCoeff theta R * sigmaSq)) := by
  exact
    matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
      A theta R t sigmaSq h.centered h.independentSelfAdjoint h.integrable
      h.squareIntegrable h.expIntegrable h.traceExpIntegrable
      h.operatorNormBound h.radiusNonneg h.thetaRange h.thetaPositive
      h.varianceProxyNormBound h.cfcPrimitive h.troppPrimitive

/-- Same NTK-style route, retaining the trace-exponential RHS. -/
theorem ntkGram_quadraticForm_tail_traceExp_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (A : Fin width -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R t sigmaSq : Real)
    (h : NTKGramMatrixBernsteinAssumptions
      (P := P) J A theta R sigmaSq) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp
            (SMul.smul (bernsteinMGFCoeff theta R)
              (matrixVarianceProxy P A))) := by
  exact
    matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives
      A theta R t h.centered h.independentSelfAdjoint h.integrable
      h.squareIntegrable h.expIntegrable h.traceExpIntegrable
      h.operatorNormBound h.radiusNonneg h.thetaRange h.thetaPositive
      h.cfcPrimitive h.troppPrimitive

end

end HighDimProb.Examples.RandomMatrix.NTKGramUsage
