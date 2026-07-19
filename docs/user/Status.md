# Status

This page is a concise snapshot of the supported library surface. Exact theorem
signatures live in Lean source and the focused API documentation.

## Supported Import Surfaces

| Import | Status and intended use |
|---|---|
| `HighDimProb` | Stable, intentionally narrow root surface for scalar probability objects and typed statement specifications. |
| `HighDimProb.Concentration` | Focused scalar concentration surface. |
| `HighDimProb.RandomMatrix` | Supported finite-dimensional random-matrix base: objects, algebra, order, spectra, sums, and statement vocabulary. |
| `HighDimProb.RandomMatrix.Concentration` | Preferred public downstream facade for trace-MGF, tail, Matrix Bernstein, and sample-covariance results. |

`HighDimProb.Experimental` and `HighDimProb.Examples` are opt-in surfaces and
are not part of the stable root import. Focused support means that theorem
contracts are stable under their documented hypotheses; it does not mean that
those hypotheses are discharged automatically.

## Proved Scope

- The RandomMatrix development supports finite-dimensional real matrices and
  finite index families. Its proved base includes the matrix algebra, Loewner
  order, spectral, trace-exponential, finite-sum, conditioning-bookkeeping, and
  variance-proxy bridges used by the concentration layer.
- The finite-dimensional analysis route proves the Bernstein CFC inequality,
  the left/right relative-entropy route to Lieb/Epstein concavity, and the
  Golden--Thompson endpoint. These results retain their stated self-adjointness,
  positivity, strict-positivity/log-domain, integrability, and finite-dimensional
  hypotheses where applicable.
- The generated-history Matrix Bernstein route proves trace-MGF, optimized
  scalar-tail, positive-threshold operator-norm, and high-probability endpoints.
  `MatrixBernstein.optimized_of_primitives` and
  `MatrixBernstein.highProbability_of_primitives` are the compact generic
  endpoints under explicit finite-family Bernstein primitives.
- Exact-row centered-rank-one and sample-covariance endpoints are also proved,
  including the normalized high-probability specialization. Their contracts
  keep matrix measurability, coordinate moment assumptions, row bounds,
  independence, and parameter-domain conditions explicit.

Across these results, theorem statements may require centeredness,
self-adjointness, independence, measurability, matrix/trace-exponential
integrability, radius bounds, variance-proxy bounds, conditional-step data, and
sign or nondegeneracy assumptions. Assumption records and facades package these
requirements; they do not erase them.

## Provider Boundary

`HighDimProb.RandomMatrix.Concentration` is the downstream API. The provider
hierarchy is the implementation and expert-proof boundary:

- `HighDimProb.RandomMatrix.Provider.Analysis` owns deterministic matrix
  analysis, CFC/resolvent, relative-entropy, Lieb/Epstein, and
  Golden--Thompson infrastructure.
- `HighDimProb.RandomMatrix.Provider.Conditioning` owns kernels, conditional
  expectation, frozen-parameter, and natural-history infrastructure.
- `HighDimProb.RandomMatrix.Provider.Concentration` owns trace-MGF, tail, and
  Matrix Bernstein assembly re-exported by the public facade.
- `HighDimProb.RandomMatrix.Provider` is the broad expert facade. Normal
  downstream code should prefer `HighDimProb.RandomMatrix.Concentration`;
  expert proofs should import the narrowest provider layer they need.

`HighDimProb.RandomMatrix.LiebProvider` is a compatibility import, not a new
ownership layer. Provider facades expose explicit proof ingredients and do not
constitute an unconditional concentration theorem.

## Unsupported Boundaries

The current supported surface does not claim:

- infinite-dimensional matrix concentration;
- an unconditional full Matrix Bernstein theorem or the older
  arbitrary-denominator chain;
- an automatic Tropp chain for arbitrary external or larger history
  sigma-algebras;
- automatic trace-exponential integrability or assumption-weaker
  integrability propagation;
- automatic application-specific or generally sharp variance-proxy bounds;
- sample-covariance concentration without the theorem's explicit
  measurability, moment, boundedness, independence, and parameter hypotheses;
- concrete support/effective-rank certificates beyond the proved explicit
  certificate consumers; or
- proof of every declaration in the hardbone statement atlas: typed statement
  targets remain specifications until backed by a theorem.

Outside RandomMatrix, the random-family layer remains vocabulary rather than a
filtration/martingale framework. The metric-entropy route now proves the finite
D1 anchored supremum bound under a supplied common-anchor path family, shared
finite level data, and an explicit integrable terminal-residual envelope. Its
compact residual bridges and D2 integral limit inequality are proved under
explicit compactness, mapping, convergence, and interval-integrability inputs.
The D3 bridge `expect_iSup_abs_sub_anchor_le_of_denseRange_of_prefix_bound` and
the D2-to-D3 assembly bridge
`expect_iSup_abs_sub_anchor_le_mul_intervalIntegral_of_denseRange_of_prefix_bound`
remain reusable supplied-bound interfaces. The public
`dudleyEntropyIntegral` theorem now closes the anchored Dudley endpoint over a
totally bounded subtype `K`: it constructs the dyadic finite geometry, controls
the finite-prefix residual by the finite subGaussian maximum bound, and invokes
the existing D2-to-D3 passage. The theorem explicitly assumes a dense sequence
in `K`, a singleton anchor `R`-net, measurable subGaussian increments, positive
parameters, continuous and bounded sample paths on `K`, integrability of the
full anchored supremum, and interval integrability of the entropy integrand at
zero. It does not derive those regularity or integrability assumptions.

The finite-dimensional covering surface is also proved and publicly imported by
`HighDimProb.Geometry`: `l1Ball` and the internal `ENat` bounds
`coveringNumber_euclideanBall_le` and `coveringNumber_l1Ball_le` give
`ceil((1 + 2R/eps)^card)` and `ceil((1 + 4R/eps)^card)` under `R >= 0`,
`eps > 0`, and finite nonempty index assumptions. The l1 result is the
volumetric route through `B1 ⊆ B2` (`l1Ball` inside the Euclidean closed ball)
and Mathlib subset comparison, not the sharper Maurey estimate. The existing
`exists_finset_isInternalEpsilonNet_of_totallyBounded` supplies the exact finite
internal-net facade; no duplicate constructor was added.

## Canonical References

- Supported import map: [`APIOverview.md`](APIOverview.md)
- Public RandomMatrix API: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- Ownership and dependency architecture:
  [`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md)
- Theorem-family status: [`TheoremAtlas.md`](../reference/TheoremAtlas.md)
- Active work only: [`TODO.md`](../maintainers/TODO.md)

This page does not assign or own next tasks; `TODO.md` is the canonical active
roadmap.
