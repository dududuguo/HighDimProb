import HighDimProb.RandomMatrix.Provider.Analysis
import HighDimProb.RandomMatrix.Provider.Conditioning
import HighDimProb.RandomMatrix.TraceExpTroppStepProvider
import HighDimProb.RandomMatrix.MatrixBernsteinProvider
import HighDimProb.RandomMatrix.TraceExpIntegrabilityCompressionProvider
import HighDimProb.RandomMatrix.TailEventNaturalStateBridgeProvider
import HighDimProb.RandomMatrix.TailEventTraceMGFBridgeProvider
import HighDimProb.RandomMatrix.ExcessSupportDominationProvider

/-!
# Matrix-concentration providers

This facade owns downstream probability assembly built on the deterministic
analysis and conditioning layers. It exposes bounded finite-measure
integrability compression, support and tail-event domination, generated-history
trace-MGF composition, and scoped Matrix Bernstein operator-norm and
high-probability endpoints.

The public results retain their documented theorem contracts, including
positivity, measurability, integrability, independence, radius, variance-proxy,
and nondegeneracy hypotheses where required. This facade does not claim
arbitrary-history conditioning, automatic application-specific variance-proxy
control, or an unconditional full Matrix Bernstein theorem.

Import `HighDimProb.RandomMatrix.MatrixBernsteinProvider` when only the
generated-history endpoint is needed.
-/
