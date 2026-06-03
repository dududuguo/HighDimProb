# Mathlib Reuse Report

This report was produced before any Lean code changes for the MVP cluster.

## Summary

All selected theorem-level concepts are already implemented in HighDimProb. The run made no new Lean definitions or theorem wrappers.

| Requested concept | KG node mapping | Existing HighDimProb status | Mathlib reuse decision |
|---|---|---|---|
| Markov inequality | `concept:basic-concentration` | already proven | wrapper around Mathlib already exists |
| Chebyshev inequality | `concept:basic-concentration` | already proven | wrapper around Mathlib already exists |
| Orlicz psi2 bound implies subGaussian tail | `concept:subgaussian-subexponential`, with `concept:moments-lp-orlicz` support | already proven | HighDimProb theorem using Mathlib Markov-style lintegral bound |

## Markov Inequality

KG node id and title:

- `concept:basic-concentration`
- "Markov, Chebyshev, Chernoff and exponential tail tools"

Proposed Lean concept:

- A nonnegative real random variable tail bound in HighDimProb terms:
  `upperTailProb P X a <= ENNReal.ofReal (expect P X / a)`.

Existing HighDimProb declarations:

- `markov_inequality_nonneg` in `HighDimProb/Concentration/Markov.lean:22`
- `markov_inequality` in `HighDimProb/Concentration/Markov.lean:50`
- `markov_inequality_ae_nonneg` in `HighDimProb/Concentration/Markov.lean:63`

Existing HighDimProb tests:

- `HighDimProbTest/ConcentrationAPI.lean:13`
- `HighDimProbTest/ConcentrationAPI.lean:14`
- `HighDimProbTest/ConcentrationAPI.lean:15`
- `HighDimProbTest/ConcentrationAPI.lean:44`
- `HighDimProbTest/ConcentrationAPI.lean:47`
- `HighDimProbTest/ConcentrationAPI.lean:50`

Searched Mathlib declarations:

- `MeasureTheory.meas_ge_le_lintegral_div`

Mathlib objects/theorems found:

- `.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/Lebesgue/Markov.lean:104`
  defines `MeasureTheory.meas_ge_le_lintegral_div`.

Classification:

- already implemented

Reason for not duplicating Mathlib:

- Mathlib already proves the measure-theoretic lintegral Markov inequality.
- HighDimProb's existing theorem is the useful project-facing wrapper around `expect`, `upperTailProb`, and `RealRandomVariable`.
- A new theorem would duplicate both Mathlib and existing HighDimProb surface.

Source validation:

- `external/theory-roadmap/sources/High-Dimensional_Probability.md:950-953` states the expected nonnegative Markov bound.
- `Random_Matrices.md:2004-2007` states the same theorem-level content.
- Tier 0 Lean/Mathlib proof evidence is stronger than OCR-derived markdown.

## Chebyshev Inequality

KG node id and title:

- `concept:basic-concentration`
- "Markov, Chebyshev, Chernoff and exponential tail tools"

Proposed Lean concept:

- A centered absolute-tail probability bound by variance over squared threshold.

Existing HighDimProb declarations:

- `chebyshev_inequality` in `HighDimProb/Concentration/Chebyshev.lean:23`
- `chebyshev_inequality_prob` in `HighDimProb/Concentration/Chebyshev.lean:32`

Existing HighDimProb tests:

- `HighDimProbTest/ConcentrationAPI.lean:34`
- `HighDimProbTest/ConcentrationAPI.lean:35`
- `HighDimProbTest/ConcentrationAPI.lean:54`
- `HighDimProbTest/ConcentrationAPI.lean:59`

Searched Mathlib declarations:

- `ProbabilityTheory.meas_ge_le_variance_div_sq`

Mathlib objects/theorems found:

- `.lake/packages/mathlib/Mathlib/Probability/Moments/Variance.lean:397`
  defines `ProbabilityTheory.meas_ge_le_variance_div_sq`.

Classification:

- already implemented

Reason for not duplicating Mathlib:

- Mathlib already proves the variance-form Chebyshev inequality.
- HighDimProb's existing theorem is a thin wrapper over project vocabulary: `absTailProb`, `centered`, `variance`, and `MemLpRealRandomVariable`.
- The probability-measure-facing wrapper already exists.

Source validation:

- `external/theory-roadmap/sources/High-Dimensional_Probability.md:972-975` states the Chebyshev variance bound.
- `Random_Matrices.md:2018-2021` states the same theorem-level content.
- Tier 0 Lean/Mathlib proof evidence is stronger than OCR-derived markdown.

## Orlicz psi2 Bound Implies SubGaussian Tail

KG node id and title:

- primary: `concept:subgaussian-subexponential`, "subGaussian and subExponential random variables"
- supporting: `concept:moments-lp-orlicz`, "moments, Lp norms and Orlicz controls"

Proposed Lean concept:

- `Psi2Bound P X K -> SubGaussianTail P X K`, assuming the existing measurable real random variable and probability-measure context.

Existing HighDimProb declarations:

- `Psi2Bound` in `HighDimProb/Orlicz.lean:49`
- `SubGaussianTail` in `HighDimProb/SubGaussian.lean:21`
- `lintegral_exp_sq_div_le_two_of_psi2Bound` in `HighDimProb/Concentration/OrliczToTail.lean:66`
- `subGaussianTail_of_psi2Bound` in `HighDimProb/Concentration/OrliczToTail.lean:130`

Existing HighDimProb tests:

- `HighDimProbTest/ConcentrationAPI.lean:16`
- `HighDimProbTest/ConcentrationAPI.lean:18`
- `HighDimProbTest/ConcentrationImplicationsAPI.lean:6`
- `HighDimProbTest/ConcentrationImplicationsAPI.lean:35`

Searched Mathlib declarations:

- `MeasureTheory.meas_ge_le_lintegral_div`
- `ProbabilityTheory.HasSubgaussianMGF`
- `ProbabilityTheory.HasSubgaussianMGF.const_mul`
- `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`
- Orlicz / psi2 / Psi2 declarations in Mathlib probability and measure-theory areas

Mathlib objects/theorems found:

- `.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/Lebesgue/Markov.lean:104`
  defines `MeasureTheory.meas_ge_le_lintegral_div`.
- `.lake/packages/mathlib/Mathlib/Probability/Moments/SubGaussian.lean:606`
  defines `ProbabilityTheory.HasSubgaussianMGF`.
- `.lake/packages/mathlib/Mathlib/Probability/Moments/SubGaussian.lean:685`
  defines `ProbabilityTheory.HasSubgaussianMGF.const_mul`.
- `.lake/packages/mathlib/Mathlib/Probability/Moments/SubGaussian.lean:768`
  defines `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`.

No direct Mathlib theorem was found for the project-specific `Psi2Bound -> SubGaussianTail` implication.

Classification:

- already implemented

Reason for not duplicating Mathlib:

- The theorem is already proven in HighDimProb as a project-facing implication between project predicates.
- Its proof uses Mathlib's lintegral Markov inequality rather than re-proving Markov.
- Mathlib's `HasSubgaussianMGF` is a different formulation and is already used elsewhere in HighDimProb's MGF branch; it should not be forced into this fixed-scale Orlicz-to-tail wrapper.

Source validation:

- `external/theory-roadmap/sources/High-Dimensional_Probability.md:1821-1839` records equivalence between tail, moments, and square-exponential MGF control.
- `external/theory-roadmap/sources/High-Dimensional_Probability.md:1873-1877` derives tail decay from square-exponential control using Markov's inequality.
- `external/theory-roadmap/sources/High-Dimensional_Probability.md:1919-1922` defines the psi2 norm through square-exponential control.
- `external/theory-roadmap/sources/High-Dimensional_Probability.md:1947-1953` records the resulting subGaussian bounds.
- `external/theory-roadmap/sources/Mathematical_Foundations_of_Infinite-Dimensional_Statistical_Models.md:1746-1752` gives an Orlicz psi2 convention and tail relationship in the reverse direction.

No source correction was needed. The exact HighDimProb theorem is a fixed-scale predicate implication, while the book source usually states norm/equivalence facts up to constants.

