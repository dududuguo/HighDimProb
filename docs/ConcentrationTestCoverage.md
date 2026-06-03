# Concentration Test Coverage

Stage SC-final-update verifies that every theorem listed in
`docs/ScalarConcentrationTheoremIndex.md` has focused `#check` coverage or
aggregate import coverage. Focused `#check` coverage is enough for this
documentation consolidation stage.

| Theorem or public declaration | Primary `#check` coverage | Aggregate coverage | Result |
|---|---|---|---|
| `measure_biUnion_le` | `HighDimProbTest/UnionBoundAPI.lean` | `HighDimProbTest/BranchImports.lean` | covered |
| `markov_inequality_nonneg` | `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ExperimentalImports.lean` | covered |
| `markov_inequality` | `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `markov_inequality_ae_nonneg` | `HighDimProbTest/ConcentrationAPI.lean` | none needed | covered |
| `chebyshev_inequality` | `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `chebyshev_inequality_prob` | `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ExperimentalImports.lean` | covered |
| `subGaussianTail_of_psi2Bound` | `HighDimProbTest/OrliczToTailAPI.lean`, `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `psi2Bound_of_subGaussianTail` | `HighDimProbTest/TailToOrliczAPI.lean`, `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `absMomentNat_le_of_psi2Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | none needed | covered |
| `absMomentNat_le_of_subGaussianTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | none needed | covered |
| `realLpNorm_nat_le_sqrt_of_psi2Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `realLpNorm_nat_le_sqrt_of_subGaussianTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `subGaussianMomentNatSqrt_of_psi2Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `subGaussianMomentNatSqrt_of_subGaussianTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `realLpNorm_le_sqrt_of_psi2Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `realLpNorm_le_sqrt_of_subGaussianTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subGaussianMoment_of_psi2Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subGaussianMoment_of_subGaussianTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `centeredSubGaussianMGFLIntegral_of_centeredSubGaussianMGF` | `HighDimProbTest/MGFImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `upperTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF` | `HighDimProbTest/MGFImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `lowerTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF` | `HighDimProbTest/MGFImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `subGaussianTail_of_centeredSubGaussianMGF` | `HighDimProbTest/MGFImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `psi2Bound_of_centeredSubGaussianMGF` | `HighDimProbTest/MGFImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `subGaussianMomentNatSqrt_of_centeredSubGaussianMGF` | `HighDimProbTest/MGFImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `centeredSubGaussianMGF_rademacher` | `HighDimProbTest/RademacherAPI.lean` | `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subGaussianTail_rademacher` | `HighDimProbTest/RademacherAPI.lean` | `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `iIndepFun_rademacherCoord` | `HighDimProbTest/RademacherFamilyAPI.lean` | `HighDimProbTest/ExperimentalImports.lean` | covered |
| `centeredSubGaussianMGF_weightedRademacherSum` | `HighDimProbTest/RademacherSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subGaussianTail_weightedRademacherSum` | `HighDimProbTest/RademacherSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `hoeffding_rademacher_sum` | `HighDimProbTest/RademacherSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos` | `HighDimProbTest/SubGaussianSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos` | `HighDimProbTest/SubGaussianSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `subGaussianTail_sum_of_iIndepFun_of_pos` | `HighDimProbTest/SubGaussianSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subGaussianTail_weighted_sum_of_iIndepFun_of_pos` | `HighDimProbTest/SubGaussianSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `subGaussianTail_sum_of_iIndepFun_bounded_centered` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `hoeffding_sum_bounded_centered` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `hoeffding_sum_bounded_centered_sharp` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `hoeffding_sum_bounded` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `hoeffding_weighted_sum_bounded_centered_sharp` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean` | covered |
| `hoeffding_weighted_sum_bounded` | `HighDimProbTest/HoeffdingAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subExponentialTail_of_psi1Bound` | `HighDimProbTest/OrliczToTailAPI.lean`, `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `psi1Bound_of_subExponentialTail` | `HighDimProbTest/TailToOrliczAPI.lean`, `HighDimProbTest/ConcentrationAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `absMomentNat_le_of_psi1Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `absMomentNat_le_of_subExponentialTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `realLpNorm_nat_le_linear_of_psi1Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `realLpNorm_nat_le_linear_of_subExponentialTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `realLpNorm_le_linear_of_psi1Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `realLpNorm_le_linear_of_subExponentialTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subExponentialMoment_of_psi1Bound` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `subExponentialMoment_of_subExponentialTail` | `HighDimProbTest/MomentImplicationsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `weightedVarianceProxy` | `HighDimProbTest/SubExponentialSumsAPI.lean` | `HighDimProbTest/BranchImports.lean`, `HighDimProbTest/ExperimentalImports.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `weightedMaxScale` | `HighDimProbTest/SubExponentialSumsAPI.lean` | `HighDimProbTest/BranchImports.lean`, `HighDimProbTest/ExperimentalImports.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale` | `HighDimProbTest/SubExponentialSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale` | `HighDimProbTest/SubExponentialSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale` | `HighDimProbTest/SubExponentialSumsAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `absTailProb_le_two_mul_exp_neg_sq_of_centeredSubExponentialMGFLIntegral_of_le` | `HighDimProbTest/BernsteinAPI.lean` | `HighDimProbTest/ExperimentalImports.lean` | covered |
| `absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_mgf_bound_of_le` | `HighDimProbTest/BernsteinAPI.lean` | none needed | covered |
| `absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_centeredSubExponentialMGFLIntegral_sum` | `HighDimProbTest/BernsteinAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `absTailProb_le_two_mul_exp_neg_linear_div_maxScale_of_mgf_bound_of_ge` | `HighDimProbTest/BernsteinAPI.lean` | none needed | covered |
| `absTailProb_le_two_mul_exp_neg_quarter_bernsteinRate_of_mgf_bound` | `HighDimProbTest/BernsteinAPI.lean` | none needed | covered |
| `upperTailProb_le_exp_neg_quarter_bernsteinRate_of_centeredSubExponentialMGFLIntegral_sum` | `HighDimProbTest/BernsteinAPI.lean` | `HighDimProbTest/ExperimentalImports.lean` | covered |
| `lowerTailProb_le_exp_neg_quarter_bernsteinRate_of_centeredSubExponentialMGFLIntegral_sum` | `HighDimProbTest/BernsteinAPI.lean` | none needed | covered |
| `bernstein_sum_subExponential` | `HighDimProbTest/BernsteinAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `bernstein_weighted_sum_subExponential` | `HighDimProbTest/BernsteinAPI.lean` | `HighDimProbTest/ConcentrationImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` | covered |
| `bernstein_subExponential_sum_statement` | `HighDimProbTest/BernsteinAPI.lean` | `HighDimProbTest/ExperimentalImports.lean` | covered |
| `bernstein_subExponential_weighted_sum_statement` | `HighDimProbTest/BernsteinAPI.lean` | `HighDimProbTest/ExperimentalImports.lean` | covered |

## Coverage Decision

No new complex examples were added in Stage SC-final-update. Existing focused
`#check` tests already cover the theorem index, and aggregate import tests
verify that representative theorem families are reachable through
`HighDimProb.Concentration`, `HighDimProb.Concentration.Implications`, and
`HighDimProb.Experimental`.
