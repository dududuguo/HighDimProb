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

private theorem comparisonMatrixPrefixSum_deterministicOperatorNorm_le
    {m n : Nat} (K : Fin m -> Matrix (Fin n) (Fin n) Real) (RK : Real)
    (hRK : 0 <= RK)
    (hK : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall k : Fin (m + 1),
      deterministicOperatorNorm (comparisonMatrixPrefixSum K k) <= m * RK := by
  intro k
  rw [comparisonMatrixPrefixSum, deterministicOperatorNorm]
  calc
    norm ((Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).sum fun i => K i)
        <=
          (Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).sum fun i => norm (K i) := by
            simpa using
              (norm_sum_le (Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat))
                fun i => K i)
    _ <= (Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).sum fun _ => RK := by
          refine Finset.sum_le_sum ?_
          intro i hi
          exact hK i
    _ =
        (((Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).card : Nat) :
          Real) * RK := by
          simp
    _ <= m * RK := by
          have hcardNat :
              (Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).card <= m := by
            simpa [Fintype.card_fin] using
              (Finset.card_filter_le (s := (Finset.univ : Finset (Fin m)))
                (p := fun i : Fin m => (i : Nat) < (k : Nat)))
          have hcard :
              (((Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).card :
                Nat) : Real) <= m := by
            exact_mod_cast hcardNat
          exact mul_le_mul_of_nonneg_right hcard hRK

private theorem comparisonMatrixSuffixSum_deterministicOperatorNorm_le
    {m n : Nat} (K : Fin m -> Matrix (Fin n) (Fin n) Real) (RK : Real)
    (hRK : 0 <= RK)
    (hK : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall k : Fin (m + 1),
      deterministicOperatorNorm (comparisonMatrixSuffixSum K k) <= m * RK := by
  intro k
  rw [comparisonMatrixSuffixSum, deterministicOperatorNorm]
  calc
    norm ((Finset.univ.filter fun i : Fin m => (k : Nat) <= (i : Nat)).sum fun i => K i)
        <=
          (Finset.univ.filter fun i : Fin m => (k : Nat) <= (i : Nat)).sum fun i => norm (K i) := by
            simpa using
              (norm_sum_le (Finset.univ.filter fun i : Fin m => (k : Nat) <= (i : Nat))
                fun i => K i)
    _ <= (Finset.univ.filter fun i : Fin m => (k : Nat) <= (i : Nat)).sum fun _ => RK := by
          refine Finset.sum_le_sum ?_
          intro i hi
          exact hK i
    _ =
        (((Finset.univ.filter fun i : Fin m => (k : Nat) <= (i : Nat)).card : Nat) :
          Real) * RK := by
          simp
    _ <= m * RK := by
          have hcardNat :
              (Finset.univ.filter fun i : Fin m => (k : Nat) <= (i : Nat)).card <= m := by
            simpa [Fintype.card_fin] using
              (Finset.card_filter_le (s := (Finset.univ : Finset (Fin m)))
                (p := fun i : Fin m => (k : Nat) <= (i : Nat)))
          have hcard :
              (((Finset.univ.filter fun i : Fin m => (k : Nat) <= (i : Nat)).card :
                Nat) : Real) <= m := by
            exact_mod_cast hcardNat
          exact mul_le_mul_of_nonneg_right hcard hRK

/-- Operator-norm bound for the natural current Tropp step from a summand bound. -/
theorem troppCurrentRandomStep_operatorNorm_le_of_summand_bound
    {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta RX : Real) (X : Fin m -> RandomMatrix Omega n n)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX) :
    forall i omega,
      operatorNorm (@troppCurrentRandomStep Omega _ m n theta X i) omega <= abs theta * RX := by
  intro i omega
  change norm (SMul.smul theta (X i omega)) <= abs theta * RX
  rw [show norm (SMul.smul theta (X i omega)) = abs theta * norm (X i omega) by
    simpa using norm_smul theta (X i omega)]
  exact mul_le_mul_of_nonneg_left (hXBound i omega) (abs_nonneg theta)

/-- Operator-norm bound for the natural Tropp history from summand and comparison bounds. -/
theorem troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds
    {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall i omega,
      operatorNorm (@troppStateHistory Omega _ m n theta X K i) omega <=
        m * RK + m * (abs theta * RX) := by
  intro i omega
  change norm (troppComparisonHistory K i + troppRandomHistory theta X i omega) <=
    m * RK + m * (abs theta * RX)
  have hComp : deterministicOperatorNorm (troppComparisonHistory K i) <= m * RK :=
    comparisonMatrixPrefixSum_deterministicOperatorNorm_le K RK hRK hKBound i.castSucc
  have hScaled :
      forall j omega, operatorNorm (scaledRandomMatrixFamily theta X j) omega <= abs theta * RX :=
    troppCurrentRandomStep_operatorNorm_le_of_summand_bound theta RX X hXBound
  have hRand : operatorNorm (troppRandomHistory theta X i) omega <= m * (abs theta * RX) := by
    change norm (comparisonMatrixSuffixSum (fun j => scaledRandomMatrixFamily theta X j omega) i.succ) <=
      m * (abs theta * RX)
    exact comparisonMatrixSuffixSum_deterministicOperatorNorm_le
      (fun j => scaledRandomMatrixFamily theta X j omega) (abs theta * RX)
      (mul_nonneg (abs_nonneg theta) hRX) (fun j => hScaled j omega) i.succ
  calc
    norm (troppComparisonHistory K i + troppRandomHistory theta X i omega)
        <= norm (troppComparisonHistory K i) + norm (troppRandomHistory theta X i omega) :=
          norm_add_le _ _
    _ <= m * RK + m * (abs theta * RX) := by
          simpa [deterministicOperatorNorm] using add_le_add hComp hRand

/-- Finite-measure Tropp add-step integrability from summand and comparison bounds.

This is stronger than the raw finite-measure wrapper: instead of requiring
pointwise bounds on `troppStateHistory` and `troppCurrentRandomStep`
themselves, it derives those bounds from a pointwise summand bound on `X`
and a deterministic operator-norm bound on the comparison family `K`. -/
theorem traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hHist : forall i,
      IsRandomMatrix P
        (@troppStateHistory Omega _ m n theta X K i))
    (hStep : forall i,
      IsRandomMatrix P
        (@troppCurrentRandomStep Omega _ m n theta X i))
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall i,
      IntegrableRealRandomVariable P
        (fun omega =>
          traceMatrixExp
            (@troppStateHistory Omega _ m n theta X K i omega +
              @troppCurrentRandomStep Omega _ m n theta X i omega)) := by
  exact
    traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure
      (P := P) theta X K (m * RK + m * (abs theta * RX)) (abs theta * RX)
      hHist hStep
      (troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds
        theta RX RK X K hRX hRK hXBound hKBound)
      (troppCurrentRandomStep_operatorNorm_le_of_summand_bound theta RX X hXBound)

/-- Finite-measure Tropp add-K integrability from summand and comparison bounds.

This derives the history bound from the Tropp construction and uses a
deterministic operator-norm bound on `K`, rather than requiring a pointwise
bound on the constant random matrix `fun _ => K i`. -/
theorem traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hHist : forall i,
      IsRandomMatrix P
        (@troppStateHistory Omega _ m n theta X K i))
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall i,
      IntegrableRealRandomVariable P
        (fun omega =>
          traceMatrixExp
            (@troppStateHistory Omega _ m n theta X K i omega + K i)) := by
  have hKBound' : forall i omega, operatorNorm (fun _ : Omega => K i) omega <= RK := by
    intro i omega
    simpa [operatorNorm, deterministicOperatorNorm] using hKBound i
  exact
    traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure
      (P := P) theta X K (m * RK + m * (abs theta * RX)) RK
      hHist
      (troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds
        theta RX RK X K hRX hRK hXBound hKBound)
      hKBound'

end

end HighDimProb
