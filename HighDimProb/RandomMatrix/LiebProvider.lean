import HighDimProb.RandomMatrix.MatrixLogProvider
import HighDimProb.RandomMatrix.MatrixExpDerivativeProvider
import HighDimProb.RandomMatrix.CFCLogDerivativeProvider
import HighDimProb.RandomMatrix.ResolventDerivativeProvider
import HighDimProb.RandomMatrix.LogResolventProvider
import HighDimProb.RandomMatrix.InverseConvexityProvider
import HighDimProb.RandomMatrix.RelativeEntropyProvider
import HighDimProb.RandomMatrix.GibbsProvider
import HighDimProb.RandomMatrix.RelativeEntropyBridgeProvider
import HighDimProb.RandomMatrix.EpsteinDerivativeProvider
import HighDimProb.RandomMatrix.TraceExpTroppStepProvider
import HighDimProb.RandomMatrix.IntegrabilityProvider
import HighDimProb.RandomMatrix.TraceExpIntegrabilityProvider
import HighDimProb.RandomMatrix.NaturalHistoryProvider
import HighDimProb.RandomMatrix.SupportProvider
import HighDimProb.RandomMatrix.SpectralMonotonicityProvider
import HighDimProb.RandomMatrix.TraceExpLaplaceProvider
import HighDimProb.RandomMatrix.TraceResolventConvexProvider
import HighDimProb.RandomMatrix.TraceResolventPerspectiveProvider
import HighDimProb.RandomMatrix.TraceExpIntegrabilityCompressionProvider
import HighDimProb.RandomMatrix.TailEventNaturalStateBridgeProvider
import HighDimProb.RandomMatrix.TailEventProviderAssumptionBridgeProvider
import HighDimProb.RandomMatrix.TailEventTraceMGFBridgeProvider
import HighDimProb.RandomMatrix.TailEventDominationProvider
import HighDimProb.RandomMatrix.ExcessSupportDominationProvider
import HighDimProb.RandomMatrix.ExcessSupportCompressionProvider
import HighDimProb.RandomMatrix.ConditioningKernelProvider
import HighDimProb.RandomMatrix.ConditioningExpectationProvider
import HighDimProb.RandomMatrix.CFCLogResolventRemainderProvider
import HighDimProb.RandomMatrix.CFCLogResolventKernelProvider

/-!
# Provider-backed Lieb/Tropp theorem-push wrappers

This aggregate module exposes the provider-proof leaves ported into the main
HighDimProb namespace. The imported modules keep the theorem boundaries
explicit: ambient and self-adjoint carrier matrix-exp Frechet derivatives,
first-order `CFC.log` affine-line derivatives, short inverse/trace-resolvent
derivatives, finite-cutoff trace/CFC log-resolvent identities,
inverse-convexity quadratic-form variational identities, relative-entropy
scalar/diagonal and Gibbs bridge MVPs, derivative-level Epstein consumer
reductions, deterministic
log/order and trace-exp monotonicity, conditional Epstein-to-Lieb/Tropp
wrappers, bounded finite-measure integrability providers, natural-history
measurability and strengthened independence under the `TroppNaturalHistory.*`
alias layer, identity support domination, spectral endpoint monotonicity, and
thin trace-MGF-to-Laplace contracts, CFC-log resolvent cutoff bridges, conditioning-kernel reductions, trace-resolvent convexity, support-to-excess compression, and tail-event subset discharge wrappers. These imports do not prove full Lieb, full Tropp, Golden-Thompson, Bernstein CFC, or Matrix Bernstein.
-/
