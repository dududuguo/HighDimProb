import HighDimProb.RandomMatrix.ConditioningTraceExpProvider
import HighDimProb.RandomMatrix.NaturalHistoryProvider

/-!
# Internal conditioning and natural-history providers

This expert facade is for provider-proof development at the probability-kernel
boundary between deterministic matrix analysis and concentration assembly. It
exposes frozen-parameter conditional expectation, independent-step
trace-exponential conditioning, and natural-history measurability and
independence bridges.

The layer keeps sigma-algebra, measurability, independence, integrability, and
frozen-bound assumptions explicit. It does not import generated-history
Bernstein assembly or operator-norm tail endpoints.

Ordinary matrix-concentration applications should import
`HighDimProb.RandomMatrix.Concentration`. Provider proofs that also need the
Bernstein trace-MGF and tail pipeline should import
`HighDimProb.RandomMatrix.Provider.Concentration`.
-/
