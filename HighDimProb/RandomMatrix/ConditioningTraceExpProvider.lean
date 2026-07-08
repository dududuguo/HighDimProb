import HighDimProb.RandomMatrix.ConditioningExpectationProvider
import HighDimProb.RandomMatrix.HardboneStatements

/-!
# Conditioning trace-exp provider wrapper

This module proves a thin wrapper from strengthened sigma-independence and an
explicit frozen trace bound to the existing conditional trace-exponential
hardbone statement.

It keeps the weak hardbone statement unchanged. The pair-law trace-exp
integrability premise is left explicit on purpose rather than deriving it from
the ambient hardbone `hTraceInt`; that derivation remains a separate
proof-engineering task.
-/

namespace HighDimProb

open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

/-- Strengthened sigma-independence wrapper for the conditional trace-exp
hardbone step.

This theorem discharges the existing weak statement
`condExp_traceExp_history_add_independent_step_statement` from a stronger
history/current-step sigma-independence premise together with an explicit
pair-law integrability witness and a frozen-history trace bound.
-/
theorem condExp_traceExp_history_add_independent_step_of_indep_sigma
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsFiniteMeasure P]
    {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (mHist : MeasurableSpace Omega)
    (H Z : @RandomMatrix Omega mOmega n n)
    (K : Matrix (Fin n) (Fin n) Real)
    (hHistStepIndep :
      ProbabilityTheory.Indep mHist (MeasurableSpace.comap Z inferInstance) P)
    (hPairInt : Integrable
      (fun p : Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real =>
        traceMatrixExp (p.1 + p.2))
      (@Measure.map Omega
        (Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real)
        mOmega inferInstance (fun omega => (H omega, Z omega)) P))
    (hFrozenBound :
      forall A : Matrix (Fin n) (Fin n) Real,
        MeasureTheory.integral
          (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega inferInstance
            Z P)
          (fun B => traceMatrixExp (A + B)) <=
        traceMatrixExp (A + K)) :
    @condExp_traceExp_history_add_independent_step_statement
      Omega mOmega P n mHist H Z K := by
  intro hHistSub _hHRand hZRand hHMeas _hHSA _hZSA _hIndepFun _hTraceInt
    _hExpInt _hExpMeanSA _hExpMeanPos _hKSA _hMGF
  have hH : @Measurable Omega (Matrix (Fin n) (Fin n) Real) mHist inferInstance
      H := by
    change @Measurable Omega (Fin n -> Fin n -> Real) mHist inferInstance H
    refine
      @measurable_pi_lambda Omega (Fin n) (fun _ => Fin n -> Real) mHist
        (fun _ => inferInstance) H ?_
    intro r
    refine
      @measurable_pi_lambda Omega (Fin n) (fun _ => Real) mHist
        (fun _ => inferInstance) (fun omega c => H omega r c) ?_
    intro c
    simpa using hHMeas r c
  have hZMeas : @Measurable Omega (Matrix (Fin n) (Fin n) Real) mOmega
      inferInstance Z := by
    change @Measurable Omega (Fin n -> Fin n -> Real) mOmega inferInstance Z
    refine
      @measurable_pi_lambda Omega (Fin n) (fun _ => Fin n -> Real) mOmega
        (fun _ => inferInstance) Z ?_
    intro r
    refine
      @measurable_pi_lambda Omega (Fin n) (fun _ => Real) mOmega
        (fun _ => inferInstance) (fun omega c => Z omega r c) ?_
    intro c
    have hzrc := hZRand r c
    change @Measurable Omega Real mOmega inferInstance (fun omega => Z omega r c)
      at hzrc
    exact hzrc
  exact
    condExp_le_of_indep_sigma_under_frozen_bound
      (mOmega := mOmega) (P := P) (mHist := mHist) (H := H) (Z := Z)
      (F := fun A B => traceMatrixExp (A + B))
      (B := fun A => traceMatrixExp (A + K))
      hHistSub hH hZMeas.aemeasurable hHistStepIndep hPairInt hFrozenBound

end

end HighDimProb
