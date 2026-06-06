# HighDimProb

HighDimProb is a Lean 4 package for high-dimensional probability foundations. It is a Mathlib-compatible ergonomic layer: reuse Mathlib first, then add small wrappers, aliases, predicates, examples, and theorem-statement specifications where they help downstream formalization.

Current status: scalar concentration branch closure on top of v0.1-alpha. The stable API is the scalar probability object layer. The high-dimensional and concentration proof layers remain experimental.

## Build and Test

```bash
lake build
lake test
```

## Judge Suite

HighDimProb also has a lightweight compile-time judge suite for downstream API
use cases and repository policy checks:

```bash
lake build HighDimProbJudge
python scripts/judge_policy_check.py
```

The judge suite is separate from `HighDimProbTest`. It imports public APIs the
way external Lean files would, checks selected theorem names, and includes small
application examples for Hoeffding, Bernstein, subGaussian, and random-matrix
statement surfaces. Details are in `docs/JudgeSystem.md`.

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

This covers the reviewed scalar object layer: probability-space conventions,
real-valued random variables, laws, expectation, scalar centering and variance
wrappers, tail events and probabilities, Lp and moment vocabulary, Orlicz
bounds, scalar subGaussian and subExponential predicate forms, and typed
statement specifications supported by current objects.

## Experimental API

Experimental v0.2+ modules are imported through:

```lean
import HighDimProb.Experimental
```

This currently includes high-dimensional vocabulary such as random vectors, covariance, isotropicity, subGaussian vector predicates, nets, metric entropy, random matrices, matrix concentration statement prerequisites, and experimental scalar concentration wrappers. The concentration branch includes Markov/Chebyshev, fixed-scale Orlicz-to-tail implications, fixed-scale tail-to-Orlicz reverse implications, sharp natural-exponent subGaussian moment growth, forward MGF-to-tail/Orlicz/moment links, finite Rademacher product/sum concentration, finite bounded-variable Hoeffding with documented conservative, sharp, and weighted constants, subExponential finite-sum MGF infrastructure, local quadratic Bernstein, scalar Bernstein min-form tails including deterministic weighted sums, and a final milestone/leaf/test audit. Do not promote an experimental module to the stable root import without tests, docs, a status update, and a root import audit.

## Scalar Concentration Milestone

The scalar concentration branch is closed for the current milestone and remains
available as:

```lean
import HighDimProb.Concentration
```

It proves Markov/Chebyshev/Boole, scalar Orlicz/tail/moment/MGF implication
arrows, full finite-`ENNReal` moment bridges for fixed-scale subGaussian and
subExponential formulations, Rademacher and Hoeffding theorem families,
subExponential finite-sum MGF infrastructure, local Bernstein, scalar Bernstein
min-form, and weighted scalar Bernstein. Future work includes reverse/source
MGF links, finite-gauge variants, raw-predicate Bernstein, operator-norm
bridges, matrix Bernstein proofs, Hanson-Wright, and WLLN/SLLN proof branches.

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
