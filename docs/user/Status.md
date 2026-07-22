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
- `MatrixBernstein.CenteredRankOneInputs.ofIIndepFun` and
  `CenteredRankOneExactRowInputs.ofIIndepFun` accept independence at the
  underlying random-vector level and discharge matrix-family independence
  internally.
- The generic `CenteredSelfAdjointObservationInputs` route lifts independent
  self-adjoint observations to optimized centered-sum tails while keeping
  centered-square integrability, operator-norm bounds, and variance-proxy
  bounds explicit.
- `FeatureGramOperator` packages normalized empirical/population Gram
  deviations and is reused by the NTK, LoRA, and softmax-attention examples.
  Positive-temperature softmax of independent measurable logits supplies
  bounded probability-vector features; shared-input conditional dependence and
  softmax Lipschitz/Jacobian theory are not formalized.
- The finite-dimensional Hanson-Wright endpoint
  `HighDimProb.HansonWright.hanson_wright_inequality_hdp_explicit_constant`
  is proved for finite real matrices and finite coordinate families under
  explicit `K > 0`, `iIndepFun`, and coordinate `HasSubgaussianMGF`
  assumptions at `K^2`. Its public `hansonWrightUniversalConstant` is
  independent of those parameters. It has no matrix symmetry premise and makes
  no infinite-dimensional claim.

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
filtration/martingale framework. The scalar concentration facade exposes the
full Dudley endpoint through `Dudley.Inputs`: callers provide total
boundedness, an anchor-radius bound, coordinate measurability, sub-Gaussian MGF
increments, uniformly continuous sample paths, and interval integrability of
the entropy integrand. `Dudley.Inputs.bound` constructs the finite nets and
derives measurability and integrability of `Dudley.supremum`, with
`E sup <= 4 * sigma * Dudley.entropyIntegral K R`.

The supplied dense-sequence D2/D3 bridges and compact residual lemmas remain
reusable lower-level interfaces, but they are not caller obligations of the
default bundled consumer. The full theorem does not remove the
entropy-integrability premise or claim an a.e.-only path/separable-modification
weakening.

The focused Gaussian-functional modules prove standard-Gaussian integration by
parts for compactly supported `C^1` functions, arbitrary two-variable Gaussian
linear-combination stability including zero variance, integral transport, and
the Ornstein-Uhlenbeck coefficient specialization. They do not yet claim
Gaussian Poincare, log-Sobolev, Herbst, or Lipschitz concentration.

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
