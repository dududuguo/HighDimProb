import HighDimProb.Expectation
import HighDimProb.Lp
import HighDimProb.RandomMatrix.Basic

/-!
# Entrywise matrix expectation vocabulary

Verified Wikipedia references:
* Expected value: https://en.wikipedia.org/wiki/Expected_value
* Random matrix: https://en.wikipedia.org/wiki/Random_matrix

Matrix-valued expectations are represented entrywise. This avoids committing to
a Bochner-integral API for matrix-valued random variables before the matrix
concentration proof layer needs it.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- Entrywise expectation of a random matrix. -/
def matrixExpect {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) :
    Matrix (Fin m) (Fin n) Real :=
  fun i j => expect P (matrixEntry A i j)

/-- Entrywise integrability predicate for random matrices. -/
def IntegrableRandomMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, forall j : Fin n,
    IntegrableRealRandomVariable P (matrixEntry A i j)

@[simp]
theorem matrixExpect_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (i : Fin m) (j : Fin n) :
    matrixExpect P A i j = expect P (matrixEntry A i j) :=
  rfl

/-- Entrywise centered random matrix `A - E A`. -/
def centeredRandomMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) :
    RandomMatrix Omega m n :=
  fun omega i j => A omega i j - matrixExpect P A i j

@[simp]
theorem centeredRandomMatrix_apply {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (P : Measure Omega) (A : RandomMatrix Omega m n)
    (omega : Omega) (i : Fin m) (j : Fin n) :
    centeredRandomMatrix P A omega i j = A omega i j - matrixExpect P A i j :=
  rfl

/--
Rank-one self outer products are entrywise integrable when every coordinate
product is explicitly integrable.

Formula reference: integrability is separate from measurability for Lebesgue
integration; see https://en.wikipedia.org/wiki/Lebesgue_integration .  This
bridge deliberately assumes product integrability and does not infer it from
random-vector measurability alone.
-/
theorem integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomVector Omega n}
    (hProd : forall i : Fin n, forall j : Fin n,
      IntegrableRealRandomVariable P (fun omega => X omega i * X omega j)) :
    IntegrableRandomMatrix P (rankOneRandomMatrix X) := by
  intro i j
  change IntegrableRealRandomVariable P (fun omega => X omega i * X omega j)
  exact hProd i j

/--
Square-moment coordinates give entrywise integrability of the rank-one
outer-product random matrix.

Formula reference: entries of the outer product are `X_i * X_j`; see
https://en.wikipedia.org/wiki/Outer_product .  The proof reuses Mathlib's
`MemLp.integrable_mul`, so the second-moment hypothesis is explicit rather than
hidden inside the random-vector measurability predicate.
-/
theorem integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomVector Omega n}
    (hX : forall i : Fin n, MemLpRealRandomVariable P (coord X i) 2) :
    IntegrableRandomMatrix P (rankOneRandomMatrix X) := by
  apply integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products
  intro i j
  change Integrable ((coord X i) * (coord X j)) P
  exact (hX i).integrable_mul (hX j)

end

end HighDimProb
