/-
Examples are kept out of `import HighDimProb` so the stable public import stays
focused on the core API. Import this module explicitly when you want the compact
usage surface.

RandomMatrix examples are intentionally routed through `StatementRoutes` instead
of importing every intermediate bridge file here. Focused lower-level examples
can still be imported directly by contributors who need them.
-/

import HighDimProb.Examples.BasicUsage
import HighDimProb.Examples.EmpiricalProcessNetUsage
import HighDimProb.Examples.NetsUsage
import HighDimProb.Examples.OrliczFeatureUsage
import HighDimProb.Examples.OrliczUsage
import HighDimProb.Examples.RandomMatrixUsage
import HighDimProb.Examples.RandomVariableUsage
import HighDimProb.Examples.RandomVectorUsage
import HighDimProb.Examples.TailUsage
import HighDimProb.Examples.RandomMatrix.StatementRoutes
import HighDimProb.Examples.RandomMatrix.SampleCovarianceUsage