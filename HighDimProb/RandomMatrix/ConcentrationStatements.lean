import HighDimProb.RandomMatrix.Assumptions
import HighDimProb.RandomMatrix.MatrixOrder
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.Sums
import HighDimProb.RandomMatrix.VarianceProxy
import HighDimProb.Tail
import Mathlib.Analysis.Normed.Algebra.Spectrum

/-!
# Matrix concentration assumption vocabulary and typed statements

This file contains assumption vocabulary and theorem-target `Prop`
specifications for future matrix concentration work. It intentionally does not
prove matrix Bernstein, matrix Hoeffding, matrix Chernoff, Hanson-Wright, or
covariance estimation.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator

noncomputable section

/-- Sample covariance centered at the identity, as a random matrix. -/
def sampleCovarianceMinusIdentity {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) : RandomMatrix Omega n n :=
  fun omega => sampleCovariance A omega - (1 : Matrix (Fin n) (Fin n) Real)

/-- Typed target for a future finite-dimensional matrix Bernstein theorem.

This is the original MC1/MC3 min-form statement. The PSD hypothesis on the
variance proxy is an explicit assumption; the corresponding derivation from
self-adjoint summands remains a typed target in `VarianceProxy.lean`, not a
proved theorem. -/
abbrev matrixBernsteinStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (sigma2 R c t : Real) : Prop :=
  CenteredSelfAdjointRandomMatrixFamily P A ->
    IndependentSelfAdjointRandomMatrices P A ->
      PointwiseOperatorNormBound A R ->
        IsPSDMatrix (matrixVarianceProxy P A) ->
          matrixVarianceProxyNorm P A <= sigma2 ->
            0 <= t ->
              upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
                ENNReal.ofReal
                  (2 * (n : Real) * Real.exp (-(c * min (t ^ 2 / sigma2) (t / R))))

/-- Refined matrix Bernstein statement with additive denominator form.

This is still a typed `Prop` target, not a theorem. It is proof-oriented:
entrywise integrability, centered self-adjointness, matrix-valued
independence, a pointwise operator-norm bound, an explicit PSD variance proxy,
nonnegative scale parameters, positive denominator constants, and denominator
positivity are all visible assumptions.

The intended shape is
`P(||sum_i A_i|| >= t) <= 2 n exp ( -t^2 / (c1*sigma2 + c2*R*t) )`.
Constants are conservative proof targets, not sharp constants. -/
abbrev matrixBernsteinSelfAdjointStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    [IsProbabilityMeasure P]
    (A : I -> RandomMatrix Omega n n) (sigma2 R c1 c2 t : Real) : Prop :=
  0 < n ->
    (forall i, IntegrableRandomMatrix P (A i)) ->
      CenteredSelfAdjointRandomMatrixFamily P A ->
        IndependentSelfAdjointRandomMatrices P A ->
          PointwiseOperatorNormBound A R ->
            IsPSDMatrix (matrixVarianceProxy P A) ->
              matrixVarianceProxyNorm P A <= sigma2 ->
                0 <= sigma2 ->
                  0 <= R ->
                    0 < c1 ->
                      0 < c2 ->
                        0 <= t ->
                          0 < c1 * sigma2 + c2 * R * t ->
                            upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
                              ENNReal.ofReal
                                (2 * (n : Real) *
                                  Real.exp (-(t ^ 2 / (c1 * sigma2 + c2 * R * t))))

/-- Typed target for the spectral-radius reduction for self-adjoint matrices.

This records a future bridge between HighDimProb's deterministic L2 operator
norm wrapper and Mathlib's spectral radius. It is not a theorem. -/
abbrev operatorNorm_eq_spectralRadius_of_selfAdjointStatement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix A ->
    deterministicOperatorNorm A = (spectralRadius ℝ A).toReal

/-- Lightweight high-probability bound notation.

`HighProbabilityBound P event rhs` means that `P(event) <= rhs`.
This is a thin wrapper around measure comparison for readability. -/
def HighProbabilityBound {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (event : Set Omega) (rhs : ENNReal) : Prop :=
  P event <= rhs

/-- Variant of `HighProbabilityBound` for events given as `Set Omega`. -/
abbrev highProbabilityBound {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (event : Set Omega) (rhs : ENNReal) : Prop :=
  HighProbabilityBound P event rhs

/-- Typed target for a future matrix Hoeffding theorem. -/
abbrev matrixHoeffdingStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (R c t : Real) : Prop :=
  CenteredRandomSelfAdjointMatrices P A ->
    IndependentRandomMatrices P A ->
      PointwiseOperatorNormBound A R ->
        0 <= t ->
          upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
            ENNReal.ofReal
              (2 * (n : Real) * Real.exp (-(c * t ^ 2 / ((Fintype.card I : Real) * R ^ 2))))

/-- Typed target for a future matrix Chernoff theorem for PSD summands. -/
abbrev matrixChernoffStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (R c t : Real) : Prop :=
  (forall i, RandomPSDMatrix P (A i)) ->
    IndependentRandomMatrices P A ->
      PointwiseOperatorNormBound A R ->
        0 <= t ->
          upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
            ENNReal.ofReal (2 * (n : Real) * Real.exp (-(c * t / R)))

/-- Typed target for future operator-norm covariance estimation from subGaussian isotropic rows. -/
abbrev covarianceEstimationStatement {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (P : Measure Omega) (A : RandomMatrix Omega m n)
    (K c t : Real) : Prop :=
  IsRandomMatrix P A ->
    SubGaussianRowsOrlicz P A K ->
      IsotropicRowsSecondMoment P A ->
        0 <= t ->
          upperTailProb P (operatorNorm (sampleCovarianceMinusIdentity A)) t <=
            ENNReal.ofReal (2 * Real.exp (-(c * t ^ 2)))

/-- Absolute quadratic-form deviation of the centered sample covariance. -/
def sampleCovarianceQuadraticFormDeviation {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (x : Fin n -> Real) :
    RealRandomVariable Omega :=
  fun omega => abs (matrixQuadraticForm (sampleCovarianceMinusIdentity A omega) x)

/-- Typed target for a future unit-sphere reduction of sample-covariance
operator-norm tails. This is a statement dependency, not a proved concentration
or covering theorem. -/
abbrev sampleCovarianceOperatorNormViaUnitSphereStatement {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (P : Measure Omega)
    (A : RandomMatrix Omega m n) (t bound : Real) : Prop :=
  0 <= bound ->
    (forall x : Fin n -> Real,
      IsUnitVector x ->
        upperTailProb P (sampleCovarianceQuadraticFormDeviation A x) t <=
          ENNReal.ofReal bound) ->
      upperTailProb P (operatorNorm (sampleCovarianceMinusIdentity A)) t <=
        ENNReal.ofReal bound

/-- Typed target for a generic sample-covariance operator-norm tail statement. -/
abbrev sampleCovarianceOperatorNormStatement {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (P : Measure Omega) (A : RandomMatrix Omega m n)
    (t bound : Real) : Prop :=
  0 <= bound ->
    upperTailProb P (operatorNorm (sampleCovariance A)) t <= ENNReal.ofReal bound

end

end HighDimProb
