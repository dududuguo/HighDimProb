import HighDimProb.RandomMatrix.Basic
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.TraceExp

namespace HighDimProb

open HighDimProb
open MeasureTheory
open scoped Matrix.Norms.L2Operator

noncomputable section

/-- Finite-measure trace-exponential integrability from uniform operator-norm bounds.

The proof is a compactness argument: the sum `H + Z` is uniformly contained in
a closed ball, `traceMatrixExp` is continuous on that ball, and a continuous
function on a compact set is bounded. The final step is
`MeasureTheory.Integrable.of_bound`.

This is intentionally narrower than the exact HighDimProb Tropp statement,
which does not assume finite measure or any domination on the trace-exponential
integrand. -/
theorem traceMatrixExp_add_integrable_of_operatorNormBounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {n : Nat} (H Z : RandomMatrix Omega n n) (RH RZ : Real)
    (hH : IsRandomMatrix P H) (hZ : IsRandomMatrix P Z)
    (hHbound : ∀ ω, operatorNorm H ω ≤ RH)
    (hZbound : ∀ ω, operatorNorm Z ω ≤ RZ) :
    IntegrableRealRandomVariable P (fun ω => traceMatrixExp (H ω + Z ω)) := by
  have hSum : IsRandomMatrix P (fun ω => H ω + Z ω) := by
    intro i j
    simpa [HighDimProb.matrixEntry] using (hH i j).add (hZ i j)

  have hSumMeas : Measurable (fun ω => H ω + Z ω) :=
    measurable_randomMatrix_of_isRandomMatrix hSum

  letI : NormedAlgebra Rat (Matrix (Fin n) (Fin n) Real) :=
    NormedAlgebra.restrictScalars Rat Real (Matrix (Fin n) (Fin n) Real)

  have hTrace : Continuous
      (Matrix.traceLinearMap (n := Fin n) (α := Real) (R := Real) :
        Matrix (Fin n) (Fin n) Real →ₗ[Real] Real) :=
    LinearMap.continuous_of_finiteDimensional _

  have hTraceExp : Continuous (fun A : Matrix (Fin n) (Fin n) Real => traceMatrixExp A) := by
    simpa [HighDimProb.traceMatrixExp, HighDimProb.matrixTrace, HighDimProb.matrixExp] using
      hTrace.comp NormedSpace.exp_continuous

  have hcompact :
      IsCompact (Metric.closedBall (0 : Matrix (Fin n) (Fin n) Real) (RH + RZ)) := by
    simpa using
      (isCompact_closedBall (0 : Matrix (Fin n) (Fin n) Real) (RH + RZ))

  rcases hcompact.exists_bound_of_continuousOn hTraceExp.continuousOn with ⟨C, hC⟩
  have hbound : ∀ ω, |traceMatrixExp (H ω + Z ω)| ≤ C := by
    intro ω
    have hdist : dist (H ω + Z ω) (0 : Matrix (Fin n) (Fin n) Real) ≤ RH + RZ := by
      rw [dist_eq_norm, sub_zero]
      calc
        ‖H ω + Z ω‖ ≤ ‖H ω‖ + ‖Z ω‖ := norm_add_le _ _
        _ ≤ RH + RZ := add_le_add (hHbound ω) (hZbound ω)
    have hmem : H ω + Z ω ∈ Metric.closedBall (0 : Matrix (Fin n) (Fin n) Real) (RH + RZ) := by
      simpa [Metric.mem_closedBall] using hdist
    exact hC _ hmem

  have hMeas : Measurable (fun ω => traceMatrixExp (H ω + Z ω)) :=
    hTraceExp.measurable.comp hSumMeas

  exact MeasureTheory.Integrable.of_bound hMeas.aestronglyMeasurable C (ae_of_all _ hbound)

/-- Tropp-state-history add-step integrability under explicit operator-norm bounds.

This is a thin wrapper around the generic finite-measure bound above. It keeps
the Tropp naming available without claiming the exact HighDimProb theorem,
which is missing finite-measure and domination hypotheses. -/
theorem traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (RH RZ : Real)
    (hHist : ∀ i,
      IsRandomMatrix P
        (@troppStateHistory Omega _ m n theta X K i))
    (hStep : ∀ i,
      IsRandomMatrix P
        (@troppCurrentRandomStep Omega _ m n theta X i))
    (hHistBound : ∀ i ω,
      operatorNorm (@troppStateHistory Omega _ m n theta X K i) ω ≤ RH)
    (hStepBound : ∀ i ω,
      operatorNorm (@troppCurrentRandomStep Omega _ m n theta X i) ω ≤ RZ) :
    ∀ i,
      IntegrableRealRandomVariable P
        (fun ω =>
          traceMatrixExp
            (@troppStateHistory Omega _ m n theta X K i ω +
              @troppCurrentRandomStep Omega _ m n theta X i ω)) := by
  intro i
  exact
    traceMatrixExp_add_integrable_of_operatorNormBounds_finiteMeasure
      (P := P)
      (@troppStateHistory Omega _ m n theta X K i)
      (@troppCurrentRandomStep Omega _ m n theta X i)
      RH RZ (hHist i) (hStep i) (hHistBound i) (hStepBound i)

end


noncomputable section

/-- Tropp-state-history add-K integrability under explicit operator-norm bounds.

This is a thin wrapper around the generic finite-measure bound above. The
deterministic comparison matrix `K i` is treated as a constant random matrix so
the bridge stays reusable without claiming the exact HighDimProb statement.
-/
theorem traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (RH RK : Real)
    (hHist : forall i,
      IsRandomMatrix P
        (@troppStateHistory Omega _ m n theta X K i))
    (hHistBound : forall i omega,
      operatorNorm (@troppStateHistory Omega _ m n theta X K i) omega <= RH)
    (hKBound : forall i omega, operatorNorm (fun _ : Omega => K i) omega <= RK) :
    forall i,
      IntegrableRealRandomVariable P
        (fun omega =>
          traceMatrixExp
            (@troppStateHistory Omega _ m n theta X K i omega + K i)) := by
  intro i
  have hKrand : IsRandomMatrix P (fun _ : Omega => K i) := by
    intro a b
    change Measurable (fun _ : Omega => K i a b)
    exact measurable_const
  exact
    traceMatrixExp_add_integrable_of_operatorNormBounds_finiteMeasure
      (P := P)
      (@troppStateHistory Omega _ m n theta X K i)
      (fun _ : Omega => K i)
      RH RK
      (hHist i) hKrand (hHistBound i) (hKBound i)

end

end HighDimProb