import HighDimProb.Concentration
import HighDimProb.Distributions

#check HighDimProb.centeredSubGaussianMGF_rademacher
#check HighDimProb.subGaussianTail_rademacher
#check HighDimProb.centeredSubGaussianMGF_weightedRademacherSum
#check HighDimProb.subGaussianTail_weightedRademacherSum
#check HighDimProb.hoeffding_rademacher_sum
#check HighDimProb.hoeffding_rademacher_sum_of_pos_variance

example :
    HighDimProb.CenteredSubGaussianMGF
      HighDimProb.rademacherMeasure HighDimProb.rademacher 1 := by
  exact HighDimProb.centeredSubGaussianMGF_rademacher

example :
    HighDimProb.SubGaussianTail
      HighDimProb.rademacherMeasure HighDimProb.rademacher 2 := by
  exact HighDimProb.subGaussianTail_rademacher
