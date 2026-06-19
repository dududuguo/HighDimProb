import HighDimProb.Examples.RandomMatrix.AttentionFeatureGramOperatorNormUsage
import HighDimProb.Examples.RandomMatrix.BoundedRowSampleCovarianceOperatorNormUsage
import HighDimProb.Examples.RandomMatrix.EmpiricalFisherOperatorNormUsage
import HighDimProb.Examples.RandomMatrix.HardboneStatementAtlasUsage
import HighDimProb.Examples.RandomMatrix.LoRAAdapterSubspaceCovarianceUsage
import HighDimProb.Examples.RandomMatrix.NTKGramUsage
import HighDimProb.Examples.RandomMatrix.NaturalTroppPipelineUsage
import HighDimProb.Examples.RandomMatrix.RandomFeatureKernelUsage
import HighDimProb.Examples.RandomMatrix.RankOneMatrixBernsteinPipelineUsage
import HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage

/-!
# RandomMatrix statement routes

This example index is intentionally thin. It adds no mathematical facts and no
new assumptions. It groups existing example-level statements by theorem family:
sample covariance, rank-one covariance/Gram sums, operator-norm tails, TraceExp
bookkeeping, and hardbone statement targets.

The focused files below contain the full assumptions and theorem statements.
This file only keeps the route names discoverable and build-checked.
-/

namespace HighDimProb.Examples.RandomMatrix.StatementRoutes

open HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage
open HighDimProb.Examples.RandomMatrix.BoundedRowSampleCovarianceOperatorNormUsage
open HighDimProb.Examples.RandomMatrix.EmpiricalFisherOperatorNormUsage
open HighDimProb.Examples.RandomMatrix.RandomFeatureKernelUsage
open HighDimProb.Examples.RandomMatrix.NTKGramUsage
open HighDimProb.Examples.RandomMatrix.RankOneMatrixBernsteinPipelineUsage
open HighDimProb.Examples.RandomMatrix.AttentionFeatureGramOperatorNormUsage
open HighDimProb.Examples.RandomMatrix.LoRAAdapterSubspaceCovarianceUsage
open HighDimProb.Examples.RandomMatrix.NaturalTroppPipelineUsage

/-!
## Sample covariance

This section indexes bounded-row covariance tail routes. The example-level
bundles expose row-norm, variance-proxy, positive-side, and negative-side
obligations without creating another core sample-covariance API.
-/

#check SampleCovarianceTailAssumptions
#check SampleCovarianceOperatorNormTailAssumptions
#check sampleCovariance_quadraticForm_tail_usage
#check sampleCovariance_operatorNorm_tail_usage
#check boundedRowSampleCovariance_operatorNorm_tail_usage

/-!
## Rank-one covariance and Gram routes

These examples show how rank-one feature or gradient covariance summands feed
the shared Matrix Bernstein wrappers. Example-specific names stay in examples;
reusable matrix facts stay in core.
-/

#check RankOneMatrixBernsteinPipelineUsage.centeredRankOnePipelineSummands_eq_centeredRankOneFamily
#check RankOneMatrixBernsteinPipelineUsage.rankOnePipeline_quadraticForm_tail_optimized_under_primitives
#check RandomFeatureKernelOptimizedMatrixBernsteinAssumptions
#check randomFeatureKernel_quadraticForm_tail_optimized_under_primitives
#check NTKGramOptimizedMatrixBernsteinAssumptions
#check ntkGram_quadraticForm_tail_optimized_under_primitives

/-!
## Structured covariance operator-norm routes

These wrappers use the same core positive- and negative-side Matrix Bernstein
assumptions. The example-specific vocabulary remains in examples until repeated
proof obligations justify a core abstraction.
-/

#check EmpiricalFisherTailAssumptions
#check empiricalFisher_operatorNorm_tail_usage
#check LoRAAdapterSubspaceCovarianceAssumptions
#check loraAdapterSubspaceCovariance_operatorNorm_tail_usage
#check AttentionFeatureGramTailAssumptions
#check attentionFeatureGram_quadraticForm_tail_usage
#check attentionFeatureGram_operatorNorm_tail_usage

/-!
## Natural TraceExp/Tropp bookkeeping

These examples index prefix/state bookkeeping around the lower-level TraceExp
statements. They do not prove Lieb, Golden-Thompson, CFC, or full Matrix
Bernstein.
-/

#check naturalTropp_traceState_zero_usage
#check naturalTropp_traceState_last_usage
#check naturalTropp_traceState_left_usage
#check naturalTropp_traceState_right_usage

/-!
## Hardbone frontier

The hardbone atlas lists proof-frontier statement targets and thin consumers
without turning typed contracts into proved tail statements.
-/

#check MatrixExpSupportDomination
#check MatrixExpExcessSupportDomination
#check matrixExpSupportDomination_identity_statement
#check traceMatrixExp_excess_supportDim_exp_lambdaMax_statement
#check traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection
#check bernsteinMatrixExp_le_quadratic
#check matrixLog_le_of_le_matrixExp
#check troppConditionalStep_of_iIndepFun

end HighDimProb.Examples.RandomMatrix.StatementRoutes