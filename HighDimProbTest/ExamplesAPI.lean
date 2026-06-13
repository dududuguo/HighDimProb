import HighDimProb.Examples.BasicUsage
import HighDimProb.Examples.NetsUsage
import HighDimProb.Examples.OrliczUsage
import HighDimProb.Examples.RandomMatrixUsage
import HighDimProb.Examples.RandomVariableUsage
import HighDimProb.Examples.RandomVectorUsage
import HighDimProb.Examples.TailUsage
import HighDimProb.Examples.RandomMatrix.CenteredRankOneCovarianceAdapterUsage
import HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage
import HighDimProb.Examples.RandomMatrix.GradientNormToOperatorBoundUsage
import HighDimProb.Examples.RandomMatrix.KernelNullspaceUsage
import HighDimProb.Examples.RandomMatrix.NTKGramDecompositionUsage
import HighDimProb.Examples.RandomMatrix.NTKGramUsage
import HighDimProb.Examples.RandomMatrix.RandomFeatureKernelUsage
import HighDimProb.Examples.RandomMatrix.RankOnePSDUsage

open HighDimProb
open HighDimProb.Examples.RandomMatrix.RankOnePSDUsage

variable {rankOneN : Nat}
variable (rankOneV : RankOneVector rankOneN)

#check (rankOneOperatorNorm_le_vectorSqNorm rankOneV :
  deterministicOperatorNorm (rankOneOuter rankOneV) <= vectorSqNorm rankOneV)
