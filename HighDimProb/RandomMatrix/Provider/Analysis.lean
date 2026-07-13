import HighDimProb.RandomMatrix.GoldenThompsonProvider
import HighDimProb.RandomMatrix.GibbsProvider
import HighDimProb.RandomMatrix.ResolventDerivativeProvider
import HighDimProb.RandomMatrix.CFCLogResolventRemainderLimitProvider
import HighDimProb.RandomMatrix.TraceResolventConvexProvider
import HighDimProb.RandomMatrix.SpectralMonotonicityProvider

/-!
# Internal deterministic matrix-analysis providers

This expert facade is for provider-proof development in the finite-dimensional
analytic layer used by the RandomMatrix probability pipeline. It exposes
matrix logarithm and exponential calculus, resolvent identities, relative
entropy and Gibbs bridges, the left/right Lieb--Epstein route,
Golden--Thompson, spectral monotonicity, and deterministic trace-resolvent
convexity.

The module intentionally does not own conditional expectation, random-history
bookkeeping, integrability compression, tail events, or Matrix Bernstein
assembly. Import `HighDimProb.RandomMatrix.Provider.Conditioning` or
`HighDimProb.RandomMatrix.Provider.Concentration` for those layers.

Ordinary matrix-concentration applications should import
`HighDimProb.RandomMatrix.Concentration`. Existing analytic leaf modules remain
available to expert consumers; this facade is the internal entry point when
provider proofs need the whole deterministic analysis layer without the
downstream probability pipeline.
-/
