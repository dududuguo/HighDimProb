import HighDimProb.Examples.RandomMatrix.CenteredRankOneCovarianceAdapterUsage
import HighDimProb.Examples.RandomMatrix.CenteredSelfAdjointClosureUsage
import HighDimProb.Examples.RandomMatrix.GradientNormToOperatorBoundUsage
import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Rank-one Matrix Bernstein pipeline usage example

This examples-only file composes the rank-one covariance, centering,
self-adjointness, operator-norm, and optimized Matrix Bernstein usage layers.
It does not prove independence, variance proxy bounds, Tropp/Lieb, Bernstein
CFC, or neural-network feature hypotheses.
-/

namespace HighDimProb.Examples.RandomMatrix.RankOneMatrixBernsteinPipelineUsage

open MeasureTheory
open HighDimProb.Examples.RandomMatrix.CenteredRankOneCovarianceAdapterUsage
open HighDimProb.Examples.RandomMatrix.CenteredSelfAdjointClosureUsage

noncomputable section

/-- The uncentered rank-one covariance family associated with random vectors. -/
def rankOneCovarianceContributionFamily {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n) :
    I -> RandomMatrix Omega (n + 1) (n + 1) :=
  fun i => rankOneCovarianceContribution (X i)

/-- The centered rank-one covariance family used as Matrix Bernstein summands. -/
def centeredRankOnePipelineSummands {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n) :
    I -> RandomMatrix Omega (n + 1) (n + 1) :=
  centeredRankOneCovarianceSummandFamily (P := P) X

/-- The pipeline summands are centered versions of the uncentered rank-one
family. -/
theorem centeredRankOnePipelineSummands_eq_centered {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n) :
    centeredRankOnePipelineSummands (P := P) X =
      centeredRandomMatrixFamily P (rankOneCovarianceContributionFamily X) := by
  rfl

/-- Matrix-exponential random matrix family used by the rank-one pipeline. -/
def centeredRankOnePipelineMatrixExp {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n) (theta : Real) (i : I) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  fun omega =>
    matrixExp
      (SMul.smul theta (centeredRankOnePipelineSummands (P := P) X i omega))

/-- Bernstein comparison family used by the rank-one pipeline Tropp
primitive. -/
def centeredRankOnePipelineBernsteinComparison {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n) (theta R : Real) :
    I -> Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  fun i =>
    SMul.smul (bernsteinMGFCoeff theta R)
      (matrixSecondMoment P (centeredRankOnePipelineSummands (P := P) X i))

/-- Assumptions for the optimized Matrix Bernstein pipeline.

The first three fields are rank-one construction facts from vector-level
assumptions. The remaining fields are the Matrix Bernstein hypotheses that
still need to be supplied explicitly in the examples layer. -/
structure RankOneMatrixBernsteinPipelineAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomRankOneVector Omega n)
    (R t sigmaSq : Real) : Prop where
  randomVector : forall i, IsRandomVector P (X i)
  coordinateMemLpTwo :
    forall i, forall j : Fin (n + 1),
      MemLpRealRandomVariable P (coord (X i) j) 2
  expectationSelfAdjoint :
    forall i,
      IsSelfAdjointMatrix
        (matrixExpect P (rankOneCovarianceContributionFamily X i))
  independentSelfAdjoint :
    IndependentSelfAdjointRandomMatrices P
      (centeredRankOnePipelineSummands (P := P) X)
  squareIntegrable :
    forall i,
      IntegrableRandomMatrix P
        (randomMatrixSquare (centeredRankOnePipelineSummands (P := P) X i))
  expIntegrable :
    forall i,
      IntegrableRandomMatrix P
        (centeredRankOnePipelineMatrixExp (P := P) X
          (bernsteinThetaChoice t sigmaSq R) i)
  traceExpIntegrable :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (randomMatrixSum (centeredRankOnePipelineSummands (P := P) X))
        (bernsteinThetaChoice t sigmaSq R))
  operatorNormBound :
    PointwiseOperatorNormBound
      (centeredRankOnePipelineSummands (P := P) X) R
  sigmaPositive : 0 < sigmaSq
  radiusNonneg : 0 <= R
  deviationPositive : 0 < t
  varianceProxyNormBound :
    MatrixVarianceProxyNormBound P
      (centeredRankOnePipelineSummands (P := P) X) sigmaSq
  cfcPrimitive :
    forall i omega,
      bernsteinMatrixExp_le_quadratic_statement
        (centeredRankOnePipelineSummands (P := P) X i omega)
        (bernsteinThetaChoice t sigmaSq R) R
  troppPrimitive :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredRankOnePipelineSummands (P := P) X)
      (centeredRankOnePipelineBernsteinComparison (P := P) X
        (bernsteinThetaChoice t sigmaSq R) R)
      (matrixVarianceProxy P
        (centeredRankOnePipelineSummands (P := P) X))
      (bernsteinThetaChoice t sigmaSq R) R

/-- The rank-one pipeline supplies the centered self-adjoint family predicate. -/
theorem centeredRankOnePipeline_centeredSelfAdjoint {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n)
    (hRandom : forall i, IsRandomVector P (X i))
    (hMemLp :
      forall i, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (coord (X i) j) 2)
    (hExpect :
      forall i,
        IsSelfAdjointMatrix
          (matrixExpect P (rankOneCovarianceContributionFamily X i))) :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredRankOnePipelineSummands (P := P) X) := by
  rw [centeredRankOnePipelineSummands_eq_centered]
  exact centeredRandomMatrix_family_centeredSelfAdjoint
    (P := P) (rankOneCovarianceContributionFamily X)
    (fun i =>
      isRandomMatrix_rankOneCovarianceContribution
        (P := P) (X := X i) (hRandom i))
    (fun i => rankOneCovarianceContribution_selfAdjoint (P := P) (X i))
    hExpect
    (fun i =>
      integrable_rankOneCovarianceContribution_of_memLp_two
        (P := P) (X := X i) (hMemLp i))

/-- The rank-one pipeline supplies centered summand integrability. -/
theorem centeredRankOnePipeline_integrable {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n)
    (hMemLp :
      forall i, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (coord (X i) j) 2)
    (i : I) :
    IntegrableRandomMatrix P
      (centeredRankOnePipelineSummands (P := P) X i) := by
  exact integrable_centeredRankOneCovarianceSummand
    (P := P) (X := X i)
    (integrable_rankOneCovarianceContribution_of_memLp_two
      (P := P) (X := X i) (hMemLp i))

/-- Optimized Matrix Bernstein tail bound for the centered rank-one covariance
pipeline under explicit primitive assumptions. -/
theorem rankOnePipeline_quadraticForm_tail_optimized_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomRankOneVector Omega n)
    (R t sigmaSq : Real)
    (h : RankOneMatrixBernsteinPipelineAssumptions
      (P := P) X R t sigmaSq) :
    P (quadraticFormUpperTailEvent
        (randomMatrixSum (centeredRankOnePipelineSummands (P := P) X)) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) := by
  have hExpIntegrable :
      forall i,
        IntegrableRandomMatrix P
          (fun omega =>
            matrixExp
              (SMul.smul (bernsteinThetaChoice t sigmaSq R)
                (centeredRankOnePipelineSummands (P := P) X i omega))) := by
    intro i
    simpa [centeredRankOnePipelineMatrixExp] using h.expIntegrable i
  have hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredRankOnePipelineSummands (P := P) X)
        (fun i => SMul.smul
          (bernsteinMGFCoeff (bernsteinThetaChoice t sigmaSq R) R)
          (matrixSecondMoment P
            (centeredRankOnePipelineSummands (P := P) X i)))
        (matrixVarianceProxy P
          (centeredRankOnePipelineSummands (P := P) X))
        (bernsteinThetaChoice t sigmaSq R) R := by
    simpa [centeredRankOnePipelineBernsteinComparison] using h.troppPrimitive
  exact
    matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
      (centeredRankOnePipelineSummands (P := P) X) R t sigmaSq
      (centeredRankOnePipeline_centeredSelfAdjoint
        (P := P) X h.randomVector h.coordinateMemLpTwo
        h.expectationSelfAdjoint)
      h.independentSelfAdjoint
      (centeredRankOnePipeline_integrable
        (P := P) X h.coordinateMemLpTwo)
      h.squareIntegrable hExpIntegrable h.traceExpIntegrable
      h.operatorNormBound h.sigmaPositive h.radiusNonneg
      h.deviationPositive h.varianceProxyNormBound h.cfcPrimitive
      hTropp

end

end HighDimProb.Examples.RandomMatrix.RankOneMatrixBernsteinPipelineUsage
