import HighDimProb.RandomMatrix.TraceExpIntegrabilityCompressionProvider

open HighDimProb
open MeasureTheory
open scoped Matrix.Norms.Operator Matrix.Norms.L2Operator

#check matrixExpScaledIntegrable_of_provider_statement_of_finiteMeasure
#check traceExpIntegrable_troppStateHistory_add_step_statement_of_summand_and_comparison_bounds_finiteMeasure
#check traceExpIntegrable_troppStateHistory_add_K_statement_of_summand_and_comparison_bounds_finiteMeasure

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n) :
    matrixExpScaledIntegrable_of_provider_statement (P := P) theta R X := by
  exact matrixExpScaledIntegrable_of_provider_statement_of_finiteMeasure
    (P := P) theta R X

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    traceExpIntegrable_troppStateHistory_add_step_statement (P := P) theta X K := by
  exact
    traceExpIntegrable_troppStateHistory_add_step_statement_of_summand_and_comparison_bounds_finiteMeasure
      (P := P) theta RX RK X K hRX hRK hXBound hKBound

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    traceExpIntegrable_troppStateHistory_add_K_statement (P := P) theta X K := by
  exact
    traceExpIntegrable_troppStateHistory_add_K_statement_of_summand_and_comparison_bounds_finiteMeasure
      (P := P) theta RX RK X K hRX hRK hXBound hKBound

