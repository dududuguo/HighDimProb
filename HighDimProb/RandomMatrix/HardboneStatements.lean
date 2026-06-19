import HighDimProb.RandomMatrix.TraceExp
import HighDimProb.Analysis.RealInequalities

/-!
# RandomMatrix hardbone statement targets

This module names small source-oriented statement targets for hard RandomMatrix
proof steps. These are typed `Prop` surfaces, not proof claims. They are meant
to split large primitive assumptions into reusable contracts before later proof
leaves decide which pieces are supported by Mathlib and the local API.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder Matrix.Norms.Operator

/-- Scalar Bernstein exponential/quadratic inequality target.

This is the scalar inequality that should feed the matrix functional-calculus
step behind `bernsteinMatrixExp_le_quadratic_statement`. -/
abbrev scalarBernsteinExpQuadraticInequality_statement
    (theta R : Real) : Prop :=
  forall x : Real,
    abs x <= R ->
      0 <= R ->
        abs theta * R < 3 ->
          Real.exp (theta * x) <=
            1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2

/-- Spectrum-boundedness target for a self-adjoint matrix under an operator-norm
bound.

This is the spectral localization step needed before applying a scalar
inequality on the spectrum of `A`. -/
abbrev selfAdjointSpectrumBoundedByOperatorNorm_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (R : Real) : Prop :=
  IsSelfAdjointMatrix A ->
    deterministicOperatorNorm A <= R ->
      forall x : Real, x ∈ spectrum Real A -> abs x <= R

/-- Functional-calculus order-transfer target.

If scalar functions are ordered on the real spectrum of a self-adjoint matrix,
their CFC evaluations should be ordered in `MatrixLE`. -/
abbrev cfcScalarInequalityToMatrixLE_statement {n : Nat}
    (f g : Real -> Real) (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix A ->
    (forall x : Real, x ∈ spectrum Real A -> f x <= g x) ->
      MatrixLE (cfc f A) (cfc g A)

/-- Expression-normalization target for the Bernstein CFC route.

This records the CFC rewrites that connect the scalar functions in the CFC
order-transfer step to the existing matrix-exponential and matrix-square
vocabulary. -/
abbrev bernsteinCFCExpressionNormalization_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real) : Prop :=
  IsSelfAdjointMatrix A ->
    cfc (fun x : Real => Real.exp (theta * x)) A =
        matrixExp (theta • A) ∧
      cfc
          (fun x : Real =>
            1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2) A =
        (1 : Matrix (Fin n) (Fin n) Real) +
          theta • A +
            bernsteinMGFCoeff theta R • matrixSquare A

/-- Source-oriented statement chain for the Bernstein matrix-exponential CFC
primitive.

The target says the current high-level matrix Bernstein CFC primitive follows
from the scalar Bernstein theorem plus spectral localization, CFC order
transfer, and expression normalization.  The individual leaves and the composed
primitive are proved below; the statement remains useful as an explicit
source-oriented contract. -/
abbrev bernsteinMatrixExp_le_quadratic_of_cfcChain_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real) : Prop :=
  scalarBernsteinExpQuadraticInequality_statement theta R ->
    selfAdjointSpectrumBoundedByOperatorNorm_statement A R ->
      cfcScalarInequalityToMatrixLE_statement
        (fun x : Real => Real.exp (theta * x))
        (fun x : Real =>
          1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2)
        A ->
        bernsteinCFCExpressionNormalization_statement A theta R ->
          bernsteinMatrixExp_le_quadratic_statement A theta R

/-! ## Log/order-to-`K` hardbone statement chain -/

/-- Operator-log monotonicity target on the positive matrix cone.

This is the analytic order fact behind turning `M <= N` into
`log M <= log N` for self-adjoint strictly positive matrices. -/
abbrev operatorLogMonotoneOnPositiveMatrices_statement {n : Nat}
    (M N : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix M ->
    IsStrictlyPositive M ->
      IsSelfAdjointMatrix N ->
        IsStrictlyPositive N ->
          MatrixLE M N ->
            MatrixLE (CFC.log M) (CFC.log N)

/-- Domain and normalization target for applying matrix log to `matrixExp K`.

This records the extra log-domain and expression-normalization facts needed to
use `matrixExp K` as the upper comparison matrix in the log/order bridge. -/
abbrev matrixExpLogDomainForSelfAdjoint_statement {n : Nat}
    (K : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix K ->
    IsSelfAdjointMatrix (matrixExp K) ∧
      IsStrictlyPositive (matrixExp K) ∧
        CFC.log (matrixExp K) = K

/-- Log-order bridge target from `M <= exp K` to `log M <= K`.

This is narrower than the existing Tropp bridge: it only targets the matrix-log
order comparison, leaving trace-exponential monotonicity as a separate
statement. -/
abbrev matrixLog_le_of_le_matrixExp_statement {n : Nat}
    (M K : Matrix (Fin n) (Fin n) Real) : Prop :=
  operatorLogMonotoneOnPositiveMatrices_statement M (matrixExp K) ->
    matrixExpLogDomainForSelfAdjoint_statement K ->
      IsSelfAdjointMatrix M ->
        IsStrictlyPositive M ->
          IsSelfAdjointMatrix K ->
            MatrixLE M (matrixExp K) ->
              MatrixLE (CFC.log M) K

/-- Trace-exponential monotonicity after adding a self-adjoint history term.

This isolates the order-preservation step needed after a log-order comparison
has produced `log M <= K`. -/
abbrev traceMatrixExp_mono_add_selfAdjoint_statement {n : Nat}
    (H A B : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix H ->
    IsSelfAdjointMatrix A ->
      IsSelfAdjointMatrix B ->
        MatrixLE A B ->
          traceMatrixExp (H + A) <= traceMatrixExp (H + B)

/-- Statement-chain target reducing the Tropp log/`K` comparison to smaller
order facts.

The existing bridge appears here only as the conclusion of the chain. The
premises are the smaller log-order and trace-exponential monotonicity targets
named above. -/
abbrev troppLogExpComparisonToK_of_logOrderKChain_statement {n : Nat}
    (H M K : Matrix (Fin n) (Fin n) Real) : Prop :=
  matrixLog_le_of_le_matrixExp_statement M K ->
    traceMatrixExp_mono_add_selfAdjoint_statement H (CFC.log M) K ->
      troppLogExpComparisonToK_statement H M K

/-! ## Tropp/Lieb/Golden-Thompson hardbone statement chain -/

/-- Lieb concavity input target for the Tropp one-step route.

This names the analytic fact that the positive-matrix map
`M ↦ tr exp(H + log M)` is concave for self-adjoint `H`. -/
abbrev liebTraceExpConcavity_statement {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix H ->
    ConcaveOn Real
      {M : Matrix (Fin n) (Fin n) Real |
        IsSelfAdjointMatrix M ∧ IsStrictlyPositive M}
      (fun M => traceMatrixExp (H + CFC.log M))

/-- Jensen-style consequence of Lieb concavity for positive random matrices.

This is the source-oriented Jensen target used before specializing
`Y omega = matrixExp (Z omega)`. It reuses the repository's entrywise
`matrixExpect`, scalar `expect`, and existing integrability vocabulary. -/
abbrev liebJensenTraceExp_statement {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Y : RandomMatrix Omega n n) : Prop :=
  liebTraceExpConcavity_statement H ->
    IsSelfAdjointMatrix H ->
      (forall omega, IsSelfAdjointMatrix (Y omega)) ->
        (forall omega, IsStrictlyPositive (Y omega)) ->
          IntegrableRandomMatrix P Y ->
            IsSelfAdjointMatrix (matrixExpect P Y) ->
              IsStrictlyPositive (matrixExpect P Y) ->
                IntegrableRealRandomVariable P
                  (fun omega => traceMatrixExp (H + CFC.log (Y omega))) ->
                  expect P
                      (fun omega => traceMatrixExp (H + CFC.log (Y omega))) <=
                    traceMatrixExp (H + CFC.log (matrixExpect P Y))

/-- Golden-Thompson trace-exponential comparison target.

This is kept separate from the Lieb/Jensen route. It records the familiar
`tr exp(A + B) <= tr (exp A * exp B)` comparison without using it in the
Tropp one-step chain. -/
abbrev goldenThompsonTraceExp_statement {n : Nat}
    (A B : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix A ->
    IsSelfAdjointMatrix B ->
      traceMatrixExp (A + B) <= matrixTrace (matrixExp A * matrixExp B)

/-- Matrix-log normalization target for self-adjoint exponentials.

This is the pointwise analytic normalization needed to turn the Jensen
integrand with `log (exp Z)` into the Tropp one-step integrand with `Z`. -/
abbrev matrixExpLogSelfAdjointNormalization_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix A -> CFC.log (matrixExp A) = A

/-- Statement-chain target reducing the Tropp one-step primitive to
Lieb/Jensen facts.

The existing one-step primitive appears here only as the conclusion of the
chain. The finite-family Tropp primitive is not part of this statement. -/
abbrev troppMasterTraceMGFStep_of_liebJensen_statement {Omega : Type*}
    [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    [MeasureTheory.IsProbabilityMeasure P] {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n) : Prop :=
  liebJensenTraceExp_statement (P := P) H (fun omega => matrixExp (Z omega)) ->
    (forall omega, matrixExpLogSelfAdjointNormalization_statement (Z omega)) ->
      troppMasterTraceMGFStep_statement (P := P) H Z

/-! ## Conditioning and history hardbone statement chain -/

/-- Natural-history measurability target for the Tropp prefix/suffix state.

The history sigma-algebras are explicit local inputs here: the current
RandomMatrix API does not yet provide a generated-prefix filtration
construction for `Fin m` matrix families. -/
abbrev troppNaturalHistoryMeasurable_statement {Omega : Type*}
    [mOmega : MeasurableSpace Omega] {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (mHist : Fin m -> MeasurableSpace Omega) : Prop :=
  (forall i, mHist i ≤ mOmega) ->
    forall i r c,
      @Measurable Omega Real (mHist i) inferInstance
        (fun omega => troppStateHistory theta X K i omega r c)

/-- Independence target for the natural history and current increment.

This records the desired provider from finite-family independence of `X` to
the one-step independence relation needed by the natural Tropp state. -/
abbrev troppHistoryStepIndependent_of_iIndepFun_statement {Omega : Type*}
    [mOmega : MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) : Prop :=
  ProbabilityTheory.iIndepFun X P ->
    forall i,
      @ProbabilityTheory.IndepFun Omega _ _ mOmega _ _
        (@troppStateHistory Omega mOmega m n theta X K i)
        (@troppCurrentRandomStep Omega mOmega m n theta X i) P

/-- Conditional-expectation reduction target for a history-measurable matrix
and an independent step.

The statement exposes the same ordinary side conditions used by the
conditional-step route, but names the probabilistic reduction separately from
finite-family bookkeeping. -/
abbrev condExp_traceExp_history_add_independent_step_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    (mHist : MeasurableSpace Omega)
    (H Z : RandomMatrix Omega n n)
    (K : Matrix (Fin n) (Fin n) Real) : Prop :=
  mHist ≤ mOmega ->
    @IsRandomMatrix Omega mOmega n n P H ->
      @IsRandomMatrix Omega mOmega n n P Z ->
        (forall i j,
          @Measurable Omega Real mHist inferInstance
            (fun omega => H omega i j)) ->
          (forall omega, IsSelfAdjointMatrix (H omega)) ->
            @RandomSelfAdjointMatrix Omega mOmega n P Z ->
              @ProbabilityTheory.IndepFun Omega _ _ mOmega _ _ H Z P ->
                @IntegrableRealRandomVariable Omega mOmega P
                  (fun omega => traceMatrixExp (H omega + Z omega)) ->
                  @IntegrableRandomMatrix Omega mOmega n n P
                    (fun omega => matrixExp (Z omega)) ->
                    IsSelfAdjointMatrix
                      (@matrixExpect Omega mOmega n n P
                        (fun omega => matrixExp (Z omega))) ->
                      IsStrictlyPositive
                        (@matrixExpect Omega mOmega n n P
                          (fun omega => matrixExp (Z omega))) ->
                        IsSelfAdjointMatrix K ->
                          MatrixLE
                            (@matrixExpect Omega mOmega n n P
                              (fun omega => matrixExp (Z omega)))
                            (matrixExp K) ->
                            ∀ᵐ omega ∂P,
                              MeasureTheory.condExp (m := mHist) P
                                (fun omega' =>
                                  traceMatrixExp (H omega' + Z omega')) omega <=
                                traceMatrixExp (H omega + K)

/-- Statement-chain target from natural finite-family conditioning data to the
existing one-step conditional target.

The premises are smaller history measurability, history/current-step
independence, and conditional-expectation reduction targets. -/
abbrev troppConditionalStep_of_iIndepFun_statement {Omega : Type*}
    [mOmega : MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (mHist : Fin m -> MeasurableSpace Omega) : Prop :=
  @troppNaturalHistoryMeasurable_statement Omega mOmega m n theta X K mHist ->
    @troppHistoryStepIndependent_of_iIndepFun_statement Omega mOmega P m n
      theta X K ->
      (forall i,
        @condExp_traceExp_history_add_independent_step_statement
          Omega mOmega P n
          (mHist i) (@troppStateHistory Omega mOmega m n theta X K i)
          (@troppCurrentRandomStep Omega mOmega m n theta X i) (K i)) ->
        ProbabilityTheory.iIndepFun X P ->
          forall i,
            @troppMasterTraceMGFConditionalStep_statement Omega mOmega P n
              (mHist i) (@troppStateHistory Omega mOmega m n theta X K i)
              (@troppCurrentRandomStep Omega mOmega m n theta X i) (K i)

/-! ## Trace-exponential integrability hardbone statement chain -/

/-- Provider target for integrability of scaled summand matrix exponentials.

The statement uses the direct TraceExp vocabulary
`matrixExp (theta • X_i)` instead of importing downstream concentration
helpers just to name `matrixExpScaledFamily`. -/
abbrev matrixExpScaledIntegrable_of_provider_statement {Omega : Type*}
    [mOmega : MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {m n : Nat}
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n) : Prop :=
  (forall i, @IsRandomMatrix Omega mOmega n n P (X i)) ->
    (forall i, @RandomSelfAdjointMatrix Omega mOmega n P (X i)) ->
      0 <= R ->
        (forall i omega, operatorNorm (X i) omega <= R) ->
          forall i,
            @IntegrableRandomMatrix Omega mOmega n n P
              (fun omega => matrixExp (SMul.smul theta (X i omega)))

/-- Provider target for trace-exponential integrability of the natural Tropp
history plus the current scaled random step. -/
abbrev traceExpIntegrable_troppStateHistory_add_step_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) : Prop :=
  (forall i,
    @IsRandomMatrix Omega mOmega n n P
      (@troppStateHistory Omega mOmega m n theta X K i)) ->
    (forall i,
      @IsRandomMatrix Omega mOmega n n P
        (@troppCurrentRandomStep Omega mOmega m n theta X i)) ->
      (forall i omega,
        IsSelfAdjointMatrix
          (@troppStateHistory Omega mOmega m n theta X K i omega)) ->
        (forall i,
          @RandomSelfAdjointMatrix Omega mOmega n P
            (@troppCurrentRandomStep Omega mOmega m n theta X i)) ->
          forall i,
            @IntegrableRealRandomVariable Omega mOmega P
              (fun omega =>
                traceMatrixExp
                  (@troppStateHistory Omega mOmega m n theta X K i omega +
                    @troppCurrentRandomStep Omega mOmega m n theta X i omega))

/-- Provider target for trace-exponential integrability of the natural Tropp
history plus the deterministic comparison matrix. -/
abbrev traceExpIntegrable_troppStateHistory_add_K_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) : Prop :=
  (forall i,
    @IsRandomMatrix Omega mOmega n n P
      (@troppStateHistory Omega mOmega m n theta X K i)) ->
    (forall i omega,
      IsSelfAdjointMatrix
        (@troppStateHistory Omega mOmega m n theta X K i omega)) ->
      (forall i, IsSelfAdjointMatrix (K i)) ->
        forall i,
          @IntegrableRealRandomVariable Omega mOmega P
            (fun omega =>
              traceMatrixExp
                (@troppStateHistory Omega mOmega m n theta X K i omega + K i))

/-- Provider target for full-sum trace-exponential integrability from an
explicit absolute-domination provider.

Summand-wise matrix-exponential integrability is not by itself enough to
control `trace exp` of a noncommutative sum. This target therefore keeps the
needed absolute domination provider explicit until a later
Golden-Thompson/product or boundedness API supplies it. -/
abbrev traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (D : RealRandomVariable Omega) : Prop :=
  @IntegrableRealRandomVariable Omega mOmega P D ->
    (forall omega, 0 <= D omega) ->
      (forall omega,
        abs (traceExpIntegrand (randomMatrixSum X) theta omega) <= D omega) ->
      @IntegrableRealRandomVariable Omega mOmega P
        (traceExpIntegrand (randomMatrixSum X) theta)

/-- Thin consumer for the full-sum trace-exponential domination provider.

This theorem only applies the explicit domination-provider statement. It does
not prove Golden-Thompson/product domination or any automatic boundedness
provider. -/
theorem traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (D : RealRandomVariable Omega)
    (hChain :
      @traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
        Omega mOmega P m n theta X D)
    (hD : @IntegrableRealRandomVariable Omega mOmega P D)
    (hD_nonneg : forall omega, 0 <= D omega)
    (hDom : forall omega,
      abs (traceExpIntegrand (randomMatrixSum X) theta omega) <= D omega) :
    @IntegrableRealRandomVariable Omega mOmega P
      (traceExpIntegrand (randomMatrixSum X) theta) :=
  hChain hD hD_nonneg hDom

/-! ## Variance-proxy and centered-square hardbone statement chain -/

/-- Centered-square expectation expansion target.

This records the future algebra/integrability target behind replacing
`E[(A - E A)^2]` by `E[A^2] - (E A)^2` in the matrix variance-proxy route. -/
abbrev matrixSquare_centeredRandomMatrix_expectation_expansion_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (A : RandomMatrix Omega n n) : Prop :=
  @IntegrableRandomMatrix Omega mOmega n n P A ->
    @IntegrableRandomMatrix Omega mOmega n n P (randomMatrixSquare A) ->
      @IntegrableRandomMatrix Omega mOmega n n P
        (randomMatrixSquare (centeredRandomMatrix P A)) ->
        matrixSecondMoment P (centeredRandomMatrix P A) =
          matrixSecondMoment P A - matrixSquare (matrixExpect P A)

/-- Centered rank-one square comparison target.

For rank-one covariance summands, this names the Loewner comparison that would
control the centered square by an uncentered rank-one second moment. -/
abbrev centeredRankOneSquare_le_rankOneSecondMoment_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (X : RandomVector Omega n) : Prop :=
  IsRandomVector P X ->
    (forall j : Fin n, MemLpRealRandomVariable P (coord X j) 2) ->
      @IntegrableRandomMatrix Omega mOmega n n P
        (randomMatrixSquare (centeredRankOneRandomMatrix P X)) ->
        @IntegrableRandomMatrix Omega mOmega n n P
          (randomMatrixSquare (rankOneRandomMatrix X)) ->
          MatrixLE
            (matrixSecondMoment P (centeredRankOneRandomMatrix P X))
            (matrixSecondMoment P (rankOneRandomMatrix X))

/-- Sample-covariance variance-proxy sharpening target in abstract row-feature
form.

The statement is written over a `Fin m` family of row feature vectors rather
than importing downstream sample-covariance tail wrappers into the hardbone
module. It targets the variance proxy of the centered rank-one row family. -/
abbrev sampleCovarianceVarianceProxy_sharp_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {m n : Nat}
    (X : Fin m -> RandomVector Omega n)
    (V : Fin m -> Matrix (Fin n) (Fin n) Real)
    (sigma2 : Real) : Prop :=
  (forall i,
    @centeredRankOneSquare_le_rankOneSecondMoment_statement
      Omega mOmega P _ n (X i)) ->
    (forall i,
      MatrixLE (matrixSecondMoment P (rankOneRandomMatrix (X i))) (V i)) ->
      deterministicMatrixVarianceProxyNorm (Finset.univ.sum fun i => V i) <=
        sigma2 ->
        MatrixVarianceProxyNormBound P
          (centeredRankOneRandomMatrixFamily P X) sigma2

/-- Generic provider-chain target from centered-square comparisons to a
variance-proxy norm bound.

This is not a Matrix Bernstein tail wrapper. It isolates the order/norm
bookkeeping needed after per-summand centered-square comparisons have been
proved. -/
abbrev varianceProxyNormBound_of_centeredSquareChain_statement
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega n n)
    (V : I -> Matrix (Fin n) (Fin n) Real)
    (sigma2 : Real) : Prop :=
  (forall i,
    @matrixSquare_centeredRandomMatrix_expectation_expansion_statement
      Omega mOmega P _ n (A i)) ->
    (forall i,
      MatrixLE (matrixSecondMoment P (centeredRandomMatrix P (A i))) (V i)) ->
      deterministicMatrixVarianceProxyNorm (Finset.univ.sum fun i => V i) <=
        sigma2 ->
        MatrixVarianceProxyNormBound P (centeredRandomMatrixFamily P A) sigma2

/-- Thin consumer for the centered-square variance-proxy provider chain.

This theorem only applies the explicit provider-chain statement. It does not
prove centered-square expansion, matrix order comparisons, or deterministic
variance-proxy norm control. -/
theorem varianceProxyNormBound_of_centeredSquareChain
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega n n)
    (V : I -> Matrix (Fin n) (Fin n) Real)
    (sigma2 : Real)
    (hChain :
      @varianceProxyNormBound_of_centeredSquareChain_statement
        Omega mOmega P _ I _ n A V sigma2)
    (hExpansion : forall i,
      @matrixSquare_centeredRandomMatrix_expectation_expansion_statement
        Omega mOmega P _ n (A i))
    (hLE : forall i,
      MatrixLE (matrixSecondMoment P (centeredRandomMatrix P (A i))) (V i))
    (hNorm : deterministicMatrixVarianceProxyNorm (Finset.univ.sum fun i => V i) <=
      sigma2) :
    MatrixVarianceProxyNormBound P (centeredRandomMatrixFamily P A) sigma2 :=
  hChain hExpansion hLE hNorm

/-! ## Dimension, support, and effective-rank hardbone statement chain -/

/-- Rank-refined trace-exponential dimension-factor target with an explicit
support certificate.

The current proved ambient-dimension bound uses `(n + 1)` through
`traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le`. This target names the
future replacement where a local rank/support certificate supplies `rankBound`
instead. Without the support comparison, the statement is false for `A = 0`
and `rankBound < n + 1`.
-/
abbrev traceMatrixExp_le_rank_exp_lambdaMax_statement {n : Nat}
    (A support : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (rankBound : Nat) : Prop :=
  0 < rankBound ->
    rankBound <= n + 1 ->
      IsPSDMatrix support ->
        matrixTrace support <= (rankBound : Real) ->
          forall hA : IsSelfAdjointMatrix A,
            MatrixLE (matrixExp A)
              (Real.exp (lambdaMaxOrdered A hA) • support) ->
              traceMatrixExp A <=
                (rankBound : Real) * Real.exp (lambdaMaxOrdered A hA)

/-- Support-dimension trace-exponential target with an explicit local support
certificate.

The support matrix is an explicit certificate parameter for future
projection/support vocabulary. A later core API can replace the explicit
`support` and `supportDim` assumptions with a named support-dimension theorem. -/
abbrev traceMatrixExp_le_supportDim_exp_lambdaMax_statement {n : Nat}
    (A support : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (supportDim : Nat) : Prop :=
  0 < supportDim ->
    supportDim <= n + 1 ->
      IsPSDMatrix support ->
        matrixTrace support <= (supportDim : Real) ->
          forall hA : IsSelfAdjointMatrix A,
            MatrixLE (matrixExp A)
              (Real.exp (lambdaMaxOrdered A hA) • support) ->
              traceMatrixExp A <=
                (supportDim : Real) * Real.exp (lambdaMaxOrdered A hA)

/-- Rank-refined trace-exponential bound from an explicit support certificate.

This consumer proves the typed hardbone target using only the support domination
and trace bound assumptions already present in the statement. It does not
construct the support certificate or prove any rank theorem. -/
theorem traceMatrixExp_le_rank_exp_lambdaMax {n : Nat}
    (A support : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (rankBound : Nat) :
    traceMatrixExp_le_rank_exp_lambdaMax_statement A support rankBound := by
  intro _hRankPos _hRankLe _hSupportPSD hTrace hA hDom
  have hBridge :=
    traceMatrixExp_le_trace_support_exp_lambdaMax_of_matrixExp_le_smul_support
      hA hDom
  exact le_trans hBridge
    (mul_le_mul_of_nonneg_right hTrace
      (Real.exp_nonneg (lambdaMaxOrdered A hA)))

/-- Support-dimension trace-exponential bound from an explicit support
certificate.

This consumer proves the typed hardbone target using only the support domination
and trace bound assumptions already present in the statement. It does not
construct a support projection or prove a support-dimension theorem. -/
theorem traceMatrixExp_le_supportDim_exp_lambdaMax {n : Nat}
    (A support : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (supportDim : Nat) :
    traceMatrixExp_le_supportDim_exp_lambdaMax_statement A support supportDim := by
  intro _hSupportDimPos _hSupportDimLe _hSupportPSD hTrace hA hDom
  have hBridge :=
    traceMatrixExp_le_trace_support_exp_lambdaMax_of_matrixExp_le_smul_support
      hA hDom
  exact le_trans hBridge
    (mul_le_mul_of_nonneg_right hTrace
      (Real.exp_nonneg (lambdaMaxOrdered A hA)))

/-- Effective-rank trace-exponential target for variance-proxy style matrices.

The local assumption `matrixTrace V <= effectiveRank * sigmaSq` records the
usual intrinsic-dimension certificate without introducing a core
effective-rank definition in this statement-atlas phase. The ambient identity
term is explicit because zero eigenvalue directions contribute `exp 0 = 1`. -/
abbrev traceMatrixExp_effectiveRank_bound_statement {n : Nat}
    (V : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (c sigmaSq effectiveRank : Real) : Prop :=
  0 <= c ->
    0 < sigmaSq ->
      0 <= effectiveRank ->
        IsPSDMatrix V ->
          matrixTrace V <= effectiveRank * sigmaSq ->
            forall hV : IsSelfAdjointMatrix V,
              lambdaMaxOrdered V hV <= sigmaSq ->
                traceMatrixExp (c • V) <=
                  ((n + 1 : Nat) : Real) +
                    effectiveRank * (Real.exp (c * sigmaSq) - 1)

/-- Thin consumer for the effective-rank trace-exponential hardbone target.

This only combines the PSD trace-exp minus-identity bridge with the explicit
trace certificate `matrixTrace V <= effectiveRank * sigmaSq`. It does not define
effective rank or prove the trace certificate. -/
theorem traceMatrixExp_effectiveRank_bound {n : Nat}
    (V : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (c sigmaSq effectiveRank : Real) :
    traceMatrixExp_effectiveRank_bound_statement V c sigmaSq effectiveRank := by
  intro hc hsigma _hEffectiveRankNonneg hPSD hTrace hV hSpec
  have hBridge :=
    traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le
      hc hsigma hPSD hV hSpec
  have hTraceDiv : matrixTrace V / sigmaSq <= effectiveRank := by
    have hmul : (matrixTrace V / sigmaSq) * sigmaSq <= effectiveRank * sigmaSq := by
      field_simp [ne_of_gt hsigma]
      simpa [mul_comm] using hTrace
    nlinarith [hmul, hsigma]
  have hExpSubNonneg : 0 <= Real.exp (c * sigmaSq) - 1 := by
    have harg : 0 <= c * sigmaSq := mul_nonneg hc (le_of_lt hsigma)
    exact sub_nonneg.mpr (Real.one_le_exp_iff.mpr harg)
  have hCoeff :
      (matrixTrace V / sigmaSq) * (Real.exp (c * sigmaSq) - 1) <=
        effectiveRank * (Real.exp (c * sigmaSq) - 1) :=
    mul_le_mul_of_nonneg_right hTraceDiv hExpSubNonneg
  exact hBridge.trans (by
    simpa [Nat.cast_add, Nat.cast_one, add_comm, add_left_comm, add_assoc] using
      add_le_add_left hCoeff ((n + 1 : Nat) : Real))

/-- Ambient-cardinality fallback for the effective-rank trace-exponential bound.

This wrapper composes the effective-rank hardbone consumer with the ambient trace
certificate from `matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le`. It fixes
the effective-rank parameter to the ambient cardinality and does not prove a true
effective-rank, support, or rank certificate. -/
theorem traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate {n : Nat}
    (V : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (c sigmaSq : Real)
    (hc : 0 <= c) (hsigma : 0 < sigmaSq)
    (hPSD : IsPSDMatrix V)
    (hV : IsSelfAdjointMatrix V)
    (hSpec : lambdaMaxOrdered V hV <= sigmaSq) :
    traceMatrixExp (c • V) <=
      ((n + 1 : Nat) : Real) +
        ((n + 1 : Nat) : Real) * (Real.exp (c * sigmaSq) - 1) := by
  have hTrace : matrixTrace V <= ((n + 1 : Nat) : Real) * sigmaSq :=
    matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le hPSD hV hSpec
  have hEff : 0 <= ((n + 1 : Nat) : Real) := by
    positivity
  exact
    traceMatrixExp_effectiveRank_bound V c sigmaSq ((n + 1 : Nat) : Real)
      hc hsigma hEff hPSD hTrace hV hSpec

/-! ## Thin consumers of hardbone statement targets -/

/-- Proved scalar Bernstein exponential/quadratic inequality.

This discharges `scalarBernsteinExpQuadraticInequality_statement` directly: it is
no longer a typed-only target but a proved theorem.  The proof is the bounded
scalar Bernstein moment-generating-function bound from
`exp_le_one_add_add_half_sq_div_one_sub_third`, specialized along `u = theta * x`
and `b = |theta| * R`.  It removes the scalar leaf of the Bernstein CFC chain as
a black box; the later theorems in this file discharge the spectrum,
Bernstein-specific CFC order-transfer, expression-normalization, and composed
pointwise CFC leaves. -/
theorem scalarBernsteinExpQuadraticInequality (theta R : Real) :
    scalarBernsteinExpQuadraticInequality_statement theta R := by
  intro x hx _hR hRange
  have hub : |theta * x| ≤ |theta| * R := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_left hx (abs_nonneg theta)
  have hmain :=
    exp_le_one_add_add_half_sq_div_one_sub_third hub hRange
  have hden : (0 : Real) < 1 - |theta| * R / 3 := by linarith
  have hcoeff :
      ((theta * x) ^ 2 / 2) / (1 - |theta| * R / 3) =
        bernsteinMGFCoeff theta R * x ^ 2 := by
    unfold bernsteinMGFCoeff
    field_simp [hden.ne']
  simpa [hcoeff] using hmain

section SpectrumLocalization

open scoped Matrix.Norms.L2Operator

/-- Proved spectrum localization from the deterministic operator-norm bound.

This discharges the spectral-localization leaf used by the Bernstein CFC
hardbone chain.  The zero-dimensional endpoint is handled separately by the
empty spectrum; the nonempty endpoint reuses Mathlib's spectrum norm bound and
the existing `deterministicOperatorNorm` vocabulary. -/
theorem selfAdjointSpectrumBoundedByOperatorNorm {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (R : Real) :
    selfAdjointSpectrumBoundedByOperatorNorm_statement A R := by
  cases n with
  | zero =>
      intro _hA _hBound x hx
      have hEmpty : spectrum Real A = ∅ := spectrum.of_subsingleton A
      rw [hEmpty] at hx
      exact False.elim hx
  | succ n =>
      intro _hA hBound x hx
      have hnorm : ‖x‖ ≤ ‖A‖ := spectrum.norm_le_norm_of_mem hx
      have hdet : |x| ≤ deterministicOperatorNorm A := by
        simpa [Real.norm_eq_abs, deterministicOperatorNorm] using hnorm
      exact hdet.trans hBound

end SpectrumLocalization

/-- Proved Bernstein CFC expression normalization.

This discharges the expression-rewrite leaf in
`bernsteinCFCExpressionNormalization_statement`.  It reuses Mathlib's
continuous functional calculus algebra rules and the existing HighDimProb
`matrixExp`/`matrixSquare` vocabulary; it does not prove scalar-to-matrix order
transfer or the final Bernstein CFC primitive. -/
theorem bernsteinCFCExpressionNormalization {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real) :
    bernsteinCFCExpressionNormalization_statement A theta R := by
  intro hA
  constructor
  · calc
      cfc (fun x : Real => Real.exp (theta * x)) A =
          cfc (Real.exp <| theta * ·) A := rfl
      _ = cfc Real.exp (theta • A) := by
          exact cfc_comp_const_mul theta Real.exp A (ha := hA.isSelfAdjoint)
      _ = matrixExp (theta • A) := by
          simpa [matrixExp] using
            (CFC.real_exp_eq_normedSpace_exp
              (a := theta • A)
              (isSelfAdjointMatrix_smul theta hA).isSelfAdjoint)
  · let c : Real := bernsteinMGFCoeff theta R
    have hlin :
        cfc (fun x : Real => 1 + theta * x) A =
          (1 : Matrix (Fin n) (Fin n) Real) + theta • A := by
      calc
        cfc (fun x : Real => 1 + theta * x) A =
            cfc (fun x : Real => (1 : Real) + theta * x) A := rfl
        _ = (1 : Matrix (Fin n) (Fin n) Real) +
              cfc (fun x : Real => theta * x) A := by
            simpa using
              (cfc_const_add (A := Matrix (Fin n) (Fin n) Real)
                (R := Real) (p := IsSelfAdjoint)
                (a := A) (r := 1) (f := fun x : Real => theta * x)
                (ha := hA.isSelfAdjoint))
        _ = (1 : Matrix (Fin n) (Fin n) Real) + theta • A := by
            rw [cfc_const_mul_id (R := Real) theta A hA.isSelfAdjoint]
    have hsq :
        cfc (fun x : Real => c * x ^ 2) A = c • matrixSquare A := by
      calc
        cfc (fun x : Real => c * x ^ 2) A =
            c • cfc (fun x : Real => x ^ 2) A := by
              simpa using
                (cfc_const_mul (A := Matrix (Fin n) (Fin n) Real)
                  (R := Real) (p := IsSelfAdjoint)
                  (a := A) (r := c) (f := fun x : Real => x ^ 2))
        _ = c • matrixSquare A := by
            rw [cfc_pow_id (R := Real) A 2 hA.isSelfAdjoint]
            simp [matrixSquare, pow_two]
    change
      cfc (fun x : Real => 1 + theta * x + c * x ^ 2) A =
        (1 : Matrix (Fin n) (Fin n) Real) + theta • A +
          c • matrixSquare A
    calc
      cfc (fun x : Real => 1 + theta * x + c * x ^ 2) A =
          cfc (fun x : Real => (1 + theta * x) + c * x ^ 2) A := rfl
      _ = cfc (fun x : Real => 1 + theta * x) A +
            cfc (fun x : Real => c * x ^ 2) A := by
          exact cfc_add A
            (fun x : Real => 1 + theta * x)
            (fun x : Real => c * x ^ 2)
      _ = (1 : Matrix (Fin n) (Fin n) Real) + theta • A +
            c • matrixSquare A := by
          rw [hlin, hsq]

/-- Bernstein-specific CFC order transfer.

The generic `cfcScalarInequalityToMatrixLE_statement` deliberately remains a
typed contract for arbitrary functions, since arbitrary `f` and `g` need
continuity hypotheses before Mathlib's `cfc_mono` applies.  This theorem proves
the concrete Bernstein exponential/quadratic instance, whose functions are
continuous. -/
theorem cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real) :
    cfcScalarInequalityToMatrixLE_statement
      (fun x : Real => Real.exp (theta * x))
      (fun x : Real =>
        1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2)
      A := by
  intro _hA hfg
  unfold MatrixLE
  have hle :
      cfc (fun x : Real => Real.exp (theta * x)) A <=
        cfc
          (fun x : Real =>
            1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2) A := by
    exact cfc_mono (a := A) hfg
  have hPSD :
      (cfc
          (fun x : Real =>
            1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2) A -
        cfc (fun x : Real => Real.exp (theta * x)) A).PosSemidef :=
    Matrix.le_iff.mp hle
  constructor
  · apply Matrix.IsSymm.ext
    intro i j
    have h := Matrix.IsHermitian.apply hPSD.isHermitian i j
    simpa using h
  · intro x
    exact matrixQuadraticForm_nonneg_of_posSemidef hPSD x

/-- Compose the four Bernstein CFC leaves into the pointwise matrix
exponential/quadratic primitive.

This theorem is the reusable proof skeleton behind the CFC hardbone route:
localize the spectrum by the operator-norm bound, apply the scalar Bernstein
inequality on that spectrum, transfer the scalar CFC order to matrix order, and
rewrite the CFC expressions back to `matrixExp` and `matrixSquare`. -/
theorem bernsteinMatrixExp_le_quadratic_of_cfcLeaves {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hScalar : scalarBernsteinExpQuadraticInequality_statement theta R)
    (hSpectrum : selfAdjointSpectrumBoundedByOperatorNorm_statement A R)
    (hCFC :
      cfcScalarInequalityToMatrixLE_statement
        (fun x : Real => Real.exp (theta * x))
        (fun x : Real =>
          1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2)
        A)
    (hNormalize : bernsteinCFCExpressionNormalization_statement A theta R) :
    bernsteinMatrixExp_le_quadratic_statement A theta R := by
  intro hA hBound hR hRange
  have hSpectrumBound :
      forall x : Real, x ∈ spectrum Real A -> |x| <= R :=
    hSpectrum hA hBound
  have hScalarOnSpectrum :
      forall x : Real, x ∈ spectrum Real A ->
        Real.exp (theta * x) <=
          1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2 := by
    intro x hx
    exact hScalar x (hSpectrumBound x hx) hR hRange
  have hOrder :=
    hCFC hA hScalarOnSpectrum
  rcases hNormalize hA with ⟨hExp, hQuad⟩
  simpa [hExp, hQuad] using hOrder

/-- Proved Bernstein-specific matrix exponential/quadratic CFC primitive.

This discharges the local Bernstein CFC hardbone chain by reusing the proved
scalar Bernstein inequality, spectrum localization, Bernstein-specific CFC
order transfer, and CFC expression normalization. It does not prove Tropp/Lieb,
Golden-Thompson, trace-MGF iteration, variance-proxy control, or any full
Matrix Bernstein tail theorem. -/
theorem bernsteinMatrixExp_le_quadratic {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real) :
    bernsteinMatrixExp_le_quadratic_statement A theta R :=
  bernsteinMatrixExp_le_quadratic_of_cfcLeaves A theta R
    (scalarBernsteinExpQuadraticInequality theta R)
    (selfAdjointSpectrumBoundedByOperatorNorm A R)
    (cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic A theta R)
    (bernsteinCFCExpressionNormalization A theta R)

/-- Thin consumer for the Bernstein CFC hardbone chain.

The scalar Bernstein leaf can now be supplied by
`scalarBernsteinExpQuadraticInequality`. This consumer still keeps the
remaining spectrum/localization, CFC order-transfer, and expression
normalization assumptions explicit. -/
theorem bernsteinMatrixExp_le_quadratic_of_cfcChain {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hChain : bernsteinMatrixExp_le_quadratic_of_cfcChain_statement A theta R)
    (hScalar : scalarBernsteinExpQuadraticInequality_statement theta R)
    (hSpectrum : selfAdjointSpectrumBoundedByOperatorNorm_statement A R)
    (hCFC :
      cfcScalarInequalityToMatrixLE_statement
        (fun x : Real => Real.exp (theta * x))
        (fun x : Real =>
          1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2)
        A)
    (hNormalize : bernsteinCFCExpressionNormalization_statement A theta R) :
    bernsteinMatrixExp_le_quadratic_statement A theta R :=
  hChain hScalar hSpectrum hCFC hNormalize

/-- Thin consumer for the Bernstein CFC hardbone chain with proved scalar and
expression-normalization leaves supplied by core API.

The remaining assumptions are exactly the current chain statement, spectral
localization, and scalar-to-matrix CFC order transfer. -/
theorem bernsteinMatrixExp_le_quadratic_of_spectrum_cfcOrder {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hChain : bernsteinMatrixExp_le_quadratic_of_cfcChain_statement A theta R)
    (hSpectrum : selfAdjointSpectrumBoundedByOperatorNorm_statement A R)
    (hCFC :
      cfcScalarInequalityToMatrixLE_statement
        (fun x : Real => Real.exp (theta * x))
        (fun x : Real =>
          1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2)
        A) :
    bernsteinMatrixExp_le_quadratic_statement A theta R :=
  hChain (scalarBernsteinExpQuadraticInequality theta R) hSpectrum hCFC
    (bernsteinCFCExpressionNormalization A theta R)

/-- Thin consumer for the Bernstein CFC hardbone chain with the proved scalar,
Bernstein-specific CFC order-transfer, and expression-normalization leaves
supplied by core API.

The only remaining mathematical input to the chain is spectral localization
from the operator-norm bound, plus the chain statement itself. -/
theorem bernsteinMatrixExp_le_quadratic_of_cfcChain_spectrum {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hChain : bernsteinMatrixExp_le_quadratic_of_cfcChain_statement A theta R)
    (hSpectrum : selfAdjointSpectrumBoundedByOperatorNorm_statement A R) :
    bernsteinMatrixExp_le_quadratic_statement A theta R :=
  hChain (scalarBernsteinExpQuadraticInequality theta R) hSpectrum
    (cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic A theta R)
    (bernsteinCFCExpressionNormalization A theta R)

/-- Thin bridge from a log-monotonicity premise and the matrix-exp log-domain
premise to the direct `log M <= K` comparison.

This theorem only composes explicit assumptions from the log/order-to-`K`
chain. It does not prove operator-log monotonicity, strict positivity of
`matrixExp K`, trace-exp monotonicity, Tropp/Lieb, Golden-Thompson,
integrability propagation, variance-proxy control, or full Matrix
Bernstein. -/
theorem matrixLog_le_of_le_matrixExp {n : Nat}
    (M K : Matrix (Fin n) (Fin n) Real) :
    matrixLog_le_of_le_matrixExp_statement M K := by
  intro hLog hDomain hM hMpos hK hMK
  rcases hDomain hK with ⟨hExpSA, hExpPos, hLogExp⟩
  have hLE : MatrixLE (CFC.log M) (CFC.log (matrixExp K)) :=
    hLog hM hMpos hExpSA hExpPos hMK
  rw [hLogExp] at hLE
  exact hLE

/-- Thin consumer for the log/order-to-`K` hardbone chain.

This theorem only composes the Phase 2 log-order and trace-exp monotonicity
targets into the existing Tropp log/`K` comparison target. -/
theorem troppLogExpComparisonToK_of_logMonotone_traceExpMono {n : Nat}
    (H M K : Matrix (Fin n) (Fin n) Real)
    (hChain : troppLogExpComparisonToK_of_logOrderKChain_statement H M K)
    (hLog : matrixLog_le_of_le_matrixExp_statement M K)
    (hTrace : traceMatrixExp_mono_add_selfAdjoint_statement H (CFC.log M) K) :
    troppLogExpComparisonToK_statement H M K :=
  hChain hLog hTrace

/-- Matrix-log normalization for self-adjoint exponentials.

This is a local CFC normalization leaf.  It does not prove Lieb concavity,
Jensen, Golden-Thompson, conditioning, integrability propagation, variance
proxy control, or full Matrix Bernstein. -/
theorem matrixExpLogSelfAdjointNormalization {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) :
    matrixExpLogSelfAdjointNormalization_statement A := by
  intro hA
  simpa [matrixExp] using (CFC.log_exp (a := A) hA.isSelfAdjoint)

/-- Thin consumer for the Tropp/Lieb/Jensen one-step hardbone chain.

This theorem does not prove Lieb concavity, Jensen, or log-exp normalization;
it only applies the typed Phase 3 chain target. -/
theorem troppMasterTraceMGFStep_of_liebJensen {Omega : Type*}
    [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    [MeasureTheory.IsProbabilityMeasure P] {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n)
    (hChain : troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Z)
    (hJensen :
      liebJensenTraceExp_statement (P := P) H
        (fun omega => matrixExp (Z omega)))
    (hNormalize :
      forall omega, matrixExpLogSelfAdjointNormalization_statement (Z omega)) :
    troppMasterTraceMGFStep_statement (P := P) H Z :=
  hChain hJensen hNormalize

/-- Thin consumer for the Phase 4 conditioning bridge.

The conclusion is one indexed conditional-step target. The proof only applies
the typed Phase 4 chain to explicit history, independence, conditional
expectation, and finite-family independence inputs. -/
theorem troppMasterTraceMGFConditionalStep_of_conditioningBridge
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (mHist : Fin m -> MeasurableSpace Omega)
    (hChain :
      @troppConditionalStep_of_iIndepFun_statement Omega mOmega P m n
        theta X K mHist)
    (hHist :
      @troppNaturalHistoryMeasurable_statement Omega mOmega m n
        theta X K mHist)
    (hHistIndep :
      @troppHistoryStepIndependent_of_iIndepFun_statement Omega mOmega P m n
        theta X K)
    (hCondExp :
      forall i,
        @condExp_traceExp_history_add_independent_step_statement
          Omega mOmega P n
          (mHist i) (@troppStateHistory Omega mOmega m n theta X K i)
          (@troppCurrentRandomStep Omega mOmega m n theta X i) (K i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (i : Fin m) :
    @troppMasterTraceMGFConditionalStep_statement Omega mOmega P n
      (mHist i) (@troppStateHistory Omega mOmega m n theta X K i)
      (@troppCurrentRandomStep Omega mOmega m n theta X i) (K i) :=
  hChain hHist hHistIndep hCondExp hIndep i

end

end HighDimProb
