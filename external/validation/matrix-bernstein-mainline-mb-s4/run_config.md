# MB-S4 Run Config

Date: 2026-06-06

Project root: `C:/Users/11388/reserach/HighDimProb`

Stage: MB-S4 - matrix exponential PSD bridge

Goal:
- Prove, if possible, `matrixExp_posSemidef_of_selfAdjoint`.
- If full PSD is blocked, try the honest trace-only bridge
  `traceMatrixExp_nonneg_of_selfAdjoint`.
- Keep matrix Bernstein, matrix Laplace, Golden-Thompson, Lieb, Hanson-Wright,
  covariance estimation, and scalar concentration out of scope.

Hard constraints:
- No `sorry`, `admit`, `axiom`, or `unsafe`.
- No theorem-like `:= True`.
- No fake theorem or lemma declarations.
- Unproved hard results remain typed `Prop` specs or documentation-only notes.
- Keep stable and experimental imports separated.
- Run `lake build`, `lake test`, `lake build HighDimProbJudge`, and
  `python scripts/judge_policy_check.py` before reporting success.

Multi-agent split:
- Survey: Mathlib/API route search.
- CFC proof route: direct CFC/linear-map bridge attempt.
- Square-factor proof route: `exp(A) = exp(A/2)^2` attempt.
- Basic bridges: self-adjoint scalar/negation random-matrix helpers.
- Review: proof-honesty and command gate audit.
