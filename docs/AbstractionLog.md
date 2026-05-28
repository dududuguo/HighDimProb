# HighDimProb Abstraction Log

## Workflow discipline

- Concrete version chosen: future rounds process one concept cluster at a time.
- Possible general version: linear translation of the reference notes into Lean files.
- Reason for not generalizing yet: the package needs a stable object language before theorem statements or broad coverage.
- Lean/mathlib obstruction: translating ahead of the object layer creates fake declarations, unstable APIs, and avoidable typeclass friction.
- Future upgrade path: use `docs/Workflow.md`, `docs/Status.md`, and `docs/BookProgress.md` to advance mechanically.

## Milestone closeout discipline

- Concrete version chosen: Milestone 1 closes with an audit document, import-boundary review, test coverage review, and documentation consistency pass.
- Possible general version: continue directly into the next implementation stage after `lake test`.
- Reason for not generalizing yet: the stable v0.1 probability API and experimental v0.2 vocabulary must stay clearly separated before theorem-statement work starts.
- Lean/mathlib obstruction: stale docs or accidental root imports can make scaffold declarations look like reviewed public API.
- Future upgrade path: use `docs/Milestone1.md` as the baseline for Stage 5B and Stage 6A planning.

## Public alpha readiness

- Concrete version chosen: Stage P0 prepares contributor-facing documentation, issue templates, and CI without changing mathematical APIs.
- Possible general version: treat the alpha push as a full release with theorem guarantees and stable v0.2 modules.
- Reason for not generalizing yet: Milestone 1 is an alpha contributor milestone; only the v0.1 probability object layer is stable.
- Lean/mathlib obstruction: v0.2 high-dimensional modules are still experimental and may need representation or theorem-statement adjustments.
- Future upgrade path: after public push, continue with Stage 5B or Stage 6A while keeping stable and experimental imports separate.

## Infrastructure hardening

- Concrete version chosen: Stage I0 hardens repository scaffolding, contribution workflow, CI, issue templates, and future-stage organization without changing Lean mathematical content.
- Possible general version: begin Stage 5B theorem statements or Stage 6A random matrices immediately.
- Reason for not generalizing yet: future contributors and model agents need explicit gates before adding new vocabulary or theorem statements.
- Lean/mathlib obstruction: weak process boundaries can accidentally promote experimental APIs, add unsupported theorem declarations, or bypass Mathlib-first design.
- Future upgrade path: use `docs/StageChecklist.md` and `docs/FutureScaffold.md` before starting each new stage.

## Experimental promotion gate

- Concrete version chosen: stable v0.1 modules are imported through `import HighDimProb`, while experimental v0.2+ modules are imported through `import HighDimProb.Experimental`.
- Possible general version: expose all compiling modules through the root import.
- Reason for not generalizing yet: experimental high-dimensional modules are partial and may still change.
- Lean/mathlib obstruction: root import promotion creates downstream compatibility obligations and can hide missing tests or docs.
- Future upgrade path: promote a module only after tests, docs, `docs/Status.md`, and a root import audit are complete.

## Mathlib-first rule

- Concrete version chosen: Mathlib search is mandatory before new definitions.
- Possible general version: define local HighDimProb versions of familiar probability and analysis objects.
- Reason for not generalizing yet: HighDimProb is an ergonomic layer, not a replacement library.
- Lean/mathlib obstruction: duplicate abstractions break interoperability with Mathlib lemmas.
- Future upgrade path: add aliases, wrappers, bridge lemmas, and examples around Mathlib objects.

## Theorem staging

- Concrete version chosen: hard theorem statements go to `docs/TODO.md`, not Lean code.
- Possible general version: add theorem declarations early and fill proofs later.
- Reason for not generalizing yet: `sorry`, `admit`, axioms, and fake statements are forbidden.
- Lean/mathlib obstruction: theorem statements often require substantial prerequisite vocabulary just to state correctly.
- Future upgrade path: promote theorem TODOs only after the required object layer and bridge lemmas compile.

## Public API boundary

- Concrete version chosen: `import HighDimProb` exposes only reviewed stable modules.
- Possible general version: root import exposes every compiling module, including future scaffolds.
- Reason for not generalizing yet: scaffold declarations should compile but should not look like stable v0.1 API.
- Lean/mathlib obstruction: downstream imports and theorem work can accidentally depend on unstable placeholder vocabulary.
- Future upgrade path: future modules live under `HighDimProb.Experimental` until their stage is active, reviewed, documented, and intentionally promoted to the stable root import.

## Experimental scaffolds

- Concrete version chosen: `HighDimProb.Experimental` aggregates future scaffold modules.
- Possible general version: delete scaffolds until their stages are active.
- Reason for not generalizing yet: keeping scaffolds compiling helps preserve roadmap structure without exposing them as stable.
- Lean/mathlib obstruction: scaffold declarations may need later redesign after Mathlib search for their specific stage.
- Future upgrade path: when a stage starts, search Mathlib, revise the scaffold, update docs/tests, and then promote only the stable module imports.

## Book theorem atlas

- Concrete version chosen: unproved book results are represented as documentation entries or typechecked `Prop` specifications.
- Possible general version: add every major book result as a Lean `theorem` or `lemma` declaration now.
- Reason for not generalizing yet: in Lean, a `theorem` or `lemma` is a proved result; unproved book statements must not appear as proved declarations.
- Lean/mathlib obstruction: many book statements require missing HighDimProb vocabulary for Lp wrappers, Orlicz norms, subGaussian predicates, random vectors, random matrices, and empirical processes.
- Future upgrade path: use typed statements to discover missing infrastructure, then promote selected specifications to proved declarations only after the object layer stabilizes.

## Probability spaces

- Concrete version chosen: Mathlib `Measure Ω` plus `[IsProbabilityMeasure P]`.
- Possible general version: bundled probability-space structure.
- Reason for not generalizing yet: Mathlib probability APIs are unbundled.
- Lean/mathlib obstruction: Bundling would create coercion and instance friction.
- Future upgrade path: Add optional bundled wrappers only if repeated examples justify them.

## Random variables

- Concrete version chosen: bare functions `Ω → E` with separate `Measurable` assumptions.
- Possible general version: bundled measurable random variable.
- Reason for not generalizing yet: Mathlib uses functions directly.
- Lean/mathlib obstruction: Bundles make `Measure.map`, integrals, and `MemLp` less ergonomic.
- Future upgrade path: Add a lightweight structure only for documentation-heavy workflows.

## Measure-indexed random-variable predicates

- Concrete version chosen: `IsRandomVariable P X := Measurable X`.
- Possible general version: omit `P`, or use `AEMeasurable X P`.
- Reason for not generalizing yet: probability-facing APIs naturally mention the ambient measure `P`, but Stage 1A uses ordinary measurability.
- Lean/mathlib obstruction: `Measurable X` does not depend on `P`, so the binder is intentionally unused in the definition.
- Future upgrade path: add separate `IsAERandomVariable P X := AEMeasurable X P` rather than changing this predicate.

## Real-valued first layer

- Concrete version chosen: `RealRandomVariable Ω := Ω → ℝ`.
- Possible general version: variables valued in normed/vector/measurable spaces.
- Reason for not generalizing yet: tail, Orlicz, and subGaussian vocabulary starts over `ℝ`.
- Lean/mathlib obstruction: General normed codomains add typeclass requirements before needed.
- Future upgrade path: Generalize selected predicates after real-valued API stabilizes.

## Measurable before AEMeasurable

- Concrete version chosen: `Measurable X` for Stage 1A random variables.
- Possible general version: `AEMeasurable X P`.
- Reason for not generalizing yet: tail-event sets and `Measure.map` examples are simpler with `Measurable`.
- Lean/mathlib obstruction: many Mathlib integral and Lp lemmas prefer a.e. measurability, but using it too early changes equality and null-set behavior.
- Future upgrade path: introduce a parallel a.e. measurable vocabulary once the measurable layer is stable.

## Expectation and integrability

- Concrete version chosen: `expect P X := ∫ ω, X ω ∂P`.
- Possible general version: bundled expectation requiring `Integrable X P`.
- Reason for not generalizing yet: Mathlib's integral notation already carries the core object language, and integrability should remain a separate assumption.
- Lean/mathlib obstruction: forcing integrability into the definition would make basic notation harder to use and diverge from Mathlib style.
- Future upgrade path: add bridge lemmas relating `IntegrableRealRandomVariable P X` to `expect` only when a focused theorem layer needs them.

## Lp and moments

- Concrete version chosen: `MemLpRandomVariable`, `MemLpRealRandomVariable`, `lpNormRandomVariable`, `realLpNorm`, `IntegrableRandomVariable`, `IntegrableRealRandomVariable`, `HasFiniteMoment`, and `momentSeminorm` are aliases around Mathlib `MemLp`, `eLpNorm`, and `Integrable`.
- Possible general version: define HighDimProb-specific Lp spaces, real-valued `p : ℝ` moment norms, or bundled moment structures.
- Reason for not generalizing yet: Mathlib already has the stable Lp object language, and Stage 2A only needs vocabulary that downstream probability statements can reuse.
- Lean/mathlib obstruction: Mathlib Lp exponents use `ENNReal`, while book notation often uses real or natural exponents; adding casts and side conditions too early would create unnecessary API churn.
- Future upgrade path: add convenience wrappers for common exponents and selected bridge lemmas, such as the `p = 1` connection to integrability, after Orlicz and subGaussian definitions reveal the needed shape.

## Random vectors

- Concrete version chosen: `RandomVector Ω n := Ω → Fin n → ℝ`, with `IsRandomVector P X` as coordinatewise measurability.
- Possible general version: `Ω → EuclideanSpace ℝ (Fin n)`, arbitrary finite-dimensional normed spaces, or a bundled measurable random-vector structure.
- Reason for not generalizing yet: coordinate projections, finite linear marginals, and squared norms are immediate with `Fin n → ℝ`, and Mathlib probability APIs already work with bare functions.
- Lean/mathlib obstruction: Euclidean-space, matrix-column, and bundled measurable-vector APIs introduce coercion and typeclass choices before covariance and random-matrix layers have fixed their needs.
- Future upgrade path: add bridges to `EuclideanSpace ℝ (Fin n)` and matrix column vectors after covariance and random matrix APIs are reviewed.

## Random-vector structure deferral

- Concrete version chosen: no custom random-vector structure; use aliases, predicates, and functions.
- Possible general version: bundle `X : Ω → Fin n → ℝ` with coordinate measurability and possibly integrability assumptions.
- Reason for not generalizing yet: bundling would make coordinates, `Measure.map`, integrals, and existing scalar random-variable APIs less direct.
- Lean/mathlib obstruction: downstream APIs need different assumptions, such as coordinatewise measurability, integrability, finite second moments, or subGaussian marginal control.
- Future upgrade path: introduce a bundled helper only if repeated theorem statements need the same package of assumptions.

## Covariance and isotropicity staging

- Concrete version chosen: Stage 4B defines scalar covariance/variance aliases, centered scalar/vector vocabulary, and entrywise second-moment/covariance matrices.
- Possible general version: define covariance matrices as matrix-valued expectations and immediately add isotropicity.
- Reason for not generalizing yet: entrywise matrices are enough for the next object layer and avoid premature Bochner integral choices for matrix-valued random variables.
- Lean/mathlib obstruction: matrix-valued expectations, finite-second-moment assumptions, and positive-semidefinite facts need careful alignment with Mathlib matrix and integrability APIs.
- Future upgrade path: Stage 4C can define isotropicity using `CenteredVector`, `secondMomentMatrix`, and `covarianceMatrix`; theorem work can later prove entrywise identities and PSD/symmetry facts.

## Third proof pilot: centered vector coordinate bridge

- Concrete version chosen: Stage P3 exposes `centeredVector_iff_forall_centered_coord` as the user-facing bridge from vector centeredness to coordinatewise scalar centeredness.
- Possible general version: prove centeredness of the centered transform or covariance identities at the same time.
- Reason for not generalizing yet: this pilot only tests the vector-coordinate API; expectation algebra and covariance identities remain separate theorem work.
- Lean/mathlib obstruction: none; the bridge is definitional and did not require function extensionality or Mathlib search.
- Future upgrade path: use this bridge in later covariance/isotropic theorem statements, then add expectation identities only with explicit integrability assumptions.

## Fourth proof pilot: centered scalar operation

- Concrete version chosen: Stage P4 proves `centered_centered` for integrable real random variables under `[IsProbabilityMeasure P]`.
- Possible general version: add a full expectation algebra API with constant, add, sub, and scalar multiplication lemmas.
- Reason for not generalizing yet: this pilot only needs the centered subtraction proof; broader expectation algebra should be introduced as downstream theorem work demands it.
- Lean/mathlib obstruction: none; `IntegrableRealRandomVariable` unfolded cleanly to Mathlib `Integrable`, and probability mass-one simplification worked through `integral_const`.
- Future upgrade path: add named HighDimProb wrappers such as `expect_const` or `expect_sub_const` only when repeated theorem statements need them.

## Fifth proof pilot: tail probability monotonicity

- Concrete version chosen: Stage P5 proves `upperTailProb_antitone`, `lowerTailProb_monotone`, and `absTailProb_antitone` directly from the tail event definitions.
- Possible general version: add a reusable event-inclusion API for every tail-event variant before proving monotonicity.
- Reason for not generalizing yet: the three proofs are one-line applications of Mathlib `measure_mono`, so named inclusion lemmas would be premature.
- Lean/mathlib obstruction: none; tail wrappers unfolded transparently, ENNReal measure order worked through `measure_mono`, and no measurability assumptions were required.
- Future upgrade path: add named tail-event inclusion lemmas only if Stage P6 or later concentration proofs reuse the same inclusions.

## Mathlib covariance reuse

- Concrete version chosen: `covariance` and `variance` are aliases around Mathlib `ProbabilityTheory.covariance` and `ProbabilityTheory.variance`.
- Possible general version: keep local HighDimProb scalar covariance and variance definitions.
- Reason for not generalizing yet: Mathlib already has the scalar probability objects and theorems.
- Lean/mathlib obstruction: duplicate scalar covariance definitions would require bridge lemmas before using Mathlib variance/covariance results.
- Future upgrade path: add HighDimProb-facing theorem wrappers around Mathlib covariance lemmas only when theorem layers need them.

## Covariance integrability assumptions

- Concrete version chosen: Stage 4B object declarations do not bundle integrability or finite-second-moment assumptions.
- Possible general version: require `MemLp X 2 P` or integrability in every covariance and second-moment object.
- Reason for not generalizing yet: the object layer is vocabulary-first, and different theorem families need different assumptions.
- Lean/mathlib obstruction: bundling assumptions too early would make basic matrix entries harder to state and would not match Mathlib's unbundled theorem style.
- Future upgrade path: add `HasFiniteSecondMoment` and vector finite-second-moment predicates when covariance identities or concentration theorems are assigned.

## Isotropic formulation separation

- Concrete version chosen: Stage 4C exposes separate predicates `IsotropicSecondMoment`, `IsotropicCovariance`, and `IsotropicMarginal`.
- Possible general version: define one canonical `Isotropic` predicate and prove or assume all standard characterizations immediately.
- Reason for not generalizing yet: the reference notes use several equivalent characterizations, but equivalence is theorem-layer work and has not been proved.
- Lean/mathlib obstruction: moving between second-moment, covariance, and marginal formulations needs covariance identities, finite-second-moment/integrability assumptions, and finite-sum algebra.
- Future upgrade path: prove the characterizations one direction at a time, then introduce a canonical alias only if downstream theorem statements need it.

## Isotropic identity representation

- Concrete version chosen: entrywise identity predicates are primary; `IsotropicSecondMomentMatrix` is a matrix-equality vocabulary wrapper.
- Possible general version: state all isotropicity only as matrix equality against `1`.
- Reason for not generalizing yet: entrywise formulations avoid dependence on extensionality lemmas in basic API examples and match the coordinatewise random-vector representation.
- Lean/mathlib obstruction: matrix equality is clean for declarations, but theorem work still typically unfolds to entries via `Matrix.one_apply`.
- Future upgrade path: add bridge lemmas between entrywise and matrix forms when isotropic equivalence theorems are assigned.

## Second proof pilot: isotropic matrix/entrywise bridge

- Concrete version chosen: Stage P2 proves `isotropicSecondMomentMatrix_iff_isotropicSecondMoment` directly in `HighDimProb.Isotropic`.
- Possible general version: prove all covariance, second-moment, and marginal isotropic characterizations together.
- Reason for not generalizing yet: covariance and marginal equivalences need integration and finite-sum algebra, while the matrix/entrywise bridge is purely definitional.
- Lean/mathlib obstruction: `Matrix.ext` and `Matrix.one_apply` worked cleanly, but unrestricted `simp` can recurse around matrix identity unfolding; the proof uses `simp only`.
- Future upgrade path: keep this theorem as the stable bridge for later isotropic theorem statements, then add covariance and marginal bridges only with explicit assumptions.

## Isotropic canonical-name deferral

- Concrete version chosen: no new ambiguous `Isotropic` predicate is introduced; `IsIsotropic` remains only as a compatibility alias for `IsotropicCovariance`.
- Possible general version: use `Isotropic` as the single user-facing predicate for all future vector results.
- Reason for not generalizing yet: choosing covariance-form versus second-moment-form isotropicity affects assumptions around centering and covariance identities.
- Lean/mathlib obstruction: a canonical predicate would force theorem statements to commit to one formulation before equivalence bridges exist.
- Future upgrade path: deprecate or redirect the compatibility alias after the vector theorem layer settles on a canonical formulation.

## High-dimensional subGaussian vector forms

- Concrete version chosen: Stage 4D defines vector subGaussianity through one-dimensional marginals `marginal X a`.
- Possible general version: define vector-valued subGaussian random variables directly in Euclidean or Banach spaces.
- Reason for not generalizing yet: the reference notes define high-dimensional subGaussianity through scalar marginals, and the existing representation is coordinatewise `Fin n → ℝ`.
- Lean/mathlib obstruction: a direct vector-valued definition would require normed-space, dual-space, and measurability choices before the random-matrix layer is active.
- Future upgrade path: add bridges to `EuclideanSpace ℝ (Fin n)` and dual/normed-space formulations after the coordinate API is stable.

## Directional scaling before unit sphere

- Concrete version chosen: vector predicates quantify over nonzero directions and use the concrete scale `K * Real.sqrt (∑ i, (a i)^2)`.
- Possible general version: define a unit-sphere supremum or ψ₂ vector norm `sup_{a ∈ S^{n-1}} ||⟪X,a⟫||_{ψ₂}`.
- Reason for not generalizing yet: HighDimProb has bound predicates but not ψ₂ gauges/norms, and unit-sphere API choices should be aligned with Mathlib before theorem work.
- Lean/mathlib obstruction: the all-direction formulation avoids choosing a sphere type, but the zero direction has zero scale while scalar ψ₂ predicates require positive scales.
- Future upgrade path: prove equivalence between nonzero all-direction scaling and a unit-direction formulation once the ψ₂ gauge and sphere vocabulary are available.

## SubGaussian vector canonical-name deferral

- Concrete version chosen: Stage 4D exposes `SubGaussianVectorTail`, `SubGaussianVectorMoment`, `CenteredSubGaussianVectorMGF`, and `SubGaussianVectorOrlicz` separately.
- Possible general version: define a single canonical `SubGaussianVector` predicate.
- Reason for not generalizing yet: scalar subGaussian formulations are still deliberately separate, and vector equivalence theorems are not proved.
- Lean/mathlib obstruction: tail, moment, MGF, and Orlicz formulations carry different integrability and constant conventions.
- Future upgrade path: choose a canonical vector predicate only after downstream theorem statements identify a preferred formulation.

## SubGaussian vector experimental status

- Concrete version chosen: `HighDimProb.SubGaussianVector` is imported through `HighDimProb.Experimental`, not through the stable root import.
- Possible general version: promote all v0.2 vector modules to the stable root immediately.
- Reason for not generalizing yet: v0.2 vector, covariance, isotropic, and matrix interfaces are still being shaped.
- Lean/mathlib obstruction: premature stable imports make future representation or scale-convention changes harder for downstream users.
- Future upgrade path: promote reviewed v0.2 modules intentionally after nets, matrix, and row-subGaussian vocabulary are aligned.

## Tail predicates

- Concrete version chosen: event-level definitions and direct tail-bound predicates.
- Possible general version: MGF, Orlicz norm, moment growth, and tail definitions with equivalence theorems.
- Reason for not generalizing yet: equivalence theorems are deep and explicitly out of scope.
- Lean/mathlib obstruction: Requires nontrivial integration and exponential moment API work.
- Future upgrade path: Formalize one direction at a time after the definitions are stable.

## Tail-event measurability

- Concrete version chosen: bridge lemmas from `IsRealRandomVariable P X` to `MeasurableSet` and `IsMeasurableEvent` for upper, lower, and absolute tails.
- Possible general version: a.e. measurable or null-measurable tail-event lemmas.
- Reason for not generalizing yet: Stage 1B uses ordinary `Measurable` to stay aligned with the Stage 1A object layer.
- Lean/mathlib obstruction: a.e. measurable variants would need null-measurable-event or completion-sensitive statements.
- Future upgrade path: add parallel `AEMeasurable`/`NullMeasurableSet` lemmas after the measurable layer is stable.

## Statement-to-bridge promotion

- Concrete version chosen: the Stage 1S `tailEventMeasurabilityStatement` is connected to proved Stage 1B bridge lemmas by `tailEventMeasurabilityStatement_holds`.
- Possible general version: immediately promote every typed `...Statement : Prop` to a proved theorem.
- Reason for not generalizing yet: only tail-event measurability has the required object-level infrastructure and trivial Mathlib proof path.
- Lean/mathlib obstruction: other statement specs still need integrability, Lp, Orlicz, subGaussian, vector, or matrix vocabulary.
- Future upgrade path: promote one statement at a time when its required declarations and bridge lemmas are already present.

## Orlicz and psi bounds

- Concrete version chosen: `OrliczFunction := ℝ → ℝ`, model functions `psiPower`, `psi1Function`, `psi2Function`, and predicate-level bounds `OrliczBound`, `Psi2Bound`, `Psi1Bound`, `HasFinitePsi2`, and `HasFinitePsi1`.
- Possible general version: bundled convex increasing Orlicz functions, Luxemburg gauges via infimum over scales, and normed-space structures for Orlicz classes.
- Reason for not generalizing yet: Stage 2B only needs stable vocabulary for later subGaussian and subExponential predicate layers.
- Lean/mathlib obstruction: no dedicated Mathlib Orlicz API was found, while Mathlib does have probability MGF infrastructure; forcing a full Orlicz norm now would require nontrivial measurability, integrability, monotonicity, and infimum design.
- Future upgrade path: define ψ₁/ψ₂ gauges by infimum after the bound predicates are used in later APIs, then prove gauge properties as theorem-layer work.

## Orlicz integration formulation

- Concrete version chosen: Orlicz and ψ bounds use `lintegral` with `ENNReal.ofReal` around the exponential integrands.
- Possible general version: use Bochner expectation `∫ ω, ... ∂P` with explicit integrability assumptions.
- Reason for not generalizing yet: the object layer should state finite exponential control without bundling integrability into a new structure.
- Lean/mathlib obstruction: real-valued integral statements would immediately require measurability and integrability side conditions for exponential transforms.
- Future upgrade path: add real-integral bridge lemmas once `AEMeasurable`, exponential integrability, and MGF-facing predicates are active.

## SubGaussian/subExponential name deferral

- Concrete version chosen: Stage 2B names only `Psi2Bound` and `Psi1Bound`.
- Possible general version: immediately define stable `SubGaussian` and `SubExponential` predicates using the Orlicz formulations.
- Reason for not generalizing yet: the project must keep tail, moment, MGF, and Orlicz formulations separate before choosing or relating final predicates.
- Lean/mathlib obstruction: Mathlib already has `ProbabilityTheory.HasSubgaussianMGF`, so HighDimProb names must be aligned carefully in Stage 3A rather than introduced casually here.
- Future upgrade path: after the separate subGaussian and subExponential predicate forms are stable, choose theorem statements formulation-by-formulation; introduce canonical predicates only when their interoperability cost is clear.

## SubGaussian predicate forms

- Concrete version chosen: Stage 3A exposes `SubGaussianTail`, `SubGaussianMoment`, `CenteredSubGaussianMGF`, `SubGaussianOrlicz`, and `HasSubGaussianOrlicz` as separate predicates.
- Possible general version: define one canonical `SubGaussian P X` predicate and make all downstream theorem statements depend on it.
- Reason for not generalizing yet: the reference notes present equivalent formulations, but equivalence is theorem work and has not been proved in HighDimProb.
- Lean/mathlib obstruction: Mathlib already has `ProbabilityTheory.HasSubgaussianMGF`, while tail, moment, and Orlicz formulations use different constants and side conditions.
- Future upgrade path: after the subExponential layer, choose theorem statements formulation-by-formulation; introduce a canonical predicate only when its interoperability cost is clear.

## SubGaussian moment exponents

- Concrete version chosen: `SubGaussianMoment` uses Mathlib's `ENNReal` exponent type and requires `1 ≤ p` and `p ≠ ∞`.
- Possible general version: state the book version for real or natural `p` with direct real-valued `L^p` norms.
- Reason for not generalizing yet: the current stable Lp wrapper is around Mathlib `eLpNorm`, whose exponent type is `ENNReal`.
- Lean/mathlib obstruction: translating between natural, real, `NNReal`, and `ENNReal` exponents introduces cast and side-condition churn before any theorem needs it.
- Future upgrade path: add natural- or real-exponent convenience predicates if the equivalence theorem or examples require them.

## SubGaussian MGF form

- Concrete version chosen: `CenteredSubGaussianMGF` wraps Mathlib `ProbabilityTheory.HasSubgaussianMGF` with scale `K ^ 2`.
- Possible general version: state the MGF form directly using `expect P (fun ω => Real.exp (λ * X ω))`.
- Reason for not generalizing yet: dependency-first policy prefers Mathlib's existing MGF predicate, which already includes exponential integrability.
- Lean/mathlib obstruction: a raw expectation inequality would omit the integrability structure that Mathlib's MGF API already tracks.
- Future upgrade path: add raw expectation-facing bridge lemmas only after the MGF formulation is used in theorem statements.

## SubExponential predicate forms

- Concrete version chosen: Stage 3B exposes `SubExponentialTail`, `SubExponentialMoment`, `CenteredSubExponentialMGF`, `SubExponentialOrlicz`, and `HasSubExponentialOrlicz` as separate predicates.
- Possible general version: define one canonical `SubExponential P X` predicate and route all downstream statements through it.
- Reason for not generalizing yet: the reference notes list equivalent formulations, but equivalence is theorem work and constants have not been selected.
- Lean/mathlib obstruction: tail, moment, local-MGF, and Orlicz formulations use different codomains and side conditions; collapsing them now would hide those choices.
- Future upgrade path: prove selected equivalence directions later, then introduce a canonical predicate only if a theorem family needs it.

## SubExponential moment exponents

- Concrete version chosen: `SubExponentialMoment` uses Mathlib's `ENNReal` exponent type and requires `1 ≤ p` and `p ≠ ∞`.
- Possible general version: state the book version for real or natural `p` with direct real-valued `L^p` norms.
- Reason for not generalizing yet: the stable Lp wrapper is around Mathlib `eLpNorm`, whose exponent type is `ENNReal`.
- Lean/mathlib obstruction: natural/real exponent convenience layers would add casts and side conditions before they are needed by proofs.
- Future upgrade path: add natural- or real-exponent variants after theorem statements show the required shape.

## SubExponential local MGF form

- Concrete version chosen: `CenteredSubExponentialMGF` states a raw expectation inequality on the local domain `|lam| ≤ 1 / K`.
- Possible general version: use a dedicated Mathlib MGF predicate with built-in exponential integrability, centering, and radius information.
- Reason for not generalizing yet: no dedicated Mathlib subExponential MGF predicate was found in the local search, while the object layer only needs a named interface.
- Lean/mathlib obstruction: proving centering, exponential integrability, and local analyticity is theorem-layer work.
- Future upgrade path: replace or bridge the raw predicate if Mathlib exposes a more suitable local-MGF API or when Bernstein-type proofs require stronger assumptions.

## Metric entropy

- Concrete version chosen: Stage 5A exposes wrappers around Mathlib `Metric.IsCover`, `Metric.IsSeparated`, `Metric.coveringNumber`, `Metric.externalCoveringNumber`, and `Metric.packingNumber`.
- Possible general version: keep local finite witness predicates and custom cardinal minimization.
- Reason for not generalizing yet: Mathlib already has the covering and packing object language, including `ℕ∞` cardinal values and basic inequalities.
- Lean/mathlib obstruction: duplicating the definitions would force bridge lemmas before using Mathlib covering/packing theorems.
- Future upgrade path: add HighDimProb-facing theorem statements and wrappers around Mathlib inequalities without changing the underlying definitions.

## Real radius wrappers

- Concrete version chosen: HighDimProb-facing APIs take `ε : ℝ` and convert it to Mathlib radii using `Real.toNNReal`.
- Possible general version: expose only Mathlib's `ℝ≥0` and `ℝ≥0∞` radius parameters.
- Reason for not generalizing yet: the reference notes use real `ε`, while Mathlib's APIs require nonnegative radii.
- Lean/mathlib obstruction: negative real radii have no metric-covering interpretation, so the wrapper truncates them to zero.
- Future upgrade path: add explicit `ℝ≥0` variants if theorem statements need to avoid `Real.toNNReal` in hypotheses.

## Mathlib cover interpretation

- Concrete version chosen: `IsEpsilonNet K N ε` is exactly `Metric.IsCover (epsilonRadius ε) K N`.
- Possible general version: bake the book convention `N ⊆ K` into the main net predicate.
- Reason for not generalizing yet: Mathlib separates external covers from internal covering numbers; direct reuse keeps compatibility.
- Lean/mathlib obstruction: `Metric.IsCover` allows centers outside `K`, while `Metric.coveringNumber` is the internal covering number with centers constrained to `K`.
- Future upgrade path: use `IsInternalEpsilonNet K N ε := N ⊆ K ∧ IsEpsilonNet K N ε` when the book's internal-net convention matters.

## Metric entropy log deferral

- Concrete version chosen: Stage 5A implements covering and packing number wrappers but does not define `metricEntropy`.
- Possible general version: define `metricEntropy K ε := Real.log (coveringNumber K ε)` immediately.
- Reason for not generalizing yet: Mathlib covering numbers return `ℕ∞`, so a real logarithm needs a deliberate finite/infinite convention.
- Lean/mathlib obstruction: coercing `ℕ∞` to `ℝ` directly would hide the infinite-covering-number case.
- Future upgrade path: define a finite-count metric entropy wrapper once theorem statements specify how to handle `⊤`.

## Metric theorem deferral

- Concrete version chosen: no covering bounds, packing-covering inequalities, or operator-norm net bounds are proved in Stage 5A.
- Possible general version: immediately wrap Mathlib's covering-packing inequalities and start Euclidean covering estimates.
- Reason for not generalizing yet: this round is API alignment only.
- Lean/mathlib obstruction: Euclidean bounds and operator-norm net bounds need sphere, matrix norm, and random matrix APIs.
- Future upgrade path: Stage 5B can add selected theorem statement wrappers around existing Mathlib inequalities.

## Metric entropy statement layer

- Concrete version chosen: Stage 5B adds typechecked `Prop` specifications for maximal separated nets, epsilon-net cardinality bounds, and packing-covering inequalities, while leaving proofs and deeper geometry blocked in the theorem atlas.
- Possible general version: prove the Mathlib-backed covering/packing inequalities immediately and define a real-valued metric entropy function.
- Reason for not generalizing yet: this stage is a statement layer; proof wrappers need real-radius conversion lemmas, and metric entropy needs a deliberate finite/infinite convention for `ℕ∞`.
- Lean/mathlib obstruction: Mathlib uses `ℝ≥0` and `ℕ∞`, while HighDimProb-facing statements use real radii and should not hide negative-radius truncation or infinite covering numbers.
- Future upgrade path: add focused bridge lemmas from `epsilonRadius`/`epsilonERadius` to Mathlib radii, then promote selected typed specifications to proved theorem wrappers when their proofs are available.

## First proof pilot: maximal separated net

- Concrete version chosen: Stage P1 introduces `MaximalEpsilonSeparatedIn` as a single-point-extension maximality predicate and proves `isInternalEpsilonNet_of_maximalEpsilonSeparatedIn`.
- Possible general version: use only Mathlib's global `Maximal` predicate or cardinal-maximal `Metric.maximalSeparatedSet`.
- Reason for not generalizing yet: the book proof is the elementary single-point insertion argument, and this local predicate is enough to test the HighDimProb net wrappers.
- Lean/mathlib obstruction: no blocker was found; Mathlib's `Metric.IsCover` uses non-strict `edist <= radius`, `Metric.IsSeparated` uses strict `radius < edist`, and `Metric.isSeparated_insert_of_notMem` matches the proof.
- Future upgrade path: keep deeper covering-number and packing-covering inequalities separate; add bridge proofs only when explicitly assigned.

## Random matrices

- Concrete version chosen: Stage 6A uses `RandomMatrix Omega m n := Omega -> Matrix (Fin m) (Fin n) Real`.
- Possible general version: matrices over arbitrary index types, normed fields, or a bundled structure carrying entry measurability and independence assumptions.
- Reason for not generalizing yet: the existing vector layer is concrete-first over `Fin n -> Real`, and book random-matrix results start with finite real `m x n` matrices.
- Lean/mathlib obstruction: bundling would make entries, rows, columns, `Measure.map`, and finite-sum actions harder to reuse with the existing unbundled random-variable APIs.
- Future upgrade path: add index-field generalizations only after row/column, sample-covariance, and theorem-statement requirements stabilize.

## Random matrix folder abstraction

- Concrete version chosen: `HighDimProb.RandomMatrix` is an aggregate over `Basic`, `RowsCols`, `Action`, `Norms`, and `Assumptions`.
- Possible general version: keep all random-matrix declarations in one file.
- Reason for not generalizing yet: random matrix theorem work will need separable imports for entries, rows, actions, norm vocabulary, and assumptions.
- Lean/mathlib obstruction: one large module would force later theorem files to import assumptions and norm vocabulary when only entry or row APIs are needed.
- Future upgrade path: add future submodules such as sample covariance or theorem statements under the same folder without promoting the aggregate to the stable root.

## Random matrix rows and columns

- Concrete version chosen: rows and columns are exposed as existing `RandomVector` values, with bridge lemmas from `IsRandomMatrix` to `IsRandomVector`.
- Possible general version: define a separate random-row or random-column structure.
- Reason for not generalizing yet: reusing `RandomVector` gives immediate access to `coord`, `marginal`, subGaussian-vector predicates, and isotropic predicates.
- Lean/mathlib obstruction: separate row/column structures would duplicate the vector API and require bridge lemmas before any theorem could use them.
- Future upgrade path: use these row and column views for Stage 6B sample covariance and later row-subGaussian random-matrix theorem statements.

## Random matrix actions

- Concrete version chosen: `matVec` and `vecMat` use explicit finite sums over `Fin` indices.
- Possible general version: define all actions through Mathlib `Matrix.mulVec` and linear maps.
- Reason for not generalizing yet: explicit sums match the existing `linearForm` style and make measurability proofs immediate from entrywise measurability.
- Lean/mathlib obstruction: committing to a linear-map representation now would pull in operator-norm choices before the norm layer is ready.
- Future upgrade path: add equivalence lemmas to `Matrix.mulVec` or linear-map actions when operator norm and Johnson-Lindenstrauss statements need them.

## Random matrix norm deferral

- Concrete version chosen: Stage 6A adds `frobeniusSq`, `frobeniusNorm`, and `entrywiseMaxAbs`, but does not define spectral/operator norm.
- Possible general version: define `operatorNorm A := ||A||` using whatever matrix norm instance Mathlib provides.
- Reason for not generalizing yet: the book operator norm is the induced spectral norm, while a generic matrix norm instance may be an entrywise Pi norm.
- Lean/mathlib obstruction: a correct operator norm needs a deliberate Matrix-to-linear-map bridge and probably Euclidean-space conventions.
- Future upgrade path: add an operator-norm submodule only after the matrix-to-linear-map representation and sphere/unit-vector API are chosen.

## Random matrix independence deferral

- Concrete version chosen: Stage 6A records entrywise, rowwise, centered, and isotropic assumptions, but does not define independent entries or independent rows.
- Possible general version: immediately wrap Mathlib `iIndepFun` for matrix entries and rows.
- Reason for not generalizing yet: independence conventions need careful choices about indexing, measurability assumptions, and whether rows or entries are primary.
- Lean/mathlib obstruction: premature independence wrappers can conflict with later product-measure or row-sample APIs.
- Future upgrade path: define independent entries and independent rows in a focused stage when theorem statements identify the exact Mathlib independence predicate to wrap.

## Sample covariance deferral

- Concrete version chosen: Stage 6A documents sample covariance as the next object cluster rather than defining it here.
- Possible general version: define `(1 / m) A^T A` immediately for a data matrix.
- Reason for not generalizing yet: sample covariance needs a choice between rows-as-samples, centered samples, empirical covariance, and scaling conventions.
- Lean/mathlib obstruction: matrix multiplication is easy, but the statistical meaning depends on row/sample orientation and centering conventions.
- Future upgrade path: Stage 6B should add sample covariance vocabulary with tests and theorem-atlas dependencies before covariance-estimation statements are promoted.

## Stage 6B sample covariance representation

- Concrete version chosen: `sampleCovarianceEntry A i j omega` is `(1 / (m : Real)) * sum k : Fin m, A omega k i * A omega k j`, and `sampleCovariance A` is assembled from these entries.
- Possible general version: define sample covariance directly by `A omega` transposition and matrix multiplication.
- Reason for not generalizing yet: explicit entries keep the row-as-samples convention visible and make entry measurability a small finite-sum bridge.
- Lean/mathlib obstruction: no blocker for the entrywise vocabulary; the `m = 0` case remains the ordinary total-division value in Lean and is not used for statistical theorems.
- Future upgrade path: add matrix-multiplication equivalence lemmas, centered empirical covariance, and nonzero sample-size hypotheses when covariance-estimation statements need them.

## Stage 6B quadratic and bilinear forms

- Concrete version chosen: `quadraticForm` and `bilinearForm` use explicit double sums over `Fin`.
- Possible general version: define through `Matrix.mulVec`, dot products, or continuous linear maps.
- Reason for not generalizing yet: the explicit-sum style matches `linearForm`, `matVec`, and sample-covariance entries, and makes measurability bridges immediate.
- Lean/mathlib obstruction: no blocker for vocabulary or measurability; no Hanson-Wright, chaos, or trace identities are proved in this stage.
- Future upgrade path: add equivalence lemmas to `Matrix.mulVec`/dot-product formulations before Hanson-Wright theorem statements.

## Stage 6B operator norm bridge

- Concrete version chosen: `operatorNorm A` uses Mathlib's `Matrix.Norms.L2Operator` scoped norm from `Mathlib.Analysis.CStarAlgebra.Matrix`.
- Possible general version: use the default matrix norm or the `L^infty` operator norm.
- Reason for not generalizing yet: the book's random-matrix bounds use the Euclidean spectral norm, so the wrapper must not silently pick the entrywise/Pi norm or the `L^infty` matrix norm.
- Lean/mathlib obstruction: the norm declaration is available, but future proofs still need bridge lemmas to `Matrix.mulVec`, unit-sphere suprema, and measurability of `operatorNorm A`.
- Future upgrade path: a focused bridge stage should prove or wrap the needed L2 operator norm lemmas before epsilon-net or random-matrix norm theorem statements are proved.

## Root-to-branch module abstraction

- Concrete version chosen: Stage I3 adds logical aggregate modules `Scalar`, `Vector`, `Geometry`, `Process`, and `Statements`.
- Possible general version: physically move all flat files into branch directories immediately.
- Reason for not generalizing yet: physical migration would create avoidable import churn while APIs are still stabilizing.
- Lean/mathlib obstruction: broad moves can hide accidental stable-root promotion and make import regressions hard to isolate.
- Future upgrade path: keep declarations in leaf modules, test branch aggregates, and migrate files physically only in a focused future stage after branch boundaries are proven by import tests.

## Stable root after branch split

- Concrete version chosen: `HighDimProb` imports `Init`, `Scalar`, and `Statements`.
- Possible general version: make the stable root import every branch aggregate.
- Reason for not generalizing yet: vector, geometry, random matrix, process, and signal-recovery APIs remain v0.2+ experimental.
- Lean/mathlib obstruction: importing experimental branches from the stable root would create downstream compatibility obligations before theorem dependencies are settled.
- Future upgrade path: promote a branch only after tests, docs, `docs/Status.md`, and a root import audit confirm it is stable.
