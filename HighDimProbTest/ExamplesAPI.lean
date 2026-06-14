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
open HighDimProb.Examples.RandomMatrix.CenteredRankOneCovarianceAdapterUsage
open HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage
open HighDimProb.Examples.RandomMatrix.GradientNormToOperatorBoundUsage
open HighDimProb.Examples.RandomMatrix.RankOnePSDUsage
open HighDimProb.Examples.RandomMatrix.KernelNullspaceUsage
open HighDimProb.Examples.RandomMatrix.NTKGramDecompositionUsage
open HighDimProb.Examples.RandomMatrix.RandomFeatureKernelUsage

variable {rankOneN : Nat}
variable (rankOneV : RankOneVector rankOneN)

#check (rankOneOperatorNorm_le_vectorSqNorm rankOneV :
  deterministicOperatorNorm (rankOneMatrix rankOneV) <= vectorSqNorm rankOneV)

variable {kernelN : Nat}
variable (kernelA : Matrix (Fin (kernelN + 1)) (Fin (kernelN + 1)) Real)
variable (kernelX : Fin (kernelN + 1) -> Real)
variable (kernelHPSD : Matrix.PosSemidef kernelA)
variable (kernelHExplicitPSD : IsPSDMatrix kernelA)

#check matrixAction_eq_mulVec
#check invisible_of_quadraticNull_of_posSemidef
#check invisible_of_quadraticNull_of_psd
#check randomInvisible_of_quadraticNull_of_posSemidef
#check randomInvisible_of_quadraticNull_of_psd

#check randomGradientCovarianceContributionFamily
#check randomGradientVectorFamily
#check randomJacobianFeatureVectorFamily
#check randomFeatureVectorFamily
#check uncenteredGradientCovariance_pointwiseOperatorNormBound
#check centeredGradientCovariance_pointwiseOperatorNormBound
#check isRandomMatrix_rankOneCovarianceContribution
#check integrable_rankOneCovarianceContribution_of_memLp_two

example :
    matrixAction kernelA kernelX = Matrix.mulVec kernelA kernelX := by
  exact matrixAction_eq_mulVec kernelA kernelX

example (hNull : KernelQuadraticNullDirection kernelA kernelX) :
    KernelInvisibleDirection kernelA kernelX := by
  exact invisible_of_quadraticNull_of_posSemidef kernelHPSD hNull

example (hNull : KernelQuadraticNullDirection kernelA kernelX) :
    KernelInvisibleDirection kernelA kernelX := by
  exact invisible_of_quadraticNull_of_psd kernelHExplicitPSD hNull
