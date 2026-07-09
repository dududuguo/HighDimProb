import HighDimProb.RandomMatrix.VarianceProxy
import HighDimProb.Tail

/-!
# Zero matrix-variance consequences

Degenerate variance forces each self-adjoint summand, their finite sum, and
every positive operator-norm upper tail to vanish almost everywhere.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator

noncomputable section

private def matrixTraceCLM {n : Nat} :
    Matrix (Fin n) (Fin n) Real →L[Real] Real :=
  (Matrix.traceLinearMap (Fin n) Real Real).toContinuousLinearMap

/-- A zero scalar norm bound forces the matrix variance proxy itself to be
zero. -/
theorem matrixVarianceProxy_eq_zero_of_normBound_zero
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hNorm : MatrixVarianceProxyNormBound P A 0) :
    matrixVarianceProxy P A = 0 := by
  have hNormZero : matrixVarianceProxyNorm P A = 0 :=
    le_antisymm hNorm (norm_nonneg _)
  exact norm_eq_zero.mp hNormZero

/-- A zero variance proxy forces every self-adjoint summand to vanish almost
everywhere. -/
theorem randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxy_eq_zero
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hSA : forall i, RandomSelfAdjointMatrix P (A i))
    (hInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hV : matrixVarianceProxy P A = 0) :
    forall i, ∀ᵐ omega ∂P, A i omega = 0 := by
  have htraceInt :
      forall i, Integrable
        (fun omega => Matrix.trace (randomMatrixSquare (A i) omega)) P := by
    intro i
    exact (matrixTraceCLM (n := n)).integrable_comp
      (integrable_matrix_of_integrableRandomMatrix (hInt i))
  have htraceIntegral :
      forall i,
        Matrix.trace (matrixSecondMoment P (A i)) =
          ∫ omega, Matrix.trace (randomMatrixSquare (A i) omega) ∂P := by
    intro i
    rw [matrixSecondMoment, matrixExpect_eq_integral (hInt i)]
    change matrixTraceCLM (∫ omega, randomMatrixSquare (A i) omega ∂P) =
      ∫ omega, matrixTraceCLM (randomMatrixSquare (A i) omega) ∂P
    exact ((matrixTraceCLM (n := n)).integral_comp_comm
      (integrable_matrix_of_integrableRandomMatrix (hInt i))).symm
  have htraceNonneg :
      forall i, 0 ≤ᵐ[P]
        fun omega => Matrix.trace (randomMatrixSquare (A i) omega) := by
    intro i
    filter_upwards with omega
    have hsymm : (A i omega).IsSymm := by
      simpa using hSA i omega
    have hpsd : (matrixSquare (A i omega)).PosSemidef := by
      simpa [matrixSquare, hsymm.eq] using
        Matrix.posSemidef_self_mul_conjTranspose (A i omega)
    exact hpsd.trace_nonneg
  have htraceVariance :
      Matrix.trace (matrixVarianceProxy P A) =
        ∑ i : I, ∫ omega,
          Matrix.trace (randomMatrixSquare (A i) omega) ∂P := by
    calc
      Matrix.trace (matrixVarianceProxy P A) =
          ∑ i : I, Matrix.trace (matrixSecondMoment P (A i)) := by
            simp [matrixVarianceProxy]
      _ = ∑ i : I, ∫ omega,
          Matrix.trace (randomMatrixSquare (A i) omega) ∂P := by
            exact Finset.sum_congr rfl fun i _ => htraceIntegral i
  have hscalarSumZero :
      (∑ i : I, ∫ omega,
        Matrix.trace (randomMatrixSquare (A i) omega) ∂P) = 0 := by
    rw [← htraceVariance, hV]
    simp
  have hscalarIntegralZero :
      forall i,
        ∫ omega, Matrix.trace (randomMatrixSquare (A i) omega) ∂P = 0 := by
    intro i
    exact
      (Finset.sum_eq_zero_iff_of_nonneg
        (fun j _ => integral_nonneg_of_ae (htraceNonneg j))).1
        hscalarSumZero i (Finset.mem_univ i)
  intro i
  have htraceAEZero :
      (fun omega => Matrix.trace (randomMatrixSquare (A i) omega)) =ᵐ[P] 0 :=
    (integral_eq_zero_iff_of_nonneg_ae (htraceNonneg i) (htraceInt i)).1
      (hscalarIntegralZero i)
  filter_upwards [htraceAEZero] with omega htrace
  have hsymm : (A i omega).IsSymm := by
    simpa using hSA i omega
  have htraceMul :
      Matrix.trace ((A i omega) * (A i omega).conjTranspose) = 0 := by
    simpa [randomMatrixSquare, matrixSquare, hsymm.eq] using htrace
  exact Matrix.trace_mul_conjTranspose_self_eq_zero_iff.mp htraceMul

/-- Norm-bound formulation of the zero-variance almost-everywhere theorem. -/
theorem randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxyNormBound_zero
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hSA : forall i, RandomSelfAdjointMatrix P (A i))
    (hInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hNorm : MatrixVarianceProxyNormBound P A 0) :
    forall i, ∀ᵐ omega ∂P, A i omega = 0 :=
  randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxy_eq_zero hSA hInt
    (matrixVarianceProxy_eq_zero_of_normBound_zero hNorm)

/-- A finite random-matrix sum vanishes almost everywhere when every summand
does. -/
theorem randomMatrixSum_ae_eq_zero_of_family_ae_eq_zero
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hA : forall i, A i =ᵐ[P] 0) :
    randomMatrixSum A =ᵐ[P] 0 := by
  filter_upwards [MeasureTheory.ae_all_iff.mpr hA] with omega homega
  simp [randomMatrixSum, homega]

/-- A random-matrix sum that vanishes almost everywhere has zero positive
operator-norm upper tail. -/
theorem upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_ae_eq_zero
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hSum : randomMatrixSum A =ᵐ[P] 0) {t : Real} (ht : 0 < t) :
    upperTailProb P (operatorNorm (randomMatrixSum A)) t = 0 := by
  rw [upperTailProb_def]
  have hNoTail :
      ∀ᵐ omega ∂P,
        ¬ (omega ∈ upperTailEvent (operatorNorm (randomMatrixSum A)) t) := by
    filter_upwards [hSum] with omega homega
    intro hTail
    have hZero : randomMatrixSum A omega =
        (0 : Matrix (Fin n) (Fin n) Real) := by
      simpa using homega
    rw [mem_upperTailEvent, operatorNorm_apply, hZero] at hTail
    have hTail' : t <= (0 : Real) := by
      simpa using hTail
    exact (not_le_of_gt ht) hTail'
  simpa [upperTailEvent] using (MeasureTheory.ae_iff.mp hNoTail)

/-- Zero variance gives a null positive operator-norm tail for the finite
random-matrix sum. -/
theorem upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_varianceNormBound_zero
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hSA : forall i, RandomSelfAdjointMatrix P (A i))
    (hInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hNorm : MatrixVarianceProxyNormBound P A 0)
    {t : Real} (ht : 0 < t) :
    upperTailProb P (operatorNorm (randomMatrixSum A)) t = 0 := by
  apply upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_ae_eq_zero (ht := ht)
  exact randomMatrixSum_ae_eq_zero_of_family_ae_eq_zero
    (randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxyNormBound_zero
      hSA hInt hNorm)

end

end HighDimProb
