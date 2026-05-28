# HighDimProb

HighDimProb is a Lean 4 package for high-dimensional probability foundations. It is a Mathlib-compatible ergonomic layer: reuse Mathlib first, then add small wrappers, aliases, predicates, examples, and theorem-statement specifications where they help downstream formalization.

Current status: Milestone 1 / v0.1-alpha. The stable API is the probability object layer. The high-dimensional object layer is experimental and partial.

## Build and Test

```bash
lake build
lake test
```

## Stable API

Stable v0.1 modules are imported through:

```lean
import HighDimProb
```

This covers the probability object layer: probability-space conventions, real-valued random variables, laws, expectation, scalar centering and variance wrappers, tail events and probabilities, Lp and moment vocabulary, Orlicz bounds, scalar subGaussian and subExponential predicate forms, and typed statement specifications supported by current objects.

## Experimental API

Experimental v0.2+ modules are imported through:

```lean
import HighDimProb.Experimental
```

This currently includes high-dimensional vocabulary such as random vectors, covariance, isotropicity, subGaussian vector predicates, nets, metric entropy, and experimental scalar concentration wrappers. Do not promote an experimental module to the stable root import without tests, docs, a status update, and a root import audit.

## How to Contribute

Start with:

- `docs/ContributorRoadmap.md`
- `docs/Workflow.md`
- `docs/StageChecklist.md`
- `docs/TheoremAtlas.md`
- `ORGANISATION.md`
- `NOTATION.md`
- `docs/Automation.md`
- `docs/Roadmap.md`
- `CONTRIBUTING.md`

Pick exactly one small task. Search Mathlib first. Implement object-level vocabulary only unless the task explicitly asks for a theorem proof. Add tests, update docs, then run `lake build` and `lake test`.

## Good First Tasks

- Add examples for existing declarations.
- Add or improve API regression tests.
- Clean up `docs/TermMap.md`.
- Add typed statement specifications when dependencies already exist.
- Improve documentation consistency.

Do not add `sorry`, `admit`, axioms, optional dependencies, custom probability universes, custom random-variable structures, or unproved book results as Lean `theorem` or `lemma` declarations.
