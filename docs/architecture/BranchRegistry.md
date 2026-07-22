# Branch Registry

This registry is a short current map. Old branch planning text was collapsed
into [`archive.md`](../archive/README.md); use git history for exact old wording.

| Branch | Import path | Status | Purpose |
|---|---|---|---|
| Scalar | `HighDimProb.Scalar` | stable | One-dimensional probability vocabulary and scalar objects. |
| Analysis | `HighDimProb.Analysis` | helper | Deterministic real inequalities used by proof layers. |
| Concentration | `HighDimProb.Concentration` | public, focused import | Scalar concentration, finite maxima, Dudley, and Hanson--Wright theorem families. |
| Distributions | `HighDimProb.Distributions` | experimental | Concrete distribution atoms such as Rademacher families. |
| Vector | `HighDimProb.Vector` | experimental | Finite-dimensional random-vector vocabulary. |
| Geometry | `HighDimProb.Geometry` | experimental | Metric entropy and geometric vocabulary. |
| RandomMatrix base | `HighDimProb.RandomMatrix` | supported, scoped | Finite-dimensional objects, spectra, trace-exp, variance proxy, and statements. |
| RM concentration | `HighDimProb.RandomMatrix.Concentration` | public, downstream-facing | Ordinary downstream facade for documented trace-MGF, tail, Matrix Bernstein, and sample-covariance APIs. |
| RM analysis providers | `HighDimProb.RandomMatrix.Provider.Analysis` | internal/expert | Maintenance import for deterministic matrix analysis and Lieb/Golden--Thompson endpoints. |
| RM conditioning providers | `HighDimProb.RandomMatrix.Provider.Conditioning` | internal/expert | Maintenance import for conditional expectation and natural histories. |
| RM concentration providers | `HighDimProb.RandomMatrix.Provider.Concentration` | internal/expert | Maintenance import for trace-MGF, tail, and generated-history Matrix Bernstein assembly. |
| Examples | `HighDimProb.Examples` | downstream-facing | Usage examples that should stay readable and avoid duplicate theorem machinery. |
| Experimental | `HighDimProb.Experimental` | experimental aggregate | Opt-in surface for APIs that should not enter the stable root import yet. |

## Promotion Rule

A branch or leaf becomes stable only after focused tests, documentation updates,
import-boundary review, and a clear reason for downstream users to import it
from the stable root.
