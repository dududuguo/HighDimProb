# MB-S6 Proof Log

## Source-backed inputs used

- `SOURCE_DIGEST.md` Source Statement 1: the book-level largest-eigenvalue
  route goes through a trace-exponential threshold.
- `SOURCE_DIGEST.md` Source Statements 2 and 3: the missing bridge depends on
  spectral/min-max/Rayleigh machinery.
- MB-S5 theorem
  `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`.
- MB-S5 theorem
  `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`.

## Declarations proved

- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`

## Declarations not proved

- Direct source-backed spectral dominance theorem from self-adjointness and
  `0 <= theta`.
- Full `matrixLaplaceTransformStatement`.
- Trace-mgf bound.
- Golden-Thompson / Lieb.
- Matrix Bernstein.

## Commands

- `lake build HighDimProb.RandomMatrix.Laplace`: pass
- `python scripts/judge_policy_check.py`: pass

## Blockers

- Direct dominance still requires the spectral/Rayleigh and matrix exponential
  eigenvalue/trace bridge, which is not currently proved in HighDimProb.
