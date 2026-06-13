import HighDimProb.Examples.RandomMatrix.RankOnePSDUsage
import HighDimProb.RandomMatrix.VarianceProxy

/-!
# Centered rank-one covariance adapter usage example

This examples-only file shows how an uncentered rank-one covariance
contribution can be converted into a centered random matrix summand
`X - E[X]` using the existing entrywise `matrixExpect` API.

It proves the expectation-zero property from existing matrix expectation
lemmas. The uncentered rank-one contribution now reuses the named
`rankOneRandomMatrix` API, so vector-level second-moment hypotheses can supply
entrywise integrability. Matrix-level centered measurability and
self-adjointness remain explicit example-local assumptions.
-/

namespace HighDimProb.Examples.RandomMatrix.CenteredRankOneCovarianceAdapterUsage

open MeasureTheory
open HighDimProb.Examples.RandomMatrix.RankOnePSDUsage

noncomputable section

/-- A random vector used to form a rank-one covariance contribution. -/
abbrev RandomRankOneVector (Omega : Type*) [MeasurableSpace Omega] (n : Nat) :=
  Omega -> RankOneVector n

/-- Uncentered rank-one covariance contribution `x x^T`. -/
def rankOneCovarianceContribution {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (X : RandomRankOneVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  rankOneRandomMatrix X

@[simp]
theorem rankOneCovarianceContribution_apply {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (X : RandomRankOneVector Omega n)
    (omega : Omega) (i j : Fin (n + 1)) :
    rankOneCovarianceContribution X omega i j = X omega i * X omega j := by
  rfl

/-- Centered rank-one covariance summand `X X^T - E[X X^T]`. -/
def centeredRankOneCovarianceSummand {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (X : RandomRankOneVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  centeredRandomMatrix P (rankOneCovarianceContribution X)

@[simp]
theorem centeredRankOneCovarianceSummand_apply {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (X : RandomRankOneVector Omega n) (omega : Omega)
    (i j : Fin (n + 1)) :
    centeredRankOneCovarianceSummand (P := P) X omega i j =
      X omega i * X omega j -
        matrixExpect P (rankOneCovarianceContribution X) i j := by
  rfl

/-- The uncentered rank-one contribution is pointwise self-adjoint. -/
theorem rankOneCovarianceContribution_selfAdjoint {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (X : RandomRankOneVector Omega n) :
    RandomSelfAdjointMatrix P (rankOneCovarianceContribution X) := by
  intro omega
  simpa [rankOneCovarianceContribution, rankOneRandomMatrix, rankOneMatrix,
    rankOneOuter] using rankOneOuter_selfAdjoint (X omega)

/-- The uncentered rank-one contribution is pointwise PSD. -/
theorem rankOneCovarianceContribution_psd {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (X : RandomRankOneVector Omega n) :
    RandomPSDMatrix P (rankOneCovarianceContribution X) := by
  intro omega
  simpa [rankOneCovarianceContribution, rankOneRandomMatrix, rankOneMatrix,
    rankOneOuter] using rankOneOuter_psd (X omega)

/-- Vector measurability gives entrywise random-matrix measurability for the
uncentered rank-one covariance contribution. -/
theorem isRandomMatrix_rankOneCovarianceContribution {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomRankOneVector Omega n}
    (hX : IsRandomVector P X) :
    IsRandomMatrix P (rankOneCovarianceContribution X) := by
  simpa [rankOneCovarianceContribution] using
    (isRandomMatrix_rankOneRandomMatrix (P := P) (X := X) hX)

/-- Coordinate second moments give entrywise integrability of the uncentered
rank-one covariance contribution. -/
theorem integrable_rankOneCovarianceContribution_of_memLp_two {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomRankOneVector Omega n}
    (hX : forall j : Fin (n + 1),
      MemLpRealRandomVariable P (coord X j) 2) :
    IntegrableRandomMatrix P (rankOneCovarianceContribution X) := by
  simpa [rankOneCovarianceContribution] using
    (integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
      (P := P) (X := X) hX)

/-- Entrywise integrability of the uncentered rank-one contribution gives
entrywise integrability of its centered version. -/
theorem integrable_centeredRankOneCovarianceSummand {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {n : Nat} {X : RandomRankOneVector Omega n}
    (hInt : IntegrableRandomMatrix P (rankOneCovarianceContribution X)) :
    IntegrableRandomMatrix P (centeredRankOneCovarianceSummand (P := P) X) := by
  let B := rankOneCovarianceContribution X
  change IntegrableRandomMatrix P (fun omega => B omega - matrixExpect P B)
  exact integrableRandomMatrix_sub
    (A := fun _omega => matrixExpect P B) (B := B)
    (integrableRandomMatrix_const (P := P) (matrixExpect P B)) hInt

/-- Centering by entrywise matrix expectation gives zero entrywise expectation. -/
theorem matrixExpect_centeredRankOneCovarianceSummand {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {n : Nat} {X : RandomRankOneVector Omega n}
    (hInt : IntegrableRandomMatrix P (rankOneCovarianceContribution X)) :
    matrixExpect P (centeredRankOneCovarianceSummand (P := P) X) = 0 := by
  let B := rankOneCovarianceContribution X
  change matrixExpect P (fun omega => B omega - matrixExpect P B) = 0
  have hConstInt :
      IntegrableRandomMatrix P (fun _omega => matrixExpect P B) :=
    integrableRandomMatrix_const (P := P) (matrixExpect P B)
  have hSub :
      matrixExpect P (fun omega => B omega - matrixExpect P B) =
        matrixExpect P B -
          matrixExpect P (fun _omega => matrixExpect P B) :=
    matrixExpect_sub (P := P) (A := fun _omega => matrixExpect P B)
      (B := B) hConstInt hInt
  rw [hSub]
  rw [matrixExpect_const_of_isProbabilityMeasure (P := P) (A := matrixExpect P B)]
  ext i j
  change matrixExpect P B i j - matrixExpect P B i j = 0
  ring

/-- A finite family of centered rank-one covariance summands. -/
def centeredRankOneCovarianceSummandFamily {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*}
    {n : Nat} (X : I -> RandomRankOneVector Omega n) :
    I -> RandomMatrix Omega (n + 1) (n + 1) :=
  fun i => centeredRankOneCovarianceSummand (P := P) (X i)

/-- Local assumptions needed to expose the centered rank-one family through
the Matrix Bernstein centered self-adjoint predicate.

Second-moment integrability is derived through the rank-one random-matrix
bridge above. Centered measurability and self-adjointness are still explicit
because this example does not bundle a general centered self-adjointness
theorem. -/
structure CenteredRankOneCovarianceMatrixAdapter {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n) : Prop where
  coordinateMemLpTwo :
    forall i, forall j : Fin (n + 1),
      MemLpRealRandomVariable P (coord (X i) j) 2
  centeredIsRandom :
    forall i, IsRandomMatrix P
      (centeredRankOneCovarianceSummand (P := P) (X i))
  centeredSelfAdjoint :
    forall i, RandomSelfAdjointMatrix P
      (centeredRankOneCovarianceSummand (P := P) (X i))

/-- The centered rank-one covariance adapter supplies the centered
self-adjoint family predicate used by Matrix Bernstein. -/
theorem centeredRankOneCovariance_family_centeredSelfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} {n : Nat}
    (X : I -> RandomRankOneVector Omega n)
    (h : CenteredRankOneCovarianceMatrixAdapter (P := P) X) :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredRankOneCovarianceSummandFamily (P := P) X) := by
  exact And.intro (And.intro h.centeredIsRandom h.centeredSelfAdjoint)
    (fun i =>
      matrixExpect_centeredRankOneCovarianceSummand
        (P := P) (X := X i)
        (integrable_rankOneCovarianceContribution_of_memLp_two
          (P := P) (X := X i) (h.coordinateMemLpTwo i)))

end

end HighDimProb.Examples.RandomMatrix.CenteredRankOneCovarianceAdapterUsage
