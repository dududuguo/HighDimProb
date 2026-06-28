import HighDimProb.RandomMatrix.MatrixLogProvider
import HighDimProb.RandomMatrix.MatrixExpDerivativeProvider
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
explicit: ambient matrix-exp Frechet derivatives, deterministic log/order and
trace-exp monotonicity, conditional Epstein-to-Lieb/Tropp wrappers, bounded
finite-measure integrability providers,
natural-history measurability from suffix entries, identity support domination,
spectral endpoint monotonicity, and thin trace-MGF-to-Laplace contracts.
-/
