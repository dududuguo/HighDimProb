import HighDimProb.RandomMatrix.Concentration
import HighDimProb.RandomVector

/-!
# NTK-style Gram matrix concentration usage example

This application specializes the centered rank-one Matrix Bernstein endpoint to
finite-width NTK/random-feature Gram summands. Random-vector measurability,
coordinate second moments, a uniform squared-vector-norm bound, and independence
of the centered self-adjoint summands are the only retained hypotheses.

This file does not prove NTK initialization, feature-tail assumptions, or
training stability.
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
  rankOneMatrix v

@[simp]
theorem ntkGramOuter_apply {n : Nat} (v : NTKFeatureVector n)
    (i j : Fin (n + 1)) :
    ntkGramOuter v i j = v i * v j := by
  rfl

/-- Random rank-one Gram contribution from one random feature. -/
def ntkGramContribution {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (J : RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  rankOneRandomMatrix J

@[simp]
theorem ntkGramContribution_apply {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (J : RandomNTKFeatureVector Omega n) (omega : Omega)
    (i j : Fin (n + 1)) :
    ntkGramContribution J omega i j = J omega i * J omega j := by
  rfl

/-- Centered rank-one Gram contribution for one feature. -/
abbrev centeredNTKGramContribution {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (J : RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  centeredRankOneRandomMatrix P J

/-- The centered NTK Gram summand family indexed by finite random features. -/
abbrev centeredNTKGramSummands {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) :
    Fin width -> RandomMatrix Omega (n + 1) (n + 1) :=
  centeredRankOneRandomMatrixFamily P J

/-- NTK-facing alias for the reusable centered rank-one inputs. -/
abbrev NTKGramInputs {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) (R : Real) : Prop :=
  MatrixBernstein.CenteredRankOneInputs (P := P) J R

/-- Operator-norm upper tail for the centered finite-width NTK Gram deviation.

The centered summand radius is `2 * R`; the variance parameter is the automatic
`centeredRankOneVarianceProxyNormRHS` for the feature family.
-/
theorem ntkGram_operatorNormTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n width : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (R t : Real) (h : NTKGramInputs (P := P) J R) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredNTKGramSummands (P := P) J))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) (2 * R) (2 * R) t
        (centeredRankOneVarianceProxyNormRHS (I := Fin width) R)
        (centeredRankOneVarianceProxyNormRHS (I := Fin width) R) := by
  simpa using
    MatrixBernstein.centeredRankOne
      (mOmega := mOmega) (P := P) J R t (Nat.succ_pos n) h ht

end

end HighDimProb.Examples.RandomMatrix.NTKGramUsage
