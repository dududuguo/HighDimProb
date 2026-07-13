import HighDimProb.RandomMatrix.Provider.Analysis
import HighDimProb.RandomMatrix.Provider.Conditioning
import HighDimProb.RandomMatrix.TraceExpTroppStepProvider
import HighDimProb.RandomMatrix.MatrixBernsteinProvider
import HighDimProb.RandomMatrix.TraceExpIntegrabilityCompressionProvider
import HighDimProb.RandomMatrix.TailEventNaturalStateBridgeProvider
import HighDimProb.RandomMatrix.TailEventTraceMGFBridgeProvider
import HighDimProb.RandomMatrix.ExcessSupportDominationProvider

/-!
# Internal matrix-concentration providers

This expert facade is the internal provider-proof assembly built on the
deterministic analysis and conditioning layers. It exposes bounded
finite-measure integrability compression, support and tail-event domination,
generated-history trace-MGF composition, and scoped Matrix Bernstein
operator-norm and high-probability endpoints.

The public results retain their documented theorem contracts, including
positivity, measurability, integrability, independence, radius, variance-proxy,
and nondegeneracy hypotheses where required. This facade does not claim
arbitrary-history conditioning, automatic application-specific variance-proxy
control, or an unconditional full Matrix Bernstein theorem.

Ordinary matrix-concentration applications and downstream users should import
`HighDimProb.RandomMatrix.Concentration`. The module
`HighDimProb.RandomMatrix.MatrixBernsteinProvider` is an implementation leaf
for the generated-history endpoint, not the preferred downstream import.
-/
