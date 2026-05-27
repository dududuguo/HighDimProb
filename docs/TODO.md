# HighDimProb TODO

## Object-Layer Tasks

| Task | Informal goal | Dependencies | Difficulty | Reason not implemented now |
|---|---|---|---|---|
| AEMeasurable random variables | Add a predicate for random variables defined up to null sets: `AEMeasurable X P`. | `AEMeasurable` | easy | Stage 1A starts with ordinary `Measurable`. |
| Common Lp exponent conveniences | Add focused wrappers/examples for common exponents such as `1`, `2`, and `∞` if later stages need them. | `MemLp`, `eLpNorm`, `Integrable` | easy/medium | Stage 2A keeps the core exponent type as Mathlib `ENNReal`. |
| Expectation-integrability bridge lemmas | Add direct examples and bridge lemmas relating `IntegrableRealRandomVariable` to `expect`. | `Integrable`, Bochner integral | easy | Expectation remains assumption-free until a theorem layer needs these lemmas. |
| Tail probability map formulas | For measurable tail events, rewrite tail probabilities using set definitions and Mathlib measure application. | Tail-event measurability | easy | Stage 1B supplies measurability; keep probability rewrite wrappers for a later focused pass. |
| Law map application bridge | If `X` is measurable and `s` is measurable, `law P X s = P (X ⁻¹' s)`. | `Measure.map_apply` | easy | Direct wrapper, but kept out of the first object pass. |
| Expand typed theorem specifications | Add `...Statement : Prop` declarations only after the required object vocabulary exists. | `docs/TheoremAtlas.md`, object-layer definitions | easy/medium | Stage 1S only types specifications supported by existing declarations. |
| ψ₂ / ψ₁ gauge definitions | Define candidate ψ₂ and ψ₁ gauges via infimum over scales satisfying `Psi2Bound` and `Psi1Bound`. | `Psi2Bound`, `Psi1Bound`, order/infimum APIs | medium | Stage 2B implements bound predicates only. |
| Orlicz space vocabulary | Define finite-Orlicz classes once gauge definitions stabilize. | Orlicz bounds or gauges | medium | Bound predicates are enough for the next predicate layers. |
| Canonical subGaussian predicate | Choose whether HighDimProb should expose a single canonical `SubGaussian` predicate. | `SubGaussianTail`, `SubGaussianMoment`, `CenteredSubGaussianMGF`, `SubGaussianOrlicz` | medium | Stage 3A deliberately keeps formulations separate. |
| SubGaussian natural/real moment conveniences | Add natural- or real-exponent moment-growth predicates if theorem statements need them. | `SubGaussianMoment`, `eLpNorm`, casts between exponent types | medium | Stage 3A uses Mathlib `ENNReal` exponents directly. |
| Canonical subExponential predicate | Choose whether HighDimProb should expose a single canonical `SubExponential` predicate. | `SubExponentialTail`, `SubExponentialMoment`, `CenteredSubExponentialMGF`, `SubExponentialOrlicz` | medium | Stage 3B deliberately keeps formulations separate. |
| SubExponential natural/real moment conveniences | Add natural- or real-exponent moment-growth predicates if theorem statements need them. | `SubExponentialMoment`, `eLpNorm`, casts between exponent types | medium | Stage 3B uses Mathlib `ENNReal` exponents directly. |
| EuclideanSpace random-vector bridges | Relate `Fin n → ℝ` random vectors to `EuclideanSpace ℝ (Fin n)` when needed. | `RandomVector`, Mathlib `EuclideanSpace`/`PiLp` APIs | medium | Stage 4A keeps the concrete coordinate representation. |
| Finite second moment predicates | Add scalar and vector predicates for finite second moments. | `MemLp`, `coord`, `secondMomentMatrix` | easy/medium | Stage 4B keeps covariance vocabulary assumption-free. |
| Covariance identity bridge statements | Add typed statements or wrappers for `covariance = secondMoment - mean product`. | `covariance`, `secondMoment`, `ProbabilityTheory.covariance_eq_sub` | medium | Requires integrability hypotheses and theorem-layer discipline. |
| Covariance matrix structural facts | Prove or wrap symmetry and positive-semidefinite facts for covariance matrices. | `covarianceMatrix`, matrix algebra, finite second moments | hard | Beyond object vocabulary. |
| Canonical subGaussian vector predicate | Choose whether HighDimProb should expose one canonical `SubGaussianVector` predicate. | `SubGaussianVectorTail`, `SubGaussianVectorMoment`, `CenteredSubGaussianVectorMGF`, `SubGaussianVectorOrlicz` | medium | Stage 4D deliberately keeps vector formulations separate. |
| Unit-sphere subGaussian vector formulation | Define vector subGaussianity through unit directions or a supremum over the unit sphere. | `directionNorm`, Mathlib sphere/norm APIs, future ψ₂ gauge | medium | Stage 4D uses nonzero all-direction scaling first. |
| Metric entropy real-log wrapper | Define a real-valued metric entropy convention from `coveringNumber`. | `coveringNumber`, `ℕ∞`, `Real.log` | medium | Stage 5A keeps Mathlib `ℕ∞` counts and defers finite/infinite conventions. |

## Theorem-Layer Tasks

| Theorem group | Informal goal | Dependencies | Difficulty | Reason not implemented now |
|---|---|---|---|---|
| Classical inequalities | Formalize standard scalar inequalities used in probability estimates. | Mathlib analysis/order APIs | medium/hard | The object layer is not stable enough. |
| Tail integral identity | Express moments or expectations by integrating tail probabilities. | Tail probabilities, integrals, measurability | hard | Requires integration theorem work. |
| ψ₂ gauge properties | Prove basic monotonicity, scaling, and finite-gauge facts for the ψ₂ bound formulation. | `Psi2Bound`, future gauge definition | medium/hard | Gauge object is not implemented yet. |
| ψ₁ gauge properties | Prove basic monotonicity, scaling, and finite-gauge facts for the ψ₁ bound formulation. | `Psi1Bound`, future gauge definition | medium/hard | Gauge object is not implemented yet. |
| ψ₂ to subGaussian connectors | Connect `Psi2Bound` / finite ψ₂ control to tail, moment, and MGF subGaussian formulations. | Orlicz, moments, MGF, tail predicates | hard | Equivalence theorem work is deferred. |
| ψ₁ to subExponential connectors | Connect `Psi1Bound` / finite ψ₁ control to tail, moment, and MGF subExponential formulations. | Orlicz, moments, MGF, tail predicates | hard | Equivalence theorem work is deferred. |
| SubGaussian equivalence theorem | Tail, MGF, moments, and Orlicz definitions are equivalent up to constants. | Orlicz norms, moments, concentration lemmas | hard | Future theorem layer. |
| SubExponential equivalence theorem | Tail, MGF, moments, and Orlicz definitions are equivalent up to constants. | Orlicz norms, moments, concentration lemmas | hard | Future theorem layer. |
| Equivalence of isotropic formulations | Prove covariance identity and marginal second-moment characterizations of isotropicity. | `IsotropicSecondMoment`, `IsotropicCovariance`, `IsotropicMarginal`, covariance matrix, centered vector, `linearForm` | hard | Stage 4C provides vocabulary only; equivalence is theorem work. |
| Second-moment identity iff marginal identity | Prove entrywise second-moment isotropicity is equivalent to the marginal second-moment identity. | `IsotropicSecondMoment`, `IsotropicMarginal`, finite sums | hard | Requires bilinear expansion of finite linear marginals under expectation. |
| Centered covariance identity iff second-moment identity | Prove centered identity covariance is equivalent to identity second moment under centeredness. | `IsotropicCovariance`, `IsotropicSecondMoment`, covariance identity bridge | hard | Requires covariance/second-moment algebra with integrability assumptions. |
| Isotropic squared-norm expectation | Prove isotropic random vectors satisfy `E ||X||² = n`. | `IsotropicSecondMoment`, `sqNorm`, finite sums | medium/hard | Requires summing diagonal second moments and expectation/sum interchange. |
| Independent unit-variance coordinates imply isotropic | Prove independent zero-mean unit-variance coordinates imply isotropicity. | independence, centeredness, variance, covariance matrix | hard | Requires independence/covariance bridge lemmas. |
| Covariance matrix symmetry and PSD | Prove or wrap symmetry and positive-semidefinite facts for covariance matrices. | `covarianceMatrix`, finite-second-moment assumptions, matrix order/PSD API | hard | Structural covariance theorem layer. |
| Equivalence of vector subGaussian predicate forms | Prove tail, moment, MGF, and Orlicz directional vector formulations are equivalent up to constants. | `SubGaussianVectorTail`, `SubGaussianVectorMoment`, `CenteredSubGaussianVectorMGF`, `SubGaussianVectorOrlicz` | hard | Depends on scalar equivalence theorem and directional scale bookkeeping. |
| All-direction versus unit-direction subGaussian vector | Prove nonzero all-direction scaling is equivalent to the unit-sphere formulation. | `directionNorm`, unit sphere, `marginal`, scalar scaling lemmas | hard | Requires ψ₂ gauge/norm and zero-direction handling. |
| Isotropic subGaussian vector theory | Develop theorem statements and proofs for isotropic subGaussian vectors. | `IsotropicSecondMoment`, `IsotropicCovariance`, vector subGaussian predicates | hard | Requires isotropic equivalences and subGaussian vector API stability. |
| SubGaussian vector norm concentration | Prove concentration of `||X||₂` or `sqNorm X` under isotropic subGaussian assumptions. | isotropic predicates, `sqNorm`, vector subGaussian predicates | hard | Explicitly outside object layer. |
| Maximal separated set is an ε-net | Wrap or prove the standard maximal separated set cover statement. | `IsEpsilonSeparated`, `IsEpsilonNet`, Mathlib maximal separated APIs | medium | Theorem-layer work; Stage 5A only aligns definitions. |
| Packing-covering inequalities | Expose HighDimProb-facing statements for `P(K, 2ε) ≤ N(K, ε) ≤ P(K, ε)`. | Mathlib `Metric.coveringNumber`, `Metric.externalCoveringNumber`, `Metric.packingNumber` | medium | Existing Mathlib theorems should be wrapped in a focused statement layer. |
| Euclidean ball covering number bounds | Prove or wrap bounds for covering numbers of Euclidean balls. | Euclidean space/sphere APIs, volume or finite-dimensional geometry | hard | Requires Euclidean geometry layer. |
| Hamming cube covering and packing bounds | Formalize covering/packing estimates for the Hamming cube. | finite cube representation, metric choice, counting | hard | Needs combinatorial metric model. |
| ε-net operator norm bound | Prove operator norm bounds using nets on spheres. | nets, sphere, matrix/operator norm APIs | hard | Random matrix and operator-norm layers are not active. |
| Metric entropy coding interpretation | Formalize coding inequalities involving log covering numbers. | metric entropy real-log wrapper, finite covers | hard | Requires finite/infinite convention for entropy. |
| Dudley integral dependency | Prepare entropy integral vocabulary for Dudley/generic chaining. | metric entropy, random processes, integrals | hard | Random process layer is not active. |
| Bounded random variables are subGaussian | Prove bounded real variables satisfy an appropriate subGaussian formulation. | boundedness predicate, centeredness or centering, subGaussian forms | medium/hard | Requires formulation choice and proof work. |
| Centered subGaussian MGF characterization | Relate centeredness and MGF-style subGaussian control. | centeredness, expectation, `CenteredSubGaussianMGF` | hard | Centeredness/covariance layer is still experimental. |
| Centered subExponential MGF characterization | Relate centeredness and local-MGF-style subExponential control. | centeredness, expectation, `CenteredSubExponentialMGF` | hard | Centeredness/covariance layer is still experimental. |
| Sums of independent subGaussian variables | Prove closure or scale bounds for independent sums. | independence, finite sums, MGF/tail forms | hard | Future theorem layer. |
| SubGaussian square is subExponential | Prove that the square of a subGaussian variable satisfies a subExponential formulation. | subGaussian forms, subExponential forms, product/square random variables | hard | Requires equivalence and product/measurability infrastructure. |
| Product of subGaussian variables is subExponential | Prove products of subGaussian variables satisfy a subExponential formulation. | subGaussian forms, subExponential forms, product random variables | hard | Requires product measurability and Orlicz/MGF estimates. |
| Bernstein inequality | Prove Bernstein-type bounds for sums of independent centered subExponential variables. | independence, finite sums, centeredness, subExponential forms | hard | Explicitly not part of the object layer. |
| Concentration inequalities | Hoeffding, Chernoff, Bernstein, Bennett, bounded differences, Gaussian concentration. | Independence, exponential moments, integrability | hard | Explicitly not part of the object layer. |
| Covariance estimation | Sample covariance concentration and sample complexity statements. | Random vectors, matrices, concentration | hard | Future high-dimensional theorem layer. |
| Random matrix row-subGaussian assumptions | Define and use row-wise subGaussian assumptions for random matrices. | random matrices, `SubGaussianVectorOrlicz`, independence | medium/hard | Random matrix layer is not active yet. |
| Random matrix norm bounds | Operator/singular-value bounds for random matrices. | Matrix norms, nets, concentration | hard | Future high-dimensional theorem layer. |
| Johnson-Lindenstrauss | Random projections preserve finite or infinite set geometry. | Random matrices, nets, concentration | hard | Future theorem layer. |
| Hanson-Wright | Quadratic forms of subGaussian vectors concentrate. | Random vectors, matrices, subGaussian theory | hard | Future theorem layer. |
| Generic chaining | Supremum of subGaussian processes controlled by chaining functionals. | Random processes, metric entropy, Gaussian width | hard | Future theorem layer. |
| Empirical process bounds | Uniform deviations controlled by entropy or VC dimension. | Empirical measures, symmetrization, entropy | hard | Future theorem layer. |
| Signal recovery theorems | RIP, M* bounds, sparse recovery, matrix completion guarantees. | Random matrices, convex geometry, optimization | hard | Future theorem layer. |
