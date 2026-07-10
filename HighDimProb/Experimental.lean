import HighDimProb.Vector
import HighDimProb.Geometry
import HighDimProb.Concentration
import HighDimProb.Distributions
import HighDimProb.RandomMatrix
import HighDimProb.LimitTheorems
import HighDimProb.Process
import HighDimProb.SignalRecovery
import HighDimProb.Tactic

/-!
# Experimental HighDimProb modules

This aggregate exposes APIs that are useful for development and documentation
but are not yet part of the stable `import HighDimProb` surface.

Use this module when you want the current high-dimensional work-in-progress
surface:

* vector, geometry, process, limit-theorem, and signal-recovery scaffolds;
* scalar concentration branches that are still outside the stable root;
* random-matrix APIs beyond the supported finite-dimensional focused surfaces.

The experimental boundary is especially important for theorem wrappers that
still carry proof-route assumptions such as explicit primitive hypotheses,
variance-proxy bounds, trace-MGF providers, CFC/Tropp assumptions, or
operator-norm bridge assumptions. Those declarations can be documented and
tested here while the assumptions are gradually removed or identified as the
right mathematical boundary.

Supported APIs should be imported through `HighDimProb` or a documented
focused module such as `HighDimProb.RandomMatrix`,
`HighDimProb.RandomMatrix.Provider.Analysis`,
`HighDimProb.RandomMatrix.Provider.Conditioning`, or
`HighDimProb.RandomMatrix.Provider.Concentration`. This development aggregate
does not re-export the provider hierarchy; import
`HighDimProb.RandomMatrix.Provider` explicitly when all provider layers are
required.

-/
