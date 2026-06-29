import HighDimProb.RandomMatrix.TraceExp
import HighDimProb.RandomMatrix.CFCLogDerivativeProvider
import HighDimProb.RandomMatrix.TraceExpDerivative
import HighDimProb.RandomMatrix.EpsteinProvider
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic

/-!
# Outer derivative bridges for the affine-line Epstein target

This module does not differentiate `CFC.log`. It isolates the reusable outer
trace-exponential derivative and packages the chain-rule step that reduces the
Epstein affine-line scalar derivative premise to a matrix-valued derivative
statement for the log curve.
-/

namespace HighDimProb

open HighDimProb
open scoped MatrixOrder Matrix.Norms.Operator RightActions

noncomputable section

/-- Frechet derivative of `traceMatrixExp` on finite-dimensional real matrices.

This is the reusable outer derivative needed for affine-line Epstein-style
chain rules: the derivative in direction `H` is `trace (H * exp A)`.
-/
theorem hasFDerivAt_traceMatrixExp
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real => traceMatrixExp X)
      ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
        (LinearMap.toContinuousLinearMap (LinearMap.mulRight Real (NormedSpace.exp A))))
      A := by
  let traceCLM : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
    LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)
  let expFDeriv : Matrix (Fin n) (Fin n) Real →L[Real] Matrix (Fin n) (Fin n) Real :=
    fderiv Real (fun X : Matrix (Fin n) (Fin n) Real => NormedSpace.exp X) A
  let L : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
    traceCLM.comp expFDeriv
  have hExpDiff : DifferentiableAt Real
      (fun X : Matrix (Fin n) (Fin n) Real => NormedSpace.exp X) A := by
    simpa using (NormedSpace.exp_analytic (𝕂 := Real) (x := A)).differentiableAt
  have hTrace :
      HasFDerivAt
        (fun X : Matrix (Fin n) (Fin n) Real => traceMatrixExp X)
        L
        A := by
    simpa [traceMatrixExp, matrixTrace, matrixExp, traceCLM, expFDeriv, L] using
      (traceCLM.hasFDerivAt.comp A hExpDiff.hasFDerivAt)
  refine hTrace.congr_fderiv ?_
  ext H
  have hAffine : HasDerivAt (fun u : Real => A + SMul.smul u H) H 0 := by
    have hLin : HasDerivAt (fun u : Real => SMul.smul u H) H 0 := by
      simpa using
        (HasDerivAt.smul_const
          (hasDerivAt_id 0 : HasDerivAt (fun u : Real => u) 1 0) H)
    simpa using hLin.const_add A
  have hComp :
      HasDerivAt
        (fun u : Real => traceMatrixExp (A + SMul.smul u H))
        (L H)
        0 := by
    have hComp0 :=
      hTrace.comp_hasDerivAt_of_eq 0 hAffine (by ext i j; simp [SMul.smul])
    simpa [Function.comp_def] using hComp0
  have hExplicit :
      HasDerivAt
        (fun u : Real => traceMatrixExp (A + SMul.smul u H))
        (Matrix.trace (H * NormedSpace.exp A))
        0 := by
    have h0 : A + SMul.smul (0 : Real) H = A := by ext i j; simp [SMul.smul]
    simpa [h0] using hasDerivAt_trace_exp_add_smul_const A H 0
  exact hComp.unique hExplicit

/-- Chain-rule bridge from a matrix-valued derivative to a scalar derivative of
`t => traceMatrixExp (H + g t)`. -/
theorem hasDerivWithinAt_traceMatrixExp_add_of_hasDerivWithinAt
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    {s : Set Real}
    {g : Real -> Matrix (Fin n) (Fin n) Real}
    {t : Real}
    {G : Matrix (Fin n) (Fin n) Real}
    (hg : HasDerivWithinAt g G s t) :
    HasDerivWithinAt
      (fun x : Real => traceMatrixExp (H + g x))
      (Matrix.trace (G * NormedSpace.exp (H + g t)))
      s
      t := by
  have hOuter :=
    hasFDerivAt_traceMatrixExp (A := H + g t)
  have hInner :
      HasDerivWithinAt
        (fun x : Real => H + g x)
        G
        s
        t := by
    simpa using hg.const_add H
  have hComp := hOuter.comp_hasDerivWithinAt t hInner
  simpa [Function.comp_def, ContinuousLinearMap.comp_apply, Matrix.traceLinearMap_apply,
    LinearMap.mulRight_apply] using hComp

/-- `HasDerivAt` version of
`hasDerivWithinAt_traceMatrixExp_add_of_hasDerivWithinAt`. -/
theorem hasDerivAt_traceMatrixExp_add_of_hasDerivAt
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    {g : Real -> Matrix (Fin n) (Fin n) Real}
    {t : Real}
    {G : Matrix (Fin n) (Fin n) Real}
    (hg : HasDerivAt g G t) :
    HasDerivAt
      (fun x : Real => traceMatrixExp (H + g x))
      (Matrix.trace (G * NormedSpace.exp (H + g t)))
      t := by
  have hOuter :=
    hasFDerivAt_traceMatrixExp (A := H + g t)
  have hInner :
      HasDerivAt
        (fun x : Real => H + g x)
        G
        t := by
    simpa using hg.const_add H
  have hComp := hOuter.comp_hasDerivAt t hInner
  simpa [Function.comp_def, ContinuousLinearMap.comp_apply, Matrix.traceLinearMap_apply,
    LinearMap.mulRight_apply] using hComp

/-- Product-rule bridge for differentiating the scalar trace expression
`s => trace (G s * exp (H + L s))`.

This is only calculus bookkeeping. It does not provide the Epstein sign input;
it packages the derivative formula that a later spectral argument can try to
show is nonpositive after specializing `G` to `CFCLog.lineDeriv`. -/
theorem hasDerivAt_trace_mul_matrixExp_add_of_hasDerivAt
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    {G L : Real -> Matrix (Fin n) (Fin n) Real}
    {t : Real} {G' L' : Matrix (Fin n) (Fin n) Real}
    (hG : HasDerivAt G G' t) (hL : HasDerivAt L L' t) :
    HasDerivAt
      (fun s : Real => Matrix.trace (G s * NormedSpace.exp (H + L s)))
      (Matrix.trace (G' * NormedSpace.exp (H + L t) +
        G t * matrixExpFDeriv (H + L t) L'))
      t := by
  have hHL : HasDerivAt (fun s : Real => H + L s) L' t := by
    simpa using hL.const_add H
  have hExp : HasDerivAt
      (fun s : Real => NormedSpace.exp (H + L s))
      (matrixExpFDeriv (H + L t) L') t := by
    simpa using (hasFDerivAt_matrix_exp (H + L t)).comp_hasDerivAt t hHL
  have hMul : HasDerivAt
      (fun s : Real => G s * NormedSpace.exp (H + L s))
      (G' * NormedSpace.exp (H + L t) + G t * matrixExpFDeriv (H + L t) L') t := by
    simpa using hG.mul hExp
  simpa [Matrix.traceLinearMap_apply] using
    ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).hasFDerivAt.comp_hasDerivAt
      t hMul)

/-- Explicit derivative formula for the Epstein trace expression after the first
`CFC.log` affine-line derivative has been written as `CFCLog.lineDeriv`.

The argument `Dline` is intended to be the derivative of
`fun s => CFCLog.lineDeriv A C hA hC s` at `t`. This definition keeps the
second-derivative candidate out of downstream statements as a long repeated
matrix expression. -/
noncomputable def cfcLogLineDerivTraceSecond
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    (Dline : Matrix (Fin n) (Fin n) Real) (t : Real) : Real :=
  Matrix.trace
    (Dline * NormedSpace.exp (H + CFC.log (A + SMul.smul t C)) +
      _root_.HighDimProb.CFCLog.lineDeriv A C hA hC t *
        matrixExpFDeriv (H + CFC.log (A + SMul.smul t C))
          (_root_.HighDimProb.CFCLog.lineDeriv A C hA hC t))

/-- Specialization of the product-rule trace derivative to the Epstein trace
expression with the already packaged affine-line `CFC.log` derivative.

This removes one layer of bookkeeping from the remaining hard Epstein input:
a spectral argument only has to prove differentiability of `CFCLog.lineDeriv`
and nonpositivity of `cfcLogLineDerivTraceSecond`. -/
theorem hasDerivAt_trace_cfcLogLineDeriv_exp_of_hasDerivAt
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real} {Dline : Matrix (Fin n) (Fin n) Real}
    (hLineDeriv : HasDerivAt
      (fun s : Real => _root_.HighDimProb.CFCLog.lineDeriv A C hA hC s)
      Dline
      t)
    (hPos : IsStrictlyPositive (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => Matrix.trace
        (_root_.HighDimProb.CFCLog.lineDeriv A C hA hC s *
          NormedSpace.exp (H + CFC.log (A + SMul.smul s C))))
      (cfcLogLineDerivTraceSecond H A C hA hC Dline t)
      t := by
  simpa [cfcLogLineDerivTraceSecond] using
    (hasDerivAt_trace_mul_matrixExp_add_of_hasDerivAt (H := H)
      (G := fun s : Real => _root_.HighDimProb.CFCLog.lineDeriv A C hA hC s)
      (L := fun s : Real => CFC.log (A + SMul.smul s C))
      hLineDeriv
      (_root_.HighDimProb.CFCLog.hasDerivAt_line A C hA hC hPos))
/-- First-derivative Epstein affine-line bridge from a matrix-valued derivative
of `CFC.log` along the positive line. -/
theorem hasDerivWithinAt_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivWithinAt_cfcLog
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    {t : Real}
    {G : Matrix (Fin n) (Fin n) Real}
    (hlog : HasDerivWithinAt
      (fun s : Real => CFC.log (A + SMul.smul s C))
      G
      (Set.Ioo (0 : Real) 1)
      t) :
    HasDerivWithinAt
      (fun s : Real => traceMatrixExp (H + CFC.log (A + SMul.smul s C)))
      (Matrix.trace (G * NormedSpace.exp (H + CFC.log (A + SMul.smul t C))))
      (Set.Ioo (0 : Real) 1)
      t := by
  simpa using
    (hasDerivWithinAt_traceMatrixExp_add_of_hasDerivWithinAt (H := H) hlog)

/-- Ordinary `HasDerivAt` version of
`hasDerivWithinAt_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivWithinAt_cfcLog`. -/
theorem hasDerivAt_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivAt_cfcLog
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    {t : Real}
    {G : Matrix (Fin n) (Fin n) Real}
    (hlog : HasDerivAt
      (fun s : Real => CFC.log (A + SMul.smul s C))
      G
      t) :
    HasDerivAt
      (fun s : Real => traceMatrixExp (H + CFC.log (A + SMul.smul s C)))
      (Matrix.trace (G * NormedSpace.exp (H + CFC.log (A + SMul.smul t C))))
      t := by
  simpa using
    (hasDerivAt_traceMatrixExp_add_of_hasDerivAt (H := H) hlog)

/-- Concavity of the affine-line Epstein scalar function from a derivative of
`CFC.log` and nonpositivity of the resulting scalar trace-derivative.

This is still only a reduction theorem: the hard analytic inputs are the
`CFC.log` line derivative and the nonpositive derivative of the displayed trace
formula.
-/
theorem concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_cfcLog_hasDerivAt_traceDerivative_nonpos
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    (hPos : ∀ t ∈ Set.Icc (0 : Real) 1, IsStrictlyPositive (A + SMul.smul t C))
    {G : Real -> Matrix (Fin n) (Fin n) Real}
    {f'' : Real -> Real}
    (hlog : ∀ t ∈ Set.Ioo (0 : Real) 1,
      HasDerivAt
        (fun s : Real => CFC.log (A + SMul.smul s C))
        (G t)
        t)
    (htraceDeriv : ∀ t ∈ Set.Ioo (0 : Real) 1,
      HasDerivAt
        (fun s : Real =>
          Matrix.trace (G s * NormedSpace.exp (H + CFC.log (A + SMul.smul s C))))
        (f'' t)
        t)
    (hf''_nonpos : ∀ t ∈ Set.Ioo (0 : Real) 1, f'' t <= 0) :
    ConcaveOn Real (Set.Icc (0 : Real) 1)
      (fun t : Real => traceMatrixExp (H + CFC.log (A + SMul.smul t C))) := by
  refine
    concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivAt2_nonpos
      (H := H) (A := A) (C := C) hA hC hPos
      (f' := fun t : Real =>
        Matrix.trace (G t * NormedSpace.exp (H + CFC.log (A + SMul.smul t C))))
      (f'' := f'') ?_ htraceDeriv hf''_nonpos
  intro t ht
  simpa using
    (hasDerivAt_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivAt_cfcLog
      H A C (hlog t ht))

/-- Global Epstein affine-line reduction from `CFC.log` line derivatives and
nonpositivity of the scalar trace-derivative expression.

Use this as the next analytic target: supply the two explicit derivative facts
for `s => CFC.log (A + SMul.smul s C)` on strictly positive affine lines.
-/
theorem epsteinAffineLineConcavity_of_cfcLog_hasDerivAt_traceDerivative_nonpos
    (hDeriv :
      ∀ {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real),
        IsSelfAdjointMatrix H ->
        IsSelfAdjointMatrix A ->
        IsSelfAdjointMatrix C ->
        (∀ t ∈ Set.Icc (0 : Real) 1, IsStrictlyPositive (A + SMul.smul t C)) ->
          ∃ G : Real -> Matrix (Fin n) (Fin n) Real,
          ∃ f'' : Real -> Real,
            (∀ t ∈ Set.Ioo (0 : Real) 1,
              HasDerivAt
                (fun s : Real => CFC.log (A + SMul.smul s C))
                (G t)
                t) ∧
            (∀ t ∈ Set.Ioo (0 : Real) 1,
              HasDerivAt
                (fun s : Real =>
                  Matrix.trace
                    (G s * NormedSpace.exp (H + CFC.log (A + SMul.smul s C))))
                (f'' t)
                t) ∧
            ∀ t ∈ Set.Ioo (0 : Real) 1, f'' t <= 0) :
    EpsteinAffineLineConcavity := by
  refine epsteinAffineLineConcavity_of_hasDerivAt2_nonpos ?_
  intro n H A C hH hA hC hPos
  rcases hDeriv H A C hH hA hC hPos with ⟨G, f'', hlog, htraceDeriv, hf''_nonpos⟩
  refine ⟨fun t : Real =>
      Matrix.trace (G t * NormedSpace.exp (H + CFC.log (A + SMul.smul t C))),
    f'', ?_, htraceDeriv, hf''_nonpos⟩
  intro t ht
  simpa using
    (hasDerivAt_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivAt_cfcLog
      H A C (hlog t ht))


/-- Interface-compressed Epstein affine-line reduction that fills the `CFC.log`
line-derivative premise with `CFCLog.hasDerivAt_line`.

The remaining hard analytic input is only the nonpositive scalar derivative for
the explicit `CFCLog.lineDeriv` trace expression on strictly positive affine
lines.
-/
theorem epsteinAffineLineConcavity_of_cfcLog_lineDeriv_traceDerivative_nonpos
    (hDeriv :
      {n : Nat} ->
        (H A C : Matrix (Fin n) (Fin n) Real) ->
        IsSelfAdjointMatrix H ->
        (hA : IsSelfAdjointMatrix A) ->
        (hC : IsSelfAdjointMatrix C) ->
        ((t : Real) -> Set.Mem (Set.Icc (0 : Real) 1) t ->
          IsStrictlyPositive (A + SMul.smul t C)) ->
        Exists fun f'' : Real -> Real =>
          And
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              HasDerivAt
                (fun s : Real =>
                  Matrix.trace
                    (_root_.HighDimProb.CFCLog.lineDeriv A C hA hC s *
                      NormedSpace.exp (H + CFC.log (A + SMul.smul s C))))
                (f'' t)
                t)
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t -> f'' t <= 0)) :
    EpsteinAffineLineConcavity := by
  refine epsteinAffineLineConcavity_of_cfcLog_hasDerivAt_traceDerivative_nonpos ?_
  intro n H A C hH hA hC hPos
  cases hDeriv H A C hH hA hC hPos with
  | intro f'' hf =>
      refine Exists.intro (fun t : Real => _root_.HighDimProb.CFCLog.lineDeriv A C hA hC t) ?_
      refine Exists.intro f'' ?_
      refine And.intro ?_ (And.intro hf.left hf.right)
      intro t ht
      have htIcc : Set.Mem (Set.Icc (0 : Real) 1) t :=
        And.intro (le_of_lt ht.1) (le_of_lt ht.2)
      simpa [SMul.smul] using
        _root_.HighDimProb.CFCLog.hasDerivAt_line A C hA hC (hPos t htIcc)

/-- Epstein affine-line reduction from differentiability of `CFCLog.lineDeriv`
and nonpositivity of the explicit second-derivative candidate
`cfcLogLineDerivTraceSecond`.

This is still a conditional bridge. It does not prove the analytic sign theorem;
it exposes the exact remaining proof obligation after the affine-line `CFC.log`
derivative and outer trace-product calculus have been packaged. -/
theorem epsteinAffineLineConcavity_of_cfcLogLineDerivTraceSecond_nonpos
    (hSecond :
      {n : Nat} ->
        (H A C : Matrix (Fin n) (Fin n) Real) ->
        IsSelfAdjointMatrix H ->
        (hA : IsSelfAdjointMatrix A) ->
        (hC : IsSelfAdjointMatrix C) ->
        ((t : Real) -> Set.Mem (Set.Icc (0 : Real) 1) t ->
          IsStrictlyPositive (A + SMul.smul t C)) ->
        Exists fun Dline : Real -> Matrix (Fin n) (Fin n) Real =>
          And
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              HasDerivAt
                (fun s : Real =>
                  _root_.HighDimProb.CFCLog.lineDeriv A C hA hC s)
                (Dline t)
                t)
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              cfcLogLineDerivTraceSecond H A C hA hC (Dline t) t <= 0)) :
    EpsteinAffineLineConcavity := by
  refine epsteinAffineLineConcavity_of_cfcLog_lineDeriv_traceDerivative_nonpos ?_
  intro n H A C hH hA hC hPos
  cases hSecond H A C hH hA hC hPos with
  | intro Dline hDline =>
      refine Exists.intro (fun t : Real =>
        cfcLogLineDerivTraceSecond H A C hA hC (Dline t) t) ?_
      refine And.intro ?_ hDline.right
      intro t ht
      have htIcc : Set.Mem (Set.Icc (0 : Real) 1) t :=
        And.intro (le_of_lt ht.1) (le_of_lt ht.2)
      exact hasDerivAt_trace_cfcLogLineDeriv_exp_of_hasDerivAt
        H A C hA hC (hDline.left t ht) (hPos t htIcc)
/-!
## Short Epstein-line API

The declarations above keep the historical top-level names. The `EpsteinLine`
namespace gives the same route a shorter proof-facing surface for future
workers.
-/

namespace EpsteinLine

/-- The scalar first-derivative trace expression obtained after substituting
the affine-line derivative vector `CFCLog.lineDeriv`. -/
noncomputable abbrev traceSlope
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    (t : Real) : Real :=
  Matrix.trace
    (_root_.HighDimProb.CFCLog.lineDeriv A C hA hC t *
      NormedSpace.exp (H + CFC.log (A + SMul.smul t C)))

/-- The explicit second-derivative candidate for `traceSlope`, parameterized by
the derivative `Dline` of `CFCLog.lineDeriv`. -/
noncomputable abbrev traceSecond
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    (Dline : Matrix (Fin n) (Fin n) Real) (t : Real) : Real :=
  cfcLogLineDerivTraceSecond H A C hA hC Dline t

/-- Short namespaced form of
`hasDerivAt_trace_cfcLogLineDeriv_exp_of_hasDerivAt`. -/
theorem hasDerivAt_traceSlope
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real} {Dline : Matrix (Fin n) (Fin n) Real}
    (hLineDeriv : HasDerivAt
      (fun s : Real => _root_.HighDimProb.CFCLog.lineDeriv A C hA hC s)
      Dline
      t)
    (hPos : IsStrictlyPositive (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => traceSlope H A C hA hC s)
      (traceSecond H A C hA hC Dline t)
      t := by
  simpa [traceSlope, traceSecond] using
    hasDerivAt_trace_cfcLogLineDeriv_exp_of_hasDerivAt
      H A C hA hC hLineDeriv hPos

/-- Trace-slope derivative from the named carrier `CFCLog.lineDerivSA` field.
This is the compact carrier-level bridge used before expanding `lineDerivSA` to
its `derivSAAt` definition. -/
theorem hasDerivAt_traceSlope_of_lineDerivSA
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real} {G : CFCLog.Carrier n}
    (hLineSA : HasDerivAt
      (fun s : Real =>
        CFCLog.lineDerivSA
          ({ val := A, property := hA } : CFCLog.Carrier n)
          ({ val := C, property := hC } : CFCLog.Carrier n)
          s)
      G
      t)
    (hPos : IsStrictlyPositive (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => traceSlope H A C hA hC s)
      (traceSecond H A C hA hC (G : Matrix (Fin n) (Fin n) Real) t)
      t := by
  exact hasDerivAt_traceSlope H A C hA hC
    (CFCLog.hasDerivAt_lineDeriv_of_lineDerivSA A C hA hC hLineSA)
    hPos

/-- Trace-slope derivative from the evaluated carrier derivative field. This is
`EpsteinLine.hasDerivAt_traceSlope` with the ambient `CFCLog.lineDeriv`
derivative supplied by `CFCLog.hasDerivAt_lineDeriv_of_hasDerivAt_eval`. -/
theorem hasDerivAt_traceSlope_of_hasDerivAt_eval
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real} {G : CFCLog.Carrier n}
    (hEval : HasDerivAt
      (fun s : Real =>
        CFCLog.derivSAAt
          (({ val := A, property := hA } : CFCLog.Carrier n) +
            s • ({ val := C, property := hC } : CFCLog.Carrier n))
          ({ val := C, property := hC } : CFCLog.Carrier n))
      G
      t)
    (hPos : IsStrictlyPositive (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => traceSlope H A C hA hC s)
      (traceSecond H A C hA hC (G : Matrix (Fin n) (Fin n) Real) t)
      t := by
  let Asa : CFCLog.Carrier n := { val := A, property := hA }
  let Csa : CFCLog.Carrier n := { val := C, property := hC }
  have hEval' : HasDerivAt (fun s : Real => CFCLog.derivSAAt (Asa + s • Csa) Csa) G t := by
    simpa [Asa, Csa] using hEval
  exact hasDerivAt_traceSlope_of_lineDerivSA H A C hA hC
    (CFCLog.hasDerivAt_lineDerivSA_of_hasDerivAt_eval Asa Csa hEval')
    hPos

/-- Short namespaced Epstein reduction from differentiability of
`CFCLog.lineDeriv` and nonpositivity of `traceSecond`. -/
theorem concavity_of_traceSecond_nonpos
    (hSecond :
      {n : Nat} ->
        (H A C : Matrix (Fin n) (Fin n) Real) ->
        IsSelfAdjointMatrix H ->
        (hA : IsSelfAdjointMatrix A) ->
        (hC : IsSelfAdjointMatrix C) ->
        ((t : Real) -> Set.Mem (Set.Icc (0 : Real) 1) t ->
          IsStrictlyPositive (A + SMul.smul t C)) ->
        Exists fun Dline : Real -> Matrix (Fin n) (Fin n) Real =>
          And
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              HasDerivAt
                (fun s : Real =>
                  _root_.HighDimProb.CFCLog.lineDeriv A C hA hC s)
                (Dline t)
                t)
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              traceSecond H A C hA hC (Dline t) t <= 0)) :
    EpsteinAffineLineConcavity := by
  refine epsteinAffineLineConcavity_of_cfcLogLineDerivTraceSecond_nonpos ?_
  intro n H A C hH hA hC hPos
  cases hSecond H A C hH hA hC hPos with
  | intro Dline hDline =>
      exact Exists.intro Dline
        (And.intro hDline.left (by
          intro t ht
          simpa [traceSecond] using hDline.right t ht))


/-- Epstein reduction whose differentiability input is stated with the named
carrier field `CFCLog.lineDerivSA`. This is the preferred compact target for the
next analytic derivative/sign sprint. -/
theorem concavity_of_traceSecond_nonpos_of_lineDerivSA
    (hSecond :
      {n : Nat} ->
        (H A C : Matrix (Fin n) (Fin n) Real) ->
        IsSelfAdjointMatrix H ->
        (hA : IsSelfAdjointMatrix A) ->
        (hC : IsSelfAdjointMatrix C) ->
        ((t : Real) -> Set.Mem (Set.Icc (0 : Real) 1) t ->
          IsStrictlyPositive (A + SMul.smul t C)) ->
        Exists fun Dline : Real -> CFCLog.Carrier n =>
          And
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              HasDerivAt
                (fun s : Real =>
                  CFCLog.lineDerivSA
                    ({ val := A, property := hA } : CFCLog.Carrier n)
                    ({ val := C, property := hC } : CFCLog.Carrier n)
                    s)
                (Dline t)
                t)
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              traceSecond H A C hA hC
                (Dline t : Matrix (Fin n) (Fin n) Real) t <= 0)) :
    EpsteinAffineLineConcavity := by
  refine concavity_of_traceSecond_nonpos ?_
  intro n H A C hH hA hC hPos
  cases hSecond H A C hH hA hC hPos with
  | intro Dline hDline =>
      refine Exists.intro (fun t : Real => (Dline t : Matrix (Fin n) (Fin n) Real)) ?_
      refine And.intro ?_ hDline.right
      intro t ht
      exact CFCLog.hasDerivAt_lineDeriv_of_lineDerivSA A C hA hC
        (hDline.left t ht)

/-- Epstein reduction whose differentiability input is already in the evaluated
carrier-field form recommended by the CFCLog API. The only remaining analytic
content is proving that evaluated-field derivative and the sign of
`EpsteinLine.traceSecond`. -/
theorem concavity_of_traceSecond_nonpos_of_eval
    (hSecond :
      {n : Nat} ->
        (H A C : Matrix (Fin n) (Fin n) Real) ->
        IsSelfAdjointMatrix H ->
        (hA : IsSelfAdjointMatrix A) ->
        (hC : IsSelfAdjointMatrix C) ->
        ((t : Real) -> Set.Mem (Set.Icc (0 : Real) 1) t ->
          IsStrictlyPositive (A + SMul.smul t C)) ->
        Exists fun Dline : Real -> CFCLog.Carrier n =>
          And
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              HasDerivAt
                (fun s : Real =>
                  CFCLog.derivSAAt
                    (({ val := A, property := hA } : CFCLog.Carrier n) +
                      s • ({ val := C, property := hC } : CFCLog.Carrier n))
                    ({ val := C, property := hC } : CFCLog.Carrier n))
                (Dline t)
                t)
            ((t : Real) -> Set.Mem (Set.Ioo (0 : Real) 1) t ->
              traceSecond H A C hA hC
                (Dline t : Matrix (Fin n) (Fin n) Real) t <= 0)) :
    EpsteinAffineLineConcavity := by
  refine concavity_of_traceSecond_nonpos_of_lineDerivSA ?_
  intro n H A C hH hA hC hPos
  cases hSecond H A C hH hA hC hPos with
  | intro Dline hDline =>
      refine Exists.intro Dline ?_
      refine And.intro ?_ hDline.right
      intro t ht
      let Asa : CFCLog.Carrier n := { val := A, property := hA }
      let Csa : CFCLog.Carrier n := { val := C, property := hC }
      have hEval' : HasDerivAt
          (fun s : Real => CFCLog.derivSAAt (Asa + s • Csa) Csa)
          (Dline t)
          t := by
        simpa [Asa, Csa] using hDline.left t ht
      exact CFCLog.hasDerivAt_lineDerivSA_of_hasDerivAt_eval Asa Csa hEval'

end EpsteinLine
end

end HighDimProb
