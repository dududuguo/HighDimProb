import HighDimProb.RandomMatrix.IntegrabilityProvider
import HighDimProb.RandomMatrix.TraceExpIntegrabilityProvider
import HighDimProb.RandomMatrix.HardboneStatements

namespace HighDimProb

open MeasureTheory
open scoped Matrix.Norms.L2Operator

noncomputable section

/-- Exact hardbone wrapper for scaled matrix-exponential integrability under an
explicit finite-measure hypothesis and uniform operator-norm bound. -/
theorem matrixExpScaledIntegrable_of_provider_statement_of_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n) :
    matrixExpScaledIntegrable_of_provider_statement (P := P) theta R X := by
  intro hRand _hSelfAdjoint hR hBound i
  exact
    matrixExpScaledIntegrable_of_provider_finiteMeasure
      (P := P) theta R X hRand hR hBound i

/-- Exact hardbone wrapper for trace-exponential integrability of the natural
Tropp history plus the current step under the existing bounded finite-measure
provider hypotheses. -/
theorem
    traceExpIntegrable_troppStateHistory_add_step_statement_of_summand_and_comparison_bounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    traceExpIntegrable_troppStateHistory_add_step_statement (P := P) theta X K := by
  intro hHist hStep _hHistSA _hStepSA
  exact
    traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure
      (P := P) theta RX RK X K hHist hStep hRX hRK hXBound hKBound

/-- Exact hardbone wrapper for trace-exponential integrability of the natural
Tropp history plus the deterministic comparison matrix under the existing
bounded finite-measure provider hypotheses. -/
theorem
    traceExpIntegrable_troppStateHistory_add_K_statement_of_summand_and_comparison_bounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    traceExpIntegrable_troppStateHistory_add_K_statement (P := P) theta X K := by
  intro hHist _hHistSA _hKSA
  exact
    traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure
      (P := P) theta RX RK X K hHist hRX hRK hXBound hKBound

end

