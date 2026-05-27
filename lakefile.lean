import Lake
open Lake DSL

package «HighDimProb» where
  version := v!"0.1.0"
  testDriver := "HighDimProbTest"

require "leanprover-community" / "mathlib" @ git "v4.29.1"

@[default_target]
lean_lib «HighDimProb» where

lean_lib «HighDimProbTest» where
  globs := #[`HighDimProbTest.*]
