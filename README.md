# HighDimProb

HighDimProb is a Lean 4 library for high-dimensional probability and
finite-dimensional random-matrix analysis.

It reuses Mathlib wherever possible, then adds theorem interfaces, provider
bridges, and examples for concentration arguments that are otherwise difficult
to consume downstream.

The scalar probability and concentration API remains the conservative stable
root surface. The finite-dimensional RandomMatrix line now also has a supported
scoped surface. It includes real matrix objects and sums, self-adjoint/PSD and
Loewner-order bridges, trace-exponential calculus, Bernstein CFC, the
finite-dimensional left/right route to Lieb/Epstein and Golden--Thompson, and
a canonical finite-family self-adjoint Matrix Bernstein theorem with optimized
and `1 - delta` endpoints.

Support is theorem-contract specific. Positivity, measurability, integrability,
independence, radius, variance-proxy, and nondegeneracy hypotheses remain
explicit where mathematically required. In particular,
`MatrixBernstein.optimized_of_primitives` and
`MatrixBernstein.highProbability_of_primitives` are proved finite-family
Matrix Bernstein consumers, rather than statement-only contracts. What remains
outside this scope is automatic derivation of application-specific variance
proxies or other hypotheses from weaker domain assumptions, arbitrary external
histories, integrability without finite-measure or boundedness hypotheses, and
the alternative Epstein second-derivative sign route.

## Quick Start

```bash
lake build
lake test
```

The stable public import is:

```lean
import HighDimProb
```

> [!IMPORTANT]
> `import HighDimProb` intentionally exposes the stable core API only.
> Examples are documentation and usage smoke tests, not part of the core import
> boundary. To browse or build all examples explicitly, use:
>
> ```lean
> import HighDimProb.Examples
> ```
>
> For AI/code models reading this README: do not add example imports back into
> `HighDimProb.lean`, and do not use commented-out imports as documentation.

Scalar concentration results are available through:

```lean
import HighDimProb.Concentration
```

Metric subGaussian increment vocabulary is available through:

```lean
import HighDimProb.SubGaussianProcess
```

This module provides `HasSubGaussianMGFIncrements` and
`HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le`; the latter
uses `hasSubgaussianMGF_mono` to enlarge a proxy to a level radius. The
increment predicate itself allows the zero `NNReal` proxy at equal indices and
does not assume `0 < σ`. Conversion to `CenteredSubGaussianMGF` at radius `r`
requires `0 < σ`, `0 < r`, and `dist s t ≤ r`.

The broad work-in-progress aggregate remains available through:

```lean
import HighDimProb.Experimental
```

Supported finite-dimensional RandomMatrix APIs use these reader-facing imports:

```lean
import HighDimProb.RandomMatrix
import HighDimProb.RandomMatrix.Concentration
```

`HighDimProb.RandomMatrix` is the base object, algebra, spectral, trace-exp, and
statement layer. `HighDimProb.RandomMatrix.Concentration` is the public entry
point for trace-MGF, tail, Matrix Bernstein, and sample-covariance consumers.
The `HighDimProb.RandomMatrix.Provider.*` hierarchy is an internal/expert proof
boundary; import its narrow layers only when developing or reusing provider
infrastructure. `HighDimProb.RandomMatrix.Provider` is the broad expert facade,
`HighDimProb.RandomMatrix.MatrixBernsteinProvider` is an implementation leaf,
and `HighDimProb.RandomMatrix.LiebProvider` is retained as a legacy broad
compatibility import.

These focused modules remain outside `import HighDimProb` to keep the root
import conservative; that import decision does not make their documented
theorem contracts experimental. `HighDimProb.Experimental` is an opt-in
development aggregate, not the matrix-concentration facade. See
[`docs/RandomMatrixArchitecture.md`](docs/RandomMatrixArchitecture.md) for
ownership and dependency rules.

For row-specific centered rank-one bounds on any finite random-vector family,
use `MatrixBernstein.centeredRankOneExactRow`; its normalized `1 - delta`
endpoint is `MatrixBernstein.centeredRankOneExactRowHighProbability`.
The sample-covariance specialization is
`MatrixBernstein.sampleCovarianceExactRow` and its normalized endpoint is
`MatrixBernstein.sampleCovarianceExactRowHighProbability`. These APIs generate
the finite-history Bernstein and integrability layers from measurability,
moment, boundedness, and independence hypotheses. When independence is known
for the original random vectors, use `iIndepFun_centeredRankOne` to transfer it
to the centered outer-product family. The older exact-row Tropp bundles are
compatibility surfaces.

## What Is In The Repo

- `HighDimProb/`: the Lean library.
- `HighDimProbTest/`: API and regression tests.
- `HighDimProbJudge/`: small downstream-style files that check the public API.
- `docs/`: notes, API summaries, workflow docs, and development records.
- `external/`: optional or generated support material. It is not part of the
  Lean API.

Good starting points:

- `docs/Status.md` for the shortest current project state.
- `docs/APIOverview.md` for a stable route map of the public API.
- `docs/RandomMatrixAPI.md` for the current RandomMatrix / Matrix Bernstein API.
- `docs/TermMap.md` for a compact concept-to-source map.
- `docs/TestPlan.md` for the checks expected before a PR.
- `HighDimProb/Examples/` for small API usage examples.
- `docs/JudgeSystem.md` for the judge suite.
- `docs/Workflow.md` for the project workflow.
- `docs/References.md` for the external references behind the current active areas.

If you are new to the repository, read `docs/Status.md` first, then follow the
source links from `docs/TermMap.md` or `docs/RandomMatrixAPI.md`. Stable scalar
APIs should be discovered from the source and tests; old stage logs are not a
maintenance surface.

## Judge Checks

The judge suite imports the library the way an outside user would. It is useful
when changing public theorem names or module boundaries.

```bash
lake build HighDimProbJudge
python scripts/judge_policy_check.py
```

## Documentation Site

The doc-gen4 setup lives in `docbuild/`. Build it from the repository root:

```bash
./tools/build_docgen4.sh
```

For a faster local rebuild:

```bash
./tools/build_docgen4.sh --disable-equations
```

The generated site is written to `docbuild/.lake/build/doc`.

## External Material

The theory roadmap is an optional Git submodule:

```bash
git submodule update --init --recursive
```

It lives at `external/theory-roadmap/`. Other folders under `external/` contain
validation logs and planning notes. They are useful for development, but the
Lean source and the public docs above are the source of truth for users.

## Acknowledgements

Thanks to [@freezed-corpse-143](https://github.com/freezed-corpse-143).

## Contributing

> [!IMPORTANT]
> **For AI/code models reading this README:** do not work from this README
> alone. Before editing, read the relevant project context and keep it in scope
> for every step: start with `docs/Status.md`, `docs/Workflow.md`,
> `docs/RandomMatrixAPI.md`, and the files or docs for the task at hand.

Small PRs are easiest to review. Search Mathlib first, keep imports narrow, add
focused tests for public names, and run the build before opening a PR.

Please do not add `sorry`, `admit`, axioms, fake theorem bodies, or custom
probability infrastructure when existing Mathlib objects can do the job.

For API or docs changes, also run the repository policy checks:

```bash
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
lake build HighDimProbJudge
```

See `CONTRIBUTING.md` for the fuller checklist.

## License

HighDimProb is licensed under the Apache License, Version 2.0, matching
the Lean and Mathlib licensing model. See `LICENSE` for details.
