import HighDimProb.RandomMatrix.GoldenThompsonProvider
import HighDimProb.RandomMatrix.GibbsProvider
import HighDimProb.RandomMatrix.ResolventDerivativeProvider
import HighDimProb.RandomMatrix.CFCLogResolventRemainderLimitProvider
import HighDimProb.RandomMatrix.TraceResolventConvexProvider
import HighDimProb.RandomMatrix.SpectralMonotonicityProvider

/-!
# Deterministic matrix-analysis providers

This facade owns the finite-dimensional analytic layer used by the
RandomMatrix probability pipeline. It exposes matrix logarithm and exponential
calculus, resolvent identities, relative entropy and Gibbs bridges, the
left/right Lieb--Epstein route, Golden--Thompson, spectral monotonicity, and
deterministic trace-resolvent convexity.

The module intentionally does not own conditional expectation, random-history
bookkeeping, integrability compression, tail events, or Matrix Bernstein
assembly. Import `HighDimProb.RandomMatrix.Provider.Conditioning` or
`HighDimProb.RandomMatrix.Provider.Concentration` for those layers.

Existing leaf modules remain valid public imports. This facade is the preferred
entry point for the proved deterministic matrix-analysis surface without the
downstream probability pipeline.
-/
