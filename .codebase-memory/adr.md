## Stage H6 finite Hoeffding theorem for bounded centered variables

- Added `HighDimProb.Concentration.Hoeffding` as the bounded centered Hoeffding leaf.
- Reused Mathlib `ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero` for the one-variable bounded centered MGF source theorem.
- Composed with Stage H5 `SubGaussianSums` to prove finite independent bounded centered MGF and tail control.
- Constants: one-variable MGF scale `(b-a)/2`; finite MGF scale `sqrt (sum_i ((b_i-a_i)/2)^2)`; tail scale `2 * sqrt (...)`; explicit Hoeffding denominator `sum_i (b_i-a_i)^2`.
- Public declarations: `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered`, `centeredSubGaussianMGF_of_forall_mem_Icc_of_centered`, `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered`, `subGaussianTail_sum_of_iIndepFun_bounded_centered`, `hoeffding_sum_bounded_centered`.
- Next safe task: Stage H7 deterministic weighted bounded Hoeffding theorem.