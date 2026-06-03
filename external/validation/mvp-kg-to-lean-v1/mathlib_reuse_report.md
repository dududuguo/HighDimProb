# Mathlib Reuse Report

Produced before Lean modifications: yes.

## Existing HighDimProb Declarations

### Chebyshev

- `HighDimProb.chebyshev_inequality`
- `HighDimProb.chebyshev_inequality_prob`
- Local module: `HighDimProb/Concentration/Chebyshev.lean`
- Test surface: `HighDimProbTest/ConcentrationAPI.lean`
- Verdict: existing proven mapping; no Lean action needed for node A.

### Finite Union Bound / Boole Inequality

- Existing declaration: `HighDimProb.measure_biUnion_le`
- Source module: `HighDimProb/ProbabilitySpace.lean`
- Statement:
  `P (iUnion i in s, A i) <= sum i in s, P (A i)`
- Mathlib bridge:
  `MeasureTheory.measure_biUnion_finset_le`
- Current tests:
  `HighDimProbTest/ProbabilityObjectAPI.lean` checks and instantiates the theorem.
- Gap:
  no dedicated `HighDimProbTest/UnionBoundAPI.lean` focused test module.
- Verdict:
  do not duplicate the theorem; add focused API tests and aggregate import wiring.

### Hoeffding

- Existing local specialization:
  `HighDimProb.hoeffding_rademacher_sum`
- Local constant:
  `2 * exp (-(t^2 / (4 * sum_i a_i^2)))`
- Existing source module:
  `HighDimProb/Concentration/RademacherSums.lean`
- Mathlib reuse candidates:
  - `ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero`
  - `ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc`
  - `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`
  - `ProbabilityTheory.HasSubgaussianMGF.const_mul`
  - `ProbabilityTheory.measure_sum_ge_le_of_iIndepFun`
- Verdict:
  Mathlib has the bounded-variable MGF lemma and subGaussian independent-sum machinery. MVP-1 will not prove general Hoeffding; the next theorem step should first design the bounded-centered-variable MGF layer and then compose it with the existing finite-sum/tail bridges.

## Reuse Decision

The only Lean change in MVP-1 is an API/test hardening action for the already-proven finite union bound. No new theorem is needed, and no Hoeffding theorem should be added in this run.

