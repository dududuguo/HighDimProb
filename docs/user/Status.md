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
- The focused matrix sub-Gaussian surface exports
  `MatrixSubGaussianMGF`, `MatrixSubGaussianMGF.neg`,
  `traceMGFVarianceProxyBound_of_matrixSubGaussian_under_troppPrimitive`, and
  `subGaussian_quadraticFormUpperTail_under_troppPrimitive` through
  `HighDimProb.RandomMatrix.Concentration`. The predicate states only a
  conditional Loewner MGF inequality; it does not bundle centeredness, PSD,
  self-adjointness, measurability, integrability, or probability. Its
  finite-family and tail consumers retain the explicit Tropp comparison,
  random/self-adjoint/independence, proxy self-adjointness, and unbounded
  matrix/trace-exponential integrability premises; the tail endpoint additionally
  retains the aggregate proxy spectral bound and uses those integrability
  premises at `theta = t / sigmaSq`.
- The separate directional matrix sub-Gaussian surface proves independent-sum
  closure and an epsilon-net operator-norm tail with prefactor
  `2 * N.card`. Its public `IsUnitSphereNet` facade uses the explicit finite
  Euclidean-vector convention of the RandomMatrix layer. The tail endpoint is
  restricted to positive finite dimension `Fin (n + 1)` and keeps
  `0 <= eps < 1 / 2`, `0 <= t`, probability, and entrywise integrability
  explicit. It neither constructs the net nor derives a dimension-only
  cardinality bound, and it does not imply the Loewner matrix-MGF route.
- Exact-row centered-rank-one and sample-covariance endpoints are also proved,
  including the normalized high-probability specialization. Their contracts
  keep matrix measurability, coordinate moment assumptions, row bounds,
  independence, and parameter-domain conditions explicit.
- The finite-dimensional Hanson-Wright endpoint
  `HighDimProb.HansonWright.hanson_wright_inequality_hdp_explicit_constant`
  is proved for finite real matrices and finite coordinate families under
  explicit `K > 0`, `iIndepFun`, and coordinate `HasSubgaussianMGF`
  assumptions at `K^2`. The public `hansonWrightUniversalConstant` is
  independent of the matrix, coordinate family, and sub-Gaussian scale; the
  existential `hanson_wright_inequality_hdp` remains a compatibility wrapper.
  Neither endpoint requires matrix symmetry or claims an infinite-dimensional
  extension.
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

`HighDimProb.RandomMatrix.Concentration` is the supported downstream API.
Provider modules are implementation details and are not part of the downstream
import contract. Their ownership, dependency direction, and proof-development
workflow are documented in
[`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md).

## Unsupported Boundaries

The current supported surface does not claim:

- infinite-dimensional matrix concentration;
- an unconditional Matrix Chernoff result, full Tropp theorem, or infinite-dimensional
  extension of the conditional matrix sub-Gaussian route;
- an unconditional full Matrix Bernstein theorem or the older
  arbitrary-denominator chain;
- an automatic Tropp chain for arbitrary external or larger history
  sigma-algebras;
- automatic trace-exponential integrability or assumption-weaker
  integrability propagation;
- automatic application-specific or generally sharp variance-proxy bounds;
- sample-covariance concentration without the theorem's explicit
  measurability, moment, boundedness, independence, and parameter hypotheses;
- an infinite-dimensional Hanson-Wright extension;
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
The scalar concentration facade also exposes the
full Dudley endpoint through `Dudley.Inputs`: callers provide total boundedness,
an anchor and radius, coordinate measurability, subGaussian MGF increments,
every-sample uniform path continuity, and
`IntervalIntegrable (Dudley.entropyIntegrand K) volume 0 R`. Then
`Dudley.Inputs.bound` proves that `Dudley.supremum X K t0` is measurable and
`Integrable`, with
`E sup ≤ 4 * sigma * ∫_0^R sqrt(2 * log(2 * N(K,t))) dt`. The explicit
`Dudley.fullBound` theorem exposes the same mathematics without bundling.
`Dudley.truncatedBound` is the lower-level finite-terminal-net consumer.

The focused Gaussian-functional modules currently prove standard-Gaussian
integration by parts for `C^1` compactly supported real functions, arbitrary
two-variable Gaussian linear-combination stability (including zero variance),
measurable/integrable integral transport, and the Ornstein--Uhlenbeck
coefficient specialization. They do not yet claim Gaussian Poincare,
log-Sobolev, or Lipschitz-concentration inequalities.

The full Dudley statement does not remove the entropy-integrability premise or
claim an a.e.-only path or separable-modification weakening.

## Canonical References

- Supported import map: [`APIOverview.md`](APIOverview.md)
- Public RandomMatrix API: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- Ownership and dependency architecture:
  [`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md)
- Theorem-family status: [`TheoremAtlas.md`](../reference/TheoremAtlas.md)
- Active work only: [`TODO.md`](../maintainers/TODO.md)

This page does not assign or own next tasks; `TODO.md` is the canonical active
roadmap.
