# Abstraction Rules

This file is the active abstraction checklist. Old notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Current Rules

- Reuse Mathlib and existing HighDimProb vocabulary before adding local names.
- Prefer named helpers, assumption bundles, and adapters over repeated theorem arguments.
- Do not expose anonymous negated families or anonymous lambda-heavy public APIs when a named family can be introduced.
- Keep assumption bundles semantic: they package obligations, but do not prove Tropp/Lieb, CFC, integrability, independence, or variance bounds unless backed by a theorem.
- Reuse scalar RHS helpers such as `matrixBernsteinOptimizedScalarTailRHS`, `matrixBernsteinTwoSidedOptimizedScalarTailRHS`, and `sampleCovarianceQuadraticFormTailRHS` instead of copying formulas.
- Keep unfinished APIs under `HighDimProb.Experimental`, focused experimental
  leaves, or examples until tests, docs, and import-boundary checks justify
  promotion. A focused RandomMatrix import is supported only within its
  documented theorem contract.
- When a theorem signature grows, first look for a reusable family adapter, side-assumption structure, or RHS helper. Do not hide mathematically real hypotheses just to shorten a call site.

## Active Links

- Current status: [`Status.md`](Status.md)
- RandomMatrix API: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- RandomMatrix architecture: [`RandomMatrixArchitecture.md`](RandomMatrixArchitecture.md)
- Term map: [`TermMap.md`](TermMap.md)
- Test plan: [`TestPlan.md`](TestPlan.md)
- Historical notes: [`archive.md`](archive.md)
