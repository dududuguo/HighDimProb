# Milestone 2 Sprint Summary

Milestone Sprint S2 deepened the scalar concentration proof spine and
initialized the random matrix theorem statement layer.

## Scalar Concentration Progress

- Markov and Chebyshev remain the core proved scalar inequalities.
- ψ₂-Orlicz implies subGaussian tail is proven.
- ψ₁-Orlicz implies subExponential tail is proven.
- SubGaussian tail implies ψ₂-Orlicz with scale `2 * K` is proven.
- SubExponential tail implies ψ₁-Orlicz with scale `3 * K` is proven.
- `HighDimProb.Concentration.Implications` collects the proved fixed-scale arrows.
- `docs/ScalarImplicationGraph.md` records the current graph and remaining links.

## Random Matrix Statement Layer

- `HighDimProb.RandomMatrix.Statements` was added.
- `epsilonNetOperatorNormStatement` is the first typed random-matrix/geometry statement.
- The other major random-matrix theorem groups remain documentation-only until assumption vocabulary is implemented.

## Missing Assumption Vocabulary

- `docs/AssumptionVocabulary.md` audits scalar, vector, and matrix assumptions.
- Matrix independence, iid rows/entries, symmetric random matrices, and PSD/order vocabulary are the highest-priority blockers for future random-matrix theorem statements.

## Proven Theorems Added In This Sprint

- `lintegral_two_thirds_exp_neg_two_thirds_le_one`
- `integral_third_exp_third`
- `lintegral_exp_third_sub_one_le_of_exp_tail`
- `lintegral_exp_abs_div_three_sub_one_le_of_subExponentialTail`
- `psi1Bound_of_subExponentialTail`

## Previously Proven And Consolidated

- `subGaussianTail_of_psi2Bound`
- `subExponentialTail_of_psi1Bound`
- `psi2Bound_of_subGaussianTail`

## Blocked Theorem Families

- Moment and MGF links for scalar subGaussian/subExponential formulations.
- Finite-gauge and norm formulation links.
- Random matrix norm bounds.
- Sample covariance concentration and covariance estimation.
- Hanson-Wright inequality.
- Johnson-Lindenstrauss lemma.
- Matrix Bernstein inequality.

## Next Recommended Branch

Stage G2A - moment formulation implication pilot.
