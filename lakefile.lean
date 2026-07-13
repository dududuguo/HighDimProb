import Lake
open Lake DSL

package «HighDimProb» where
  version := v!"0.1.0"
  license := "Apache-2.0"
  testDriver := "HighDimProbTest"

require "leanprover-community" / "mathlib" @ git "v4.29.1"

abbrev highDimProbLeanOptions : Array LeanOption := #[
  ⟨`autoImplicit, false⟩,
]

@[default_target]
lean_lib «HighDimProb» where
  roots := #[`HighDimProb, `HighDimProb.Experimental, `HighDimProb.Examples,
    `HighDimProb.RandomMatrix.Provider]
  leanOptions := highDimProbLeanOptions

lean_lib «HighDimProbTest» where
  globs := #[`HighDimProbTest.*]
  leanOptions := highDimProbLeanOptions

lean_lib «HighDimProbJudge» where
  globs := #[`HighDimProbJudge.*]
  leanOptions := highDimProbLeanOptions
