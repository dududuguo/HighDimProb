import HighDimProb.RandomMatrix.Basic
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.TraceExp

namespace HighDimProb

open HighDimProb
open MeasureTheory
open scoped Matrix.Norms.L2Operator

noncomputable section

/-- Finite-measure provider bridge for the scaled matrix exponential.

The proof is entrywise: each entry of `matrixExp (theta • X_k)` is continuous
on a compact closed ball, hence bounded; the bound is then turned into
integrability using `MeasureTheory.Integrable.of_bound`.

This is intentionally narrower than HighDimProb's exact statement, because the
exact statement quantifies over an arbitrary measure `P` and therefore is not
honestly provable without a finite/probability-measure hypothesis. -/
theorem matrixExpScaledIntegrable_of_provider_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta R : Real) (X : Fin m -> RandomMatrix Omega n n) :
    (forall k, IsRandomMatrix P (X k)) ->
      0 <= R ->
        (forall k omega, operatorNorm (X k) omega <= R) ->
          forall k, IntegrableRandomMatrix P (fun omega => matrixExp (theta • (X k omega))) := by
  intro hX hR hbound k i j
  letI : NormedAlgebra Rat (Matrix (Fin n) (Fin n) Real) :=
    NormedAlgebra.restrictScalars Rat Real (Matrix (Fin n) (Fin n) Real)
  have hEntry : Continuous (fun M : Matrix (Fin n) (Fin n) Real => matrixExp M i j) := by
    have hEntry' : Continuous (fun M : Matrix (Fin n) (Fin n) Real => M i j) := by
      simpa using (continuous_apply j).comp (continuous_apply i)
    simpa [HighDimProb.matrixExp] using hEntry'.comp NormedSpace.exp_continuous
  have hcompact :
      IsCompact (Metric.closedBall (0 : Matrix (Fin n) (Fin n) Real) (abs theta * R)) := by
    simpa using
      (isCompact_closedBall (0 : Matrix (Fin n) (Fin n) Real) (abs theta * R))
  rcases hcompact.exists_bound_of_continuousOn hEntry.continuousOn with ⟨C, hC⟩
  have hsmul_meas : Measurable (fun omega => theta • (X k omega)) := by
    change Measurable (fun omega => fun i : Fin n => fun j : Fin n => theta * (X k omega i j))
    refine measurable_pi_lambda (fun omega i => fun j : Fin n => theta * (X k omega i j)) ?_
    intro i'
    refine measurable_pi_lambda (fun omega j => theta * (X k omega i' j)) ?_
    intro j'
    simpa using (hX k i' j').const_mul theta
  have hmeas : Measurable (fun omega => matrixExp (theta • (X k omega)) i j) :=
    hEntry.measurable.comp hsmul_meas
  apply MeasureTheory.Integrable.of_bound hmeas.aestronglyMeasurable C
  filter_upwards with omega
  have hdist :
      dist (theta • (X k omega)) (0 : Matrix (Fin n) (Fin n) Real) <= abs theta * R := by
    rw [dist_eq_norm, sub_zero, norm_smul, Real.norm_eq_abs]
    exact mul_le_mul_of_nonneg_left (hbound k omega) (abs_nonneg theta)
  have hmem : theta • (X k omega) ∈ Metric.closedBall (0 : Matrix (Fin n) (Fin n) Real) (abs theta * R) := by
    simpa [Metric.mem_closedBall] using hdist
  exact hC _ hmem

end

end HighDimProb