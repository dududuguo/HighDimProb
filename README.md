# HighDimProb

HighDimProb is an early Lean 4 library for high-dimensional probability.

The goal is modest: reuse Mathlib wherever possible, then add a thin layer of
names, wrappers, examples, and theorem interfaces that make probability and
random-matrix formalization easier to build on.

The scalar concentration side is the most stable part right now. Random vectors,
random matrices, and Matrix Bernstein material are under active development.

## Quick Start

```bash
lake build
lake test
```

The main public import is:

```lean
import HighDimProb
```

Scalar concentration results are available through:

```lean
import HighDimProb.Concentration
```

Experimental and fast-moving modules are kept under:

```lean
import HighDimProb.Experimental
```

## What Is In The Repo

- `HighDimProb/`: the Lean library.
- `HighDimProbTest/`: API and regression tests.
- `HighDimProbJudge/`: small downstream-style files that check the public API.
- `docs/`: notes, API summaries, workflow docs, and development records.
- `external/`: optional or generated support material. It is not part of the
  Lean API.

Good starting points:

- `docs/RandomMatrixAPI.md` for the current RandomMatrix / Matrix Bernstein API.
- `HighDimProb/Examples/` for small API usage examples.
- `docs/JudgeSystem.md` for the judge suite.
- `docs/Workflow.md` for the project workflow.
- `docs/Status.md` for the current development state.
- `docs/References.md` for the external references behind the MVP areas.

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
generated knowledge-graph artifacts, validation logs, and planning notes. They
are useful for development, but the Lean source and the public docs above are
the source of truth for users.

## Acknowledgements

Thanks to [@freezed-corpse-143](https://github.com/freezed-corpse-143).

## Contributing

Small PRs are easiest to review. Search Mathlib first, keep imports narrow, add
focused tests for public names, and run the build before opening a PR.

Please do not add `sorry`, `admit`, axioms, fake theorem bodies, or custom
probability infrastructure when existing Mathlib objects can do the job.

See `CONTRIBUTING.md` for the fuller checklist.
