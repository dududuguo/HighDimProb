# Matrix Bernstein Mainline MC5 Run Config

Date: 2026-06-06

Repository: `C:/Users/11388/reserach/HighDimProb`

Stage: MC5 - lambda-max, trace-exponential, and matrix Laplace infrastructure

## Objective

Build the spectral, trace-exponential, and matrix Laplace vocabulary needed for a future proof of matrix Bernstein without proving matrix Bernstein in this stage.

## Constraints

- No `sorry`, `admit`, `axiom`, or `unsafe`.
- No theorem-like `Prop := True` placeholders.
- No optional dependencies.
- Preserve existing theorem meanings and public names.
- Keep scalar concentration and random matrix APIs compatible.
- Keep `lake build`, `lake test`, `lake build HighDimProbJudge`, and the judge policy script passing when available.

## Preflight Findings

1. PSD square / second moment / variance proxy theorems:
   - `isPSD_matrixSquare_of_selfAdjoint` is present in `HighDimProb/RandomMatrix/VarianceProxy.lean`.
   - `matrixQuadraticForm_matrixExpect` is present in `HighDimProb/RandomMatrix/VarianceProxy.lean`.
   - `isPSD_matrixSecondMoment_of_selfAdjoint` is present in `HighDimProb/RandomMatrix/VarianceProxy.lean`.
   - `isPSD_matrixVarianceProxy_of_selfAdjoint` is present in `HighDimProb/RandomMatrix/VarianceProxy.lean`.

2. Matrix Bernstein typed statement:
   - `matrixBernsteinSelfAdjointStatement` exists in `HighDimProb/RandomMatrix/ConcentrationStatements.lean`.
   - It is still a typed statement only, not a proved theorem.
   - The remaining proof-critical gaps are spectral/lambda-max vocabulary, trace exponential vocabulary, and matrix Laplace/trace-mgf infrastructure.

3. `Prop := True` placeholders:
   - Preflight exact source search found no `:= True` occurrences in the inspected random matrix statement files.
   - The policy script will perform the repository-wide conservative check.

4. RandomMatrix judge coverage:
   - `HighDimProbJudge.lean` exists.
   - Existing random matrix judge files cover operator norm, statements, PSD/order, sample covariance, and variance proxy APIs.

5. Mathlib spectral APIs:
   - `Mathlib.Analysis.Matrix.Spectrum` exposes Hermitian matrix eigenvalue APIs.
   - `Mathlib.Analysis.InnerProductSpace.Rayleigh` exposes Rayleigh quotient infrastructure for self-adjoint continuous linear maps.
   - `Mathlib.Analysis.CStarAlgebra.Matrix` and related files expose L2 operator norm and spectral radius facts.
   - No direct `lambdaMax` wrapper was found by name.
   - `Matrix.trace` exists; direct matrix exponential / trace-exponential APIs remain under audit.

## Validation Commands

Baseline and post-substage commands:

```text
lake build
lake test
lake build HighDimProbJudge
python scripts/judge_policy_check.py
git diff --check
```
