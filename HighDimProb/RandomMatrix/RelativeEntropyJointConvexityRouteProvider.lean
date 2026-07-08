import HighDimProb.RandomMatrix.InverseConvexityProvider
import HighDimProb.RandomMatrix.RelativeEntropyBridgeProvider
import HighDimProb.RandomMatrix.RelativeEntropyLeftRightIntegrandProvider
import Mathlib.MeasureTheory.Function.L1Space.Integrable

/-!
# Left/right route to relative-entropy joint convexity

This provider-facing module ports the thin route assembly sitting immediately
above the fixed-`t` left/right integrand leaf. It keeps the density
integrability and integral-representation facts explicit, and proves that those
premises imply the ambient plain trace-entropy joint-convexity contract and the
carrier `RelativeEntropyJointConvexity` premise consumed by the existing Gibbs
and Epstein bridge layer.

It does not prove the density integrability premise, the left/right integral
representation, Epstein, Lieb, Tropp, Golden-Thompson, or Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory
open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator Matrix.Norms.L2Operator

noncomputable section

namespace RelativeEntropy

/-- Ambient trace-matrix relative entropy shape used by the left/right integral
route, before the affine `-tr T + tr A` correction. -/
def traceMatrixRelativeEntropyPlain {n : Nat}
    (T A : Matrix (Fin n) (Fin n) Real) : Real :=
  Matrix.trace (T * (CFC.log T - CFC.log A))

/-- Carrier relative entropy equals the ambient trace entropy plus the affine
correction used by the Gibbs route. -/
theorem relativeEntropyUnnormalized_eq_traceMatrixRelativeEntropyPlain {n : Nat}
    (T A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    relativeEntropyUnnormalized T A =
      traceMatrixRelativeEntropyPlain
          (T : Matrix (Fin n) (Fin n) Real)
          (A : Matrix (Fin n) (Fin n) Real)
        - Matrix.trace (T : Matrix (Fin n) (Fin n) Real)
        + Matrix.trace (A : Matrix (Fin n) (Fin n) Real) := by
  simp [relativeEntropyUnnormalized, traceMatrixRelativeEntropyPlain,
    Matrix.mul_sub, Matrix.trace_sub]

end RelativeEntropy

/-- Ambient joint-convexity premise for the plain trace relative entropy. -/
abbrev TraceMatrixRelativeEntropyPlainJointConvexity : Prop :=
  forall {n : Nat} (T0 T1 A0 A1 : Matrix (Fin n) (Fin n) Real),
    T0.PosDef ->
    T1.PosDef ->
    A0.PosDef ->
    A1.PosDef ->
    forall {a b : Real}, 0 <= a -> 0 <= b -> a + b = 1 ->
      let T := SMul.smul a T0 + SMul.smul b T1
      let A := SMul.smul a A0 + SMul.smul b A1
      RelativeEntropy.traceMatrixRelativeEntropyPlain T A
        <=
      a * RelativeEntropy.traceMatrixRelativeEntropyPlain T0 A0
        + b * RelativeEntropy.traceMatrixRelativeEntropyPlain T1 A1

/-- Convert ambient plain trace-entropy joint convexity into the existing
carrier hard premise. -/
theorem relativeEntropyJointConvexity_of_traceMatrixRelativeEntropyPlain_jointConvex
    (hj : TraceMatrixRelativeEntropyPlainJointConvexity) :
    RelativeEntropyJointConvexity := by
  intro n T0 T1 A0 A1 hT0 hT1 hA0 hA1 a b ha hb hab
  have hT0pd : ((T0 : Matrix (Fin n) (Fin n) Real)).PosDef :=
    (mem_selfAdjointStrictlyPositiveSet_iff_posDef).mp hT0
  have hT1pd : ((T1 : Matrix (Fin n) (Fin n) Real)).PosDef :=
    (mem_selfAdjointStrictlyPositiveSet_iff_posDef).mp hT1
  have hA0pd : ((A0 : Matrix (Fin n) (Fin n) Real)).PosDef :=
    (mem_selfAdjointStrictlyPositiveSet_iff_posDef).mp hA0
  have hA1pd : ((A1 : Matrix (Fin n) (Fin n) Real)).PosDef :=
    (mem_selfAdjointStrictlyPositiveSet_iff_posDef).mp hA1
  have hPlain :=
    hj (T0 : Matrix (Fin n) (Fin n) Real)
      (T1 : Matrix (Fin n) (Fin n) Real)
      (A0 : Matrix (Fin n) (Fin n) Real)
      (A1 : Matrix (Fin n) (Fin n) Real)
      hT0pd hT1pd hA0pd hA1pd ha hb hab
  have hPlainCarrier :
      RelativeEntropy.traceMatrixRelativeEntropyPlain
          (((SMul.smul a T0 + SMul.smul b T1 :
              selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
              Matrix (Fin n) (Fin n) Real))
          (((SMul.smul a A0 + SMul.smul b A1 :
              selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
              Matrix (Fin n) (Fin n) Real))
        <=
      a * RelativeEntropy.traceMatrixRelativeEntropyPlain
          (T0 : Matrix (Fin n) (Fin n) Real)
          (A0 : Matrix (Fin n) (Fin n) Real)
        + b * RelativeEntropy.traceMatrixRelativeEntropyPlain
          (T1 : Matrix (Fin n) (Fin n) Real)
          (A1 : Matrix (Fin n) (Fin n) Real) := by
    simpa using hPlain
  have hTraceT :
      Matrix.trace (((SMul.smul a T0 + SMul.smul b T1 :
          selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real)) =
        a * Matrix.trace (T0 : Matrix (Fin n) (Fin n) Real)
          + b * Matrix.trace (T1 : Matrix (Fin n) (Fin n) Real) := by
    change Matrix.trace ((a : Real) • (T0 : Matrix (Fin n) (Fin n) Real)
      + b • (T1 : Matrix (Fin n) (Fin n) Real)) = _
    simp [Matrix.trace_add]
  have hTraceA :
      Matrix.trace (((SMul.smul a A0 + SMul.smul b A1 :
          selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real)) =
        a * Matrix.trace (A0 : Matrix (Fin n) (Fin n) Real)
          + b * Matrix.trace (A1 : Matrix (Fin n) (Fin n) Real) := by
    change Matrix.trace ((a : Real) • (A0 : Matrix (Fin n) (Fin n) Real)
      + b • (A1 : Matrix (Fin n) (Fin n) Real)) = _
    simp [Matrix.trace_add]
  rw [RelativeEntropy.relativeEntropyUnnormalized_eq_traceMatrixRelativeEntropyPlain,
    RelativeEntropy.relativeEntropyUnnormalized_eq_traceMatrixRelativeEntropyPlain,
    RelativeEntropy.relativeEntropyUnnormalized_eq_traceMatrixRelativeEntropyPlain]
  rw [hTraceT, hTraceA]
  nlinarith [hPlainCarrier]

/-- The weighted left/right integrand is integrable on `(0, inf)` for every
positive-definite pair. This remains an explicit premise in this route module. -/
abbrev LeftRightRelativeEntropyIntegrandDensityIntegrable : Prop :=
  forall {n : Nat} {T A : Matrix (Fin n) (Fin n) Real},
    T.PosDef ->
    A.PosDef ->
    IntegrableOn
      (fun t : Real =>
        (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A)
      (Set.Ioi (0 : Real))

/-- The plain trace relative entropy is represented by the affine trace term
plus the weighted left/right integral. -/
abbrev TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation : Prop :=
  forall {n : Nat} {T A : Matrix (Fin n) (Fin n) Real},
    T.PosDef ->
    A.PosDef ->
    RelativeEntropy.traceMatrixRelativeEntropyPlain T A =
      Matrix.trace (T - A) +
        ∫ t in Set.Ioi (0 : Real),
          (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A

/-- Assemble the density integrability, integral representation, and fixed-`t`
integrand convexity leaf into ambient plain trace-entropy joint convexity. -/
theorem traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight_density_integral_representation
    (hInt : LeftRightRelativeEntropyIntegrandDensityIntegrable)
    (hRepr : TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation) :
    TraceMatrixRelativeEntropyPlainJointConvexity := by
  intro n T0 T1 A0 A1 hT0 hT1 hA0 hA1 a b ha hb hab T A
  have hT : T.PosDef := by
    have hb1 : b <= 1 := by nlinarith
    have hsum : (((1 - b) • T0) + b • T1).PosDef :=
      convexCombo_posDef_of_posDef T0 T1 hT0 hT1 hb hb1
    have hEq : a • T0 + b • T1 = ((1 - b) • T0) + b • T1 := by
      ext i j
      have ha_eq : a = 1 - b := by nlinarith [hab]
      simp [ha_eq]
    simpa [T] using hEq ▸ hsum
  have hA : A.PosDef := by
    have hb1 : b <= 1 := by nlinarith
    have hsum : (((1 - b) • A0) + b • A1).PosDef :=
      convexCombo_posDef_of_posDef A0 A1 hA0 hA1 hb hb1
    have hEq : a • A0 + b • A1 = ((1 - b) • A0) + b • A1 := by
      ext i j
      have ha_eq : a = 1 - b := by nlinarith [hab]
      simp [ha_eq]
    simpa [A] using hEq ▸ hsum
  let s : Set Real := Set.Ioi (0 : Real)
  let g : Matrix (Fin n) (Fin n) Real -> Matrix (Fin n) (Fin n) Real -> Real -> Real :=
    fun X Y t =>
      (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t X Y
  have hrepr :
      RelativeEntropy.traceMatrixRelativeEntropyPlain T A =
        Matrix.trace (T - A) + ∫ t in s, g T A t := by
    change RelativeEntropy.traceMatrixRelativeEntropyPlain T A =
      Matrix.trace (T - A) + ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A
    exact hRepr hT hA
  have hrepr0 :
      RelativeEntropy.traceMatrixRelativeEntropyPlain T0 A0 =
        Matrix.trace (T0 - A0) + ∫ t in s, g T0 A0 t := by
    change RelativeEntropy.traceMatrixRelativeEntropyPlain T0 A0 =
      Matrix.trace (T0 - A0) + ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T0 A0
    exact hRepr hT0 hA0
  have hrepr1 :
      RelativeEntropy.traceMatrixRelativeEntropyPlain T1 A1 =
        Matrix.trace (T1 - A1) + ∫ t in s, g T1 A1 t := by
    change RelativeEntropy.traceMatrixRelativeEntropyPlain T1 A1 =
      Matrix.trace (T1 - A1) + ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T1 A1
    exact hRepr hT1 hA1
  have hg_int : Integrable (fun t => g T A t) (volume.restrict s) := by
    change IntegrableOn
      (fun t : Real =>
        (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A)
      (Set.Ioi (0 : Real))
    exact hInt hT hA
  have hg0_int : Integrable (fun t => g T0 A0 t) (volume.restrict s) := by
    change IntegrableOn
      (fun t : Real =>
        (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T0 A0)
      (Set.Ioi (0 : Real))
    exact hInt hT0 hA0
  have hg1_int : Integrable (fun t => g T1 A1 t) (volume.restrict s) := by
    change IntegrableOn
      (fun t : Real =>
        (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T1 A1)
      (Set.Ioi (0 : Real))
    exact hInt hT1 hA1
  have hrhs_int : Integrable
      (fun t => a * g T0 A0 t + b * g T1 A1 t) (volume.restrict s) :=
    (hg0_int.const_mul a).add (hg1_int.const_mul b)
  have hpoint :
      g T A ≤ᵐ[volume.restrict s] fun t => a * g T0 A0 t + b * g T1 A1 t := by
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    have hdensity : 0 <= t / (1 + t) ^ 2 :=
      div_nonneg (le_of_lt ht) (sq_nonneg (1 + t))
    have hconv :=
      RelativeEntropy.leftRightRelativeEntropyIntegrand_jointConvex
        (n := Fin n) hT0 hT1 hA0 hA1 (t := t) (le_of_lt ht)
        (a := a) (b := b) ha hb hab
    change
      (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A <=
        a * ((t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T0 A0) +
          b * ((t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T1 A1)
    calc
      (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A <=
          (t / (1 + t) ^ 2) *
            (a * RelativeEntropy.leftRightRelativeEntropyIntegrand t T0 A0 +
              b * RelativeEntropy.leftRightRelativeEntropyIntegrand t T1 A1) := by
        exact mul_le_mul_of_nonneg_left (by simpa [T, A] using hconv) hdensity
      _ = a * ((t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T0 A0) +
          b * ((t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T1 A1) := by
        ring
  have hint_le :
      (∫ t in s, g T A t) <=
        ∫ t in s, a * g T0 A0 t + b * g T1 A1 t :=
    setIntegral_mono_ae_restrict hg_int hrhs_int hpoint
  have hrhs_integral :
      (∫ t in s, a * g T0 A0 t + b * g T1 A1 t) =
        a * (∫ t in s, g T0 A0 t) + b * (∫ t in s, g T1 A1 t) := by
    rw [integral_add (hg0_int.const_mul a) (hg1_int.const_mul b),
      integral_const_mul, integral_const_mul]
  have hint_le' :
      (∫ t in s, g T A t) <=
        a * (∫ t in s, g T0 A0 t) + b * (∫ t in s, g T1 A1 t) := by
    rw [hrhs_integral] at hint_le
    exact hint_le
  have htrace_affine :
      Matrix.trace (T - A) =
        a * Matrix.trace (T0 - A0) + b * Matrix.trace (T1 - A1) := by
    have htraceT :
        Matrix.trace T = a * Matrix.trace T0 + b * Matrix.trace T1 := by
      change Matrix.trace (a • T0 + b • T1) = _
      rw [Matrix.trace_add, Matrix.trace_smul, Matrix.trace_smul]
      simp [smul_eq_mul]
    have htraceA :
        Matrix.trace A = a * Matrix.trace A0 + b * Matrix.trace A1 := by
      change Matrix.trace (a • A0 + b • A1) = _
      rw [Matrix.trace_add, Matrix.trace_smul, Matrix.trace_smul]
      simp [smul_eq_mul]
    calc
      Matrix.trace (T - A) = Matrix.trace T - Matrix.trace A := by
        simp
      _ = (a * Matrix.trace T0 + b * Matrix.trace T1) -
          (a * Matrix.trace A0 + b * Matrix.trace A1) := by
        rw [htraceT, htraceA]
      _ = a * Matrix.trace (T0 - A0) + b * Matrix.trace (T1 - A1) := by
        rw [Matrix.trace_sub, Matrix.trace_sub]
        ring
  calc
    RelativeEntropy.traceMatrixRelativeEntropyPlain T A =
        Matrix.trace (T - A) + ∫ t in s, g T A t := hrepr
    _ <= Matrix.trace (T - A) +
        (a * (∫ t in s, g T0 A0 t) + b * (∫ t in s, g T1 A1 t)) := by
      exact add_le_add le_rfl hint_le'
    _ = a * (Matrix.trace (T0 - A0) + ∫ t in s, g T0 A0 t) +
        b * (Matrix.trace (T1 - A1) + ∫ t in s, g T1 A1 t) := by
      rw [htrace_affine]
      ring
    _ = a * RelativeEntropy.traceMatrixRelativeEntropyPlain T0 A0 +
        b * RelativeEntropy.traceMatrixRelativeEntropyPlain T1 A1 := by
      rw [show Matrix.trace (T0 - A0) + ∫ t in s, g T0 A0 t =
          RelativeEntropy.traceMatrixRelativeEntropyPlain T0 A0 by
            exact hrepr0.symm]
      rw [show Matrix.trace (T1 - A1) + ∫ t in s, g T1 A1 t =
          RelativeEntropy.traceMatrixRelativeEntropyPlain T1 A1 by
            exact hrepr1.symm]

/-- The left/right density and integral-representation premises imply the
carrier relative-entropy joint-convexity premise used by the Gibbs bridge. -/
theorem relativeEntropyJointConvexity_of_leftRight_density_integral_representation
    (hInt : LeftRightRelativeEntropyIntegrandDensityIntegrable)
    (hRepr : TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation) :
    RelativeEntropyJointConvexity :=
  relativeEntropyJointConvexity_of_traceMatrixRelativeEntropyPlain_jointConvex
    (traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight_density_integral_representation
      hInt hRepr)

namespace RelativeEntropy

/-- Carrier Lieb concavity from the left/right density/integral route and full
matrix Klein. -/
theorem fullKlein_liebCarrierConcavity_of_leftRight_density_integral_representation
    (hInt : LeftRightRelativeEntropyIntegrandDensityIntegrable)
    (hRepr : TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation) :
    forall {n : Nat} (H : Matrix (Fin n) (Fin n) Real),
      IsSelfAdjointMatrix H ->
        ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
          (fun A : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
            traceMatrixExp (H + CFC.log (A : Matrix (Fin n) (Fin n) Real))) :=
  fullKlein_liebCarrierConcavity
    (relativeEntropyJointConvexity_of_leftRight_density_integral_representation hInt hRepr)

/-- Ambient Lieb concavity from the left/right density/integral route and full
matrix Klein. -/
theorem fullKlein_liebConcavity_of_leftRight_density_integral_representation
    (hInt : LeftRightRelativeEntropyIntegrandDensityIntegrable)
    (hRepr : TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation)
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    liebTraceExpConcavity_statement H :=
  fullKlein_liebConcavity
    (relativeEntropyJointConvexity_of_leftRight_density_integral_representation hInt hRepr) H

/-- Epstein affine-line concavity from the left/right density/integral route and
full matrix Klein. -/
theorem fullKlein_epsteinConcavity_of_leftRight_density_integral_representation
    (hInt : LeftRightRelativeEntropyIntegrandDensityIntegrable)
    (hRepr : TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation) :
    EpsteinAffineLineConcavity :=
  fullKlein_epsteinConcavity
    (relativeEntropyJointConvexity_of_leftRight_density_integral_representation hInt hRepr)

end RelativeEntropy

/-- Root-level Lieb concavity facade from the left/right density/integral route
and full matrix Klein. -/
theorem liebTraceExpConcavity_statement_of_leftRight_density_integral_representation
    (hInt : LeftRightRelativeEntropyIntegrandDensityIntegrable)
    (hRepr : TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation)
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    liebTraceExpConcavity_statement H :=
  RelativeEntropy.fullKlein_liebConcavity_of_leftRight_density_integral_representation
    hInt hRepr H

/-- Root-level Epstein facade from the left/right density/integral route and
full matrix Klein. -/
theorem epsteinAffineLineConcavity_of_leftRight_density_integral_representation
    (hInt : LeftRightRelativeEntropyIntegrandDensityIntegrable)
    (hRepr : TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation) :
    EpsteinAffineLineConcavity :=
  RelativeEntropy.fullKlein_epsteinConcavity_of_leftRight_density_integral_representation
    hInt hRepr

end

end HighDimProb
