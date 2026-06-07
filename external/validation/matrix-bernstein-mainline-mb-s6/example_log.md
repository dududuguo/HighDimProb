# MB-S6 Example/Judge Log

## Public API Covered

- `TraceExpDominatesQuadraticFormUpperTail`
- `traceExpDominatesQuadraticFormUpperTailStatement`
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`

## Files Updated

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`

## Example Shape

- The explicit dominance predicate is checked by `#check` and by definitional
  equality to the event subset.
- The typed statement is checked as a `Prop`.
- Conditional examples pass an explicit
  `TraceExpDominatesQuadraticFormUpperTail Y theta t` hypothesis into the MB-S6
  subset and Laplace bridge theorems.
- No new mathematical facts are proved in the example or judge files.

## Commands

- `lake build HighDimProbTest.RandomMatrixLaplaceAPI`: pass
- `lake build HighDimProbJudge.RandomMatrix.LaplaceUse`: pass
- `python scripts/judge_policy_check.py`: pass

## Blockers

- None for example/judge coverage.
