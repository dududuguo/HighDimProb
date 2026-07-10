import HighDimProb.RandomMatrix.ConditioningTraceExpProvider
import HighDimProb.RandomMatrix.TraceExpTroppStepProvider
import HighDimProb.RandomMatrix.NaturalHistoryProvider
import HighDimProb.RandomMatrix.IntegrabilityProvider
import HighDimProb.RandomMatrix.TraceExpIntegrabilityProvider
import HighDimProb.RandomMatrix.TraceExpLaplaceProvider
import HighDimProb.RandomMatrix.TraceExpDomainProvider
import HighDimProb.RandomMatrix.ConcentrationStatements
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Topology.Algebra.Module.FiniteDimension

/-!
# Generated-history Bernstein trace-exp provider wrappers

This module upstreams the smallest stable generated-history Bernstein wrappers
from the provider repository into `HighDimProb`.

It derives the finite-family Tropp trace-MGF wrapper and the downstream
Bernstein trace-MGF and quadratic-form upper-tail contracts from the usual
bounded centered self-adjoint Bernstein primitives along the generated natural
history. Current-step exponential-mean self-adjointness is derived from the
centered self-adjoint summand primitives, while strict positivity is derived
from the self-adjoint current step and its matrix-exponential integrability.
This module does not prove full Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory
open scoped ProbabilityTheory MatrixOrder Matrix.Norms.L2Operator BigOperators

noncomputable section

/-- The exponential mean of a Bernstein current step is self-adjoint under the
usual centered self-adjoint summand primitives. -/
theorem isSelfAdjointMatrix_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (i : Fin m)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X) :
    IsSelfAdjointMatrix
      (@matrixExpect Omega mOmega n n P
        (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))) := by
  have hStepSA : RandomSelfAdjointMatrix P (troppCurrentRandomStep theta X i) := by
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      (randomSelfAdjointMatrix_scaledRandomMatrix (P := P) theta (hCentered.1.2 i))
  exact
    isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint (P := P)
      (A := fun omega => matrixExp (troppCurrentRandomStep theta X i omega))
      (fun omega => isSelfAdjointMatrix_matrixExp (hStepSA omega))

/-- The exponential mean of a Bernstein current step is strictly positive under
the usual bounded centered self-adjoint summand primitives. -/
theorem isStrictlyPositive_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (i : Fin m)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R) :
    IsStrictlyPositive
      (@matrixExpect Omega mOmega n n P
        (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))) := by
  have hX : forall j, IsRandomMatrix P (X j) := hCentered.1.1
  have hSA : forall j, RandomSelfAdjointMatrix P (X j) := hCentered.1.2
  have hStepSA :
      @RandomSelfAdjointMatrix Omega mOmega n P
        (@troppCurrentRandomStep Omega mOmega m n theta X i) := by
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      (randomSelfAdjointMatrix_scaledRandomMatrix (P := P) theta (hSA i))
  have hExpStep :
      @IntegrableRandomMatrix Omega mOmega n n P
        (fun omega => matrixExp (troppCurrentRandomStep theta X i omega)) := by
    have hExp :=
      matrixExpScaledIntegrable_of_provider_finiteMeasure
        theta R X hX hR (fun j omega => hBound j omega) i
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      hExp
  exact
    isStrictlyPositive_matrixExpect_matrixExp_of_randomSelfAdjoint
      (P := P) (Z := @troppCurrentRandomStep Omega mOmega m n theta X i)
      hStepSA hExpStep

private abbrev GeneratedHistorySigma
    {Omega : Type*} [mOmega : MeasurableSpace Omega] {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (i : Fin m) : MeasurableSpace Omega :=
  MeasurableSpace.comap (@troppStateHistory Omega mOmega m n theta X K i) inferInstance

private abbrev TraceExpPairIntegrable
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat}
    (H Z : @RandomMatrix Omega mOmega n n) : Prop :=
  Integrable
    (fun p : Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real =>
      traceMatrixExp (p.1 + p.2))
    (@Measure.map Omega
      (Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real)
      mOmega inferInstance (fun omega => (H omega, Z omega)) P)

private abbrev TraceExpSelfAdjointFrozenBound
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat}
    (Z : @RandomMatrix Omega mOmega n n)
    (K : Matrix (Fin n) (Fin n) Real) : Prop :=
  forall A : Matrix (Fin n) (Fin n) Real,
    IsSelfAdjointMatrix A ->
      MeasureTheory.integral
          (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega inferInstance Z P)
          (fun z => traceMatrixExp (A + z)) <=
        traceMatrixExp (A + K)

private abbrev TraceExpFrozenTraceIntegrable
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat}
    (Z : @RandomMatrix Omega mOmega n n) : Prop :=
  forall A : Matrix (Fin n) (Fin n) Real,
    IsSelfAdjointMatrix A ->
      @IntegrableRealRandomVariable Omega mOmega P
        (fun omega => traceMatrixExp (A + Z omega))

/-- Convert the integral over the current-step law into the project expectation
notation. -/
private theorem traceMatrixExp_add_integral_map_eq_expect
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real)
    {Z : @RandomMatrix Omega mOmega n n}
    (hZ : AEMeasurable Z P) :
    MeasureTheory.integral
        (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega inferInstance Z P)
        (fun z => traceMatrixExp (A + z)) =
      expect P (fun omega => traceMatrixExp (A + Z omega)) := by
  have hTraceExp :
      Continuous (fun z : Matrix (Fin n) (Fin n) Real => traceMatrixExp (A + z)) := by
    have hBase :
        Continuous (fun M : Matrix (Fin n) (Fin n) Real => traceMatrixExp M) := by
      letI : NormedAlgebra Rat (Matrix (Fin n) (Fin n) Real) :=
        NormedAlgebra.restrictScalars Rat Real (Matrix (Fin n) (Fin n) Real)
      have hTrace :
          Continuous
            (Matrix.traceLinearMap (n := Fin n) (α := Real) (R := Real) :
              Matrix (Fin n) (Fin n) Real →ₗ[Real] Real) :=
        LinearMap.continuous_of_finiteDimensional _
      simpa [traceMatrixExp, matrixTrace, matrixExp] using
        hTrace.comp NormedSpace.exp_continuous
    exact hBase.comp (continuous_const.add continuous_id)
  rw [expect_def]
  exact
    MeasureTheory.integral_map
      (μ := P) (φ := Z) hZ hTraceExp.aestronglyMeasurable

/-- Reusable finite-dimensional side-condition packet for the frozen-history
Tropp trace-exp bound.

The packet contains no history-independence claim; consumers must supply either
sigma-level independence or a justified history-sigma containment relation. -/
structure TraceExpTroppFrozenBoundInputs
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    (Z : @RandomMatrix Omega mOmega n n)
    (K : Matrix (Fin n) (Fin n) Real) : Prop where
  stepAEMeasurable : AEMeasurable Z P
  frozenTraceIntegrable : TraceExpFrozenTraceIntegrable (mOmega := mOmega) (P := P) Z
  stepSelfAdjoint : @RandomSelfAdjointMatrix Omega mOmega n P Z
  expIntegrable : @IntegrableRandomMatrix Omega mOmega n n P
    (fun omega => matrixExp (Z omega))
  expMeanSelfAdjoint : IsSelfAdjointMatrix
    (@matrixExpect Omega mOmega n n P
      (fun omega => matrixExp (Z omega)))
  expMeanStrictlyPositive : IsStrictlyPositive
    (@matrixExpect Omega mOmega n n P
      (fun omega => matrixExp (Z omega)))
  comparisonSelfAdjoint : IsSelfAdjointMatrix K
  matrixMGFBound : MatrixLE
    (@matrixExpect Omega mOmega n n P
      (fun omega => matrixExp (Z omega)))
    (matrixExp K)

private abbrev TraceExpTroppConditionalStepSigmaInputs
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    (mHist : MeasurableSpace Omega)
    (Z : @RandomMatrix Omega mOmega n n)
    (K : Matrix (Fin n) (Fin n) Real) : Prop :=
  TraceExpTroppFrozenBoundInputs (mOmega := mOmega) (P := P) Z K ∧
    ProbabilityTheory.Indep mHist (MeasurableSpace.comap Z inferInstance) P

private theorem traceExpPairIntegrable_of_histEntryMeasurable
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat}
    {mHist : MeasurableSpace Omega}
    {H Z : @RandomMatrix Omega mOmega n n}
    (hHistSub : mHist ≤ mOmega)
    (hHMeas : forall i j,
      @Measurable Omega Real mHist inferInstance
        (fun omega => H omega i j))
    (hZ : AEMeasurable Z P)
    (hInt : @IntegrableRealRandomVariable Omega mOmega P
      (fun omega => traceMatrixExp (H omega + Z omega))) :
    TraceExpPairIntegrable (mOmega := mOmega) (P := P) H Z := by
  have hHRand : @IsRandomMatrix Omega mOmega n n P H :=
    fun i j => (hHMeas i j).mono hHistSub le_rfl
  have hHAE : AEMeasurable H P :=
    (@measurable_randomMatrix_of_isRandomMatrix
      Omega mOmega P n n H hHRand).aemeasurable
  have hPairAEMeas : AEMeasurable (fun omega => (H omega, Z omega)) P :=
    hHAE.prodMk hZ
  have hTraceExp :
      Continuous
        (fun p : Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real =>
          traceMatrixExp (p.1 + p.2)) := by
    have hBase :
        Continuous
          (fun M : Matrix (Fin n) (Fin n) Real => traceMatrixExp M) := by
      letI : NormedAlgebra Rat (Matrix (Fin n) (Fin n) Real) :=
        NormedAlgebra.restrictScalars Rat Real (Matrix (Fin n) (Fin n) Real)
      have hTrace :
          Continuous
            (Matrix.traceLinearMap (n := Fin n) (α := Real) (R := Real) :
              Matrix (Fin n) (Fin n) Real →ₗ[Real] Real) :=
        LinearMap.continuous_of_finiteDimensional _
      simpa [traceMatrixExp, matrixTrace, matrixExp] using
        hTrace.comp NormedSpace.exp_continuous
    exact hBase.comp (continuous_fst.add continuous_snd)
  unfold TraceExpPairIntegrable
  rw [MeasureTheory.integrable_map_measure hTraceExp.aestronglyMeasurable hPairAEMeas]
  change Integrable (fun omega => traceMatrixExp (H omega + Z omega)) P
  exact hInt

private theorem traceMatrixExp_frozenBound_of_leftRight_and_providerLogOrder
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    (A K : Matrix (Fin n) (Fin n) Real)
    {Z : @RandomMatrix Omega mOmega n n}
    (hZ : AEMeasurable Z P)
    (hASA : IsSelfAdjointMatrix A)
    (hZSA : @RandomSelfAdjointMatrix Omega mOmega n P Z)
    (hTraceInt : @IntegrableRealRandomVariable Omega mOmega P
      (fun omega => traceMatrixExp (A + Z omega)))
    (hExpInt : @IntegrableRandomMatrix Omega mOmega n n P
      (fun omega => matrixExp (Z omega)))
    (hExpMeanSA : IsSelfAdjointMatrix
      (@matrixExpect Omega mOmega n n P
        (fun omega => matrixExp (Z omega))))
    (hExpMeanPos : IsStrictlyPositive
      (@matrixExpect Omega mOmega n n P
        (fun omega => matrixExp (Z omega))))
    (hKSA : IsSelfAdjointMatrix K)
    (hMGF : MatrixLE
      (@matrixExpect Omega mOmega n n P
        (fun omega => matrixExp (Z omega)))
      (matrixExp K)) :
    MeasureTheory.integral
        (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega inferInstance Z P)
        (fun z => traceMatrixExp (A + z)) <=
      traceMatrixExp (A + K) := by
  rw [traceMatrixExp_add_integral_map_eq_expect (P := P) (A := A) (Z := Z) hZ]
  exact
    troppMasterTraceMGFStep_trace_bound_of_leftRight_and_providerLogOrder
      (P := P) A K Z hASA hZSA hTraceInt hExpInt hExpMeanSA hExpMeanPos hKSA hMGF

private theorem traceExpSelfAdjointFrozenBound_of_troppInputs
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    {Z : @RandomMatrix Omega mOmega n n}
    {K : Matrix (Fin n) (Fin n) Real}
    (hTropp : TraceExpTroppFrozenBoundInputs (mOmega := mOmega) (P := P) Z K) :
    TraceExpSelfAdjointFrozenBound (mOmega := mOmega) (P := P) Z K := by
  intro A hA
  exact
    traceMatrixExp_frozenBound_of_leftRight_and_providerLogOrder
      (P := P) A K hTropp.stepAEMeasurable hA hTropp.stepSelfAdjoint
      (hTropp.frozenTraceIntegrable A hA) hTropp.expIntegrable
      hTropp.expMeanSelfAdjoint hTropp.expMeanStrictlyPositive
      hTropp.comparisonSelfAdjoint hTropp.matrixMGFBound

private theorem condExp_traceMatrixExp_mHist_le_of_indep_sigma_under_selfAdjoint_frozen_bound
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsFiniteMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    {mHist : MeasurableSpace Omega}
    {H Z : @RandomMatrix Omega mOmega n n}
    {K : Matrix (Fin n) (Fin n) Real}
    (hHistSub : mHist ≤ mOmega)
    (hHMeas : forall i j,
      @Measurable Omega Real mHist inferInstance
        (fun omega => H omega i j))
    (hHSA : forall omega, IsSelfAdjointMatrix (H omega))
    (hZ : AEMeasurable Z P)
    (hIndepSigma :
      ProbabilityTheory.Indep mHist (MeasurableSpace.comap Z inferInstance) P)
    (hInt : TraceExpPairIntegrable (mOmega := mOmega) (P := P) H Z)
    (hFrozenBound : TraceExpSelfAdjointFrozenBound (mOmega := mOmega) (P := P) Z K) :
    Filter.EventuallyLE (MeasureTheory.ae P)
      (MeasureTheory.condExp (m := mHist) P
        (fun omega => traceMatrixExp (H omega + Z omega)))
      (fun omega => traceMatrixExp (H omega + K)) := by
  let B : Matrix (Fin n) (Fin n) Real -> Real := fun A =>
    if hA : IsSelfAdjointMatrix A then
      traceMatrixExp (A + K)
    else
      MeasureTheory.integral
        (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega inferInstance Z P)
        (fun z => traceMatrixExp (A + z))
  have hH : @Measurable Omega (Matrix (Fin n) (Fin n) Real) mHist inferInstance H := by
    refine measurable_pi_lambda _ ?_
    intro r
    refine measurable_pi_lambda _ ?_
    intro c
    simpa using hHMeas r c
  have hCore :
      Filter.EventuallyLE (MeasureTheory.ae P)
        (MeasureTheory.condExp (m := mHist) P
          (fun omega => traceMatrixExp (H omega + Z omega)))
        (fun omega => B (H omega)) := by
    exact condExp_le_of_indep_sigma_under_frozen_bound
      (mOmega := mOmega) (P := P) (mHist := mHist) (H := H) (Z := Z)
      (F := fun A z => traceMatrixExp (A + z))
      (B := B)
      hHistSub hH hZ hIndepSigma hInt (fun A => by
        by_cases hA : IsSelfAdjointMatrix A
        · simpa only [B, hA, dif_pos] using hFrozenBound A hA
        · simpa only [B, hA, dif_neg] using
            (le_rfl :
              MeasureTheory.integral
                  (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega
                    inferInstance Z P)
                  (fun z => traceMatrixExp (A + z)) <=
                MeasureTheory.integral
                  (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega
                    inferInstance Z P)
                  (fun z => traceMatrixExp (A + z))))
  filter_upwards [hCore] with omega homega
  simpa only [B, hHSA omega, dif_pos] using homega

private theorem condExp_traceExp_history_add_independent_step_of_indep_sigma_of_troppInputs
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    {mHist : MeasurableSpace Omega}
    {H Z : @RandomMatrix Omega mOmega n n}
    {K : Matrix (Fin n) (Fin n) Real}
    (hCond :
      TraceExpTroppConditionalStepSigmaInputs
        (mOmega := mOmega) (P := P) mHist Z K) :
    @condExp_traceExp_history_add_independent_step_statement
      Omega mOmega P n mHist H Z K := by
  intro hHistSub _hHRand hZRand hHMeas hHSA _hZSA _hIndep hTraceInt _hExpInt
    _hExpMeanSA _hExpMeanPos _hKSA _hMGF
  have hTropp :
      TraceExpTroppFrozenBoundInputs (mOmega := mOmega) (P := P) Z K :=
    hCond.1
  have hStepAE :
      @AEMeasurable Omega (Matrix (Fin n) (Fin n) Real) inferInstance mOmega Z P :=
    (@measurable_randomMatrix_of_isRandomMatrix
      Omega mOmega P n n Z hZRand).aemeasurable
  have hPairInt :
      TraceExpPairIntegrable (mOmega := mOmega) (P := P) H Z :=
    @traceExpPairIntegrable_of_histEntryMeasurable
      Omega mOmega P n mHist H Z
      hHistSub hHMeas hStepAE hTraceInt
  exact
    @condExp_traceMatrixExp_mHist_le_of_indep_sigma_under_selfAdjoint_frozen_bound
      Omega mOmega inferInstance P inferInstance n inferInstance mHist H Z K
      hHistSub hHMeas hHSA hStepAE hCond.2 hPairInt
      (traceExpSelfAdjointFrozenBound_of_troppInputs
        (mOmega := mOmega) (P := P) hTropp)

namespace TraceExpConditioning

/-- Close the exact conditional-step contract when the chosen history
sigma-algebra is contained in the sigma-algebra generated by the history
matrix.

The contract's own `IndepFun H Z P` premise then supplies the sigma-level
independence required by the frozen-bound conditioning proof. This theorem
does not cover an arbitrary larger history sigma-algebra. -/
theorem troppStep_of_history_le
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    {mHist : MeasurableSpace Omega}
    {H Z : @RandomMatrix Omega mOmega n n}
    {K : Matrix (Fin n) (Fin n) Real}
    (hHistoryLe : mHist <= MeasurableSpace.comap H inferInstance)
    (hTropp : TraceExpTroppFrozenBoundInputs (mOmega := mOmega) (P := P) Z K) :
    @troppMasterTraceMGFConditionalStep_statement
      Omega mOmega P n mHist H Z K := by
  intro hHistSub hHRand hZRand hHMeas hHSA hZSA hIndep
  have hIndepSigma :
      @ProbabilityTheory.Indep Omega mHist
        (MeasurableSpace.comap Z inferInstance) mOmega P :=
    @ProbabilityTheory.indep_of_indep_of_le_left
      Omega (MeasurableSpace.comap H inferInstance)
      (MeasurableSpace.comap Z inferInstance) mHist mOmega P
      ((@ProbabilityTheory.IndepFun_iff_Indep
        Omega (Matrix (Fin n) (Fin n) Real) (Matrix (Fin n) (Fin n) Real)
        mOmega inferInstance inferInstance H Z P).mp hIndep)
      hHistoryLe
  exact
    (condExp_traceExp_history_add_independent_step_of_indep_sigma_of_troppInputs
      (mOmega := mOmega) (P := P) (mHist := mHist)
      (H := H) (Z := Z) (K := K) (And.intro hTropp hIndepSigma))
      hHistSub hHRand hZRand hHMeas hHSA hZSA hIndep

/-- Hardbone-name facade for `troppStep_of_history_le`. -/
theorem condExpStep_of_history_le
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    {mHist : MeasurableSpace Omega}
    {H Z : @RandomMatrix Omega mOmega n n}
    {K : Matrix (Fin n) (Fin n) Real}
    (hHistoryLe : mHist <= MeasurableSpace.comap H inferInstance)
    (hTropp : TraceExpTroppFrozenBoundInputs (mOmega := mOmega) (P := P) Z K) :
    @condExp_traceExp_history_add_independent_step_statement
      Omega mOmega P n mHist H Z K :=
  troppStep_of_history_le (mOmega := mOmega) (P := P) hHistoryLe hTropp

end TraceExpConditioning

private theorem bernsteinTroppFrozenBoundInputs_of_primitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (i : Fin m)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3) :
    TraceExpTroppFrozenBoundInputs (mOmega := mOmega) (P := P)
      (troppCurrentRandomStep theta X i)
      (bernsteinSecondMomentComparisonFamily P X theta R i) := by
  have hX : forall j, IsRandomMatrix P (X j) := hCentered.1.1
  have hSA : forall j, RandomSelfAdjointMatrix P (X j) := hCentered.1.2
  have hMeanZero : matrixExpect P (X i) = 0 := hCentered.2 i
  have hStepRand : IsRandomMatrix P (troppCurrentRandomStep theta X i) := by
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      (isRandomMatrix_scaledRandomMatrixFamily (P := P) theta hX i)
  refine
    { stepAEMeasurable :=
        (measurable_randomMatrix_of_isRandomMatrix hStepRand).aemeasurable
      frozenTraceIntegrable := ?_
      stepSelfAdjoint := ?_
      expIntegrable := ?_
      expMeanSelfAdjoint :=
        isSelfAdjointMatrix_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint
          (mOmega := mOmega) (P := P) theta X i hCentered
      expMeanStrictlyPositive :=
        isStrictlyPositive_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint
          (mOmega := mOmega) (P := P) theta R X i hCentered hBound hR
      comparisonSelfAdjoint := ?_
      matrixMGFBound := ?_ }
  · intro A hA
    exact
      traceMatrixExp_add_integrable_of_operatorNormBounds_finiteMeasure
        (P := P) (fun _ : Omega => A) (troppCurrentRandomStep theta X i)
        (deterministicOperatorNorm A) (abs theta * R)
        (by
          intro r c
          exact measurable_const)
        hStepRand
        (by
          intro omega
          change ‖A‖ <= ‖A‖
          exact le_rfl)
        (troppCurrentRandomStep_operatorNorm_le_of_summand_bound
          theta R X (fun j omega => hBound j omega) i)
  · simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      (randomSelfAdjointMatrix_scaledRandomMatrix (P := P) theta (hSA i))
  · have hExpStep :=
      matrixExpScaledIntegrable_of_provider_finiteMeasure
        theta R X hX hR (fun j omega => hBound j omega) i
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      hExpStep
  · simpa [bernsteinSecondMomentComparisonFamily] using
      (isSelfAdjointMatrix_smul (bernsteinMGFCoeff theta R)
        (isSelfAdjointMatrix_matrixSecondMoment (hSA i)))
  · simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix,
      bernsteinSecondMomentComparisonFamily, matrixExpScaledFamily] using
      (singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
        (P := P) (X i) (matrixSecondMoment P (X i)) theta R
        (fun omega => bernsteinMatrixExp_le_quadratic (X i omega) theta R)
        (hX i) (hSA i) (hIntX i) (hIntSq i)
        (by
          have hExpStep :=
            matrixExpScaledIntegrable_of_provider_finiteMeasure
              theta R X hX hR (fun j omega => hBound j omega) i
          simpa [matrixExpScaledFamily] using hExpStep)
        hMeanZero
        (fun omega => hBound i omega)
        hR hRange
        (isSelfAdjointMatrix_matrixSecondMoment (hSA i))
        (isPSD_matrixSecondMoment_of_selfAdjoint (hSA i) (hIntSq i))
        (matrixLE_refl (matrixSecondMoment P (X i))))

namespace TraceExpConditioning

/-- Build the frozen-bound current-step packet from the standard Bernstein
single-summand primitives. -/
abbrev bernsteinInputs_of_primitives :=
  @bernsteinTroppFrozenBoundInputs_of_primitives

/-- Close a restricted-history conditional step directly from the standard
Bernstein single-summand primitives.

The exact conditional-step statement still supplies its own history/current-step
`IndepFun` premise. This theorem removes only the separate frozen-bound packet
construction; it does not control an arbitrary larger history sigma-algebra. -/
theorem bernsteinStep_of_history_le
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (i : Fin m)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    {mHist : MeasurableSpace Omega}
    {H : @RandomMatrix Omega mOmega n n}
    (hHistoryLe : mHist <= MeasurableSpace.comap H inferInstance) :
    @troppMasterTraceMGFConditionalStep_statement
      Omega mOmega P n mHist H
      (@troppCurrentRandomStep Omega mOmega m n theta X i)
      (@bernsteinSecondMomentComparisonFamily
        Omega mOmega (Fin m) n P X theta R i) :=
  troppStep_of_history_le
    (mOmega := mOmega) (P := P) hHistoryLe
    (bernsteinInputs_of_primitives
      (mOmega := mOmega) (P := P) theta R X i
      hCentered hIntX hIntSq hBound hR hRange)

end TraceExpConditioning

private theorem troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives_and_sideConditions
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hHistSub : forall i,
      GeneratedHistorySigma theta X
        (bernsteinSecondMomentComparisonFamily P X theta R) i ≤ mOmega)
    (hHistRand : forall i,
      @IsRandomMatrix Omega mOmega n n P
        (@troppStateHistory Omega mOmega m n theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i))
    (hHistMeas : forall i r c,
      @Measurable Omega Real
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i) inferInstance
        (fun omega =>
          troppStateHistory theta X
            (bernsteinSecondMomentComparisonFamily P X theta R) i omega r c))
    (hHistSA : forall i omega,
      IsSelfAdjointMatrix
        (troppStateHistory theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i omega))
    (hCondTraceInt : forall i,
      @IntegrableRealRandomVariable Omega mOmega P
        (fun omega =>
          traceMatrixExp
            (troppStateHistory theta X
              (bernsteinSecondMomentComparisonFamily P X theta R) i omega +
              troppCurrentRandomStep theta X i omega)))
    (hSigma : forall i, SigmaFinite (P.trim (hHistSub i)))
    (hRhsInt : forall i,
      @IntegrableRealRandomVariable Omega mOmega P
        (fun omega =>
          traceMatrixExp
            (troppStateHistory theta X
              (bernsteinSecondMomentComparisonFamily P X theta R) i omega +
              bernsteinSecondMomentComparisonFamily P X theta R i))) :
    troppMasterTraceMGFFiniteFamily_statement (P := P) X
      (bernsteinSecondMomentComparisonFamily P X theta R) V theta R := by
  have hX : forall j, IsRandomMatrix P (X j) := hCentered.1.1
  have hMeas : forall j, Measurable (X j) := fun j =>
    measurable_randomMatrix_of_isRandomMatrix (hX j)
  have hSA : forall j, RandomSelfAdjointMatrix P (X j) := hCentered.1.2
  have hZRand : forall i,
      @IsRandomMatrix Omega mOmega n n P
        (@troppCurrentRandomStep Omega mOmega m n theta X i) := by
    intro i
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      (isRandomMatrix_scaledRandomMatrixFamily (P := P) theta hX i)
  have hZSA : forall i,
      @RandomSelfAdjointMatrix Omega mOmega n P
        (@troppCurrentRandomStep Omega mOmega m n theta X i) := by
    intro i
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      (randomSelfAdjointMatrix_scaledRandomMatrix (P := P) theta (hSA i))
  have hTropp : forall i,
      TraceExpTroppConditionalStepSigmaInputs
        (mOmega := mOmega) (P := P)
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i)
        (@troppCurrentRandomStep Omega mOmega m n theta X i)
        (bernsteinSecondMomentComparisonFamily P X theta R i) := by
    intro i
    refine ⟨?_, ?_⟩
    · exact
        bernsteinTroppFrozenBoundInputs_of_primitives
          (mOmega := mOmega) (P := P) theta R X i
          hCentered hIntX hIntSq hBound hR hRange
    · exact
        (ProbabilityTheory.IndepFun_iff_Indep
          (@troppStateHistory Omega mOmega m n theta X
            (bernsteinSecondMomentComparisonFamily P X theta R) i)
          (@troppCurrentRandomStep Omega mOmega m n theta X i) P).mp <|
          TroppNaturalHistory.historyStepIndependent
            theta X (bernsteinSecondMomentComparisonFamily P X theta R)
            hIndep hMeas i
  have hHist :
      troppNaturalHistoryMeasurable_statement theta X
        (bernsteinSecondMomentComparisonFamily P X theta R)
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R)) := by
    intro _ i r c
    exact hHistMeas i r c
  have hHistIndep :
      @troppHistoryStepIndependent_of_iIndepFun_statement
        Omega mOmega P m n theta X
        (bernsteinSecondMomentComparisonFamily P X theta R) := by
    intro hIndep' i
    exact
      TroppNaturalHistory.historyStepIndependent
        theta X (bernsteinSecondMomentComparisonFamily P X theta R)
        hIndep' hMeas i
  have hCondExp : forall i,
      @condExp_traceExp_history_add_independent_step_statement
        Omega mOmega P n
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i)
        (@troppStateHistory Omega mOmega m n theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i)
        (@troppCurrentRandomStep Omega mOmega m n theta X i)
        (bernsteinSecondMomentComparisonFamily P X theta R i) := by
    intro i
    exact
      condExp_traceExp_history_add_independent_step_of_indep_sigma_of_troppInputs
        (mOmega := mOmega) (P := P)
        (mHist := GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i)
        (H := @troppStateHistory Omega mOmega m n theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i)
        (Z := @troppCurrentRandomStep Omega mOmega m n theta X i)
        (K := bernsteinSecondMomentComparisonFamily P X theta R i)
        (hTropp i)
  have hChain :
      @troppConditionalStep_of_iIndepFun_statement
        Omega mOmega P m n theta X
        (bernsteinSecondMomentComparisonFamily P X theta R)
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R)) :=
    troppConditionalStep_of_iIndepFun theta X
      (bernsteinSecondMomentComparisonFamily P X theta R)
      (GeneratedHistorySigma theta X
        (bernsteinSecondMomentComparisonFamily P X theta R))
  have hCond : forall i,
      @troppMasterTraceMGFConditionalStep_statement Omega mOmega P n
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i)
        (@troppStateHistory Omega mOmega m n theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i)
        (@troppCurrentRandomStep Omega mOmega m n theta X i)
        (bernsteinSecondMomentComparisonFamily P X theta R i) := by
    intro i
    exact
      troppMasterTraceMGFConditionalStep_of_conditioningBridge
        theta X (bernsteinSecondMomentComparisonFamily P X theta R)
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R))
        hChain hHist hHistIndep hCondExp hIndep i
  have hExpIntStep : forall i,
      @IntegrableRandomMatrix Omega mOmega n n P
        (fun omega => matrixExp (troppCurrentRandomStep theta X i omega)) := by
    intro i
    exact (hTropp i).1.expIntegrable
  have hExpMeanSelfAdjoint : forall i,
      IsSelfAdjointMatrix
        (@matrixExpect Omega mOmega n n P
          (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))) := by
    intro i
    exact
      isSelfAdjointMatrix_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint
        (mOmega := mOmega) (P := P) theta X i hCentered
  have hExpMeanStrictlyPositive : forall i,
      IsStrictlyPositive
        (@matrixExpect Omega mOmega n n P
          (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))) := by
    intro i
    exact
      isStrictlyPositive_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint
        (mOmega := mOmega) (P := P) theta R X i hCentered hBound hR
  exact
    troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps
      X (bernsteinSecondMomentComparisonFamily P X theta R) V theta R
      (GeneratedHistorySigma theta X
        (bernsteinSecondMomentComparisonFamily P X theta R))
      hCond hHistSub hHistRand hZRand hHistMeas hHistSA hZSA (hHistIndep hIndep)
      hCondTraceInt hExpIntStep hExpMeanSelfAdjoint hExpMeanStrictlyPositive
      hSigma hRhsInt

/-- Finite-family Tropp wrapper for Bernstein primitives along the generated
natural history.

This derives the generated-history measurability, self-adjointness,
sigma-finiteness, and bounded trace-exp integrability side conditions from the
Bernstein primitive bundle itself. Current-step exponential-mean
self-adjointness is derived from the centered self-adjoint summand primitives;
strict positivity is derived from bounded self-adjoint current steps. -/
theorem troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hIndep : ProbabilityTheory.iIndepFun X P) :
    troppMasterTraceMGFFiniteFamily_statement (P := P) X
      (bernsteinSecondMomentComparisonFamily P X theta R) V theta R := by
  have hX : forall j, IsRandomMatrix P (X j) := hCentered.1.1
  have hSA : forall j, RandomSelfAdjointMatrix P (X j) := hCentered.1.2
  have hKSA :
      forall j,
        IsSelfAdjointMatrix
          (bernsteinSecondMomentComparisonFamily P X theta R j) := by
    intro j
    simpa [bernsteinSecondMomentComparisonFamily] using
      isSelfAdjointMatrix_smul (bernsteinMGFCoeff theta R)
        (isSelfAdjointMatrix_matrixSecondMoment (hSA j))
  have hZRand : forall i,
      @IsRandomMatrix Omega mOmega n n P
        (@troppCurrentRandomStep Omega mOmega m n theta X i) := by
    intro i
    simpa [troppCurrentRandomStep, scaledRandomMatrixFamily, scaledRandomMatrix] using
      (isRandomMatrix_scaledRandomMatrixFamily (P := P) theta hX i)
  have hHistAmbient :
      troppNaturalHistoryMeasurable_statement theta X
        (bernsteinSecondMomentComparisonFamily P X theta R)
        (fun _ : Fin m => mOmega) :=
    TroppNaturalHistory.suffixMeasurable
      theta X (bernsteinSecondMomentComparisonFamily P X theta R)
      (fun _ : Fin m => mOmega) (by
        intro i j _hj r c
        exact hX j r c)
  have hHistRand : forall i,
      @IsRandomMatrix Omega mOmega n n P
        (@troppStateHistory Omega mOmega m n theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i) := by
    intro i r c
    simpa using hHistAmbient (fun _ => le_rfl) i r c
  have hHistSub : forall i,
      GeneratedHistorySigma theta X
        (bernsteinSecondMomentComparisonFamily P X theta R) i ≤ mOmega := by
    intro i
    simpa [GeneratedHistorySigma] using
      (measurable_iff_comap_le).mp
        (measurable_randomMatrix_of_isRandomMatrix (hHistRand i))
  have hHistMatMeas : forall i,
      @Measurable Omega (Matrix (Fin n) (Fin n) Real)
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i) inferInstance
        (@troppStateHistory Omega mOmega m n theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i) := by
    intro i
    exact (measurable_iff_comap_le).2 le_rfl
  have hHistMeas : forall i r c,
      @Measurable Omega Real
        (GeneratedHistorySigma theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i) inferInstance
        (fun omega =>
          troppStateHistory theta X
            (bernsteinSecondMomentComparisonFamily P X theta R) i omega r c) := by
    intro i r c
    exact (measurable_pi_apply c).comp
      ((measurable_pi_apply r).comp (hHistMatMeas i))
  have hCompSA : forall i,
      IsSelfAdjointMatrix
        (troppComparisonHistory
          (bernsteinSecondMomentComparisonFamily P X theta R) i) := by
    intro i
    classical
    rw [troppComparisonHistory, comparisonMatrixPrefixSum]
    let Kself : Fin m -> Matrix (Fin n) (Fin n) Real := fun j =>
      if j < i then
        bernsteinSecondMomentComparisonFamily P X theta R j
      else 0
    have hKself : forall j, IsSelfAdjointMatrix (Kself j) := by
      intro j
      by_cases hj : j < i
      · simpa [Kself, hj] using hKSA j
      · simp [Kself, hj]
    have hEq :
        (Finset.univ.filter fun j : Fin m =>
            (j : Nat) < ((i.castSucc : Fin (m + 1)) : Nat)).sum
          (fun j => bernsteinSecondMomentComparisonFamily P X theta R j) =
        Finset.univ.sum fun j : Fin m => Kself j := by
      simp [Kself, Finset.sum_filter]
    rw [hEq]
    exact isSelfAdjointMatrix_sum hKself
  have hRandHistSA : forall i omega,
      IsSelfAdjointMatrix (troppRandomHistory theta X i omega) := by
    intro i omega
    classical
    rw [troppRandomHistory, randomMatrixSuffixSum_apply, comparisonMatrixSuffixSum]
    let Zself : Fin m -> Matrix (Fin n) (Fin n) Real := fun j =>
      if i < j then
        scaledRandomMatrixFamily theta X j omega
      else 0
    have hZself : forall j, IsSelfAdjointMatrix (Zself j) := by
      intro j
      by_cases hj : i < j
      · simpa [Zself, hj, scaledRandomMatrixFamily, scaledRandomMatrix] using
          (randomSelfAdjointMatrix_scaledRandomMatrix
            (P := P) theta (hSA j) omega)
      · simp [Zself, hj]
    have hEq :
        (Finset.univ.filter fun j : Fin m =>
            ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat)).sum
          (fun j => scaledRandomMatrixFamily theta X j omega) =
        Finset.univ.sum fun j : Fin m => Zself j := by
      simp [Zself, Finset.sum_filter]
    rw [hEq]
    exact isSelfAdjointMatrix_sum hZself
  have hHistSA : forall i omega,
      IsSelfAdjointMatrix
        (troppStateHistory theta X
          (bernsteinSecondMomentComparisonFamily P X theta R) i omega) := by
    intro i omega
    exact (hCompSA i).add (hRandHistSA i omega)
  let RK : Real := abs (bernsteinMGFCoeff theta R) * R ^ 2
  have hRK : 0 <= RK := by
    dsimp [RK]
    exact mul_nonneg (abs_nonneg _) (sq_nonneg R)
  have hKBound : forall j,
      deterministicOperatorNorm
        (bernsteinSecondMomentComparisonFamily P X theta R j) <= RK := by
    intro j
    dsimp [RK]
    change
      deterministicOperatorNorm
          (bernsteinMGFCoeff theta R • matrixSecondMoment P (X j)) <=
        abs (bernsteinMGFCoeff theta R) * R ^ 2
    rw [deterministicOperatorNorm, norm_smul]
    exact mul_le_mul_of_nonneg_left
      (deterministicOperatorNorm_matrixSecondMoment_le_sq_of_forall
        (P := P) (A := X j) (R := R) (hIntSq j)
        (fun omega => hBound j omega) hR)
      (abs_nonneg _)
  have hCondTraceInt : forall i,
      @IntegrableRealRandomVariable Omega mOmega P
        (fun omega =>
          traceMatrixExp
            (troppStateHistory theta X
              (bernsteinSecondMomentComparisonFamily P X theta R) i omega +
              troppCurrentRandomStep theta X i omega)) := by
    intro i
    exact
      traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure
        (P := P) theta R RK X
        (bernsteinSecondMomentComparisonFamily P X theta R)
        hHistRand hZRand hR hRK (fun j omega => hBound j omega) hKBound i
  have hSigma : forall i, SigmaFinite (P.trim (hHistSub i)) := by
    intro i
    infer_instance
  have hRhsInt : forall i,
      @IntegrableRealRandomVariable Omega mOmega P
        (fun omega =>
          traceMatrixExp
            (troppStateHistory theta X
              (bernsteinSecondMomentComparisonFamily P X theta R) i omega +
              bernsteinSecondMomentComparisonFamily P X theta R i)) := by
    intro i
    exact
      traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure
        (P := P) theta R RK X
        (bernsteinSecondMomentComparisonFamily P X theta R)
        hHistRand hR hRK (fun j omega => hBound j omega) hKBound i
  exact
    troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives_and_sideConditions
      (mOmega := mOmega) (P := P) theta R X V
      hCentered hIntX hIntSq hBound hR hRange hIndep
      hHistSub hHistRand hHistMeas hHistSA hCondTraceInt hSigma hRhsInt

private theorem comparisonMatrixPrefixSum_deterministicOperatorNorm_le_for_traceExpSum
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
          (Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).sum fun i =>
            norm (K i) := by
              simpa using
                (norm_sum_le (Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat))
                  fun i => K i)
    _ <= (Finset.univ.filter fun i : Fin m => (i : Nat) < (k : Nat)).sum fun _ =>
          RK := by
            refine Finset.sum_le_sum ?_
            intro i _hi
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

/-- Finite-measure full-sum trace-exp integrability from uniform summand bounds.

This is the bounded finite-family bridge for the exact `hTraceIntegrable`-shaped
consumer conclusion used downstream by the Tropp / Matrix Bernstein route. -/
theorem traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (hX : forall i, IsRandomMatrix P (X i))
    (hRX : 0 <= RX)
    (hXBound : forall i omega, operatorNorm (X i) omega <= RX) :
    IntegrableRealRandomVariable P
      (traceExpIntegrand (randomMatrixSum X) theta) := by
  have hScaled : forall i, IsRandomMatrix P (scaledRandomMatrixFamily theta X i) :=
    isRandomMatrix_scaledRandomMatrixFamily (P := P) theta hX
  have hSum : IsRandomMatrix P (randomMatrixSum (scaledRandomMatrixFamily theta X)) :=
    isRandomMatrix_sum (P := P) hScaled
  have hZero : IsRandomMatrix P (fun _ : Omega => (0 : Matrix (Fin n) (Fin n) Real)) := by
    intro i j
    change Measurable (fun _ : Omega => (0 : Real))
    exact measurable_const
  have hScaledBound :
      forall i omega, operatorNorm (scaledRandomMatrixFamily theta X i) omega <=
        abs theta * RX :=
    troppCurrentRandomStep_operatorNorm_le_of_summand_bound theta RX X hXBound
  have hSumBound :
      forall omega, operatorNorm (randomMatrixSum (scaledRandomMatrixFamily theta X)) omega <=
        m * (abs theta * RX) := by
    intro omega
    rw [randomMatrixSum_eq_prefixSum_last (A := scaledRandomMatrixFamily theta X)]
    change norm (randomMatrixPrefixSum (scaledRandomMatrixFamily theta X) (Fin.last m) omega) <=
      m * (abs theta * RX)
    rw [randomMatrixPrefixSum_apply]
    exact
      comparisonMatrixPrefixSum_deterministicOperatorNorm_le_for_traceExpSum
        (fun i => scaledRandomMatrixFamily theta X i omega) (abs theta * RX)
        (mul_nonneg (abs_nonneg theta) hRX) (fun i => hScaledBound i omega) (Fin.last m)
  have hTraceInt :
      IntegrableRealRandomVariable P
        (fun omega =>
          traceMatrixExp
            ((0 : Matrix (Fin n) (Fin n) Real) +
              randomMatrixSum (scaledRandomMatrixFamily theta X) omega)) :=
    traceMatrixExp_add_integrable_of_operatorNormBounds_finiteMeasure
      (P := P)
      (fun _ : Omega => (0 : Matrix (Fin n) (Fin n) Real))
      (randomMatrixSum (scaledRandomMatrixFamily theta X))
      0 (m * (abs theta * RX))
      hZero
      hSum
      (by
        intro omega
        simp [operatorNorm])
      hSumBound
  have hScaledTraceInt :
      IntegrableRealRandomVariable P
        (fun omega => traceMatrixExp (randomMatrixSum (scaledRandomMatrixFamily theta X) omega)) := by
    simpa only [zero_add] using hTraceInt
  have hScaledIntegrand :
      (fun omega => traceMatrixExp (randomMatrixSum (scaledRandomMatrixFamily theta X) omega)) =
        traceExpIntegrand (randomMatrixSum X) theta := by
    funext omega
    unfold traceExpIntegrand randomMatrixSum scaledRandomMatrixFamily scaledRandomMatrix
    congr 1
    ext r c
    rw [Matrix.sum_apply]
    change
      (Finset.univ.sum fun i : Fin m => (theta • X i omega) r c) =
        (theta • (Finset.univ.sum fun i : Fin m => X i omega)) r c
    rw [Matrix.smul_apply]
    rw [Matrix.sum_apply]
    simp_rw [Matrix.smul_apply]
    simp only [smul_eq_mul]
    change (Finset.univ.sum fun i : Fin m => theta * X i omega r c) =
      theta * (Finset.univ.sum fun i : Fin m => X i omega r c)
    rw [Finset.mul_sum]
  rw [hScaledIntegrand] at hScaledTraceInt
  exact hScaledTraceInt

/-- Matrix Bernstein trace-MGF wrapper from Bernstein primitives and the
generated-history Tropp chain.

This consumes the generated-history finite-family wrapper above and the main
HighDimProb Bernstein trace-MGF wrapper. The bounded finite-measure
integrability side conditions for the per-summand matrix exponential and the
full trace-exponential sum are derived from the pointwise operator-norm bound.
Current-step exponential-mean self-adjointness is derived from the centered
self-adjoint summand primitives, and strict positivity is derived internally. -/
theorem matrixBernsteinTraceMGFWithBernsteinCoeff_generatedHistory_of_bernsteinPrimitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3) :
    matrixBernsteinTraceMGFWithBernsteinCoeff_statement P X theta R := by
  have hX : forall j, IsRandomMatrix P (X j) := hCentered.1.1
  have hIndep : ProbabilityTheory.iIndepFun X P := hIndepSA.2
  have hExpInt :
      forall i,
        IntegrableRandomMatrix P (matrixExpScaledFamily X theta i) := by
    have h :=
      matrixExpScaledIntegrable_of_provider_finiteMeasure
        theta R X hX hR (fun j omega => hBound j omega)
    simpa [matrixExpScaledFamily] using h
  have hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) theta) :=
    traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure
      theta R X hX hR (fun j omega => hBound j omega)
  have hTropp :
      troppMasterTraceMGFFiniteFamily_statement (P := P) X
        (bernsteinSecondMomentComparisonFamily P X theta R)
        (matrixVarianceProxy P X) theta R :=
    troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P) theta R X (matrixVarianceProxy P X)
      hCentered hIntX hIntSq hBound hR hRange hIndep
  exact
    matrixBernsteinTraceMGFWithBernsteinCoeff_under_troppPrimitive
      X theta R hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound hR
      hRange hTropp

/-- Quadratic-form upper-tail Laplace bound from Bernstein primitives and the
generated-history Tropp chain.

This composes the generated-history Bernstein trace-MGF wrapper with the
Laplace contract. The tail-side measurability and event-subset bridge remain
explicit, and current-step exponential-mean self-adjointness is derived from the
centered self-adjoint summand primitives, with strict positivity derived
internally. -/
theorem matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (theta t R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hTailMeas :
      AEMeasurable
        (fun omega => ENNReal.ofReal
          (traceExpIntegrand (randomMatrixSum X) theta omega)) P)
    (hTailSubset :
      quadraticFormUpperTailEvent (randomMatrixSum X) t ⊆
        traceExpThresholdEvent (randomMatrixSum X) theta t) :
    P (quadraticFormUpperTailEvent (randomMatrixSum X) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp
            (SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P X))) := by
  have hX : forall j, IsRandomMatrix P (X j) := hCentered.1.1
  have hSA : forall j, RandomSelfAdjointMatrix P (X j) := hCentered.1.2
  have hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) theta) :=
    traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure
      theta R X hX hR (fun j omega => hBound j omega)
  have hNonneg :
      forall omega, 0 <= traceExpIntegrand (randomMatrixSum X) theta omega := by
    exact traceExpIntegrand_nonneg_of_randomSelfAdjoint theta
      (randomSelfAdjointMatrix_sum hSA)
  have hTraceMGF :
      matrixBernsteinTraceMGFWithBernsteinCoeff_statement P X theta R :=
    matrixBernsteinTraceMGFWithBernsteinCoeff_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P) theta R X
      hCentered hIndepSA hIntX hIntSq hBound hR hRange
  exact
    matrixBernsteinTraceMGFToLaplaceContract_under_primitives
      (P := P) X theta t R hTailMeas hTailSubset hTraceInt hNonneg hTraceMGF

end

end HighDimProb
