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
- The `MatrixBernstein.CenteredRankOneInputs.ofIIndepFun` and
  `CenteredRankOneExactRowInputs.ofIIndepFun` constructors let callers supply
  independence at the underlying random-vector level via Mathlib `iIndepFun`;
  the matrix-family independence obligation is discharged internally.
- A generic centered self-adjoint observation route
  (`MatrixBernstein.CenteredSelfAdjointObservationInputs`,
  `centeredSelfAdjointObservations`, and its high-probability specialization)
  lifts self-adjoint observations to the optimized operator-norm tail under
  explicit centered-square-integrability, centered operator-norm, and
  variance-proxy assumptions. Only centeredness, self-adjointness, and centered
  entrywise integrability are derived from the uncentered family;
  `CenteredSelfAdjointObservationInputs.ofIIndepFun` additionally discharges the
  centered independence obligation from observation-level `iIndepFun` via
  `iIndepFun_centeredRandomMatrix`. It is a conditional facade, not an
  unconditional integrable/self-adjoint Bernstein theorem.
- The Attention feature-Gram example includes a positive-temperature
  softmax-attention closure: with `tau : {t : Real // 0 < t}`, softmax of
  independent measurable logits yields bounded attention-weight probability
  features (`vectorSqNorm <= 1`) that feed the centered rank-one endpoints with
  radius and variance radii `1`; the general all-real object is the core
  `HighDimProb.expNormalized`. The softmax Jacobian / Lipschitz layer and the
  shared-input conditional-dependence case are not formalized.

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
filtration/martingale framework. The metric-entropy route now includes the full
Dudley endpoint: under a probability measure, for totally bounded `K`, a root
`t0 ∈ K`, coordinate measurability, subGaussian MGF increments, `0 < R`,
`0 < sigma`, and `dist t t0 ≤ R` on `K`, together with every-sample
uniformly continuous paths and the explicit
`IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R`,
`dudley_full_supremum_bound` proves that the actual set supremum
`dudleySupremum` is measurable and `Integrable`, with
`E sup ≤ 4 * sigma * ∫_0^R sqrt(2 * log(2 * N(K,t))) dt`.
This statement does not remove the entropy-integrability premise or claim an
a.e.-only path or separable-modification weakening.

## Canonical References

- Supported import map: [`APIOverview.md`](APIOverview.md)
- Public RandomMatrix API: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- Ownership and dependency architecture:
  [`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md)
- Theorem-family status: [`TheoremAtlas.md`](../reference/TheoremAtlas.md)
- Active work only: [`TODO.md`](../maintainers/TODO.md)

This page does not assign or own next tasks; `TODO.md` is the canonical active
roadmap.
