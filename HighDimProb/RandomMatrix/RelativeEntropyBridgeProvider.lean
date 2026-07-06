import HighDimProb.RandomMatrix.EpsteinProvider
import HighDimProb.RandomMatrix.RelativeEntropyProvider

/-!
# Relative-entropy conditional bridge provider

This module exposes the stable conditional bridge surface for the
relative-entropy route: named log-shift/Gibbs adapters, the minimal
joint-convexity/Gibbs facade needed downstream by Epstein consumers, and the
carrier-to-ambient Epstein transport.

It consumes full matrix Klein from `RelativeEntropyProvider` to discharge the
Gibbs upper-bound premise, but still keeps relative-entropy joint convexity,
Epstein, and Lieb as explicit downstream hard premises.
-/

namespace HighDimProb

open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator Matrix.Norms.L2Operator

noncomputable section

namespace RelativeEntropy

/-- Unnormalized relative entropy on the strictly positive self-adjoint carrier. -/
def relativeEntropyUnnormalized {n : Nat}
    (T A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Real :=
  Matrix.trace ((T : Matrix (Fin n) (Fin n) Real) * CFC.log (T : Matrix (Fin n) (Fin n) Real))
    - Matrix.trace ((T : Matrix (Fin n) (Fin n) Real) * CFC.log (A : Matrix (Fin n) (Fin n) Real))
    - Matrix.trace (T : Matrix (Fin n) (Fin n) Real)
    + Matrix.trace (A : Matrix (Fin n) (Fin n) Real)

/-- The reusable log-shift point `H + log A` in the Gibbs/Epstein bridge. -/
def logShift {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real :=
  H + CFC.log (A : Matrix (Fin n) (Fin n) Real)

/-- Matrix exponential of the log-shift point `H + log A`. -/
def expLogMatrix {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real :=
  matrixExp (logShift H A)

/-- Carrier Gibbs objective in the `H + log A` normal form. -/
def gibbsObjective {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (T A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Real :=
  Matrix.trace ((T : Matrix (Fin n) (Fin n) Real) * H)
    - relativeEntropyUnnormalized T A
    + Matrix.trace (A : Matrix (Fin n) (Fin n) Real)

/-- Algebraic rewrite exposing the usual carrier Gibbs objective form. -/
theorem gibbsObjective_eq_trace_shift_sub_relativeEntropy
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (T A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    gibbsObjective H T A =
      Matrix.trace ((T : Matrix (Fin n) (Fin n) Real) * logShift H A)
        - Matrix.trace ((T : Matrix (Fin n) (Fin n) Real) *
            CFC.log (T : Matrix (Fin n) (Fin n) Real))
        + Matrix.trace (T : Matrix (Fin n) (Fin n) Real) := by
  simp [gibbsObjective, relativeEntropyUnnormalized, logShift, Matrix.mul_add, Matrix.trace_add]
  ring

/-- The explicit Gibbs witness `exp (H + log A)` bundled on the self-adjoint carrier. -/
def expLogWitness {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (A : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (hH : IsSelfAdjointMatrix H) :
    selfAdjoint (Matrix (Fin n) (Fin n) Real) := by
  have hL : IsSelfAdjointMatrix (logShift H A) := by
    simpa [logShift] using hH.add (isSelfAdjointMatrix_cfc_log A.2)
  exact Subtype.mk (expLogMatrix H A) (by
    simpa [expLogMatrix] using (((matrixExpLogDomainForSelfAdjoint (logShift H A)) hL).1))

/-- The Gibbs witness stays inside the strictly positive carrier domain. -/
theorem expLogWitness_mem_selfAdjointStrictlyPositiveSet
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (A : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (hH : IsSelfAdjointMatrix H) :
    Set.Mem (selfAdjointStrictlyPositiveSet n) (expLogWitness H A hH) := by
  have hL : IsSelfAdjointMatrix (logShift H A) := by
    simpa [logShift] using hH.add (isSelfAdjointMatrix_cfc_log A.2)
  have hDom := (matrixExpLogDomainForSelfAdjoint (logShift H A)) hL
  simpa [expLogWitness, expLogMatrix, mem_selfAdjointStrictlyPositiveSet] using hDom.2.1

/-- Carrier-side Gibbs upper bound specialized to the named log-shift point. -/
theorem carrierGibbs_le_traceMatrixExp_of_kleinPremise
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (T A : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (hH : IsSelfAdjointMatrix H)
    (hKlein :
      0 <= Matrix.trace
          (((T : Matrix (Fin n) (Fin n) Real)) *
            CFC.log ((T : Matrix (Fin n) (Fin n) Real))) -
        Matrix.trace
          (((T : Matrix (Fin n) (Fin n) Real)) * CFC.log (expLogMatrix H A)) -
        Matrix.trace ((T : Matrix (Fin n) (Fin n) Real)) +
        Matrix.trace (expLogMatrix H A)) :
    Matrix.trace (((T : Matrix (Fin n) (Fin n) Real)) * logShift H A) -
        Matrix.trace (((T : Matrix (Fin n) (Fin n) Real)) *
          CFC.log ((T : Matrix (Fin n) (Fin n) Real))) +
      Matrix.trace ((T : Matrix (Fin n) (Fin n) Real)) <= traceMatrixExp (logShift H A) := by
  have hHA : IsSelfAdjointMatrix (logShift H A) := by
    simpa [logShift] using hH.add (isSelfAdjointMatrix_cfc_log A.2)
  have hNorm : CFC.log (expLogMatrix H A) = logShift H A := by
    simpa [expLogMatrix] using (matrixExpLogSelfAdjointNormalization (logShift H A)) hHA
  have hTraceLog :
      Matrix.trace (((T : Matrix (Fin n) (Fin n) Real)) * CFC.log (expLogMatrix H A)) =
        Matrix.trace (((T : Matrix (Fin n) (Fin n) Real)) * logShift H A) := by
    rw [hNorm]
  rw [show traceMatrixExp (logShift H A) = Matrix.trace (expLogMatrix H A) by rfl]
  linarith [hKlein, hTraceLog]

/-- Carrier-side Gibbs equality witness specialized to the named log-shift point. -/
theorem carrierGibbs_eq_traceMatrixExp_at_matrixExp_logPoint
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (A : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (hH : IsSelfAdjointMatrix H) :
    Matrix.trace (expLogMatrix H A * logShift H A) -
      Matrix.trace (expLogMatrix H A * CFC.log (expLogMatrix H A)) +
      Matrix.trace (expLogMatrix H A) = traceMatrixExp (logShift H A) := by
  have hHA : IsSelfAdjointMatrix (logShift H A) := by
    simpa [logShift] using hH.add (isSelfAdjointMatrix_cfc_log A.2)
  have hNorm : CFC.log (expLogMatrix H A) = logShift H A := by
    simpa [expLogMatrix] using (matrixExpLogSelfAdjointNormalization (logShift H A)) hHA
  have hTraceLog : Matrix.trace (expLogMatrix H A * CFC.log (expLogMatrix H A)) =
      Matrix.trace (expLogMatrix H A * logShift H A) := by
    rw [hNorm]
  rw [show traceMatrixExp (logShift H A) = Matrix.trace (expLogMatrix H A) by rfl]
  rw [hTraceLog]
  ring

/-- Equality at the explicit Gibbs witness in carrier form. -/
theorem gibbsObjective_eq_traceMatrixExp_at_expLogWitness
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (A : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (hH : IsSelfAdjointMatrix H) :
    gibbsObjective H (expLogWitness H A hH) A = traceMatrixExp (logShift H A) := by
  rw [gibbsObjective_eq_trace_shift_sub_relativeEntropy]
  dsimp [expLogWitness]
  simpa [expLogMatrix] using carrierGibbs_eq_traceMatrixExp_at_matrixExp_logPoint H A hH

end RelativeEntropy

/-- Transport carrier concavity on the strictly positive self-adjoint domain
back to the ambient affine-line Epstein contract. This is a pure domain/coercion
wrapper: it does not prove relative entropy joint convexity, Gibbs, or Epstein
itself. -/
theorem epsteinAffineLineConcavity_of_liebTraceExpConcavity_selfAdjointCarrier
    (hCarrier :
      forall {n : Nat} (H : Matrix (Fin n) (Fin n) Real),
        IsSelfAdjointMatrix H ->
          ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
            (fun A : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
              traceMatrixExp (RelativeEntropy.logShift H A))) :
    EpsteinAffineLineConcavity := by
  intro n H A C hH hA hC hPos
  let linePoint : Real -> selfAdjoint (Matrix (Fin n) (Fin n) Real) := fun t =>
    Subtype.mk (A + SMul.smul t C) (by
      have ht : IsSelfAdjoint t := by
        simp [IsSelfAdjoint]
      change (A + SMul.smul t C).IsHermitian
      exact hA.add (hC.smul ht))
  have hCarrierConcave := hCarrier H hH
  constructor
  . simpa using convex_Icc (0 : Real) 1
  . intro x hx y hy a b ha hb hab
    have hxLine : Set.Mem (selfAdjointStrictlyPositiveSet n) (linePoint x) := by
      simpa [linePoint] using hPos x hx
    have hyLine : Set.Mem (selfAdjointStrictlyPositiveSet n) (linePoint y) := by
      simpa [linePoint] using hPos y hy
    have hLineIneq := hCarrierConcave.2 hxLine hyLine ha hb hab
    have hWeighted :
        (((SMul.smul a (linePoint x) + SMul.smul b (linePoint y) :
            selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
            Matrix (Fin n) (Fin n) Real)) =
          A + SMul.smul (a * x + b * y) C := by
      ext i j
      change a * (A i j + x * C i j) + b * (A i j + y * C i j) =
        A i j + (a * x + b * y) * C i j
      ring_nf
      have hCoeff : a * A i j + A i j * b = A i j := by
        calc
          a * A i j + A i j * b = (a + b) * A i j := by ring
          _ = A i j := by rw [hab]; ring
      linarith [hCoeff]
    have hxEval :
        traceMatrixExp (H + CFC.log ((linePoint x : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real)) =
          traceMatrixExp (H + CFC.log (A + SMul.smul x C)) := by
      rfl
    have hyEval :
        traceMatrixExp (H + CFC.log ((linePoint y : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real)) =
          traceMatrixExp (H + CFC.log (A + SMul.smul y C)) := by
      rfl
    calc
      a * traceMatrixExp (H + CFC.log (A + SMul.smul x C)) +
          b * traceMatrixExp (H + CFC.log (A + SMul.smul y C))
          = a * traceMatrixExp
              (H +
                CFC.log
                  (((linePoint x : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                    Matrix (Fin n) (Fin n) Real))) +
            b * traceMatrixExp
              (H +
                CFC.log
                  (((linePoint y : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                    Matrix (Fin n) (Fin n) Real))) := by
              rw [hxEval, hyEval]
      _ <= traceMatrixExp
            (H +
              CFC.log
                ((((SMul.smul a (linePoint x) + SMul.smul b (linePoint y) :
                    selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                    Matrix (Fin n) (Fin n) Real)))) := by
              simpa [smul_eq_mul] using hLineIneq
      _ = traceMatrixExp (H + CFC.log (A + SMul.smul (a * x + b * y) C)) := by
            rw [hWeighted]

/-- Hard premise: joint convexity of unnormalized relative entropy on the
strictly positive self-adjoint carrier, stated in the exact two-point form used
by the Gibbs-to-Epstein bridge. -/
abbrev RelativeEntropyJointConvexity : Prop :=
  forall {n : Nat}
      (T0 T1 A0 A1 : selfAdjoint (Matrix (Fin n) (Fin n) Real)),
    Set.Mem (selfAdjointStrictlyPositiveSet n) T0 ->
    Set.Mem (selfAdjointStrictlyPositiveSet n) T1 ->
    Set.Mem (selfAdjointStrictlyPositiveSet n) A0 ->
    Set.Mem (selfAdjointStrictlyPositiveSet n) A1 ->
    forall {a b : Real}, 0 <= a -> 0 <= b -> a + b = 1 ->
      RelativeEntropy.relativeEntropyUnnormalized
          (SMul.smul a T0 + SMul.smul b T1)
          (SMul.smul a A0 + SMul.smul b A1)
        <=
      a * RelativeEntropy.relativeEntropyUnnormalized T0 A0
        + b * RelativeEntropy.relativeEntropyUnnormalized T1 A1

/-- Reusable Gibbs upper-bound premise kept as the conditional facade for the
relative-entropy route. Full matrix Klein discharges it below, but downstream
proofs may still consume this premise directly. -/
abbrev GibbsVariationalUpperBoundPremise : Prop :=
  forall {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
      (_hH : IsSelfAdjointMatrix H)
      (T A : selfAdjoint (Matrix (Fin n) (Fin n) Real)),
    Set.Mem (selfAdjointStrictlyPositiveSet n) T ->
    Set.Mem (selfAdjointStrictlyPositiveSet n) A ->
    RelativeEntropy.gibbsObjective H T A <=
      traceMatrixExp (RelativeEntropy.logShift H A)

private theorem gibbsObjective_convex_combo_le_of_relativeEntropyJointConvexity
    (hRE : RelativeEntropyJointConvexity)
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (T0 T1 A0 A1 : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (hT0 : Set.Mem (selfAdjointStrictlyPositiveSet n) T0)
    (hT1 : Set.Mem (selfAdjointStrictlyPositiveSet n) T1)
    (hA0 : Set.Mem (selfAdjointStrictlyPositiveSet n) A0)
    (hA1 : Set.Mem (selfAdjointStrictlyPositiveSet n) A1)
    {a b : Real} (ha : 0 <= a) (hb : 0 <= b) (hab : a + b = 1) :
    a * RelativeEntropy.gibbsObjective H T0 A0
      + b * RelativeEntropy.gibbsObjective H T1 A1
      <=
    RelativeEntropy.gibbsObjective H (SMul.smul a T0 + SMul.smul b T1)
      (SMul.smul a A0 + SMul.smul b A1) := by
  have hConv := hRE T0 T1 A0 A1 hT0 hT1 hA0 hA1 ha hb hab
  have hMulT0 :
      (SMul.smul a (T0 : Matrix (Fin n) (Fin n) Real)) * H =
        SMul.smul a (((T0 : Matrix (Fin n) (Fin n) Real) * H)) := by
    exact smul_mul_assoc a (T0 : Matrix (Fin n) (Fin n) Real) H
  have hMulT1 :
      (SMul.smul b (T1 : Matrix (Fin n) (Fin n) Real)) * H =
        SMul.smul b (((T1 : Matrix (Fin n) (Fin n) Real) * H)) := by
    exact smul_mul_assoc b (T1 : Matrix (Fin n) (Fin n) Real) H
  have hTraceSmulT0 :
      Matrix.trace (SMul.smul a (((T0 : Matrix (Fin n) (Fin n) Real) * H))) =
        a * Matrix.trace (((T0 : Matrix (Fin n) (Fin n) Real) * H)) := by
    exact Matrix.trace_smul a (((T0 : Matrix (Fin n) (Fin n) Real) * H))
  have hTraceSmulT1 :
      Matrix.trace (SMul.smul b (((T1 : Matrix (Fin n) (Fin n) Real) * H))) =
        b * Matrix.trace (((T1 : Matrix (Fin n) (Fin n) Real) * H)) := by
    exact Matrix.trace_smul b (((T1 : Matrix (Fin n) (Fin n) Real) * H))
  have hTraceH :
      Matrix.trace ((((SMul.smul a T0 + SMul.smul b T1 :
            selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
            Matrix (Fin n) (Fin n) Real) * H)) =
        a * Matrix.trace (((T0 : Matrix (Fin n) (Fin n) Real) * H)) +
          b * Matrix.trace (((T1 : Matrix (Fin n) (Fin n) Real) * H)) := by
    change Matrix.trace ((SMul.smul a (T0 : Matrix (Fin n) (Fin n) Real) +
        SMul.smul b (T1 : Matrix (Fin n) (Fin n) Real)) * H) = _
    rw [Matrix.add_mul, Matrix.trace_add, hMulT0, hMulT1, hTraceSmulT0, hTraceSmulT1]
  have hTraceSmulA0 :
      Matrix.trace (SMul.smul a (A0 : Matrix (Fin n) (Fin n) Real)) =
        a * Matrix.trace (A0 : Matrix (Fin n) (Fin n) Real) := by
    exact Matrix.trace_smul a (A0 : Matrix (Fin n) (Fin n) Real)
  have hTraceSmulA1 :
      Matrix.trace (SMul.smul b (A1 : Matrix (Fin n) (Fin n) Real)) =
        b * Matrix.trace (A1 : Matrix (Fin n) (Fin n) Real) := by
    exact Matrix.trace_smul b (A1 : Matrix (Fin n) (Fin n) Real)
  have hTraceA :
      Matrix.trace (((SMul.smul a A0 + SMul.smul b A1 :
            selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
            Matrix (Fin n) (Fin n) Real)) =
        a * Matrix.trace (A0 : Matrix (Fin n) (Fin n) Real) +
          b * Matrix.trace (A1 : Matrix (Fin n) (Fin n) Real) := by
    change Matrix.trace (SMul.smul a (A0 : Matrix (Fin n) (Fin n) Real) +
        SMul.smul b (A1 : Matrix (Fin n) (Fin n) Real)) = _
    rw [Matrix.trace_add, hTraceSmulA0, hTraceSmulA1]
  unfold RelativeEntropy.gibbsObjective
  rw [hTraceH, hTraceA]
  linarith

/-- Honest carrier concavity bridge from relative-entropy joint convexity plus
an explicit Gibbs upper-bound premise. -/
theorem liebTraceExpConcavity_selfAdjointCarrier_of_relativeEntropyJointConvexity_and_gibbsUpperBoundPremise
    (hRE : RelativeEntropyJointConvexity)
    (hGibbs : GibbsVariationalUpperBoundPremise) :
    forall {n : Nat} (H : Matrix (Fin n) (Fin n) Real),
      IsSelfAdjointMatrix H ->
        ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
          (fun A : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
            traceMatrixExp (RelativeEntropy.logShift H A)) := by
  intro n H hH
  constructor
  . exact convex_selfAdjointStrictlyPositiveSet n
  . intro A hA B hB a b ha hb hab
    let TA := RelativeEntropy.expLogWitness H A hH
    let TB := RelativeEntropy.expLogWitness H B hH
    have hTA : Set.Mem (selfAdjointStrictlyPositiveSet n) TA := by
      simpa [TA] using RelativeEntropy.expLogWitness_mem_selfAdjointStrictlyPositiveSet H A hH
    have hTB : Set.Mem (selfAdjointStrictlyPositiveSet n) TB := by
      simpa [TB] using RelativeEntropy.expLogWitness_mem_selfAdjointStrictlyPositiveSet H B hH
    have hMixT : Set.Mem (selfAdjointStrictlyPositiveSet n) (SMul.smul a TA + SMul.smul b TB) :=
      (convex_selfAdjointStrictlyPositiveSet n) hTA hTB ha hb hab
    have hMixA : Set.Mem (selfAdjointStrictlyPositiveSet n) (SMul.smul a A + SMul.smul b B) :=
      (convex_selfAdjointStrictlyPositiveSet n) hA hB ha hb hab
    have hEqA :
        RelativeEntropy.gibbsObjective H TA A =
          traceMatrixExp (RelativeEntropy.logShift H A) := by
      simpa [TA] using RelativeEntropy.gibbsObjective_eq_traceMatrixExp_at_expLogWitness H A hH
    have hEqB :
        RelativeEntropy.gibbsObjective H TB B =
          traceMatrixExp (RelativeEntropy.logShift H B) := by
      simpa [TB] using RelativeEntropy.gibbsObjective_eq_traceMatrixExp_at_expLogWitness H B hH
    have hConcaveGibbs :=
      gibbsObjective_convex_combo_le_of_relativeEntropyJointConvexity
        hRE H TA TB A B hTA hTB hA hB ha hb hab
    have hUpperMixed :=
      hGibbs H hH (SMul.smul a TA + SMul.smul b TB) (SMul.smul a A + SMul.smul b B) hMixT hMixA
    calc
      a * traceMatrixExp (RelativeEntropy.logShift H A) +
          b * traceMatrixExp (RelativeEntropy.logShift H B)
          =
            a * RelativeEntropy.gibbsObjective H TA A +
              b * RelativeEntropy.gibbsObjective H TB B := by
                rw [hEqA, hEqB]
      _ <= RelativeEntropy.gibbsObjective H (SMul.smul a TA + SMul.smul b TB) (SMul.smul a A + SMul.smul b B) :=
        hConcaveGibbs
      _ <= traceMatrixExp
            (H + CFC.log (((SMul.smul a A + SMul.smul b B :
                selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                Matrix (Fin n) (Fin n) Real))) :=
        by simpa [RelativeEntropy.logShift] using hUpperMixed

/-- Honest Epstein consumer bridge from relative-entropy joint convexity plus
the explicit Gibbs upper-bound premise. -/
theorem epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_gibbsUpperBoundPremise
    (hRE : RelativeEntropyJointConvexity)
    (hGibbs : GibbsVariationalUpperBoundPremise) :
    EpsteinAffineLineConcavity :=
  epsteinAffineLineConcavity_of_liebTraceExpConcavity_selfAdjointCarrier
    (liebTraceExpConcavity_selfAdjointCarrier_of_relativeEntropyJointConvexity_and_gibbsUpperBoundPremise
      hRE hGibbs)

/-- Full-Klein-style pointwise premise in the named log-shift normal form needed
by the Gibbs bridge. -/
abbrev GibbsKleinPremise : Prop :=
  forall {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
      (_hH : IsSelfAdjointMatrix H)
      (T A : selfAdjoint (Matrix (Fin n) (Fin n) Real)),
    Set.Mem (selfAdjointStrictlyPositiveSet n) T ->
    Set.Mem (selfAdjointStrictlyPositiveSet n) A ->
    0 <= Matrix.trace
        (((T : Matrix (Fin n) (Fin n) Real)) *
          CFC.log ((T : Matrix (Fin n) (Fin n) Real))) -
      Matrix.trace
        (((T : Matrix (Fin n) (Fin n) Real)) * CFC.log (RelativeEntropy.expLogMatrix H A)) -
      Matrix.trace ((T : Matrix (Fin n) (Fin n) Real)) +
      Matrix.trace (RelativeEntropy.expLogMatrix H A)

/-- Package the explicit Klein-style pointwise nonnegativity premise into the
existing Gibbs upper-bound premise used by the conditional relative-entropy
bridge. -/
theorem gibbsVariationalUpperBoundPremise_of_gibbsKleinPremise
    (hKlein : GibbsKleinPremise) : GibbsVariationalUpperBoundPremise := by
  intro n H hH T A hT hA
  rw [RelativeEntropy.gibbsObjective_eq_trace_shift_sub_relativeEntropy]
  exact RelativeEntropy.carrierGibbs_le_traceMatrixExp_of_kleinPremise
    H T A hH (hKlein H hH T A hT hA)

/-- Conditional Epstein bridge that consumes relative-entropy joint convexity
and the explicit Klein-style Gibbs premise adapter. -/
theorem epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_gibbsKleinPremise
    (hRE : RelativeEntropyJointConvexity)
    (hKlein : GibbsKleinPremise) :
    EpsteinAffineLineConcavity :=
  epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_gibbsUpperBoundPremise
    hRE (gibbsVariationalUpperBoundPremise_of_gibbsKleinPremise hKlein)

/-- Discharge the explicit Gibbs Klein premise by instantiating the full matrix
Klein theorem at `S = matrixExp (H + CFC.log A)`. -/
theorem gibbsKleinPremise_of_fullMatrixKlein : GibbsKleinPremise := by
  intro n H hH T A hT hA
  let L : Matrix (Fin n) (Fin n) Real := H + CFC.log (A : Matrix (Fin n) (Fin n) Real)
  have hL : IsSelfAdjointMatrix L := by
    exact hH.add (isSelfAdjointMatrix_cfc_log A.2)
  have hTpos : IsStrictlyPositive (T : Matrix (Fin n) (Fin n) Real) := by
    simpa [mem_selfAdjointStrictlyPositiveSet] using hT
  have hSsa : IsSelfAdjointMatrix (matrixExp L) := by
    exact ((matrixExpLogDomainForSelfAdjoint L) hL).1
  have hSpos : IsStrictlyPositive (matrixExp L) := by
    exact ((matrixExpLogDomainForSelfAdjoint L) hL).2.1
  simpa [RelativeEntropy.expLogMatrix, RelativeEntropy.logShift, L] using
    (kleinInequality_relativeEntropy_nonneg
      (T := (T : Matrix (Fin n) (Fin n) Real))
      (S := matrixExp L)
      T.2
      hSsa
      hTpos
      hSpos)

/-- Thin wrapper exposing the existing Gibbs upper-bound premise from the full
matrix Klein theorem. -/
theorem gibbsVariationalUpperBoundPremise_of_fullMatrixKlein :
    GibbsVariationalUpperBoundPremise :=
  gibbsVariationalUpperBoundPremise_of_gibbsKleinPremise
    gibbsKleinPremise_of_fullMatrixKlein

/-- Conditional Epstein bridge that now consumes full matrix Klein directly,
while keeping relative-entropy joint convexity explicit. -/
theorem epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_fullMatrixKlein
    (hRE : RelativeEntropyJointConvexity) : EpsteinAffineLineConcavity :=
  epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_gibbsUpperBoundPremise
    hRE gibbsVariationalUpperBoundPremise_of_fullMatrixKlein
end

end HighDimProb
