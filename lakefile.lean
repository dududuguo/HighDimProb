import Lake
open Lake DSL

package «HighDimProb» where
  version := v!"0.1.0"
  license := "Apache-2.0"
  testDriver := "HighDimProbTest"

require "leanprover-community" / "mathlib" @ git "v4.29.1"

@[default_target]
lean_lib «HighDimProb» where
  roots := #[`HighDimProb, `HighDimProb.Experimental, `HighDimProb.Examples]

lean_lib «HighDimProbTest» where
  globs := #[`HighDimProbTest.*]

lean_lib «HighDimProbJudge» where
  globs := #[`HighDimProbJudge.*]
