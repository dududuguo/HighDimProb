## Stage H6-sharp sharp Hoeffding constant

Decision: keep the existing HighDimProb subGaussian predicates and scalar implication graph unchanged, and prove the sharp finite bounded centered Hoeffding theorem locally in `HighDimProb.Concentration.Hoeffding`.

Rationale: the existing `CenteredSubGaussianMGF -> SubGaussianTail` bridge deliberately uses the current conservative scale convention, which gives exponent `-t^2 / sum_i (b_i-a_i)^2` for bounded centered sums. The classical/Wikipedia Hoeffding constant requires optimizing the Hoeffding MGF bound `E exp(lambda*Y) <= exp(lambda^2*V/8)` directly, giving exponent `-2*t^2/V`.

Implementation: added public helpers `upperTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`, `lowerTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`, `absTailProb_le_two_mul_exp_neg_two_mul_sq_div_of_mgf_eighth`, and theorem `hoeffding_sum_bounded_centered_sharp`. No new predicate was introduced and no existing `SubGaussianTail`, `Psi2Bound`, or `CenteredSubGaussianMGF` meaning changed.

Verification: `lake build`, `lake test`, and the Lean-source forbidden-token audit passed for this stage.

## Stage H7 non-centered Wikipedia Hoeffding corollary

Decision: prove `hoeffding_sum_bounded` by centering each independent bounded variable locally and applying `hoeffding_sum_bounded_centered_sharp`; do not change `CenteredSubGaussianMGF`, `SubGaussianTail`, `Psi2Bound`, or the scalar implication graph.

Rationale: the non-centered Wikipedia form is a centering corollary, not a reason to redesign the global subGaussian scale convention. The proof needs finite expectation linearity and independence preservation under deterministic shifts, so those facts are exposed as small helpers instead of a new predicate layer.

Implementation: added `expect_finset_sum`, `iIndepFun_centered_of_iIndepFun`, `ae_mem_Icc_centered_of_ae_mem_Icc`, `sum_centered_eq_sum_sub_expect_sum`, and `hoeffding_sum_bounded`. The theorem keeps the positive denominator and integrability assumptions explicit and proves the exponent `-2*t^2 / sum_i (b_i-a_i)^2` for `sum_i X_i - E[sum_i X_i]`.

Verification: `lake build`, `lake test`, `rg -n "\b(sorry|admit|axiom|unsafe)\b" .\HighDimProb .\HighDimProbTest`, and `git diff --check` passed for this stage. Next safe task: Stage H8 weighted bounded Hoeffding theorem.
