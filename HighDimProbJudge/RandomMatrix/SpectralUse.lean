import HighDimProb.RandomMatrix

#check HighDimProb.lambdaMax
#check HighDimProb.SpectralUpperBound
#check HighDimProb.RayleighUpperBound
#check HighDimProb.scalarUpperTailEvent
#check HighDimProb.matrixUpperBoundTailEvent
#check HighDimProb.lambdaMaxOrdered
#check HighDimProb.lambdaMaxOrdered_eq_eigenvalues₀_zero
#check HighDimProb.lambdaMin
#check HighDimProb.QuadraticFormUpperBound
#check HighDimProb.QuadraticFormLowerBound
#check HighDimProb.quadraticFormUpperBound_mono
#check HighDimProb.quadraticFormLowerBound_mono
#check HighDimProb.LambdaMaxBound
#check HighDimProb.lambdaMax_is_greatest_eigenvalue_statement
#check HighDimProb.lambdaMax_eq_lambdaMaxOrdered_statement
#check HighDimProb.lambdaMaxOrdered_is_greatest_eigenvalue_statement
#check HighDimProb.lambdaMaxOrdered_is_greatest_eigenvalue
#check HighDimProb.lambdaMin_is_least_eigenvalue_statement
#check HighDimProb.matrixQuadraticForm_le_lambdaMax_statement
#check HighDimProb.matrixQuadraticForm_le_lambdaMaxOrdered_statement
#check HighDimProb.LambdaMaxPSDUpperBound
#check HighDimProb.LambdaMaxOrderedPSDUpperBound
#check HighDimProb.spectralUpperBound_of_lambdaMaxPSDUpperBound
#check HighDimProb.spectralUpperBound_of_lambdaMaxOrderedPSDUpperBound
#check HighDimProb.matrixQuadraticForm_nonneg_of_posSemidef
#check HighDimProb.matrixQuadraticForm_smul_one_of_isUnitVector
#check HighDimProb.rayleighUpperBound_of_spectralUpperBound
#check HighDimProb.matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef
#check HighDimProb.matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound
#check HighDimProb.matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound
#check HighDimProb.quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax
#check HighDimProb.lambdaMaxUpperTailEvent
#check HighDimProb.lambdaMaxOrderedUpperTailEvent
#check HighDimProb.lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent
#check HighDimProb.lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent
#check HighDimProb.quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound
#check HighDimProb.quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
#check HighDimProb.quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound
#check HighDimProb.quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax
#check HighDimProb.quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
#check HighDimProb.not_isUnitVector_fin_zero
#check HighDimProb.unitSphere_empty_of_zero_dim
#check HighDimProb.quadraticFormUpperTailEvent_empty_of_zero_dim
#check HighDimProb.quadraticFormUpperTailEvent
#check HighDimProb.quadraticFormLowerTailEvent
#check HighDimProb.SelfAdjointOperatorNormTailEvent
#check HighDimProb.selfAdjointOperatorNormTailEvent
#check HighDimProb.twoSidedQuadraticFormTailEvent
#check HighDimProb.quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent
#check HighDimProb.quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent
#check HighDimProb.selfAdjointOperatorNormTailViaQuadraticFormStatement
#check HighDimProb.lambdaMax_le_iff_quadraticForm_le_statement
#check HighDimProb.operatorNorm_eq_max_abs_lambda_statement

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (t : Real) :
    HighDimProb.LambdaMaxBound A t =
      HighDimProb.QuadraticFormUpperBound A t := by
  rfl

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (L : Real) :
    HighDimProb.SpectralUpperBound A L =
      ((((L • (1 : Matrix (Fin n) (Fin n) Real)) - A).PosSemidef)) := by
  rfl

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (L : Real)
    (h : HighDimProb.SpectralUpperBound A L) :
    HighDimProb.RayleighUpperBound A L := by
  exact HighDimProb.rayleighUpperBound_of_spectralUpperBound h

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (L : Real)
    (x : Fin n -> Real) (h : HighDimProb.RayleighUpperBound A L)
    (hx : HighDimProb.IsUnitVector x) :
    HighDimProb.matrixQuadraticForm A x <= L := by
  exact h x hx

example {Omega : Type*} [MeasurableSpace Omega]
    (Z : Omega -> Real) (t : Real) : Set Omega :=
  HighDimProb.scalarUpperTailEvent Z t

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega n n) (Z : Omega -> Real) (t : Real) :
    Set Omega :=
  HighDimProb.matrixUpperBoundTailEvent A Z t

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega n n) (t : Real) : Set Omega :=
  HighDimProb.quadraticFormUpperTailEvent A t

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega n n) (t : Real) :
    HighDimProb.quadraticFormUpperTailEvent A t ⊆
      HighDimProb.twoSidedQuadraticFormTailEvent A t := by
  exact HighDimProb.quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent A t

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) (t : Real)
    (hRayleigh : HighDimProb.matrixQuadraticForm_le_lambdaMax_statement A hA)
    (ht : HighDimProb.lambdaMax A hA <= t) :
    HighDimProb.QuadraticFormUpperBound A t := by
  exact
    HighDimProb.quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax
      hRayleigh ht

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.lambdaMaxOrdered A hA = hA.eigenvalues₀ 0 := by
  exact HighDimProb.lambdaMaxOrdered_eq_eigenvalues₀_zero A hA

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.lambdaMaxOrdered_is_greatest_eigenvalue_statement A hA := by
  exact HighDimProb.lambdaMaxOrdered_is_greatest_eigenvalue A hA

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hBridge : HighDimProb.lambdaMax_eq_lambdaMaxOrdered_statement A hA) :
    HighDimProb.lambdaMax A hA = HighDimProb.lambdaMaxOrdered A hA := by
  exact hBridge

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (x : Fin n -> Real) (hA : A.PosSemidef) :
    0 <= HighDimProb.matrixQuadraticForm A x := by
  exact HighDimProb.matrixQuadraticForm_nonneg_of_posSemidef hA x

example {n : Nat} (x : Fin n -> Real) (c : Real)
    (hx : HighDimProb.IsUnitVector x) :
    HighDimProb.matrixQuadraticForm
      (c • (1 : Matrix (Fin n) (Fin n) Real)) x = c := by
  exact HighDimProb.matrixQuadraticForm_smul_one_of_isUnitVector c hx

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hPSD :
      (((HighDimProb.lambdaMax A hA) •
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) - A).PosSemidef) :
    HighDimProb.matrixQuadraticForm_le_lambdaMax_statement A hA := by
  exact HighDimProb.matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef hPSD

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hPSD : HighDimProb.LambdaMaxPSDUpperBound A hA) :
    HighDimProb.matrixQuadraticForm_le_lambdaMax_statement A hA := by
  exact HighDimProb.matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound hPSD

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hPSD : HighDimProb.LambdaMaxPSDUpperBound A hA) :
    HighDimProb.SpectralUpperBound A (HighDimProb.lambdaMax A hA) := by
  exact HighDimProb.spectralUpperBound_of_lambdaMaxPSDUpperBound hPSD

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hPSD : HighDimProb.LambdaMaxOrderedPSDUpperBound A hA) :
    HighDimProb.matrixQuadraticForm_le_lambdaMaxOrdered_statement A hA := by
  exact
    HighDimProb.matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound
      hPSD

example {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hPSD : HighDimProb.LambdaMaxOrderedPSDUpperBound A hA) :
    HighDimProb.SpectralUpperBound A (HighDimProb.lambdaMaxOrdered A hA) := by
  exact HighDimProb.spectralUpperBound_of_lambdaMaxOrderedPSDUpperBound hPSD

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega n n) (Z : Omega -> Real) (t : Real)
    (hRayleigh :
      forall omega, HighDimProb.RayleighUpperBound (A omega) (Z omega)) :
    HighDimProb.quadraticFormUpperTailEvent A t <=
      HighDimProb.scalarUpperTailEvent Z t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound
      A Z t hRayleigh

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega n n) (Z : Omega -> Real) (t : Real)
    (hRayleigh :
      forall omega, HighDimProb.RayleighUpperBound (A omega) (Z omega)) :
    HighDimProb.quadraticFormUpperTailEvent A t <=
      HighDimProb.matrixUpperBoundTailEvent A Z t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
      A Z t hRayleigh

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega n n) (Z : Omega -> Real) (t : Real)
    (hUpper :
      forall omega, HighDimProb.SpectralUpperBound (A omega) (Z omega)) :
    HighDimProb.quadraticFormUpperTailEvent A t <=
      HighDimProb.matrixUpperBoundTailEvent A Z t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound
      A Z t hUpper

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega (n + 1) (n + 1)) (t : Real)
    (hA : forall omega, HighDimProb.IsSelfAdjointMatrix (A omega))
    (hRayleigh :
      forall omega, HighDimProb.matrixQuadraticForm_le_lambdaMax_statement (A omega) (hA omega)) :
    HighDimProb.quadraticFormUpperTailEvent A t <=
      HighDimProb.lambdaMaxUpperTailEvent A hA t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax
      A t hA hRayleigh

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega (n + 1) (n + 1)) (t : Real)
    (hA : forall omega, HighDimProb.IsSelfAdjointMatrix (A omega)) :
    HighDimProb.lambdaMaxUpperTailEvent A hA t =
      HighDimProb.matrixUpperBoundTailEvent A
        (fun omega => HighDimProb.lambdaMax (A omega) (hA omega)) t := by
  exact HighDimProb.lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent A hA t

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega (n + 1) (n + 1)) (t : Real)
    (hA : forall omega, HighDimProb.IsSelfAdjointMatrix (A omega))
    (hRayleigh :
      forall omega,
        HighDimProb.matrixQuadraticForm_le_lambdaMaxOrdered_statement (A omega) (hA omega)) :
    HighDimProb.quadraticFormUpperTailEvent A t <=
      HighDimProb.lambdaMaxOrderedUpperTailEvent A hA t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
      A t hA hRayleigh

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : HighDimProb.RandomMatrix Omega (n + 1) (n + 1)) (t : Real)
    (hA : forall omega, HighDimProb.IsSelfAdjointMatrix (A omega)) :
    HighDimProb.lambdaMaxOrderedUpperTailEvent A hA t =
      HighDimProb.matrixUpperBoundTailEvent A
        (fun omega => HighDimProb.lambdaMaxOrdered (A omega) (hA omega)) t := by
  exact
    HighDimProb.lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent A hA t

example {Omega : Type*} [MeasurableSpace Omega]
    (A : HighDimProb.RandomMatrix Omega 0 0) (t : Real) :
    HighDimProb.quadraticFormUpperTailEvent A t = ∅ := by
  exact HighDimProb.quadraticFormUpperTailEvent_empty_of_zero_dim A t
