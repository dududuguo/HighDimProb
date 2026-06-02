# HighDimProb

HighDimProb is a Lean 4 package for high-dimensional probability foundations. It is a Mathlib-compatible ergonomic layer: reuse Mathlib first, then add small wrappers, aliases, predicates, examples, and theorem-statement specifications where they help downstream formalization.

Current status: finite Rademacher/Hoeffding branch closeout on top of v0.1-alpha. The stable API is the scalar probability object layer. The high-dimensional and concentration proof layers remain experimental.

## Build and Test

```bash
lake build
lake test
```

## Theory Roadmap Submodule

The external theory-side knowledge graph is mounted as a Git submodule:

```bash
git submodule update --init --recursive
```

It lives at `external/theory-roadmap/` and tracks the separate
`dududuguo/highdimprob-theory-roadmap` repository. This submodule contains the
source-reference roadmap for future formalization. The main repository's
`knowledge_graph/` namespace, if added later, is reserved for the Lean code
graph: modules, declarations, imports, tests, and API exposure.

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

This currently includes high-dimensional vocabulary such as random vectors, covariance, isotropicity, subGaussian vector predicates, nets, metric entropy, random matrices, and experimental scalar concentration wrappers. The concentration branch includes Markov/Chebyshev, fixed-scale Orlicz-to-tail implications, fixed-scale tail-to-Orlicz reverse implications, sharp natural-exponent subGaussian moment growth, forward MGF-to-tail/Orlicz/moment links, finite Rademacher product/sum concentration, and an implication-graph module. Do not promote an experimental module to the stable root import without tests, docs, a status update, and a root import audit.

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
- `docs/ScalarImplicationGraph.md`
- `docs/AssumptionVocabulary.md`
- `CONTRIBUTING.md`

Pick exactly one small task. Search Mathlib first. Implement object-level vocabulary only unless the task explicitly asks for a theorem proof. Add tests, update docs, then run `lake build` and `lake test`.

## Good First Tasks

- Add examples for existing declarations.
- Add or improve API regression tests.
- Clean up `docs/TermMap.md`.
- Add typed statement specifications when dependencies already exist.
- Improve documentation consistency.

Do not add `sorry`, `admit`, axioms, optional dependencies, custom probability universes, custom random-variable structures, or unproved book results as Lean `theorem` or `lemma` declarations.
