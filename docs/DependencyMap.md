# HighDimProb Dependency Map

## Policy

HighDimProb is an ergonomic wrapper layer over Mathlib. Before adding a declaration, search Mathlib first. If Mathlib already has the object, add only notation, aliases, bridge lemmas, or examples. Optional packages must not be added to `lakefile.lean` without an explicit instruction and an update to this file.

## Current Lake state

- Direct dependency in `lakefile.lean`: Mathlib only.
- Inherited Mathlib dependencies in `lake-manifest.json`: Aesop, Batteries, Qq, ProofWidgets, LeanSearchClient, importGraph, plausible, Cli.
- These inherited packages are not HighDimProb core dependencies and should not be imported from core modules unless explicitly promoted.

## Packages and tools

| Package/tool | Source URL or Reservoir name | Why it may help HighDimProb | Classification | Modules/concepts it may support | Currently imported? | Risks |
|---|---|---|---|---|---|---|
| Mathlib | `https://github.com/leanprover-community/mathlib4` | Core formal mathematics library. | core dependency | Probability, measure theory, integrals, `MemLp`, `eLpNorm`, independence, conditional probability, Euclidean spaces, matrices, metric spaces, covering numbers, convexity, linear algebra, operator/matrix norms. | Yes, direct Lake dependency. Core files currently import `Mathlib` through `HighDimProb.Basic`. | Heavy import if left global; APIs can require careful typeclass management. |
| Aesop | `https://github.com/leanprover-community/aesop` | Rule-based automation for future package tactics. | optional future automation dependency | Future `highdim_prob` tactic, routine set/measurability goals. | Inherited by Mathlib in the manifest; not imported by HighDimProb modules. | Can hide proof complexity; not needed for object-language layer. |
| Batteries | `https://github.com/leanprover-community/batteries` | Programming utilities used by Lean/mathlib ecosystem. | optional programming utility | Scripts/tools only if needed. | Inherited by Mathlib in the manifest; not imported by HighDimProb modules. | Not a source for mathematical definitions; avoid core coupling. |
| SciLean | `https://github.com/lecopivo/SciLean` | Future scientific-computing layer. | optional future scientific-computing dependency | Arrays, tensors, automatic differentiation, computational random matrix examples. | No. | Heavy build, experimental APIs, possible version conflicts with Mathlib. |
| CvxLean | Reservoir `@verified-optimization/CvxLean`; repository `https://github.com/verified-optimization/CvxLean` | Future convex optimization and SDP vocabulary. | optional future optimization dependency | Semidefinite programming, convex optimization, signal recovery, semidefinite relaxation. | No. | Optimization-specific abstraction may be premature; solver integrations and version conflicts. |
| LeanCopilot | `https://github.com/lean-dojo/LeanCopilot` | Premise/tactic suggestions during development. | development tool only | Proof search and tactic suggestions. | No. | Should not be imported in core modules; model/tool setup is non-mathematical infrastructure. |
| Loogle | `https://loogle.lean-lang.org/`; Reservoir `@nomeata/loogle` | Search existing Lean/Mathlib declarations. | search tool, not dependency | Discovery before definitions or theorem attempts. | No. | Search result quality depends on indexed Mathlib version. |
| LeanSearch | `https://leansearch.net/`; `LeanSearchClient` inherited by Mathlib | Natural-language theorem search. | search tool, not dependency | Discovery before definitions or theorem attempts. | `LeanSearchClient` is inherited by Mathlib in the manifest, but HighDimProb does not import it. | Search suggestions must be verified locally. |
| LeanExplore | `https://www.leanexplore.com/`; repository `https://github.com/justincasher/lean-explore` | Semantic declaration search. | search tool, not dependency | Discovery before definitions or theorem attempts. | No. | External index may not match the pinned Mathlib version. |

## Mathlib infrastructure to reuse first

| HighDimProb area | Mathlib object/module found | Use policy |
|---|---|---|
| Probability spaces | `Measure`, `IsProbabilityMeasure`; `Mathlib/MeasureTheory/Measure/Typeclasses/Probability.lean` | Alias only; do not bundle by default. |
| Random variables | Functions plus `Measurable`, `AEMeasurable` | Keep random variables as functions with separate assumptions. |
| Distribution/law | `Measure.map` | `law` should remain a wrapper around `Measure.map`. |
| Expectation/integral | Lebesgue/Bochner integral notation `∫ x, f x ∂μ` | Reuse directly for means, covariance, moments. |
| Lp and moments | `MemLp`, `eLpNorm`; `Mathlib/MeasureTheory/Function/LpSeminorm/Defs.lean` | Alias/wrap; do not define a new Lp space. |
| Independence | `ProbabilityTheory.iIndepFun`, `ProbabilityTheory.IndepFun` | Future wrappers only after API inspection. |
| Conditional probability | `ProbabilityTheory.cond`, notation `μ[|s]`, `μ[t | s]` | Reuse for conditional probability vocabulary. |
| Euclidean spaces | `EuclideanSpace`; `Mathlib/Analysis/InnerProductSpace/PiL2.lean` | Add bridges from `Fin n → ℝ` only when needed. |
| Matrices | `Matrix`; `Mathlib/Data/Matrix/*`, `Mathlib/LinearAlgebra/Matrix/*` | Use Mathlib matrices for random matrices. |
| Matrix norms | `Mathlib/Analysis/Matrix/Normed.lean`, `Mathlib/Analysis/CStarAlgebra/Matrix.lean` | Choose scoped norm deliberately; do not make a global matrix norm wrapper yet. |
| Metric covering/packing | `Metric.IsCover`, `Metric.IsSeparated`, `Metric.coveringNumber`, `Metric.externalCoveringNumber`, `Metric.packingNumber`; `Mathlib/Topology/MetricSpace/CoveringNumbers.lean` | Replace local covering/separated numeric plans with wrappers around Mathlib. |
| Convexity | Convex-space and convex-set APIs in Mathlib | Reuse for convex hull/body vocabulary later. |
| Operator norm | Continuous linear map/operator norm APIs in Mathlib | Reuse when random matrix/operator layer is ready. |

## Optional package gate

Before adding any non-Mathlib dependency:

1. Record the package here with a concrete use case.
2. Check version compatibility with the pinned Lean and Mathlib versions.
3. Confirm no Mathlib object already covers the required concept.
4. Add the package only after explicit instruction.
