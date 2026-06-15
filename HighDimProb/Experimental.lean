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
* random-matrix APIs whose mathematical boundary is still being refined.

The experimental boundary is especially important for theorem wrappers that
still carry proof-route assumptions such as explicit primitive hypotheses,
variance-proxy bounds, trace-MGF providers, CFC/Tropp assumptions, or
operator-norm bridge assumptions. Those declarations can be documented and
tested here while the assumptions are gradually removed or identified as the
right mathematical boundary.

Stable APIs should be imported through `HighDimProb`. Experimental APIs should
be imported through a focused branch, such as `HighDimProb.RandomMatrix`, or
through this aggregate when broad work-in-progress access is intended.
-/
