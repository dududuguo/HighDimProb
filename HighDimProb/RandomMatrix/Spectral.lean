import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.Matrix.Order
import HighDimProb.RandomMatrix.MatrixOrder
import HighDimProb.RandomMatrix.OperatorNorm

/-!
# Spectral and quadratic-form event vocabulary

Verified Wikipedia references:
* Eigenvalues and eigenvectors: https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors
* Spectral theorem: https://en.wikipedia.org/wiki/Spectral_theorem
* Operator norm: https://en.wikipedia.org/wiki/Operator_norm
* Loewner order: https://en.wikipedia.org/wiki/Loewner_order

This module starts the matrix Bernstein spectral layer. Mathlib provides
Hermitian eigenvalues, but HighDimProb does not yet have a proved lambda-max
Rayleigh quotient bridge. We therefore expose two honest layers:

* narrow `lambdaMax` / `lambdaMin` wrappers for visibly nonempty finite real
  self-adjoint matrices;
* dimension-agnostic quadratic-form bound and tail-event predicates that can
  be used before the full spectral theorem interface is connected.
-/

namespace HighDimProb

open MeasureTheory
open scoped Matrix.Norms.L2Operator MatrixOrder Pointwise

noncomputable section

/-! ## Semantic spectral upper-bound layer -/

/-- Semantic Loewner-style upper spectral bound.

`SpectralUpperBound A L` means that `L * I - A` is positive semidefinite in
Mathlib's matrix order. Concrete endpoint providers such as `lambdaMax` and
`lambdaMaxOrdered` should specialize to this predicate rather than duplicating
its matrix expression downstream. -/
abbrev SpectralUpperBound {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (L : Real) : Prop :=
  (((L • (1 : Matrix (Fin n) (Fin n) Real)) - A).PosSemidef)

/-- Semantic Rayleigh upper bound over HighDimProb's explicit unit sphere. -/
def RayleighUpperBound {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (L : Real) : Prop :=
  forall x : Fin n -> Real, IsUnitVector x -> matrixQuadraticForm A x <= L

/-- Generic scalar upper-tail event for a real-valued process. -/
def scalarUpperTailEvent {Omega : Type*} [MeasurableSpace Omega]
    (Z : Omega -> Real) (t : Real) : Set Omega :=
  {omega | t <= Z omega}

/-- Upper-tail event for a scalar semantic upper-bound provider attached to a
random matrix.

The matrix argument records the semantic owner of the bound; the proof that
`L omega` actually bounds `A omega` remains a separate hypothesis. -/
def matrixUpperBoundTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (_A : RandomMatrix Omega n n) (L : Omega -> Real)
    (t : Real) : Set Omega :=
  scalarUpperTailEvent L t

/-! ## Lambda endpoint wrappers -/

/-- Largest-eigenvalue wrapper for a real self-adjoint matrix indexed by a
nonempty `Fin (n + 1)` type.

This uses Mathlib's ordered Hermitian eigenvalue list. The bridge from this
wrapper to HighDimProb's explicit quadratic-form order is intentionally kept as
a statement target below. -/
def lambdaMax {n : Nat} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Real :=
  hA.eigenvalues 0

/-- Canonical largest-eigenvalue endpoint using Mathlib's ordered Hermitian
eigenvalue API directly.

This is intentionally separate from `lambdaMax`, whose public meaning remains
the existing `eigenvalues 0` wrapper. -/
def lambdaMaxOrdered {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Real :=
  hA.eigenvalues₀ 0

/-- The ordered lambda-max wrapper is definitionally Mathlib's ordered
Hermitian endpoint. -/
theorem lambdaMaxOrdered_eq_eigenvalues₀_zero {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered A hA = hA.eigenvalues₀ 0 :=
  rfl

/-- Smallest-eigenvalue wrapper for a real self-adjoint matrix indexed by a
nonempty `Fin (n + 1)` type. -/
def lambdaMin {n : Nat} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Real :=
  hA.eigenvalues (Fin.last n)

/-! ## Explicit quadratic-form bound predicates -/

/-- Quadratic-form upper bound over the explicit unit sphere.

This is the proof-ready surrogate for a future `lambdaMax A <= t` event when
the lambda-max/Rayleigh bridge is not yet available. -/
def QuadraticFormUpperBound {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (t : Real) : Prop :=
  RayleighUpperBound A t

/-- Quadratic-form lower bound over the explicit unit sphere. -/
def QuadraticFormLowerBound {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (t : Real) : Prop :=
  forall x : Fin n -> Real, IsUnitVector x -> t <= matrixQuadraticForm A x

/-- Monotonicity of quadratic-form upper bounds in the scalar threshold. -/
theorem quadraticFormUpperBound_mono {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} {s t : Real}
    (hst : s <= t) (hA : QuadraticFormUpperBound A s) :
    QuadraticFormUpperBound A t := by
  intro x hx
  exact le_trans (hA x hx) hst

/-- Monotonicity of quadratic-form lower bounds in the scalar threshold. -/
theorem quadraticFormLowerBound_mono {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} {s t : Real}
    (hst : s <= t) (hA : QuadraticFormLowerBound A t) :
    QuadraticFormLowerBound A s := by
  intro x hx
  exact le_trans hst (hA x hx)

/-- Proof-friendly lambda-max upper-bound predicate.

This is definitionally the quadratic-form upper bound. It is not a proved
eigenvalue characterization; that bridge is recorded by
`lambdaMax_le_iff_quadraticForm_le_statement`. -/
abbrev LambdaMaxBound {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (t : Real) : Prop :=
  QuadraticFormUpperBound A t

/-! ## Spectral bridge typed targets -/

/-- Typed target recording that the `lambdaMax` wrapper is the greatest
Hermitian eigenvalue.

Mathlib exposes decreasing Hermitian eigenvalue order through the underlying
`eigenvalues₀` / symmetric-operator APIs. The remaining work is the clean
bridge through HighDimProb's `Fin (n + 1)` wrapper and explicit naming. -/
abbrev lambdaMax_is_greatest_eigenvalue_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  forall i : Fin (n + 1), hA.eigenvalues i <= lambdaMax A hA

/-- Typed target recording that the legacy `lambdaMax` wrapper agrees with the
canonical ordered endpoint wrapper.

This remains a statement target because Mathlib's `eigenvalues` API reindexes
`eigenvalues₀` through `Fintype.equivOfCardEq`. -/
abbrev lambdaMax_eq_lambdaMaxOrdered_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  lambdaMax A hA = lambdaMaxOrdered A hA

/-- Typed target recording that the ordered endpoint wrapper is the greatest
ordered Hermitian eigenvalue. -/
abbrev lambdaMaxOrdered_is_greatest_eigenvalue_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  forall i : Fin (Fintype.card (Fin (n + 1))),
    hA.eigenvalues₀ i <= lambdaMaxOrdered A hA

/-- Mathlib's ordered Hermitian endpoint is greatest in the ordered list. -/
theorem lambdaMaxOrdered_is_greatest_eigenvalue {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered_is_greatest_eigenvalue_statement A hA := by
  intro i
  simpa [lambdaMaxOrdered,
    lambdaMaxOrdered_is_greatest_eigenvalue_statement] using
    hA.eigenvalues₀_antitone (Fin.zero_le i)

/-- The ordered lambda-max endpoint is a real spectral value. -/
private theorem lambdaMaxOrdered_mem_spectrum_real {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered A hA ∈ spectrum Real A := by
  classical
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  have hmem := hA.eigenvalues_mem_spectrum_real (e 0)
  simpa [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues, e] using hmem

/-- The ordered lambda-max endpoint is bounded by the deterministic L2
operator norm. -/
theorem lambdaMaxOrdered_le_deterministicOperatorNorm
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered A hA <= deterministicOperatorNorm A := by
  have hmem : lambdaMaxOrdered A hA ∈ spectrum Real A :=
    lambdaMaxOrdered_mem_spectrum_real A hA
  have hnorm : ‖lambdaMaxOrdered A hA‖ <= ‖A‖ :=
    spectrum.norm_le_norm_of_mem hmem
  exact (le_abs_self (lambdaMaxOrdered A hA)).trans (by
    simpa [Real.norm_eq_abs, deterministicOperatorNorm] using hnorm)

/-- Every real spectral value of a self-adjoint matrix is bounded by the
ordered endpoint. -/
private theorem spectrum_real_le_lambdaMaxOrdered {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) {x : Real}
    (hx : x ∈ spectrum Real A) :
    x <= lambdaMaxOrdered A hA := by
  classical
  rw [hA.spectrum_real_eq_range_eigenvalues] at hx
  rcases hx with ⟨i, rfl⟩
  dsimp [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues]
  exact hA.eigenvalues₀_antitone (Fin.zero_le _)

/-- The ordered lambda-max endpoint commutes with nonnegative scalar
multiplication. -/
theorem lambdaMaxOrdered_smul_of_nonneg
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (theta : Real) (hTheta : 0 <= theta)
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered (theta • A) (isSelfAdjointMatrix_smul theta hA)
      = theta * lambdaMaxOrdered A hA := by
  classical
  let hThetaA : IsSelfAdjointMatrix (theta • A) :=
    isSelfAdjointMatrix_smul theta hA
  apply le_antisymm
  · have hmemTheta :
        lambdaMaxOrdered (theta • A) hThetaA ∈ spectrum Real (theta • A) :=
      lambdaMaxOrdered_mem_spectrum_real (theta • A) hThetaA
    have hspectrum :
        spectrum Real (theta • A) = theta • spectrum Real A :=
      spectrum.smul_eq_smul theta A
        (Set.nonempty_of_mem (lambdaMaxOrdered_mem_spectrum_real A hA))
    rw [hspectrum] at hmemTheta
    rcases hmemTheta with ⟨mu, hmu, hmul⟩
    rw [← hmul]
    exact mul_le_mul_of_nonneg_left
      (spectrum_real_le_lambdaMaxOrdered hA hmu) hTheta
  · have hmem :
        theta * lambdaMaxOrdered A hA ∈ spectrum Real (theta • A) := by
      have hspectrum :
          spectrum Real (theta • A) = theta • spectrum Real A :=
        spectrum.smul_eq_smul theta A
          (Set.nonempty_of_mem (lambdaMaxOrdered_mem_spectrum_real A hA))
      rw [hspectrum]
      simpa [smul_eq_mul] using
        (Set.smul_mem_smul_set
          (a := theta)
          (lambdaMaxOrdered_mem_spectrum_real A hA))
    exact spectrum_real_le_lambdaMaxOrdered hThetaA hmem

/-- For a positive semidefinite self-adjoint matrix, the ordered largest
eigenvalue is bounded by the matrix trace.

This is stated with `Matrix.trace` so it can live in `Spectral.lean` without
importing the downstream `matrixTrace` wrapper from `TraceExp.lean`. -/
theorem lambdaMaxOrdered_le_trace_of_posSemidef
    {n : Nat} {B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hB : IsSelfAdjointMatrix B)
    (hPSD : Matrix.PosSemidef B) :
    lambdaMaxOrdered B hB <= Matrix.trace B := by
  classical
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  have htrace : Matrix.trace B = ∑ i, (hB.eigenvalues i : Real) :=
    hB.trace_eq_sum_eigenvalues
  have hnonneg : ∀ i : Fin (n + 1), 0 <= hB.eigenvalues i := by
    intro i
    exact hPSD.eigenvalues_nonneg i
  have hterm :
      hB.eigenvalues (e 0) <= ∑ i, hB.eigenvalues i := by
    exact Finset.single_le_sum (by
      intro j _hj
      exact hnonneg j) (Finset.mem_univ (e 0))
  simpa [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues, e, htrace] using hterm

/-- Typed target recording that the `lambdaMin` wrapper is the least
Hermitian eigenvalue. -/
abbrev lambdaMin_is_least_eigenvalue_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  forall i : Fin (n + 1), lambdaMin A hA <= hA.eigenvalues i

/-- Typed target for the Rayleigh bridge from HighDimProb's explicit
unit-vector quadratic form to the `lambdaMax` wrapper.

This statement is restricted to the nonempty `Fin (n + 1)` route used by
`lambdaMax`.  The actual proof still requires connecting
`matrixQuadraticForm`/`IsUnitVector` to Mathlib's Rayleigh quotient or
Hermitian eigenvalue API. -/
abbrev matrixQuadraticForm_le_lambdaMax_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  RayleighUpperBound A (lambdaMax A hA)

/-- Typed target for the Rayleigh bridge to the canonical ordered endpoint
wrapper. -/
abbrev matrixQuadraticForm_le_lambdaMaxOrdered_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  RayleighUpperBound A (lambdaMaxOrdered A hA)

/-! ## Endpoint-PSD helper bridge -/

/-- Named endpoint PSD premise for the lambda-max Rayleigh bridge.

This is a premise, not a theorem. The next spectral proof task is to prove
this predicate from Mathlib Hermitian eigenvalue endpoint ordering or an
equivalent Loewner/CFC route. -/
abbrev LambdaMaxPSDUpperBound {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  SpectralUpperBound A (lambdaMax A hA)

/-- Named endpoint PSD premise for the ordered lambda-max Rayleigh bridge. -/
abbrev LambdaMaxOrderedPSDUpperBound {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  SpectralUpperBound A (lambdaMaxOrdered A hA)

/-- The canonical ordered lambda-max endpoint provides the semantic spectral
upper-bound predicate. -/
theorem lambdaMaxOrdered_spectralUpperBound
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    SpectralUpperBound A (lambdaMaxOrdered A hA) := by
  classical
  have hle :
      A ≤ algebraMap Real (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
        (lambdaMaxOrdered A hA) := by
    apply le_algebraMap_of_spectrum_le
    · intro x hx
      rw [hA.spectrum_real_eq_range_eigenvalues] at hx
      rcases hx with ⟨i, rfl⟩
      dsimp [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues]
      exact hA.eigenvalues₀_antitone (Fin.zero_le _)
    · exact hA.isSelfAdjoint
  simpa [SpectralUpperBound, Algebra.algebraMap_eq_smul_one] using
    (Matrix.le_iff.mp hle)

/-- The ordered lambda-max endpoint satisfies the named provider predicate. -/
theorem lambdaMaxOrderedPSDUpperBound
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    LambdaMaxOrderedPSDUpperBound A hA :=
  lambdaMaxOrdered_spectralUpperBound hA

/-- Compatibility projection from the legacy lambda-max PSD premise to the
semantic spectral upper-bound predicate. -/
theorem spectralUpperBound_of_lambdaMaxPSDUpperBound
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {hA : IsSelfAdjointMatrix A}
    (hPSD : LambdaMaxPSDUpperBound A hA) :
    SpectralUpperBound A (lambdaMax A hA) :=
  hPSD

/-- Compatibility projection from the ordered lambda-max PSD premise to the
semantic spectral upper-bound predicate. -/
theorem spectralUpperBound_of_lambdaMaxOrderedPSDUpperBound
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {hA : IsSelfAdjointMatrix A}
    (hPSD : LambdaMaxOrderedPSDUpperBound A hA) :
    SpectralUpperBound A (lambdaMaxOrdered A hA) :=
  hPSD

/-- Mathlib positive semidefiniteness implies nonnegativity of the
HighDimProb explicit double-sum quadratic form.

This is only a conversion lemma. It does not identify HighDimProb's
`IsPSDMatrix` with Mathlib's `Matrix.PosSemidef`. -/
theorem matrixQuadraticForm_nonneg_of_posSemidef {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : A.PosSemidef)
    (x : Fin n -> Real) :
    0 <= matrixQuadraticForm A x := by
  have h := hA.dotProduct_mulVec_nonneg x
  simpa [matrixQuadraticForm, dotProduct, Matrix.mulVec,
    Finset.mul_sum, Finset.sum_mul, mul_assoc] using h

/-- HighDimProb's explicit PSD predicate gives Mathlib positive
semidefiniteness.

Formula reference: positive semidefinite real matrices are characterized by a
nonnegative quadratic form; see https://en.wikipedia.org/wiki/Definite_matrix .
This bridge keeps the explicit HighDimProb assumptions visible while exposing
Mathlib's `Matrix.PosSemidef` API. -/
theorem posSemidef_of_isPSDMatrix {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsPSDMatrix A) :
    A.PosSemidef := by
  apply Matrix.PosSemidef.of_dotProduct_mulVec_nonneg
  · apply Matrix.IsHermitian.ext
    intro i j
    simpa using Matrix.IsSymm.apply hA.1 i j
  · intro x
    have hx := hA.2 x
    simpa [matrixQuadraticForm, dotProduct, Matrix.mulVec,
      Finset.mul_sum, Finset.sum_mul, mul_assoc] using hx

/-- PSD nullspace converse in HighDimProb's explicit quadratic-form vocabulary.

Formula reference: for a positive semidefinite matrix, a zero quadratic form
forces the vector into the kernel; one proof uses the PSD square root, see
https://en.wikipedia.org/wiki/Definite_matrix#Square_root .  This theorem is a
thin wrapper over Mathlib's `Matrix.PosSemidef.dotProduct_mulVec_zero_iff`. -/
theorem matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_posSemidef {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : A.PosSemidef)
    (x : Fin n -> Real) :
    matrixQuadraticForm A x = 0 <-> Matrix.mulVec A x = 0 := by
  have h := hA.dotProduct_mulVec_zero_iff x
  simpa [matrixQuadraticForm, dotProduct, Matrix.mulVec,
    Finset.mul_sum, Finset.sum_mul, mul_assoc] using h

/-- One-way PSD nullspace converse from a zero HighDimProb quadratic form. -/
theorem matrix_mulVec_eq_zero_of_posSemidef_quadraticForm_eq_zero {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : A.PosSemidef)
    {x : Fin n -> Real} (hx : matrixQuadraticForm A x = 0) :
    Matrix.mulVec A x = 0 :=
  (matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_posSemidef hA x).mp hx

/-- Explicit-PSD version of the PSD nullspace iff.

Formula reference: the statement is the usual PSD nullspace converse for
symmetric positive semidefinite real matrices; see
https://math.stackexchange.com/questions/3918031/prove-that-if-xtax-0-rightarrow-ax-0 .
-/
theorem matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_isPSDMatrix {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsPSDMatrix A)
    (x : Fin n -> Real) :
    matrixQuadraticForm A x = 0 <-> Matrix.mulVec A x = 0 :=
  matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_posSemidef
    (posSemidef_of_isPSDMatrix hA) x

/-- One-way explicit-PSD nullspace converse from a zero HighDimProb quadratic
form. -/
theorem matrix_mulVec_eq_zero_of_isPSDMatrix_quadraticForm_eq_zero {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsPSDMatrix A)
    {x : Fin n -> Real} (hx : matrixQuadraticForm A x = 0) :
    Matrix.mulVec A x = 0 :=
  (matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_isPSDMatrix hA x).mp hx

/-- Scalar-matrix quadratic form over an explicit unit vector.

This is the small algebraic bridge needed to turn a Loewner-order upper bound
`A <= lambdaMax A * I` into HighDimProb's explicit Rayleigh bound. -/
theorem matrixQuadraticForm_smul_one_of_isUnitVector {n : Nat}
    (c : Real) {x : Fin n -> Real} (hx : IsUnitVector x) :
    matrixQuadraticForm (c • (1 : Matrix (Fin n) (Fin n) Real)) x = c := by
  calc
    matrixQuadraticForm (c • (1 : Matrix (Fin n) (Fin n) Real)) x
        = Finset.univ.sum fun i : Fin n => x i * (c * x i) := by
          simp [matrixQuadraticForm]
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.sum_eq_single i]
          · simp [mul_assoc]
          · intro j _ hji
            simp [hji.symm]
          · intro hi
            simp at hi
    _ = c * Finset.univ.sum fun i : Fin n => x i ^ 2 := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          ring
    _ = c := by
          rw [show (Finset.univ.sum fun i : Fin n => x i ^ 2) = 1 by
            simpa [IsUnitVector, vectorSqNorm] using hx]
          ring

/-- A semantic spectral upper bound implies the corresponding explicit
HighDimProb Rayleigh upper bound. -/
theorem rayleighUpperBound_of_spectralUpperBound
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real} {L : Real}
    (hUpper : SpectralUpperBound A L) :
    RayleighUpperBound A L := by
  intro x hx
  have hnonneg := matrixQuadraticForm_nonneg_of_posSemidef hUpper x
  rw [matrixQuadraticForm_sub] at hnonneg
  rw [matrixQuadraticForm_smul_one_of_isUnitVector L hx] at hnonneg
  exact sub_nonneg.mp hnonneg

/-- Direct Rayleigh bridge supplied by the ordered lambda-max provider theorem. -/
theorem lambdaMaxOrdered_rayleighUpperBound
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    matrixQuadraticForm_le_lambdaMaxOrdered_statement A hA :=
  rayleighUpperBound_of_spectralUpperBound
    (lambdaMaxOrdered_spectralUpperBound hA)

/-- Conditional Rayleigh conversion from a Mathlib Loewner-style premise.

The hard spectral fact is the premise
`((lambdaMax A hA) • 1 - A).PosSemidef`; proving that premise from the
Hermitian eigenvalue order remains a separate bridge target. -/
theorem matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {hA : IsSelfAdjointMatrix A}
    (hPSD :
      (((lambdaMax A hA) •
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) - A).PosSemidef) :
    matrixQuadraticForm_le_lambdaMax_statement A hA := by
  exact rayleighUpperBound_of_spectralUpperBound hPSD

/-- Conditional Rayleigh conversion from the named endpoint PSD premise. -/
theorem matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {hA : IsSelfAdjointMatrix A}
    (hPSD : LambdaMaxPSDUpperBound A hA) :
    matrixQuadraticForm_le_lambdaMax_statement A hA := by
  exact matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef hPSD

/-- Conditional Rayleigh conversion from the named ordered endpoint PSD
premise. -/
theorem matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {hA : IsSelfAdjointMatrix A}
    (hPSD : LambdaMaxOrderedPSDUpperBound A hA) :
    matrixQuadraticForm_le_lambdaMaxOrdered_statement A hA := by
  exact rayleighUpperBound_of_spectralUpperBound hPSD

/-- Conditional conversion from a proved Rayleigh bridge and a lambda-max
threshold into the explicit quadratic-form upper-bound predicate. -/
theorem quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {hA : IsSelfAdjointMatrix A} {t : Real}
    (hRayleigh : matrixQuadraticForm_le_lambdaMax_statement A hA)
    (ht : lambdaMax A hA <= t) :
    QuadraticFormUpperBound A t := by
  intro x hx
  exact le_trans (hRayleigh x hx) ht

/-! ## Tail event vocabulary -/

/-- Largest-eigenvalue upper-tail event for the nonempty `Fin (n + 1)`
lambda-max wrapper.

The self-adjointness proof is an explicit parameter so the event does not hide
the dependence of `lambdaMax` on a Hermitian witness. -/
def lambdaMaxUpperTailEvent {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1))
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) (t : Real) :
    Set Omega :=
  matrixUpperBoundTailEvent A (fun omega => lambdaMax (A omega) (hA omega)) t

/-- Largest-eigenvalue upper-tail event for the canonical ordered endpoint
wrapper. -/
def lambdaMaxOrderedUpperTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega (n + 1) (n + 1))
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) (t : Real) :
    Set Omega :=
  matrixUpperBoundTailEvent A
    (fun omega => lambdaMaxOrdered (A omega) (hA omega)) t

/-- The legacy lambda-max upper-tail event is a concrete provider instance of
the generic matrix upper-bound tail event. -/
theorem lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1))
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) (t : Real) :
    lambdaMaxUpperTailEvent A hA t =
      matrixUpperBoundTailEvent A
        (fun omega => lambdaMax (A omega) (hA omega)) t :=
  rfl

/-- The ordered lambda-max upper-tail event is a concrete provider instance of
the generic matrix upper-bound tail event. -/
theorem lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1))
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) (t : Real) :
    lambdaMaxOrderedUpperTailEvent A hA t =
      matrixUpperBoundTailEvent A
        (fun omega => lambdaMaxOrdered (A omega) (hA omega)) t :=
  rfl

/-! ## Zero-dimensional cleanup for explicit unit-sphere events -/

/-- There are no explicit HighDimProb unit vectors in dimension zero. -/
theorem not_isUnitVector_fin_zero (x : Fin 0 -> Real) :
    ¬ IsUnitVector x := by
  intro hx
  have hzero : vectorSqNorm x = 0 := by
    simp [vectorSqNorm]
  rw [IsUnitVector, hzero] at hx
  norm_num at hx

/-- The explicit unit sphere is empty in dimension zero. -/
theorem unitSphere_empty_of_zero_dim :
    unitSphere 0 = ∅ := by
  ext x
  constructor
  · intro hx
    exact False.elim ((not_isUnitVector_fin_zero x) hx)
  · intro hEmpty
    cases hEmpty

/-- Event that some unit vector has quadratic form at least `t`. -/
def quadraticFormUpperTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega n n) (t : Real) : Set Omega :=
  {omega | exists x : Fin n -> Real,
    IsUnitVector x /\ t <= matrixQuadraticForm (A omega) x}

/-- Generic event-level bridge from pointwise Rayleigh upper bounds to a scalar
upper-tail provider event. -/
theorem quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (L : Omega -> Real) (t : Real)
    (hRayleigh : forall omega, RayleighUpperBound (A omega) (L omega)) :
    quadraticFormUpperTailEvent A t <= scalarUpperTailEvent L t := by
  intro omega hTail
  rcases hTail with ⟨x, hx, ht⟩
  exact le_trans ht (hRayleigh omega x hx)

/-- Generic event-level bridge from pointwise Rayleigh upper bounds to a matrix
upper-bound provider event. -/
theorem quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (L : Omega -> Real) (t : Real)
    (hRayleigh : forall omega, RayleighUpperBound (A omega) (L omega)) :
    quadraticFormUpperTailEvent A t <= matrixUpperBoundTailEvent A L t := by
  exact
    quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound
      A L t hRayleigh

/-- Generic event-level bridge from pointwise semantic spectral upper bounds to
a matrix upper-bound provider event. -/
theorem quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (L : Omega -> Real) (t : Real)
    (hUpper : forall omega, SpectralUpperBound (A omega) (L omega)) :
    quadraticFormUpperTailEvent A t <= matrixUpperBoundTailEvent A L t := by
  exact
    quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
      A L t (fun omega => rayleighUpperBound_of_spectralUpperBound (hUpper omega))

/-- Conditional event-level Rayleigh bridge from the explicit unit-sphere
quadratic-form upper tail to the lambda-max upper tail. -/
theorem quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1)) (t : Real)
    (hA : forall omega, IsSelfAdjointMatrix (A omega))
    (hRayleigh :
      forall omega, matrixQuadraticForm_le_lambdaMax_statement (A omega) (hA omega)) :
    quadraticFormUpperTailEvent A t <= lambdaMaxUpperTailEvent A hA t := by
  exact
    quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
      A (fun omega => lambdaMax (A omega) (hA omega)) t hRayleigh

/-- Conditional event-level Rayleigh bridge to the ordered lambda-max upper
tail. -/
theorem quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1)) (t : Real)
    (hA : forall omega, IsSelfAdjointMatrix (A omega))
    (hRayleigh :
      forall omega,
        matrixQuadraticForm_le_lambdaMaxOrdered_statement (A omega) (hA omega)) :
    quadraticFormUpperTailEvent A t <= lambdaMaxOrderedUpperTailEvent A hA t := by
  exact
    quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
      A (fun omega => lambdaMaxOrdered (A omega) (hA omega)) t hRayleigh

/-- The quadratic-form upper-tail event is empty in dimension zero because the
explicit unit sphere is empty. -/
theorem quadraticFormUpperTailEvent_empty_of_zero_dim {Omega : Type*}
    [MeasurableSpace Omega] (A : RandomMatrix Omega 0 0) (t : Real) :
    quadraticFormUpperTailEvent A t = ∅ := by
  ext omega
  constructor
  · intro hTail
    rcases hTail with ⟨x, hx, _⟩
    exact False.elim ((not_isUnitVector_fin_zero x) hx)
  · intro hEmpty
    cases hEmpty

/-- Event that some unit vector has quadratic form at most `t`. -/
def quadraticFormLowerTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega n n) (t : Real) : Set Omega :=
  {omega | exists x : Fin n -> Real,
    IsUnitVector x /\ matrixQuadraticForm (A omega) x <= t}

/-- Operator-norm tail event for square random matrices.

Future self-adjoint concentration statements should pair this event with a
self-adjointness assumption on `A`; the event itself is just the operator-norm
tail set. -/
def SelfAdjointOperatorNormTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega n n) (t : Real) : Set Omega :=
  {omega | t <= operatorNorm A omega}

/-- Lowercase compatibility alias for the self-adjoint operator-norm tail
event vocabulary. -/
abbrev selfAdjointOperatorNormTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega n n) (t : Real) : Set Omega :=
  SelfAdjointOperatorNormTailEvent A t

/-- Two-sided quadratic-form tail event over the explicit unit sphere.

This is the proof-ready event that should receive a future self-adjoint
operator-norm tail by the Rayleigh/eigenvalue bridge. -/
def twoSidedQuadraticFormTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega n n) (t : Real) : Set Omega :=
  quadraticFormUpperTailEvent A t ∪ quadraticFormLowerTailEvent A (-t)

/-- The upper quadratic-form tail is one side of the two-sided event. -/
theorem quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (t : Real) :
    quadraticFormUpperTailEvent A t ⊆ twoSidedQuadraticFormTailEvent A t := by
  intro omega h
  exact Or.inl h

/-- The reflected lower quadratic-form tail is one side of the two-sided
event. -/
theorem quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (t : Real) :
    quadraticFormLowerTailEvent A (-t) ⊆ twoSidedQuadraticFormTailEvent A t := by
  intro omega h
  exact Or.inr h

/-- Typed target for the future self-adjoint operator-norm tail reduction.

The proof is blocked until HighDimProb connects Mathlib's self-adjoint
spectral/Rayleigh theorem to the explicit finite-dimensional quadratic form
used by `IsUnitVector`. -/
abbrev selfAdjointOperatorNormTailViaQuadraticFormStatement
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (t : Real) : Prop :=
  (forall omega, IsSelfAdjointMatrix (A omega)) ->
    0 <= t ->
      SelfAdjointOperatorNormTailEvent A t ⊆ twoSidedQuadraticFormTailEvent A t

/-- Typed target for the future Rayleigh quotient bridge between Mathlib
Hermitian eigenvalues and HighDimProb's explicit unit-sphere quadratic form. -/
abbrev lambdaMax_le_iff_quadraticForm_le_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) (t : Real) : Prop :=
  lambdaMax A hA <= t <-> QuadraticFormUpperBound A t

/-- Typed target for relating the self-adjoint operator norm to the largest
absolute endpoint eigenvalue. -/
abbrev operatorNorm_eq_max_abs_lambda_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) : Prop :=
  deterministicOperatorNorm A = max (abs (lambdaMax A hA)) (abs (lambdaMin A hA))

end

end HighDimProb
