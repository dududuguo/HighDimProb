import HighDimProb.RandomMatrix.ConditioningTraceExpProvider
import HighDimProb.RandomMatrix.NaturalHistoryProvider

/-!
# Conditioning and natural-history providers

This facade owns the probability-kernel boundary between deterministic matrix
analysis and concentration assembly. It exposes frozen-parameter conditional
expectation, independent-step trace-exponential conditioning, and natural
history measurability and independence bridges.

The layer keeps sigma-algebra, measurability, independence, integrability, and
frozen-bound assumptions explicit. It does not import generated-history
Bernstein assembly or operator-norm tail endpoints.

Import `HighDimProb.RandomMatrix.Provider.Concentration` when the consumer also
needs the Bernstein trace-MGF and tail pipeline.
-/
