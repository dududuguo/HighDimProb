import HighDimProb.RandomMatrix.CFCLogDerivativeProvider
import HighDimProb.RandomMatrix.LogResolventProvider
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Analysis.Normed.Algebra.Exponential
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.Tactic

/-!
# Relative-entropy provider layer

This module exposes the stable finite-dimensional relative-entropy/Klein API
ported from the provider-facing Lieb route: scalar and diagonal nonnegativity,
diagonal-matrix and same-basis `CFC.log` bookkeeping, common-eigenbasis and
overlap-weight spectral expansions, and the full finite-dimensional real matrix
Klein theorem under Hermitian strictly-positive hypotheses. It does not prove
relative-entropy joint convexity, Epstein, or Lieb.
-/

namespace HighDimProb

open scoped BigOperators MatrixOrder Matrix.Norms.L2Operator Matrix.Norms.Operator

noncomputable section

namespace RelativeEntropy

/-- Scalar unnormalized relative-entropy integrand `x log (x / y) - x + y`. -/
noncomputable def scalarTerm (x y : Real) : Real :=
  x * Real.log (x / y) - x + y

/-- Diagonal/spectral-data version of the unnormalized relative entropy. -/
noncomputable def diagonalTerm {n : Nat} (t s : Fin n -> Real) : Real :=
  Finset.univ.sum (fun i => scalarTerm (t i) (s i))

private theorem trace_diagonal_mul_diagonal {n : Nat} (a b : Fin n -> Real) :
    Matrix.trace (Matrix.diagonal a * Matrix.diagonal b) =
      Finset.univ.sum (fun i => a i * b i) := by
  simp [Matrix.trace, Matrix.mul_apply, Matrix.diagonal]

/-- Diagonal matrix trace-log form of the unnormalized relative entropy.

This is still a diagonal/same-basis object: the logarithms are scalar logs on
the diagonal entries, not a general `CFC.log` matrix theorem. -/
noncomputable def diagonalMatrixTerm {n : Nat} (t s : Fin n -> Real) : Real :=
  Matrix.trace (Matrix.diagonal t * Matrix.diagonal (fun i => Real.log (t i))) -
    Matrix.trace (Matrix.diagonal t * Matrix.diagonal (fun i => Real.log (s i))) -
    Matrix.trace (Matrix.diagonal t) + Matrix.trace (Matrix.diagonal s)

/-- Scalar Klein inequality for the unnormalized relative-entropy integrand. -/
theorem scalarTerm_nonneg {x y : Real} (hx : 0 < x) (hy : 0 < y) :
    0 <= scalarTerm x y := by
  dsimp [scalarTerm]
  have hz : 0 < x / y := by
    positivity
  have hlog0 : 1 - Inv.inv (x / y) <= Real.log (x / y) :=
    Real.one_sub_inv_le_log_of_pos hz
  have hx_ne : Ne x 0 := ne_of_gt hx
  have hy_ne : Ne y 0 := ne_of_gt hy
  have hinv : Inv.inv (x / y) = y / x := by
    field_simp [hx_ne, hy_ne]
  have hlog : 1 - y / x <= Real.log (x / y) := by
    simpa [hinv] using hlog0
  have hmul : x * (1 - y / x) <= x * Real.log (x / y) := by
    exact mul_le_mul_of_nonneg_left hlog (le_of_lt hx)
  have hleft : x * (1 - y / x) = x - y := by
    field_simp [hx_ne]
  linarith

/-- Diagonal Klein inequality on explicit positive scalar spectral data. -/
theorem diagonalTerm_nonneg {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <= diagonalTerm t s := by
  dsimp [diagonalTerm]
  refine Finset.sum_nonneg ?_
  intro i _hi
  exact scalarTerm_nonneg (ht i) (hs i)

/-- Expand the diagonal matrix trace-log term into the corresponding separated
finite scalar sum. This is the reusable same-basis bookkeeping layer; it still
uses scalar diagonal logs, not `CFC.log`. -/
theorem diagonalMatrixTerm_eq_sum {n : Nat} (t s : Fin n -> Real) :
    diagonalMatrixTerm t s =
      Finset.univ.sum (fun i =>
        t i * Real.log (t i) - t i * Real.log (s i) - t i + s i) := by
  dsimp [diagonalMatrixTerm]
  rw [trace_diagonal_mul_diagonal, trace_diagonal_mul_diagonal,
    Matrix.trace_diagonal, Matrix.trace_diagonal]
  symm
  simp_rw [sub_eq_add_neg]
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib, Finset.sum_add_distrib]
  rw [Finset.sum_neg_distrib, Finset.sum_neg_distrib]

/-- The scalar diagonal relative-entropy sum is exactly its diagonal matrix
trace-log form. This is a bookkeeping bridge toward same-eigenbasis Klein
normal forms, not a full matrix Klein theorem. -/
theorem diagonalTerm_eq_diagonalMatrixTerm {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    diagonalTerm t s = diagonalMatrixTerm t s := by
  rw [diagonalMatrixTerm_eq_sum]
  dsimp [diagonalTerm, scalarTerm]
  refine Finset.sum_congr rfl ?_
  intro i _hi
  rw [Real.log_div (ne_of_gt (ht i)) (ne_of_gt (hs i))]
  ring

/-- Nonnegativity of the diagonal matrix trace-log Klein expression. -/
theorem diagonalMatrixTerm_nonneg {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <= diagonalMatrixTerm t s := by
  rw [<- diagonalTerm_eq_diagonalMatrixTerm t s ht hs]
  exact diagonalTerm_nonneg t s ht hs

private def diagonalSelfAdjoint {n : Nat} (d : Fin n -> Real) :
    selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
  Subtype.mk (Matrix.diagonal d) (Matrix.isHermitian_diagonal d)

/-- On a positive diagonal matrix, `CFC.log` is the diagonal matrix of scalar
logs. This is a same-basis finite-dimensional bridge only. -/
theorem cfcLog_diagonal_eq_diagonal_log_of_pos {n : Nat}
    (s : Fin n -> Real) (hs : forall i, 0 < s i) :
    CFC.log (Matrix.diagonal s) = Matrix.diagonal (fun i => Real.log (s i)) := by
  let L : selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
    diagonalSelfAdjoint (fun i => Real.log (s i))
  have hExpDiag :
      NormedSpace.exp (Matrix.diagonal (fun i => Real.log (s i))) =
        Matrix.diagonal (fun i => NormedSpace.exp (Real.log (s i))) := by
    simpa [Pi.exp_def] using (Matrix.exp_diagonal (fun i => Real.log (s i)))
  have hExpMatrix :
      (matrixExpSelfAdjoint L : Matrix (Fin n) (Fin n) Real) = Matrix.diagonal s := by
    calc
      (matrixExpSelfAdjoint L : Matrix (Fin n) (Fin n) Real)
          = NormedSpace.exp (Matrix.diagonal (fun i => Real.log (s i))) := by
              rfl
      _ = Matrix.diagonal (fun i => NormedSpace.exp (Real.log (s i))) := hExpDiag
      _ = Matrix.diagonal s := by
            apply congrArg Matrix.diagonal
            funext i
            rw [<- Real.exp_eq_exp_ℝ]
            exact Real.exp_log (hs i)
  have hExp : matrixExpSelfAdjoint L = diagonalSelfAdjoint s := by
    apply Subtype.ext
    simpa [diagonalSelfAdjoint] using hExpMatrix
  have hLog : cfcLogSelfAdjoint (matrixExpSelfAdjoint L) = L :=
    cfcLogSelfAdjoint_matrixExpSelfAdjoint_eq L
  rw [hExp] at hLog
  have hLogMatrix :
      (cfcLogSelfAdjoint (diagonalSelfAdjoint s) : Matrix (Fin n) (Fin n) Real) =
        Matrix.diagonal (fun i => Real.log (s i)) := by
    simpa [L, diagonalSelfAdjoint] using
      congrArg
        (fun X : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
          (X : Matrix (Fin n) (Fin n) Real))
        hLog
  simpa [diagonalSelfAdjoint, cfcLogSelfAdjoint] using hLogMatrix

/-- Same-basis weighted trace-log bridge for positive diagonal matrices. -/
theorem trace_diagonal_mul_cfcLog_diagonal_eq_sum {n : Nat}
    (t s : Fin n -> Real) (hs : forall i, 0 < s i) :
    Matrix.trace (Matrix.diagonal t * CFC.log (Matrix.diagonal s)) =
      Finset.univ.sum (fun i => t i * Real.log (s i)) := by
  rw [cfcLog_diagonal_eq_diagonal_log_of_pos s hs, trace_diagonal_mul_diagonal]

/-- The diagonal `CFC.log` Klein expression is exactly the existing diagonal
relative-entropy trace-log term. -/
theorem diagonalMatrixTerm_cfcLog_eq {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    Matrix.trace (Matrix.diagonal t * CFC.log (Matrix.diagonal t)) -
        Matrix.trace (Matrix.diagonal t * CFC.log (Matrix.diagonal s)) -
        Matrix.trace (Matrix.diagonal t) + Matrix.trace (Matrix.diagonal s) =
      diagonalMatrixTerm t s := by
  rw [cfcLog_diagonal_eq_diagonal_log_of_pos t ht,
    cfcLog_diagonal_eq_diagonal_log_of_pos s hs]
  rfl

/-- Same-basis diagonal Klein MVP restated with `CFC.log`. -/
theorem diagonalMatrixTerm_cfcLog_nonneg {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <=
      Matrix.trace (Matrix.diagonal t * CFC.log (Matrix.diagonal t)) -
        Matrix.trace (Matrix.diagonal t * CFC.log (Matrix.diagonal s)) -
        Matrix.trace (Matrix.diagonal t) + Matrix.trace (Matrix.diagonal s) := by
  rw [diagonalMatrixTerm_cfcLog_eq t s ht hs]
  exact diagonalMatrixTerm_nonneg t s ht hs

/-- The diagonal weight contributed by `B` after conjugating into an eigenbasis
of the Hermitian matrix `A`. -/
def commonEigenbasisWeight {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (B : Matrix (Fin n) (Fin n) Real) (i : Fin n) : Real :=
  ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
        (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i)

/-- Expand `trace (B * log A)` as a scalar sum in a common eigenbasis of the
Hermitian matrix `A`. This is the conjugated common-eigenbasis bridge needed by
the relative-entropy roadmap; it is not yet the full two-basis Klein theorem. -/
theorem trace_mul_cfcLog_eq_sum_conj_diag_of_isHermitian
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real} (hA : A.IsHermitian) :
    Matrix.trace (B * CFC.log A) =
      Finset.univ.sum (fun i =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i) *
          Real.log (hA.eigenvalues i)) := by
  simpa [CFC.log] using
    trace_mul_cfc_eq_sum_conj_diag_of_isHermitian (M := A) (B := B) hA Real.log

/-- The same common-eigenbasis trace-log bridge stated using
`commonEigenbasisWeight` to name the conjugated diagonal weights. -/
theorem trace_mul_cfcLog_eq_sum_commonEigenbasisWeight_of_isHermitian
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real} (hA : A.IsHermitian) :
    Matrix.trace (B * CFC.log A) =
      Finset.univ.sum (fun i =>
        commonEigenbasisWeight hA B i * Real.log (hA.eigenvalues i)) := by
  simpa [commonEigenbasisWeight] using
    trace_mul_cfcLog_eq_sum_conj_diag_of_isHermitian (A := A) (B := B) hA

/-- Squared overlap coefficient between the `j`-th eigenvector of `T` and the
`i`-th eigenvector of `S`. In the real Hermitian setting this is a nonnegative
scalar weight. -/
def overlapWeight {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) (i j : Fin n) : Real :=
  ((star (hT.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) *
        (hS.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) j i) ^ 2

theorem overlapWeight_nonneg {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) (i j : Fin n) :
    0 <= overlapWeight hT hS i j := by
  dsimp [overlapWeight]
  positivity

theorem commonEigenbasisWeight_self_eq_eigenvalue {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : A.IsHermitian) (i : Fin n) :
    commonEigenbasisWeight hA A i = hA.eigenvalues i := by
  simpa [commonEigenbasisWeight] using
    congrFun (congrFun hA.conjStarAlgAut_star_eigenvectorUnitary i) i

theorem commonEigenbasisWeight_pos_of_isHermitian_of_isStrictlyPositive
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hBpos : IsStrictlyPositive B) (i : Fin n) :
    0 < commonEigenbasisWeight hA B i := by
  let U : Matrix (Fin n) (Fin n) Real := hA.eigenvectorUnitary
  let C : Matrix (Fin n) (Fin n) Real := star U * B * U
  have hBpd : B.PosDef := Matrix.isStrictlyPositive_iff_posDef.mp hBpos
  have hUunit : IsUnit U := by
    simpa [U] using (Unitary.isUnit_coe (U := hA.eigenvectorUnitary))
  have hCpd : C.PosDef := by
    exact (Matrix.IsUnit.posDef_star_left_conjugate_iff (x := B) (U := U) hUunit).2 hBpd
  simpa [commonEigenbasisWeight, C, U] using (Matrix.PosDef.diag_pos hCpd (i := i))

private theorem eigenvalues_pos_of_isHermitian_of_isStrictlyPositive {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A) :
    forall i, 0 < hA.eigenvalues i := by
  exact hA.posDef_iff_eigenvalues_pos.mp (Matrix.isStrictlyPositive_iff_posDef.mp hPos)

/-- Explicit weighted scalar Klein inequality on two Hermitian eigenvalue lists.
This is the verified two-basis MVP: it proves the weighted scalar sum that the
full matrix Klein theorem reduces to once the overlap expansion and row/column
sum bridges are packaged. -/
theorem weightedSpectralKlein_nonneg {n : Nat}
    {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian)
    (hTpos : IsStrictlyPositive T) (hSpos : IsStrictlyPositive S) :
    0 <=
      Finset.univ.sum (fun i =>
        Finset.univ.sum (fun j =>
          overlapWeight hT hS i j *
            (hT.eigenvalues j * Real.log (hT.eigenvalues j / hS.eigenvalues i) -
              hT.eigenvalues j + hS.eigenvalues i))) := by
  have hTeigPos := eigenvalues_pos_of_isHermitian_of_isStrictlyPositive hT hTpos
  have hSeigPos := eigenvalues_pos_of_isHermitian_of_isStrictlyPositive hS hSpos
  refine Finset.sum_nonneg ?_
  intro i _hi
  refine Finset.sum_nonneg ?_
  intro j _hj
  exact mul_nonneg
    (overlapWeight_nonneg hT hS i j)
    (scalarTerm_nonneg (hTeigPos j) (hSeigPos i))

theorem overlapWeight_sum_right
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) (i : Fin n) :
    Finset.univ.sum (fun j => overlapWeight hT hS i j) = 1 := by
  let U : Matrix.unitaryGroup (Fin n) Real := star hT.eigenvectorUnitary * hS.eigenvectorUnitary
  have hU : (star (U : Matrix (Fin n) (Fin n) Real) * (U : Matrix (Fin n) (Fin n) Real)) i i = 1 := by
    simpa [U] using congrFun (congrFun U.2.1 i) i
  simpa [U, overlapWeight, Matrix.mul_apply, Matrix.star_apply, pow_two, mul_comm, mul_left_comm,
    mul_assoc] using hU

theorem overlapWeight_sum_left
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) (j : Fin n) :
    Finset.univ.sum (fun i => overlapWeight hT hS i j) = 1 := by
  let U : Matrix.unitaryGroup (Fin n) Real := star hT.eigenvectorUnitary * hS.eigenvectorUnitary
  have hU :
      (((U : Matrix.unitaryGroup (Fin n) Real) : Matrix (Fin n) (Fin n) Real) *
        star (((U : Matrix.unitaryGroup (Fin n) Real) : Matrix (Fin n) (Fin n) Real))) j j = 1 := by
    simp
  simpa [U, overlapWeight, Matrix.mul_apply, Matrix.star_apply, pow_two, mul_comm, mul_left_comm,
    mul_assoc] using hU

/-- Rewrite a common-eigenbasis weight for `T` in an eigenbasis of `S` as a
weighted sum over the overlap coefficients between the eigenbases of `T` and
`S`. -/
theorem commonEigenbasisWeight_eq_sum_overlapWeight_mul_eigenvalues
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) (i : Fin n) :
    commonEigenbasisWeight hS T i =
      Finset.univ.sum (fun j => overlapWeight hT hS i j * hT.eigenvalues j) := by
  let UT : Matrix (Fin n) (Fin n) Real := hT.eigenvectorUnitary
  let US : Matrix (Fin n) (Fin n) Real := hS.eigenvectorUnitary
  let U : Matrix.unitaryGroup (Fin n) Real := star hT.eigenvectorUnitary * hS.eigenvectorUnitary
  let Um : Matrix (Fin n) (Fin n) Real := U
  have hspec : T = UT * Matrix.diagonal hT.eigenvalues * star UT := by
    simpa [UT, Unitary.conjStarAlgAut_apply] using hT.spectral_theorem
  calc
    commonEigenbasisWeight hS T i
      = ((star Um * Matrix.diagonal hT.eigenvalues * Um) i i) := by
          have hrew := congrArg
            (fun M : Matrix (Fin n) (Fin n) Real => ((star US * M * US) i i)) hspec
          simpa [commonEigenbasisWeight, UT, US, U, Um, Matrix.mul_assoc]
            using hrew
    _ = Finset.univ.sum (fun j => overlapWeight hT hS i j * hT.eigenvalues j) := by
          rw [Matrix.mul_apply]
          refine Finset.sum_congr rfl ?_
          intro j _hj
          rw [Matrix.mul_diagonal, Matrix.star_apply]
          simp [overlapWeight, U, Um, pow_two]
          ring

/-- Trace of a real Hermitian matrix as the sum of its eigenvalues. -/
theorem trace_eq_sum_eigenvalues_of_isHermitian
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real} (hA : A.IsHermitian) :
    Matrix.trace A = Finset.univ.sum (fun i => hA.eigenvalues i) := by
  calc
    Matrix.trace A = Matrix.trace (cfc id A) := by
      rw [cfc_id Real A hA.isSelfAdjoint]
    _ = Finset.univ.sum (fun i => hA.eigenvalues i) := by
      simpa using (trace_cfc_eq_sum_of_isHermitian hA id)

private theorem trace_eq_sum_overlapWeight_mul_self_eigenvalues
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) :
    Matrix.trace T =
      Finset.univ.sum (fun i =>
        Finset.univ.sum (fun j => overlapWeight hT hS i j * hT.eigenvalues j)) := by
  calc
    Matrix.trace T = Finset.univ.sum (fun j => hT.eigenvalues j) :=
      trace_eq_sum_eigenvalues_of_isHermitian hT
    _ = Finset.univ.sum (fun j =>
          (Finset.univ.sum (fun i => overlapWeight hT hS i j)) * hT.eigenvalues j) := by
      refine Finset.sum_congr rfl ?_
      intro j _hj
      rw [overlapWeight_sum_left hT hS j, one_mul]
    _ = Finset.univ.sum (fun j =>
          Finset.univ.sum (fun i => overlapWeight hT hS i j * hT.eigenvalues j)) := by
      refine Finset.sum_congr rfl ?_
      intro j _hj
      rw [Finset.sum_mul]
    _ = Finset.univ.sum (fun i =>
          Finset.univ.sum (fun j => overlapWeight hT hS i j * hT.eigenvalues j)) := by
      rw [Finset.sum_comm]

private theorem trace_eq_sum_overlapWeight_mul_other_eigenvalues
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) :
    Matrix.trace S =
      Finset.univ.sum (fun i =>
        Finset.univ.sum (fun j => overlapWeight hT hS i j * hS.eigenvalues i)) := by
  calc
    Matrix.trace S = Finset.univ.sum (fun i => hS.eigenvalues i) :=
      trace_eq_sum_eigenvalues_of_isHermitian hS
    _ = Finset.univ.sum (fun i =>
          (Finset.univ.sum (fun j => overlapWeight hT hS i j)) * hS.eigenvalues i) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [overlapWeight_sum_right hT hS i, one_mul]
    _ = Finset.univ.sum (fun i =>
          Finset.univ.sum (fun j => overlapWeight hT hS i j * hS.eigenvalues i)) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [Finset.sum_mul]

private theorem trace_mul_cfcLog_self_eq_sum_overlapWeight_mul_eigenvalues_log
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) :
    Matrix.trace (T * CFC.log T) =
      Finset.univ.sum (fun i =>
        Finset.univ.sum (fun j =>
          overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hT.eigenvalues j)))) := by
  calc
    Matrix.trace (T * CFC.log T)
      = Finset.univ.sum (fun j =>
          commonEigenbasisWeight hT T j * Real.log (hT.eigenvalues j)) := by
      simpa using
        (trace_mul_cfcLog_eq_sum_commonEigenbasisWeight_of_isHermitian (A := T) (B := T) hT)
    _ = Finset.univ.sum (fun j => hT.eigenvalues j * Real.log (hT.eigenvalues j)) := by
      refine Finset.sum_congr rfl ?_
      intro j _hj
      rw [commonEigenbasisWeight_self_eq_eigenvalue hT j]
    _ = Finset.univ.sum (fun j =>
          (Finset.univ.sum (fun i => overlapWeight hT hS i j)) *
            (hT.eigenvalues j * Real.log (hT.eigenvalues j))) := by
      refine Finset.sum_congr rfl ?_
      intro j _hj
      rw [overlapWeight_sum_left hT hS j, one_mul]
    _ = Finset.univ.sum (fun j =>
          Finset.univ.sum (fun i =>
            overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hT.eigenvalues j)))) := by
      refine Finset.sum_congr rfl ?_
      intro j _hj
      rw [Finset.sum_mul]
    _ = Finset.univ.sum (fun i =>
          Finset.univ.sum (fun j =>
            overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hT.eigenvalues j)))) := by
      rw [Finset.sum_comm]

private theorem trace_mul_cfcLog_cross_eq_sum_overlapWeight_mul_eigenvalues_log
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian) :
    Matrix.trace (T * CFC.log S) =
      Finset.univ.sum (fun i =>
        Finset.univ.sum (fun j =>
          overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hS.eigenvalues i)))) := by
  calc
    Matrix.trace (T * CFC.log S)
      = Finset.univ.sum (fun i =>
          commonEigenbasisWeight hS T i * Real.log (hS.eigenvalues i)) := by
      simpa using
        (trace_mul_cfcLog_eq_sum_commonEigenbasisWeight_of_isHermitian (A := S) (B := T) hS)
    _ = Finset.univ.sum (fun i =>
          (Finset.univ.sum (fun j => overlapWeight hT hS i j * hT.eigenvalues j)) *
            Real.log (hS.eigenvalues i)) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [commonEigenbasisWeight_eq_sum_overlapWeight_mul_eigenvalues hT hS i]
    _ = Finset.univ.sum (fun i =>
          Finset.univ.sum (fun j =>
            (overlapWeight hT hS i j * hT.eigenvalues j) * Real.log (hS.eigenvalues i))) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [Finset.sum_mul]
    _ = Finset.univ.sum (fun i =>
          Finset.univ.sum (fun j =>
            overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hS.eigenvalues i)))) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      refine Finset.sum_congr rfl ?_
      intro j _hj
      ring

/-- Expand the full trace-level relative-entropy expression into the weighted
spectral double sum consumed by `weightedSpectralKlein_nonneg`. -/
theorem fullMatrixKlein_eq_weightedSpectralSum_of_isHermitian_of_strictlyPositive
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian)
    (hTpos : IsStrictlyPositive T) (hSpos : IsStrictlyPositive S) :
    Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log S) - Matrix.trace T + Matrix.trace S =
      Finset.univ.sum (fun i =>
        Finset.univ.sum (fun j =>
          overlapWeight hT hS i j *
            (hT.eigenvalues j * Real.log (hT.eigenvalues j / hS.eigenvalues i) -
              hT.eigenvalues j + hS.eigenvalues i))) := by
  have hTeigPos := eigenvalues_pos_of_isHermitian_of_isStrictlyPositive hT hTpos
  have hSeigPos := eigenvalues_pos_of_isHermitian_of_isStrictlyPositive hS hSpos
  rw [trace_mul_cfcLog_self_eq_sum_overlapWeight_mul_eigenvalues_log hT hS,
    trace_mul_cfcLog_cross_eq_sum_overlapWeight_mul_eigenvalues_log hT hS,
    trace_eq_sum_overlapWeight_mul_self_eigenvalues hT hS,
    trace_eq_sum_overlapWeight_mul_other_eigenvalues hT hS]
  symm
  calc
    Finset.univ.sum (fun i =>
      Finset.univ.sum (fun j =>
        overlapWeight hT hS i j *
          (hT.eigenvalues j * Real.log (hT.eigenvalues j / hS.eigenvalues i) -
            hT.eigenvalues j + hS.eigenvalues i)))
      = Finset.univ.sum (fun i =>
          Finset.univ.sum (fun j =>
            overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hT.eigenvalues j)) +
              -(overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hS.eigenvalues i))) +
              -(overlapWeight hT hS i j * hT.eigenvalues j) +
              overlapWeight hT hS i j * hS.eigenvalues i)) := by
        refine Finset.sum_congr rfl ?_
        intro i _hi
        refine Finset.sum_congr rfl ?_
        intro j _hj
        rw [Real.log_div (ne_of_gt (hTeigPos j)) (ne_of_gt (hSeigPos i))]
        ring
    _ = Finset.univ.sum (fun i =>
          Finset.univ.sum (fun j => overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hT.eigenvalues j)))) +
          -(Finset.univ.sum (fun i =>
            Finset.univ.sum (fun j => overlapWeight hT hS i j * (hT.eigenvalues j * Real.log (hS.eigenvalues i))))) +
          -(Finset.univ.sum (fun i =>
            Finset.univ.sum (fun j => overlapWeight hT hS i j * hT.eigenvalues j))) +
          Finset.univ.sum (fun i =>
            Finset.univ.sum (fun j => overlapWeight hT hS i j * hS.eigenvalues i)) := by
        simp_rw [Finset.sum_add_distrib, Finset.sum_neg_distrib]

/-- Full finite-dimensional real matrix Klein inequality assembled from the
proved overlap-adapter layer. -/
theorem fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian)
    (hTpos : IsStrictlyPositive T) (hSpos : IsStrictlyPositive S) :
    0 <= Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log S) - Matrix.trace T + Matrix.trace S := by
  rw [fullMatrixKlein_eq_weightedSpectralSum_of_isHermitian_of_strictlyPositive hT hS hTpos hSpos]
  exact weightedSpectralKlein_nonneg hT hS hTpos hSpos

/-- Compatibility alias for the assembled full matrix Klein theorem in the
`RelativeEntropy` namespace. -/
theorem kleinInequality_relativeEntropy_nonneg
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian)
    (hTpos : IsStrictlyPositive T) (hSpos : IsStrictlyPositive S) :
    0 <= Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log S) - Matrix.trace T + Matrix.trace S :=
  fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive hT hS hTpos hSpos

end RelativeEntropy

/-- Scalar Klein inequality for the unnormalized relative-entropy integrand. -/
theorem kleinInequality_scalar_relativeEntropy_nonneg
    {x y : Real} (hx : 0 < x) (hy : 0 < y) :
    0 <= x * Real.log (x / y) - x + y := by
  simpa [RelativeEntropy.scalarTerm] using
    RelativeEntropy.scalarTerm_nonneg hx hy

/-- Diagonal/same-eigenbasis Klein inequality on explicit scalar spectral data.

This is a scalar-data MVP: it proves nonnegativity once the trace expression has
already been reduced to diagonal entries. It does not rewrite a general matrix
trace-log expression into this sum.
-/
theorem kleinInequality_relativeEntropy_nonneg_diagonal
    {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <= Finset.univ.sum (fun i => t i * Real.log (t i / s i) - t i + s i) := by
  simpa [RelativeEntropy.diagonalTerm, RelativeEntropy.scalarTerm] using
    RelativeEntropy.diagonalTerm_nonneg t s ht hs

/-- Diagonal matrix trace-log Klein inequality.

This is a same-basis matrix-shaped version of the diagonal MVP. It does not
rewrite general `CFC.log` trace expressions and does not prove full matrix
Klein. -/
theorem kleinInequality_relativeEntropy_nonneg_diagonal_matrix
    {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <=
      Matrix.trace (Matrix.diagonal t * Matrix.diagonal (fun i => Real.log (t i))) -
        Matrix.trace (Matrix.diagonal t * Matrix.diagonal (fun i => Real.log (s i))) -
        Matrix.trace (Matrix.diagonal t) + Matrix.trace (Matrix.diagonal s) := by
  simpa [RelativeEntropy.diagonalMatrixTerm] using
    RelativeEntropy.diagonalMatrixTerm_nonneg t s ht hs

/-- Diagonal matrix Klein inequality restated with `CFC.log` on diagonal
matrices. This is still the same-basis MVP, not the full matrix theorem. -/
theorem kleinInequality_relativeEntropy_nonneg_diagonal_matrix_cfcLog
    {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <=
      Matrix.trace (Matrix.diagonal t * CFC.log (Matrix.diagonal t)) -
        Matrix.trace (Matrix.diagonal t * CFC.log (Matrix.diagonal s)) -
        Matrix.trace (Matrix.diagonal t) + Matrix.trace (Matrix.diagonal s) := by
  exact RelativeEntropy.diagonalMatrixTerm_cfcLog_nonneg t s ht hs

/-- Root-level compatibility alias matching the existing `kleinInequality_*`
surface for relative-entropy provider APIs. -/
theorem kleinInequality_relativeEntropy_nonneg
    {n : Nat} {T S : Matrix (Fin n) (Fin n) Real}
    (hT : T.IsHermitian) (hS : S.IsHermitian)
    (hTpos : IsStrictlyPositive T) (hSpos : IsStrictlyPositive S) :
    0 <= Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log S) - Matrix.trace T + Matrix.trace S :=
  RelativeEntropy.kleinInequality_relativeEntropy_nonneg hT hS hTpos hSpos

end

end HighDimProb
