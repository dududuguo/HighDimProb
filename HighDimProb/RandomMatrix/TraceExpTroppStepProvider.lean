import HighDimProb.RandomMatrix.EpsteinProvider
import HighDimProb.RandomMatrix.RelativeEntropyLeftRightRepresentationProvider
import HighDimProb.RandomMatrix.TraceExpLogOrderProvider
import HighDimProb.RandomMatrix.TraceExpJensenProvider
import HighDimProb.RandomMatrix.TraceExpMonotonicityProvider

/-!
# Tropp step composition wrappers

This module packages thin provider-side Tropp wrappers.

- `troppLogExpComparisonToK_of_traceMatrixExp_mono_add_selfAdjoint` reuses the
  provider log-order bridge plus the provider trace-exp monotonicity theorem.
- `troppMasterTraceMGFStep_of_providerJensen` reuses the provider Jensen bridge
  and main-library matrix-log normalization while keeping the one-step chain
  premise explicit.

It does not prove Lieb concavity, the one-step Tropp chain, Golden-Thompson, or
Matrix Bernstein.
-/

namespace HighDimProb

open HighDimProb
open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

noncomputable section

/-- Tropp log/`K` comparison from provider log-order plus trace-exp monotonicity.

The only analytic input left explicit is
`HighDimProb.traceMatrixExp_mono_add_selfAdjoint_statement`. This theorem does
not prove that monotonicity statement, Lieb concavity, Golden-Thompson, or any
Bernstein CFC fact. -/
theorem troppLogExpComparisonToK_of_traceMatrixExp_mono_add_selfAdjoint {n : Nat}
    (H M K : Matrix (Fin n) (Fin n) Real)
    (hTrace :
      HighDimProb.traceMatrixExp_mono_add_selfAdjoint_statement H (CFC.log M) K) :
    HighDimProb.troppLogExpComparisonToK_statement H M K := by
  intro hH hM hMpos hK hMK
  have hLogLE : HighDimProb.MatrixLE (CFC.log M) K :=
    matrixLog_le_of_le_matrixExp_of_providerLogMonotone M K hM hMpos hK hMK
  have hLogSelfAdjoint : HighDimProb.IsSelfAdjointMatrix (CFC.log M) :=
    isSelfAdjointMatrix_cfc_log hM
  exact hTrace hH hLogSelfAdjoint hK hLogLE

/-- Tropp log/`K` comparison using only provider log-order and provider trace-exp monotonicity. -/
theorem troppLogExpComparisonToK_of_providerLogOrder {n : Nat}
    (H M K : Matrix (Fin n) (Fin n) Real) :
    HighDimProb.troppLogExpComparisonToK_statement H M K := by
  intro hH hM hMpos hK hMK
  exact
    troppLogExpComparisonToK_of_traceMatrixExp_mono_add_selfAdjoint
      H M K (traceMatrixExp_mono_add_selfAdjoint H (CFC.log M) K)
      hH hM hMpos hK hMK
/-- Thin Tropp one-step composition from the provider's exact Jensen theorem.

This theorem keeps the hard one-step chain hypothesis explicit. The provider
only discharges the Jensen input using the exact Lieb-concavity-to-Jensen
wrapper, while HighDimProb supplies the pointwise `log (exp Z) = Z`
normalization for self-adjoint `Z`. It does not prove Lieb concavity,
Golden-Thompson, trace-exp monotonicity, or Matrix Bernstein. -/
theorem troppMasterTraceMGFStep_of_providerJensen
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n)
    (hChain : troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Z) :
    troppMasterTraceMGFStep_statement (P := P) H Z :=
  HighDimProb.troppMasterTraceMGFStep_of_liebJensen H Z hChain
    (liebJensenTraceExp_statement_of_liebConcavity
      (P := P) H (fun omega => HighDimProb.matrixExp (Z omega)))
    (fun omega => HighDimProb.matrixExpLogSelfAdjointNormalization (Z omega))

/-- Conditional Tropp one-step bound from the explicit Epstein affine-line
hypothesis.

This discharges the Lieb/Jensen part of the one-step trace-MGF primitive, while
keeping the original statement's self-adjointness, integrability, and mean
strict-positivity inputs explicit. -/
theorem troppMasterTraceMGFStep_of_epsteinAffineLine
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    (hEpstein : EpsteinAffineLineConcavity)
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n) :
    HighDimProb.troppMasterTraceMGFStep_statement (P := P) H Z := by
  intro hH hZ hTraceInt hExpInt hExpMeanSA hExpMeanPos
  have hIntegrandEq :
      (fun omega => HighDimProb.traceMatrixExp
        (H + CFC.log (HighDimProb.matrixExp (Z omega)))) =
        (fun omega => HighDimProb.traceMatrixExp (H + Z omega)) := by
    funext omega
    rw [HighDimProb.matrixExpLogSelfAdjointNormalization (Z omega) (hZ omega)]
  have hTraceLogInt : HighDimProb.IntegrableRealRandomVariable P
      (fun omega => HighDimProb.traceMatrixExp
        (H + CFC.log (HighDimProb.matrixExp (Z omega)))) := by
    rw [hIntegrandEq]
    exact hTraceInt
  have hJensen :=
    liebJensenTraceExp_of_epsteinAffineLine (P := P) hEpstein H
      (fun omega => HighDimProb.matrixExp (Z omega))
      hH
      (fun omega => HighDimProb.isSelfAdjointMatrix_matrixExp (hZ omega))
      (fun omega =>
        (HighDimProb.matrixExpLogDomainForSelfAdjoint (Z omega) (hZ omega)).2.1)
      hExpInt hExpMeanSA hExpMeanPos hTraceLogInt
  rw [← hIntegrandEq]
  exact hJensen

/-- Conditional Tropp one-step-to-`K` trace bound from the explicit Epstein
hypothesis plus the provider log-order bridge. -/
theorem troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    (hEpstein : EpsteinAffineLineConcavity)
    {n : Nat}
    (H K : Matrix (Fin n) (Fin n) Real)
    (Z : HighDimProb.RandomMatrix Omega n n)
    (hH : HighDimProb.IsSelfAdjointMatrix H)
    (hZ : HighDimProb.RandomSelfAdjointMatrix P Z)
    (hTraceInt : HighDimProb.IntegrableRealRandomVariable P
      (fun omega => HighDimProb.traceMatrixExp (H + Z omega)))
    (hExpInt : HighDimProb.IntegrableRandomMatrix P
      (fun omega => HighDimProb.matrixExp (Z omega)))
    (hExpMeanSA : HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hExpMeanPos : IsStrictlyPositive
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hKSA : HighDimProb.IsSelfAdjointMatrix K)
    (hMGF : HighDimProb.MatrixLE
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))
      (HighDimProb.matrixExp K)) :
    HighDimProb.expect P (fun omega => HighDimProb.traceMatrixExp (H + Z omega)) <=
      HighDimProb.traceMatrixExp (H + K) := by
  have hStep : HighDimProb.troppMasterTraceMGFStep_statement (P := P) H Z :=
    troppMasterTraceMGFStep_of_epsteinAffineLine (P := P) hEpstein H Z
  have hBridge :
      HighDimProb.troppLogExpComparisonToK_statement H
        (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))) K :=
    troppLogExpComparisonToK_of_providerLogOrder
      H
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))
      K
  exact
    HighDimProb.troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK
      H K Z hStep hBridge hH hZ hTraceInt hExpInt hExpMeanSA hExpMeanPos
      hKSA hMGF

/-- Tropp one-step bound from the proved left/right relative-entropy route.

This wrapper exists for downstream users that want the provider's finished
Lieb/Epstein route without manually passing
`epsteinAffineLineConcavity_of_leftRight`. It still only proves the one-step
statement, not Golden-Thompson, Matrix Bernstein, or the finite-family
conditioning chain. -/
theorem troppMasterTraceMGFStep_of_leftRight
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n) :
    HighDimProb.troppMasterTraceMGFStep_statement (P := P) H Z :=
  troppMasterTraceMGFStep_of_epsteinAffineLine
    (P := P) epsteinAffineLineConcavity_of_leftRight H Z

/-- Compatibility witness for the legacy Lieb/Jensen decomposition contract.

The preferred proof-facing API is `troppMasterTraceMGFStep_of_leftRight`.
The Jensen and normalization arguments remain in the statement only for
backward compatibility. -/
theorem troppLiebJensenChain_of_leftRight
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n) :
    HighDimProb.troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Z := by
  intro _hJensen _hNormalize
  exact troppMasterTraceMGFStep_of_leftRight (P := P) H Z

/-- Tropp one-step-to-`K` trace bound from the proved left/right
relative-entropy route plus the provider log-order bridge. -/
theorem troppMasterTraceMGFStep_trace_bound_of_leftRight_and_providerLogOrder
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (H K : Matrix (Fin n) (Fin n) Real)
    (Z : HighDimProb.RandomMatrix Omega n n)
    (hH : HighDimProb.IsSelfAdjointMatrix H)
    (hZ : HighDimProb.RandomSelfAdjointMatrix P Z)
    (hTraceInt : HighDimProb.IntegrableRealRandomVariable P
      (fun omega => HighDimProb.traceMatrixExp (H + Z omega)))
    (hExpInt : HighDimProb.IntegrableRandomMatrix P
      (fun omega => HighDimProb.matrixExp (Z omega)))
    (hExpMeanSA : HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hExpMeanPos : IsStrictlyPositive
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hKSA : HighDimProb.IsSelfAdjointMatrix K)
    (hMGF : HighDimProb.MatrixLE
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))
      (HighDimProb.matrixExp K)) :
    HighDimProb.expect P (fun omega => HighDimProb.traceMatrixExp (H + Z omega)) <=
      HighDimProb.traceMatrixExp (H + K) :=
  troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder
    (P := P) epsteinAffineLineConcavity_of_leftRight H K Z hH hZ hTraceInt
    hExpInt hExpMeanSA hExpMeanPos hKSA hMGF

/-- Thin Tropp one-step-to-`K` composition from the provider Jensen and
log-order bridges.

This theorem keeps the hard one-step chain and trace-exp monotonicity bridge
explicit. It only composes existing provider wrappers with the main
HighDimProb trace-bound theorem. -/
theorem troppMasterTraceMGFStep_trace_bound_of_providerJensen_and_logOrder
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (H K : Matrix (Fin n) (Fin n) Real)
    (Z : HighDimProb.RandomMatrix Omega n n)
    (hChain : HighDimProb.troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Z)
    (hTraceMono : HighDimProb.traceMatrixExp_mono_add_selfAdjoint_statement H
      (CFC.log (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))) K)
    (hH : HighDimProb.IsSelfAdjointMatrix H)
    (hZ : HighDimProb.RandomSelfAdjointMatrix P Z)
    (hTraceInt : HighDimProb.IntegrableRealRandomVariable P
      (fun omega => HighDimProb.traceMatrixExp (H + Z omega)))
    (hExpInt : HighDimProb.IntegrableRandomMatrix P
      (fun omega => HighDimProb.matrixExp (Z omega)))
    (hExpMeanSA : HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hExpMeanPos : IsStrictlyPositive
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hKSA : HighDimProb.IsSelfAdjointMatrix K)
    (hMGF : HighDimProb.MatrixLE
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))
      (HighDimProb.matrixExp K)) :
    HighDimProb.expect P (fun omega => HighDimProb.traceMatrixExp (H + Z omega)) <=
      HighDimProb.traceMatrixExp (H + K) := by
  let hStep := troppMasterTraceMGFStep_of_providerJensen (P := P) H Z hChain
  let hBridge :=
    troppLogExpComparisonToK_of_traceMatrixExp_mono_add_selfAdjoint
      H
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))
      K
      hTraceMono
  exact
    HighDimProb.troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK
      H K Z hStep hBridge hH hZ hTraceInt hExpInt hExpMeanSA hExpMeanPos
      hKSA hMGF


/-- Thin Tropp one-step-to-`K` composition from the provider Jensen and
provider log-order bridges.

This theorem keeps the hard one-step chain explicit, but discharges the
trace-exp monotonicity bridge internally via the provider theorem
`traceMatrixExp_mono_add_selfAdjoint`. It only composes existing provider
wrappers with the main HighDimProb trace-bound theorem. -/
theorem troppMasterTraceMGFStep_trace_bound_of_providerJensen_and_providerLogOrder
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (H K : Matrix (Fin n) (Fin n) Real)
    (Z : HighDimProb.RandomMatrix Omega n n)
    (hChain : HighDimProb.troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Z)
    (hH : HighDimProb.IsSelfAdjointMatrix H)
    (hZ : HighDimProb.RandomSelfAdjointMatrix P Z)
    (hTraceInt : HighDimProb.IntegrableRealRandomVariable P
      (fun omega => HighDimProb.traceMatrixExp (H + Z omega)))
    (hExpInt : HighDimProb.IntegrableRandomMatrix P
      (fun omega => HighDimProb.matrixExp (Z omega)))
    (hExpMeanSA : HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hExpMeanPos : IsStrictlyPositive
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))))
    (hKSA : HighDimProb.IsSelfAdjointMatrix K)
    (hMGF : HighDimProb.MatrixLE
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))
      (HighDimProb.matrixExp K)) :
    HighDimProb.expect P (fun omega => HighDimProb.traceMatrixExp (H + Z omega)) <=
      HighDimProb.traceMatrixExp (H + K) := by
  have hStep : HighDimProb.troppMasterTraceMGFStep_statement (P := P) H Z :=
    troppMasterTraceMGFStep_of_providerJensen (P := P) H Z hChain
  have hBridge :
      HighDimProb.troppLogExpComparisonToK_statement H
        (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega))) K :=
    troppLogExpComparisonToK_of_providerLogOrder
      H
      (HighDimProb.matrixExpect P (fun omega => HighDimProb.matrixExp (Z omega)))
      K
  exact
    HighDimProb.troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK
      H K Z hStep hBridge hH hZ hTraceInt hExpInt hExpMeanSA hExpMeanPos
      hKSA hMGF
end

end HighDimProb
