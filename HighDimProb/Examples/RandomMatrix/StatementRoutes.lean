import HighDimProb.Examples.RandomMatrix.AttentionFeatureGramOperatorNormUsage
import HighDimProb.Examples.RandomMatrix.EmpiricalFisherOperatorNormUsage
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

#check sampleCovariance_operatorNorm_tail_usage
#check sampleCovariance_exactRow_centeredSquare_quadraticForm_tail_usage
#check sampleCovariance_exactRow_centeredSquare_operatorNorm_tail_usage

/-!
## Rank-one covariance and Gram routes

These examples show how rank-one feature or gradient covariance summands feed
the shared Matrix Bernstein wrappers. Example-specific names stay in examples;
reusable matrix facts stay in core.
-/

#check RankOneMatrixBernsteinPipelineUsage.rankOne_operatorNormTail
#check loraCovariance_normalizedTail
#check loraCovariance_highProbability
#check loraCovariance_matrixLESandwich

/-!
## Structured covariance operator-norm routes

These wrappers specialize the shared covariance and Matrix Bernstein APIs.
Generated rank-one routes expose natural input bundles; legacy examples keep
their remaining positive- and negative-side assumptions explicit.
-/

#check empiricalFisher_operatorNorm_tail_usage

/-!
## Natural TraceExp/Tropp bookkeeping

These examples index prefix/state bookkeeping around the lower-level TraceExp
statements. They do not prove Lieb, Golden-Thompson, CFC, or full Matrix
Bernstein.
-/

#check naturalTropp_traceState_zero_usage
#check arbitraryHistory_quadraticForm_tail_usage


end HighDimProb.Examples.RandomMatrix.StatementRoutes
