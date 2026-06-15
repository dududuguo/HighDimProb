DONE

Proved the bridge:

```lean
lambdaMaxOrderedUpperTailEvent_subset_quadraticFormUpperTailEvent
```

It shows `lambdaMaxOrderedUpperTailEvent A hA t <= quadraticFormUpperTailEvent A t` for `Fin (n + 1)` matrices under only the existing pointwise self-adjointness witness `hA`.

APIs reused: `lambdaMaxOrdered`, `lambdaMaxOrderedUpperTailEvent`, `quadraticFormUpperTailEvent`, `matrixUpperBoundTailEvent`, `matrixQuadraticForm`, `isUnitVector_of_norm_toLp_eq_one`, plus Mathlib `Matrix.IsHermitian.eigenvectorBasis`, `Matrix.IsHermitian.eigenvalues_eq`, `OrthonormalBasis.norm_eq_one`.

Files changed:
- `HighDimProb/RandomMatrix/Spectral.lean`
- `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- `docs/Status.md`
- `docs/TermMap.md`
- `docs/TestPlan.md`
- ignored validation artifacts under `external/validation/rm-s7a-lambda-max-tail-bridge/`

Remaining spectral blocker: `selfAdjointOperatorNormTailViaQuadraticFormStatement` is still typed-only. The legacy `lambdaMax` compatibility route also remains typed through `lambdaMax_eq_lambdaMaxOrdered_statement`.

FSM state log: `EXTRACTING -> REUSE_SOURCE_VALIDATING -> TRANSLATING -> COMPILING -> REVIEWING -> VERIFYING -> INTEGRATING`.

Command status:
- `lake build HighDimProb.RandomMatrix.Spectral`: 0
- `lake env lean HighDimProbTest/RandomMatrixSpectralAPI.lean`: 0
- `lake env lean HighDimProbJudge/RandomMatrix/SpectralUse.lean`: 0
- `lake env lean external/validation/rm-s7a-lambda-max-tail-bridge/RM_S7A_LambdaMaxTailBridgeProbe.lean`: 0
- `lake build`: 0
- `lake test`: 0
- `lake build HighDimProbJudge`: 0
- `python scripts/judge_policy_check.py`: 0
- `git diff --check`: 0, with the existing line-ending warning for `docs/visualizations/lake_import_graph.html`
- `rg "sorry|admit|axiom|unsafe" HighDimProb HighDimProbTest HighDimProbJudge`: 1, no matches
- `rg ":= True" HighDimProb HighDimProbTest HighDimProbJudge docs`: 1, no matches

`pwd`: `C:\Users\11388\reserach\HighDimProb`

Final `git status --short`:
```text
 M HighDimProb/RandomMatrix/Spectral.lean
 M HighDimProbJudge/RandomMatrix/SpectralUse.lean
 M HighDimProbTest/RandomMatrixSpectralAPI.lean
 M docs/Status.md
 M docs/TermMap.md
 M docs/TestPlan.md
 M docs/visualizations/lake_import_graph.html
```

Unrelated dirty file left untouched: `docs/visualizations/lake_import_graph.html`.

Next safe task: `RM-S7B-self-adjoint-operator-norm-tail-bridge`.