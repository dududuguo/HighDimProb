import HighDimProb.RandomProcess

/-!
# Gaussian width vocabulary

Actual Gaussian-width theorems are future work.

Note: wiki.md listed `https://en.wikipedia.org/wiki/Gaussian_width`, but this
was not verified as a dedicated Wikipedia page. No Wikipedia link is embedded
for the placeholder formula beyond this audit note.  The standard mathematical
formula usually formalized later is `w(T) = E sup_{t in T} <g, t>` for a
standard Gaussian vector `g`, but this file does not define that formula.
-/

namespace HighDimProb

/--
Placeholder type for a Gaussian-width functional on subsets of a space.

Formula audit note: `Set E -> R` only reserves the type of a future functional.
It does not assert the Gaussian-width formula `w(T) = E sup_{t in T} <g, t>`,
so there is no Wikipedia-backed formula to cite here.
-/
abbrev GaussianWidthFunctional (E : Type*) := Set E → ℝ

end HighDimProb
