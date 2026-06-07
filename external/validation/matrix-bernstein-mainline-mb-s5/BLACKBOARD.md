# MB-S5 Blackboard

## Current FSM State

- `INTEGRATED`

## Active File Lease

- None; MB-S5 is integrated.

## Allowed Files

### `LEASE_SNAPSHOT`

Read-only:

- `docs/Workflow.md`
- `docs/Status.md`
- `docs/MatrixBernsteinProofPlan.md`
- `docs/BranchRegistry.md`
- `docs/LeafPlan.md`
- `HighDimProb/RandomMatrix/TraceExp.lean`
- `HighDimProb/RandomMatrix/Laplace.lean`
- `HighDimProb/RandomMatrix/Spectral.lean`
- `HighDimProb/Concentration/Markov.lean`
- `HighDimProb/Concentration/Hoeffding.lean`
- `HighDimProb/Concentration/Bernstein.lean`
- `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- `external/multi-agent-system/README.md`
- `external/multi-agent-system/fsm/states.md`
- `external/multi-agent-system/fsm/transitions.md`

Write-only:

- `external/validation/matrix-bernstein-mainline-mb-s5/READ_ONCE_MANIFEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s5/BLACKBOARD.md`

Future leases must be recorded here before any worker edits leased files.

## Forbidden Files

- Scalar concentration source files.
- `HighDimProb/RandomMatrix/TraceExp.lean` during MB-S5 formalization.
- `HighDimProb/RandomMatrix/Spectral.lean` during MB-S5 formalization.
- `HighDimProb/RandomMatrix/SelfAdjoint.lean` during MB-S5 formalization.
- Global docs/status files before source/test/judge and review pass.

## Current Target

- Close out MB-S4 consistency.
- Survey MB-S5 Markov/Laplace bridge APIs.
- If and only if safe, prove a conditional lintegral Markov/Laplace theorem
  that explicitly assumes the missing event-subset bridge.

## Current Blockers

- The full matrix Laplace statement is blocked by the missing pointwise bridge
  from `quadraticFormUpperTailEvent Y t` into
  `traceExpThresholdEvent Y theta t`.
- Golden-Thompson, Lieb, trace-mgf comparison, and full Matrix Bernstein remain
  forbidden and unproved.

## Latest Command Results

- Phase 0 snapshot completed.
- Created `READ_ONCE_MANIFEST.md`.
- MB-S4 closeout consistency pass updated allowed closeout docs only.
- Survey scratch probe passed:
  `lake env lean external/validation/matrix-bernstein-mainline-mb-s5/MB_S5_MarkovProbe.lean`.
- Survey recommendation: `PROVE_CONDITIONAL_LINTEGRAL_MARKOV`.
- Focused source/test/judge gates passed:
  `lake build HighDimProb.RandomMatrix.Laplace`,
  `lake build HighDimProbTest.RandomMatrixLaplaceAPI`, and
  `lake build HighDimProbJudge.RandomMatrix.LaplaceUse`.
- Review check passed for MB-S5 scope, naming, and public coverage. Existing
  unrelated dirty files remain outside the MB-S5 lease.
- Final docs integration completed under `LEASE_FINAL_DOCS`.
- Final gates passed:
  `lake build`,
  `lake test`,
  `lake build HighDimProbJudge`,
  `python scripts/judge_policy_check.py`, and
  `git diff --check`.
- `git diff --check` emitted only existing CRLF normalization warnings and
  exited successfully.

## Merge Decision

- Snapshot manifest accepted.
- MB-S4 closeout consistency pass accepted.
- MB-S5 Markov/Laplace survey accepted.
- Conditional lintegral formalization accepted at focused-gate level.
- Review accepted.
- Final docs integration accepted.
- MB-S5 integrated.

## Exactly One Next Safe Task

- Stage MB-S6: survey and, if safe, prove the missing pointwise event-subset
  bridge from `quadraticFormUpperTailEvent Y t` into
  `traceExpThresholdEvent Y theta t` under explicit spectral/trace
  hypotheses, without proving trace-mgf, Golden-Thompson, Lieb, full matrix
  Laplace, or Matrix Bernstein.
