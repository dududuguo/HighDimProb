# HighDimProb

HighDimProb is a Lean 4 library for high-dimensional probability and
finite-dimensional random-matrix analysis.

It reuses Mathlib wherever possible, then adds theorem interfaces, provider
bridges, and examples for concentration arguments that are otherwise difficult
to consume downstream.

The root import is deliberately small. Concentration and finite-dimensional
random-matrix results live behind focused imports so downstream users can choose
the supported surface they need without pulling implementation infrastructure
into every file.

## Quick Start

```bash
lake build
lake test
```

The stable root import is:

```lean
import HighDimProb
```

> [!IMPORTANT]
> `import HighDimProb` expands only to `HighDimProb.Init`,
> `HighDimProb.Scalar`, and `HighDimProb.Statements`. Scalar concentration is a
> focused import, not part of the root.
> Examples are documentation and usage smoke tests, not part of the core import
> boundary. To browse or build all examples explicitly, use:
>
> ```lean
> import HighDimProb.Examples
> ```
>
> For AI/code models reading this README: do not add example imports back into
> `HighDimProb.lean`, and do not use commented-out imports as documentation.

Scalar concentration results, including the full Dudley consumer
`HighDimProb.Dudley.Inputs.bound`, are available through:

```lean
import HighDimProb.Concentration
```

Metric subGaussian increment vocabulary is available through:

```lean
import HighDimProb.SubGaussianProcess
```

Gaussian integration by parts and affine-stability foundations use focused
imports:

```lean
import HighDimProb.GaussianFunctional.IntegrationByParts
import HighDimProb.GaussianFunctional.AffineStability
```

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
statement layer. Downstream concentration users should import
`HighDimProb.RandomMatrix.Concentration`. The
internal provider hierarchy is not a downstream API. Its ownership and
proof-development imports are documented only in the architecture guide.

These focused modules remain outside `import HighDimProb` to keep the root
import conservative; that import decision does not make their documented
theorem contracts experimental. `HighDimProb.Experimental` is an opt-in
development aggregate, not the matrix-concentration facade. See
[`docs/architecture/RandomMatrixArchitecture.md`](docs/architecture/RandomMatrixArchitecture.md) for
ownership and dependency rules.

## What Is In The Repo

- `HighDimProb/`: the Lean library.
- `HighDimProbTest/`: API and regression tests.
- `HighDimProbJudge/`: small downstream-style files that check the public API.
- `docs/`: notes, API summaries, workflow docs, and development records.
- `external/`: optional or generated support material. It is not part of the
  Lean API.

Good starting points:

- [`docs/user/APIOverview.md`](docs/user/APIOverview.md) for the stable import and API
  route map.
- [`docs/README.md`](docs/README.md) for the canonical documentation index,
  organized by audience.
- [`docs/user/RandomMatrixAPI.md`](docs/user/RandomMatrixAPI.md) for the supported
  RandomMatrix caller surface.
- [`HighDimProb/Examples/`](HighDimProb/Examples/) for small API usage examples.

If you are new to the repository, read the API overview first, then use the
documentation index to choose the user, contributor, or provider-development
path. Active status and task files are coordination aids, not API orientation.

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
> for every step: start with `docs/README.md`, `docs/maintainers/Workflow.md`, the focused
> API or architecture page, and the files for the task at hand.

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
