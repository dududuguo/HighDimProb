import HighDimProb.RandomMatrix.Spectral

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {n : Nat}
variable (A : RandomMatrix Omega n n)
variable (M : Matrix (Fin n) (Fin n) Real)
variable (x : Fin n -> Real)
variable (L : Real)
variable (t : Real)
variable (Z : Omega -> Real)

variable {d : Nat}
variable (H : Matrix (Fin (d + 1)) (Fin (d + 1)) Real)
variable (hH : IsSelfAdjointMatrix H)
variable (B : RandomMatrix Omega (d + 1) (d + 1))
variable (hB : forall omega, IsSelfAdjointMatrix (B omega))

#check lambdaMax
#check SpectralUpperBound
#check RayleighUpperBound
#check scalarUpperTailEvent
#check matrixUpperBoundTailEvent
#check lambdaMaxOrdered
#check lambdaMaxOrdered_eq_eigenvalues₀_zero
#check lambdaMin
#check QuadraticFormUpperBound
#check QuadraticFormLowerBound
#check quadraticFormUpperBound_mono
#check quadraticFormLowerBound_mono
#check LambdaMaxBound
#check lambdaMax_is_greatest_eigenvalue_statement
#check lambdaMax_eq_lambdaMaxOrdered_statement
#check lambdaMaxOrdered_is_greatest_eigenvalue_statement
#check lambdaMaxOrdered_is_greatest_eigenvalue
#check lambdaMin_is_least_eigenvalue_statement
#check matrixQuadraticForm_le_lambdaMax_statement
#check matrixQuadraticForm_le_lambdaMaxOrdered_statement
#check LambdaMaxPSDUpperBound
#check LambdaMaxOrderedPSDUpperBound
#check spectralUpperBound_of_lambdaMaxPSDUpperBound
#check spectralUpperBound_of_lambdaMaxOrderedPSDUpperBound
#check matrixQuadraticForm_nonneg_of_posSemidef
#check matrixQuadraticForm_smul_one_of_isUnitVector
#check rayleighUpperBound_of_spectralUpperBound
#check matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef
#check matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound
#check matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound
#check quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax
#check lambdaMaxUpperTailEvent
#check lambdaMaxOrderedUpperTailEvent
#check lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent
#check lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent
#check quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound
#check quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
#check quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound
#check quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax
#check quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
#check not_isUnitVector_fin_zero
#check unitSphere_empty_of_zero_dim
#check quadraticFormUpperTailEvent_empty_of_zero_dim
#check quadraticFormUpperTailEvent
#check quadraticFormLowerTailEvent
#check SelfAdjointOperatorNormTailEvent
#check selfAdjointOperatorNormTailEvent
#check twoSidedQuadraticFormTailEvent
#check quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent
#check quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent
#check selfAdjointOperatorNormTailViaQuadraticFormStatement
#check lambdaMax_le_iff_quadraticForm_le_statement
#check operatorNorm_eq_max_abs_lambda_statement

#check (lambdaMax H hH : Real)
#check (SpectralUpperBound M L : Prop)
#check (RayleighUpperBound M L : Prop)
#check (scalarUpperTailEvent Z t : Set Omega)
#check (matrixUpperBoundTailEvent A Z t : Set Omega)
#check (lambdaMaxOrdered H hH : Real)
#check (lambdaMin H hH : Real)
#check (QuadraticFormUpperBound M t : Prop)
#check (QuadraticFormLowerBound M t : Prop)
#check (LambdaMaxBound M t : Prop)
#check (lambdaMax_is_greatest_eigenvalue_statement H hH : Prop)
#check (lambdaMax_eq_lambdaMaxOrdered_statement H hH : Prop)
#check (lambdaMaxOrdered_is_greatest_eigenvalue_statement H hH : Prop)
#check (lambdaMin_is_least_eigenvalue_statement H hH : Prop)
#check (matrixQuadraticForm_le_lambdaMax_statement H hH : Prop)
#check (matrixQuadraticForm_le_lambdaMaxOrdered_statement H hH : Prop)
#check (LambdaMaxPSDUpperBound H hH : Prop)
#check (LambdaMaxOrderedPSDUpperBound H hH : Prop)
#check (lambdaMaxUpperTailEvent B hB t : Set Omega)
#check (lambdaMaxOrderedUpperTailEvent B hB t : Set Omega)
#check (quadraticFormUpperTailEvent A t : Set Omega)
#check (quadraticFormLowerTailEvent A t : Set Omega)
#check (SelfAdjointOperatorNormTailEvent A t : Set Omega)
#check (selfAdjointOperatorNormTailEvent A t : Set Omega)
#check (twoSidedQuadraticFormTailEvent A t : Set Omega)
#check (selfAdjointOperatorNormTailViaQuadraticFormStatement A t : Prop)
#check (lambdaMax_le_iff_quadraticForm_le_statement H hH t : Prop)
#check (operatorNorm_eq_max_abs_lambda_statement H hH : Prop)

example :
    lambdaMaxOrdered H hH = hH.eigenvalues₀ 0 := by
  exact lambdaMaxOrdered_eq_eigenvalues₀_zero H hH

example :
    lambdaMaxOrdered_is_greatest_eigenvalue_statement H hH := by
  exact lambdaMaxOrdered_is_greatest_eigenvalue H hH

example (hBridge : lambdaMax_eq_lambdaMaxOrdered_statement H hH) :
    lambdaMax H hH = lambdaMaxOrdered H hH := by
  exact hBridge

example (h : QuadraticFormUpperBound M t) (hx : IsUnitVector x) :
    matrixQuadraticForm M x <= t := by
  exact h x hx

example (h : SpectralUpperBound M L) :
    RayleighUpperBound M L := by
  exact rayleighUpperBound_of_spectralUpperBound h

example (h : RayleighUpperBound M L) (hx : IsUnitVector x) :
    matrixQuadraticForm M x <= L := by
  exact h x hx

example (hPSD : LambdaMaxPSDUpperBound H hH) :
    SpectralUpperBound H (lambdaMax H hH) := by
  exact spectralUpperBound_of_lambdaMaxPSDUpperBound hPSD

example (hPSD : LambdaMaxOrderedPSDUpperBound H hH) :
    SpectralUpperBound H (lambdaMaxOrdered H hH) := by
  exact spectralUpperBound_of_lambdaMaxOrderedPSDUpperBound hPSD

example (hPSD : M.PosSemidef) :
    0 <= matrixQuadraticForm M x := by
  exact matrixQuadraticForm_nonneg_of_posSemidef hPSD x

example (hx : IsUnitVector x) :
    matrixQuadraticForm (t • (1 : Matrix (Fin n) (Fin n) Real)) x = t := by
  exact matrixQuadraticForm_smul_one_of_isUnitVector t hx

example
    (hPSD :
      (((lambdaMax H hH) •
          (1 : Matrix (Fin (d + 1)) (Fin (d + 1)) Real)) - H).PosSemidef) :
    matrixQuadraticForm_le_lambdaMax_statement H hH := by
  exact matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef hPSD

example (hPSD : LambdaMaxPSDUpperBound H hH) :
    matrixQuadraticForm_le_lambdaMax_statement H hH := by
  exact matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound hPSD

example (hPSD : LambdaMaxOrderedPSDUpperBound H hH) :
    matrixQuadraticForm_le_lambdaMaxOrdered_statement H hH := by
  exact matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound hPSD

example {s t : Real} (hst : s <= t) (h : QuadraticFormUpperBound M s) :
    QuadraticFormUpperBound M t := by
  exact quadraticFormUpperBound_mono hst h

example {s t : Real} (hst : s <= t) (h : QuadraticFormLowerBound M t) :
    QuadraticFormLowerBound M s := by
  exact quadraticFormLowerBound_mono hst h

example (hRayleigh : matrixQuadraticForm_le_lambdaMax_statement H hH)
    (ht : lambdaMax H hH <= t) :
    QuadraticFormUpperBound H t := by
  exact
    quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax
      hRayleigh ht

example
    (hRayleigh :
      forall omega, RayleighUpperBound (A omega) (Z omega)) :
    quadraticFormUpperTailEvent A t <= scalarUpperTailEvent Z t := by
  exact
    quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound
      A Z t hRayleigh

example
    (hRayleigh :
      forall omega, RayleighUpperBound (A omega) (Z omega)) :
    quadraticFormUpperTailEvent A t <= matrixUpperBoundTailEvent A Z t := by
  exact
    quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
      A Z t hRayleigh

example
    (hUpper :
      forall omega, SpectralUpperBound (A omega) (Z omega)) :
    quadraticFormUpperTailEvent A t <= matrixUpperBoundTailEvent A Z t := by
  exact
    quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound
      A Z t hUpper

example :
    lambdaMaxUpperTailEvent B hB t =
      matrixUpperBoundTailEvent B
        (fun omega => lambdaMax (B omega) (hB omega)) t := by
  exact lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent B hB t

example :
    lambdaMaxOrderedUpperTailEvent B hB t =
      matrixUpperBoundTailEvent B
        (fun omega => lambdaMaxOrdered (B omega) (hB omega)) t := by
  exact lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent B hB t

example
    (hRayleigh :
      forall omega, matrixQuadraticForm_le_lambdaMax_statement (B omega) (hB omega)) :
    quadraticFormUpperTailEvent B t <= lambdaMaxUpperTailEvent B hB t := by
  exact
    quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax
      B t hB hRayleigh

example
    (hRayleigh :
      forall omega, matrixQuadraticForm_le_lambdaMaxOrdered_statement (B omega) (hB omega)) :
    quadraticFormUpperTailEvent B t <= lambdaMaxOrderedUpperTailEvent B hB t := by
  exact
    quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
      B t hB hRayleigh

example (Z : RandomMatrix Omega 0 0) :
    quadraticFormUpperTailEvent Z t = ∅ := by
  exact quadraticFormUpperTailEvent_empty_of_zero_dim Z t

example :
    quadraticFormUpperTailEvent A t ⊆ twoSidedQuadraticFormTailEvent A t := by
  exact quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent A t

example :
    quadraticFormLowerTailEvent A (-t) ⊆ twoSidedQuadraticFormTailEvent A t := by
  exact quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent A t
