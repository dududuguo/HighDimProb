import HighDimProb.RandomMatrix.Provider.Concentration
import HighDimProb.RandomMatrix.SubGaussian
import HighDimProb.RandomMatrix.DirectionalSubGaussian

/-!
# Matrix concentration

Public theorem surface for finite-dimensional random-matrix concentration.

Applications and downstream consumers should import this module rather than
the implementation-oriented `Provider` hierarchy. It exposes the documented
trace-MGF, tail, and Matrix Bernstein APIs while retaining the existing proof
assembly as an internal dependency.
-/
