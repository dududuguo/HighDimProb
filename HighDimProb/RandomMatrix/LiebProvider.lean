import HighDimProb.RandomMatrix.MatrixLogProvider
import HighDimProb.RandomMatrix.MatrixExpDerivativeProvider
import HighDimProb.RandomMatrix.CFCLogDerivativeProvider
import HighDimProb.RandomMatrix.ResolventDerivativeProvider
import HighDimProb.RandomMatrix.EpsteinDerivativeProvider
import HighDimProb.RandomMatrix.TraceExpTroppStepProvider
import HighDimProb.RandomMatrix.IntegrabilityProvider
import HighDimProb.RandomMatrix.TraceExpIntegrabilityProvider
import HighDimProb.RandomMatrix.NaturalHistoryProvider
import HighDimProb.RandomMatrix.SupportProvider
import HighDimProb.RandomMatrix.SpectralMonotonicityProvider
import HighDimProb.RandomMatrix.TraceExpLaplaceProvider

/-!
# Provider-backed Lieb/Tropp theorem-push wrappers

This aggregate module exposes the provider-proof leaves ported into the main
HighDimProb namespace. The imported modules keep the theorem boundaries
explicit: ambient and self-adjoint carrier matrix-exp Frechet derivatives,
first-order `CFC.log` affine-line derivatives, short inverse/trace-resolvent
derivatives, derivative-level Epstein consumer reductions, deterministic
log/order and trace-exp monotonicity, conditional Epstein-to-Lieb/Tropp
wrappers, bounded finite-measure integrability providers, natural-history
measurability and strengthened independence under the `TroppNaturalHistory.*`
alias layer, identity support domination, spectral endpoint monotonicity, and
thin trace-MGF-to-Laplace contracts.
-/
