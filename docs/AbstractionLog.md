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

## Finite union bound

- Concrete version chosen: Stage G1E exposes `measure_biUnion_le` in `HighDimProb.ProbabilitySpace` as a stable wrapper around Mathlib finite subadditivity.
- Possible general version: create a concentration-specific union-bound module or prove the result from disjointization.
- Reason for not generalizing yet: Mathlib already proves the exact finite `Finset` union bound for arbitrary measures, so a probability-facing wrapper is enough.
- Lean/mathlib obstruction: none; the Mathlib theorem works for all sets through outer-measure subadditivity and does not require measurability hypotheses.
- Future upgrade path: add countable union-bound wrappers only in a separate focused stage, without starting Borel-Cantelli or concentration theorem families.

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
- Lean/mathlib obstruction: a raw expectation inequality would omit the integrability structure that Mathlib's MGF API already tracks; HighDimProb tail probabilities are `ENNReal`, so Chernoff proofs also benefit from a lintegral-facing auxiliary predicate.
- Future upgrade path: add raw expectation-facing bridge lemmas only after a theorem genuinely needs them; the current forward implication path uses `CenteredSubGaussianMGFLIntegral`.

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

## Stage RM2 sample covariance algebra bridge

- Concrete version chosen: `quadraticForm_sampleCovariance_eq_sum_sq` rewrites `quadraticForm (sampleCovariance A) x omega` to `(1 / (m : Real)) * sum k, (sum i, A omega k i * x i)^2`.
- Possible general version: introduce a full row-dot/inner-product API or prove the identity through abstract matrix multiplication.
- Reason for not generalizing yet: the current random-matrix definitions are entrywise finite sums, and the focused bridge only needs distributivity and finite-sum reindexing.
- Lean/mathlib obstruction: no blocker; `Finset.mul_sum`, `Finset.sum_mul`, and `Finset.sum_comm` are enough with targeted `ring` normalization of scalar terms.
- Future upgrade path: Stage RM3 can layer PSD/symmetry statements on top of the proven row-dot-square identity without starting matrix norm bounds or random-matrix concentration.

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

## Stage MC1 matrix concentration vocabulary

- Concrete version chosen: Stage MC1 adds separate leaves for symmetry/self-adjointness, explicit PSD/order, entrywise matrix expectation, and matrix concentration statement targets.
- Possible general version: rely directly on Mathlib Hermitian/positive-semidefinite/order structures and a Bochner-style matrix expectation from the beginning.
- Reason for not generalizing yet: the existing random-matrix layer is entrywise and finite-dimensional; explicit predicates keep theorem statements honest without silently installing a global matrix order convention.
- Lean/mathlib reuse: `Matrix.IsSymm`, `Matrix.IsHermitian`, product measurable spaces for matrix-valued `iIndepFun`, `Matrix.scalar`, and the existing scoped L2 operator norm all work for the statement layer.
- Lean/mathlib obstruction: future proofs still need variance-proxy PSD algebra, matrix Laplace-transform infrastructure, and theorem-specific sampling/unit-sphere reductions.
- Future upgrade path: Stage MC2-fix proves the exact operator-norm comparison and measurability bridges; Stage MC3 can now focus on variance proxies and independent self-adjoint matrix sums without starting matrix concentration.

## Stage MC2 operator-norm and unit-sphere bridges

- Concrete version chosen: add explicit finite-sum unit-vector vocabulary
  (`vectorSqNorm`, `IsUnitVector`, `unitSphere`), explicit matrix-vector squared
  norm vocabulary (`matVecSqNorm`), and squared unit-vector bound predicates
  (`OperatorNormBoundSq`, `RandomOperatorNormBoundSq`).
- Possible general version: use Mathlib's sphere, `Matrix.mulVec`, Euclidean
  linear maps, and the scoped L2 matrix operator norm for all statements from
  the beginning.
- Reason for not generalizing yet: future theorem statements need stable,
  inspectable finite-sum normal forms now, while richer sphere/net APIs should
  wait until a proof stage actually needs them.
- Lean/mathlib reuse: the existing `Matrix.Norms.L2Operator` wrapper is kept,
  product measurable spaces are centralized in `RandomMatrix.Basic`, and
  finite sums over `Fin` provide the deterministic squared-norm normal form.
- Lean/mathlib obstruction: MC2 deliberately left exact Mathlib L2
  operator-norm comparison and operator-norm measurability to a focused
  bridge cleanup.
- Future upgrade path: Stage MC2-fix resolves those comparison and
  measurability bridges. The remaining sample-covariance unit-sphere reduction
  needs a separate supremum/net or spectral-form argument.

## Stage MC2-fix operator norm Mathlib bridge cleanup

- Concrete version chosen: prove finite-sum norm identities
  `vectorSqNorm_eq_norm_sq_toLp` and
  `matVecSqNorm_eq_norm_sq_toLp_mulVec`, then use them to prove both
  `operatorNorm_le_of_operatorNormBoundSq` and
  `operatorNormBoundSq_of_operatorNorm_le`.
- Possible general version: replace the explicit `IsUnitVector` and
  `OperatorNormBoundSq` predicates entirely with Mathlib sphere and
  continuous-linear-map statements.
- Reason for not generalizing yet: existing matrix concentration statements
  are written in explicit finite-sum form, and retaining those predicates keeps
  downstream theorem assumptions readable while allowing exact Mathlib
  comparison when needed.
- Lean/mathlib reuse: `EuclideanSpace.real_norm_sq_eq`, `Matrix.l2_opNorm_def`,
  `Matrix.l2_opNorm_mulVec`, `ContinuousLinearMap.opNorm_le_of_unit_norm`,
  `Matrix.toLpLin_apply`, and `measurable_norm`.
- Lean/mathlib obstruction: no blocker remains for the two deterministic
  operator-norm bridge directions or `operatorNorm` measurability. The
  sample-covariance unit-sphere reduction remains statement-only because it is
  a theorem-level supremum/net or spectral reduction, not just a norm API
  bridge.
- Future upgrade path: Stage MC3 should build variance-proxy and independent
  self-adjoint matrix-sum infrastructure without proving matrix Bernstein.

## Stage MC3 matrix variance proxy and self-adjoint sums

- Concrete version chosen: move finite random-matrix sums into
  `HighDimProb.RandomMatrix.Sums`, move matrix square/second-moment/variance
  proxy vocabulary into `HighDimProb.RandomMatrix.VarianceProxy`, and keep
  assumption vocabulary in `HighDimProb.RandomMatrix.Assumptions`.
- Possible general version: define the variance proxy through a Bochner
  expectation or a global Mathlib Loewner-order structure.
- Reason for not generalizing yet: the random-matrix branch already uses
  entrywise matrix measurability, entrywise `matrixExpect`, and explicit
  quadratic-form PSD/order predicates. Keeping MC3 in that style avoids a large
  semantic change before matrix Bernstein proof work needs it.
- Independence decision: `IndependentRandomMatrices` is an abbrev for Mathlib
  `ProbabilityTheory.iIndepFun`; `IndependentSelfAdjointRandomMatrices` adds
  the self-adjoint family wrapper without inventing a new independence theory.
- Centering decision: `CenteredSelfAdjointRandomMatrixFamily` uses the matrix
  zero-mean condition `matrixExpect P (A i) = 0`; the older
  `CenteredRandomSelfAdjointMatrices` entrywise-centered vocabulary is retained
  for compatibility.
- Variance decision: `matrixVarianceProxy P A` is
  `sum_i, matrixSecondMoment P (A i)`, where `matrixSecondMoment P A` is the
  entrywise expectation of `A omega * A omega`.
- Boundedness decision: expose `PointwiseOperatorNormBound` and
  `AeOperatorNormBound` separately. The typed matrix Bernstein statement uses
  the pointwise predicate for now, so no a.e. assumption is hidden.
- Lean/mathlib reuse: `Matrix.sum_apply`, `Matrix.mul_apply`,
  `Finset.measurable_sum`, `Measurable.mul`, `Matrix.IsHermitian.ext`,
  `Matrix.IsHermitian.apply`, and `ProbabilityTheory.iIndepFun`.
- Future upgrade path: Stage MC4 should refine the matrix Bernstein statement
  and proof plan around matrix Laplace transforms, trace exponential
  inequalities, and PSD facts for `E[A_i^2]` / `matrixVarianceProxy`.

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

## Branch registry and reserved modules

- Concrete version chosen: Stage I4 adds `docs/BranchRegistry.md`, `docs/LeafPlan.md`, `docs/PhysicalMigrationPlan.md`, and a reserved `HighDimProb.Concentration` aggregate.
- Possible general version: start implementing Markov, Chebyshev, and concentration theorem leaves immediately.
- Reason for not generalizing yet: the repository needs stable branch ownership and reserved import paths before new proof families are added.
- Lean/mathlib obstruction: concentration proofs will need expectation, integrability, tail-event, Lp, Orlicz, and MGF bridge choices; planning the branch avoids mixing those choices into unrelated modules.
- Future upgrade path: Stage G1A may begin the scalar concentration proof spine under the reserved Concentration branch, while random matrix theorem statements remain under RandomMatrix/Statements.

## Scalar tail concentration foundations

- Concrete version chosen: Stage G1A physically starts the new `HighDimProb/Concentration/` branch with `Basic`, `Markov`, and `Chebyshev` leaves.
- Possible general version: prove Chernoff, Hoeffding, Bernstein, and subGaussian/subExponential equivalence theorems in the same pass.
- Reason for not generalizing yet: Markov and Chebyshev test the expectation, tail-event, lintegral, variance, and finite-measure interfaces without requiring independence or MGF infrastructure.
- Lean/mathlib obstruction: Markov is naturally a lintegral theorem in Mathlib, so `lintegral_ofReal_eq_ofReal_expect` is needed to return to `expect`; Chebyshev reused Mathlib's variance theorem but required targeted `change` because broad `simp` loops around covariance/variance notation.
- Future upgrade path: add an a.e.-nonnegative Markov wrapper and split scalar `centered`/`variance` vocabulary out of the vector-heavy `Covariance` module before deeper scalar concentration proofs.

## Scalar concentration API cleanup

- Concrete version chosen: Stage G1B moves scalar `mean`, `centered`, `Centered`, `centered_centered`, `integrable_centered`, `variance`, `covariance`, and `secondMoment` into `HighDimProb.Scalar.Centering` and `HighDimProb.Scalar.Variance`.
- Possible general version: leave all scalar covariance vocabulary in `HighDimProb.Covariance` and add concentration-local aliases.
- Reason for not generalizing yet: concentration-local aliases would create duplicate names or duplicate meanings, while the scalar branch is the right owner for one-dimensional centering and variance vocabulary.
- Compatibility decision: `HighDimProb.Covariance` imports the scalar leaves and keeps the vector covariance API in place, so existing imports still expose the old names.
- Chebyshev decision: `HighDimProb.Concentration.Chebyshev` no longer imports the vector-heavy covariance module; it uses scalar variance leaves and adds `chebyshev_inequality_prob` for the common `[IsProbabilityMeasure P]` convention.
- Markov decision: `expect_nonneg_of_nonneg` drops its unused integrability argument, while `expect_nonneg_of_nonneg_integrable` preserves the old call shape. `markov_inequality` is a short alias for the pointwise-nonnegative theorem.
- Lean/mathlib obstruction: the real-expectation Markov wrapper still depends on the lintegral theorem plus `lintegral_ofReal_eq_ofReal_expect`; an a.e.-nonnegative Markov wrapper needs a deliberate a.e. API rather than a pointwise hypothesis.
- Automation note: moving `centered_centered` exposed a broad-simp recursion, so the proof now uses explicit `measureReal_def`, `measure_univ`, and `ENNReal.toReal_one` rewrites.
- Future upgrade path: add a.e.-nonnegative Markov, a centered Chebyshev corollary if needed, and namespace policy before adding more concentration families.

## Orlicz-to-tail implication pilot

- Concrete version chosen: Stage G1C adds `HighDimProb.Concentration.OrliczToTail` with ψ₂-to-subGaussian-tail and ψ₁-to-subExponential-tail implications.
- Possible general version: prove the full tail, moment, MGF, and Orlicz equivalence theorem family with optimized constants.
- Reason for not generalizing yet: this stage is only an implication pilot; the bound predicates and tail predicates already align well enough for the forward direction, while reverse directions and gauge/norm objects need separate design.
- Probability assumption: `Psi2Bound` and `Psi1Bound` do not control total mass when the shifted integrand vanishes, so the implication theorems explicitly require `[IsProbabilityMeasure P]`.
- Measurability assumption: `Psi2Bound` and `Psi1Bound` are integral-bound predicates, not random-variable predicates, so the implication theorems explicitly require `IsRealRandomVariable P X`.
- Markov interface decision: the proofs use Mathlib's `MeasureTheory.meas_ge_le_lintegral_div` directly rather than the real-expectation Markov wrapper, because the Orlicz layer is already stated in `lintegral` form.
- Constant decision: the shifted definitions `exp(...) - 1` give exponential moment bounds with constant `2` by `lintegral_add_right` and probability mass one, matching the existing tail predicates.
- Lean/mathlib obstruction: `fun_prop` did not handle the reducible `RealRandomVariable` alias robustly in the exponential measurability goals, so the proof uses explicit `Measurable.norm`, `div_const`, `pow_const`, and `Real.measurable_exp` composition.
- Future upgrade path: add reverse tail-to-Orlicz directions, gauge/norm definitions, MGF/moment connections, and a namespace policy before attempting full subGaussian/subExponential equivalence theorems.

## Tail-to-Orlicz reverse implication pilot

- Concrete version chosen: Stage G1D adds `HighDimProb.Concentration.TailToOrlicz` with typed `Prop` targets for `SubGaussianTail -> Psi2Bound` at scale `2 * K` and `SubExponentialTail -> Psi1Bound` at scale `3 * K`.
- Possible general version: prove both reverse implications immediately and package them with the Stage G1C forward implications as an equivalence graph.
- Reason for not generalizing yet: the reverse direction is a genuine tail-integration theorem, not a small wrapper around Markov.
- Layer-cake decision: Mathlib's `MeasureTheory.lintegral_eq_lintegral_meas_le` is exposed through `lintegral_ofReal_eq_lintegral_tail` so future proofs can start from a HighDimProb-facing tail integral identity.
- Constant decision: the target constants remain `2 * K` for psi2 and `3 * K` for psi1; no larger constant was introduced.
- Lean/mathlib obstruction: the primary proof needed a specialized exponential-tail integral estimate plus event transformations and real/ENNReal coercion lemmas for the shifted Orlicz integrand.
- Secondary target decision: the psi1 reverse direction was left as a typed target during G1D, then completed in Sprint S2 after the layer-cake pattern was validated.
- Future upgrade path: use the fixed-scale proof graph before attempting finite-gauge variants, moment links, or MGF links.

## Layer-cake / tail-integral bridge infrastructure

- Concrete version chosen: Stage G1D-fix and Sprint S2 prove the reusable bridges `lintegral_exp_quarter_sub_one_le_of_exp_tail` and `lintegral_exp_third_sub_one_le_of_exp_tail`, plus the fixed-scale theorems `psi2Bound_of_subGaussianTail` and `psi1Bound_of_subExponentialTail`.
- Possible general version: develop a full library of tail integration, moment-from-tail formulas, and all Orlicz reverse implications at once.
- Reason for not generalizing yet: the fixed-scale ψ₂/ψ₁ reverse implications need only two specialized exponential-tail calculus lemmas; moment-from-tail and gauge/norm results deserve a separate design.
- Layer-cake decision: the proofs use Mathlib's general layer-cake formula with derivative weights `(1/4) * exp(s/4)` and `(1/3) * exp(s/3)`, avoiding direct `log`/`sqrt` transformations of shifted Orlicz integrands.
- Integral decision: the concrete bounds reduce to `∫_0^∞ (1/2) exp(-(3/4)t) dt <= 1` and `∫_0^∞ (2/3) exp(-(2/3)t) dt <= 1`, using Mathlib's `integral_exp_mul_Ioi`.
- Constant decision: the requested scales `2 * K` and `3 * K` are proved exactly; no larger constants were introduced.
- Remaining obstruction: finite-gauge variants, moment links, and MGF links are not yet implemented.
- Future upgrade path: consolidate the fixed-scale scalar implication graph, then choose between moment formulation or random-matrix assumption vocabulary as the next branch.

## Sprint S2 scalar implication graph consolidation

- Concrete version chosen: Sprint S2 adds `HighDimProb.Concentration.Implications` as an import-only collection point for proved Orlicz/tail arrows and documents the graph in `docs/ScalarImplicationGraph.md`.
- Possible general version: define canonical `SubGaussian` and `SubExponential` predicates immediately.
- Reason for not generalizing yet: moment, MGF, and finite-gauge links are still TODO, so a canonical predicate would overstate the current proof coverage.
- Lean/mathlib obstruction: no obstruction for the fixed-scale tail/Orlicz arrows; future graph edges will need moment-from-tail and MGF infrastructure.
- Future upgrade path: add moment formulation links under a focused Stage G2A before choosing canonical predicates.

## Sprint S2 random matrix statement layer initialization

- Concrete version chosen: Sprint S2 adds `HighDimProb.RandomMatrix.Statements` and only the typed statement `epsilonNetOperatorNormStatement`.
- Possible general version: encode all random-matrix theorem families as Lean `abbrev ...Statement : Prop` declarations now.
- Reason for not generalizing yet: most theorem families require assumptions that are not expressible yet, especially independent entries, iid rows, symmetric random matrices, PSD/order vocabulary, and high-probability statement conventions.
- Lean/mathlib obstruction: the deterministic epsilon-net/operator-norm statement can type using `IsEpsilonNet`, function-space unit sphere notation, and Mathlib's L2 matrix norm; probabilistic random-matrix theorem statements need a richer assumption layer first.
- Future upgrade path: implement random-matrix independence and order vocabulary before promoting blocked theorem groups to typed Prop statements.

## Sprint S2 assumption vocabulary audit

- Concrete version chosen: Sprint S2 records scalar, vector, and matrix assumptions in `docs/AssumptionVocabulary.md` without implementing independence.
- Possible general version: add public independence predicates immediately.
- Reason for not generalizing yet: Mathlib independence APIs need careful finite-indexed wrapper choices, and a premature public predicate would constrain random matrix theorem statements.
- Lean/mathlib obstruction: independent entries, iid rows, symmetric random matrices, and PSD random matrices require separate API decisions.
- Future upgrade path: Stage RM1 should implement the highest-priority random-matrix assumptions with focused tests before matrix concentration statement work resumes.

## Sprint S3 small branch proof battery

- Concrete version chosen: Stage S3 proves small reusable lemmas across concentration, scalar variance, metric entropy, isotropic vectors, and random matrices without starting large theorem families.
- Tail/concentration result: `markov_inequality_ae_nonneg` reuses the existing pointwise tail event but relaxes the nonnegativity needed for the lintegral-to-expectation bridge to an a.e. hypothesis.
- Scalar variance result: `variance_nonneg` and `variance_centered_eq_variance` show that scalar-owned centering/variance leaves can wrap Mathlib variance facts without importing vector covariance infrastructure.
- Geometry result: explicit-net covering-number wrappers work cleanly when the external/internal net distinction is kept visible.
- Vector/isotropic result: `IsotropicCovariance.centeredVector` is only a definitional projection, confirming the covariance-form predicate exposes its centeredness assumption cleanly.
- Random-matrix result: `frobeniusSq_nonneg` and `sampleCovarianceEntry_diag_nonneg` are straightforward with explicit finite sums; Stage RM2 later resolved the quadratic-form sample-covariance stretch via a finite-sum algebra bridge.
- Future upgrade path: Stage RM3 should add PSD/symmetry statement layers on top of the row-dot-square identity before any random matrix norm bounds are attempted.

## Limit theorem scaffold

- Concrete version chosen: Stage LLN0-LLN1 adds an experimental `HighDimProb.LimitTheorems` branch with `sampleSum`, `sampleMean`, and `sampleMeanCentered` over `Fin n`.
- Possible general version: define sequence-valued random samples, iid bundles, convergence-in-probability aliases, and WLLN theorem proofs immediately.
- Reason for not generalizing yet: WLLN needs independence/iid vocabulary, variance-of-sum theorems, square-integrability bridges, and convergence-in-probability conventions that should be selected deliberately.
- Chebyshev decision: `weakLawChebyshevBoundStatement` is a typed `Prop` target with explicit variance/mean hypotheses, not a fake theorem.
- Convergence decision: `weakLawFiniteVarianceStatement` uses Mathlib `MeasureTheory.TendstoInMeasure` directly rather than introducing a HighDimProb alias before the surrounding API is known.
- Lean/mathlib obstruction: finite-sum measurability and integrability are easy through `Finset.measurable_sum`, `integrable_finset_sum`, and `Integrable.const_mul`; theorem proof blockers are structural rather than local.
- Future upgrade path: add independence/iid assumption wrappers and variance-of-sum/mean-of-sample-mean bridge lemmas before proving the Chebyshev WLLN bound.

## Stage C1 abstraction cleanup

- Concentration decision: `HighDimProb.Concentration.LayerCake` is now the public import boundary for reusable layer-cake and exponential-tail calculus helpers. The declaration bodies remain in `TailToOrlicz` for name stability; future physical movement should preserve theorem names.
- Scalar implication decision: `HighDimProb.Concentration.Implications` remains the collection point for the fixed-scale Orlicz/tail graph and explicitly avoids canonical `SubGaussian`/`SubExponential` predicates until moment and MGF links are proved.
- Random-matrix decision: `rowDot` and row-dot-square helper lemmas were added on top of the existing sample-covariance finite-sum proof, with `quadraticForm_sampleCovariance_eq_sum_sq` kept as the compatibility normal form.
- LLN decision: `HighDimProb.LimitTheorems.Assumptions` adds thin wrappers around Mathlib `iIndepFun`, `IndepFun`, and `IdentDistrib` for scalar finite samples and sequences only.
- Lean/mathlib obstruction: Mathlib already has the core independence and variance-sum objects, but HighDimProb still lacks wrappers connecting them to `sampleMean`, `variance`, common mean/variance assumptions, and convergence-in-probability naming.
- Future upgrade path: Stage G2A should tackle moment formulation links for scalar concentration, while WLLN proof work should first add variance-of-sample-mean bridge lemmas over the new assumption vocabulary.

## Stage G2A moment implication pilot

- Concrete version chosen: Stage G2A adds `HighDimProb.Concentration.MomentImplications` with an `ENNReal` natural absolute-moment normal form `absMomentNat`.
- Possible general version: prove `SubGaussianTail -> SubGaussianMoment` directly for Mathlib `eLpNorm` and all real/ENNReal exponents with optimized constants.
- Reason for not generalizing yet: the full theorem needs all-exponent layer-cake or Gamma/exponential-integral infrastructure plus a bridge from absolute natural moments back to `realLpNorm`.
- Moment normal form: the proved theorem uses natural exponent `q = 2` and `lintegral` of `ENNReal.ofReal (|X|^q)`, not the existing real-Lp seminorm predicate.
- Constant decision: `Psi2Bound P X K` gives `absMomentNat P X 2 <= ofReal (K^2)`, and `SubGaussianTail P X K` gives the fixed-scale bound `ofReal ((2*K)^2)` through `psi2Bound_of_subGaussianTail`.
- Stretch decision: the same elementary pattern also proves `Psi1Bound P X K -> absMomentNat P X 1 <= ofReal K` and `SubExponentialTail P X K -> absMomentNat P X 1 <= ofReal (3*K)`.
- Lean/mathlib obstruction: no blocker for fixed exponents `1` and `2`; broad moment growth remains blocked by missing reusable all-exponent integral estimates and coercion bridges between `ENNReal` moments and `eLpNorm`.
- Future upgrade path: Stage G2B should prove an all-natural-exponent absolute-moment bound before attempting the full `SubGaussianMoment` real-Lp formulation.

## Stage G2B all-natural absolute moments

- Concrete version chosen: Stage G2B proves an all-natural-exponent absolute-moment bound with factorial growth, not the sharp `sqrt(q)` growth theorem.
- Possible general version: prove `absMomentNat P X q <= ofReal ((C*K*sqrt q)^q)` and then bridge it directly to `realLpNorm` / `SubGaussianMoment`.
- Reason for not generalizing yet: the factorial theorem is available from elementary Mathlib exponential-series estimates, while sharp `sqrt(q)` growth needs either a tighter real optimization lemma or a Gamma/layer-cake moment integral.
- Probability assumption: all-`q` uses `[IsProbabilityMeasure P]` because the proof passes through the unshifted exponential-square moment bound `lintegral_exp_sq_div_le_two_of_psi2Bound`; a shifted ψ₂ bound alone does not control low moments on arbitrary infinite measures.
- Constant decision: `Psi2Bound P X K` gives `absMomentNat P X q <= ofReal (exp(1/4) * K^q * q!) * 2`; `SubGaussianTail P X K` uses the existing scale loss `K -> 2*K`.
- Lean/mathlib reuse: `Real.pow_div_factorial_le_exp` supplies `a^q / q! <= exp a`; the elementary inequality `a <= a^2 + 1/4` converts this to exponential-square control.
- Future upgrade path: after Stage G2C's bridge, sharpen the natural moment bound to `sqrt(q)` growth before proving the existing `SubGaussianMoment` predicate.

## Stage G2C natural moment to Lp bridge

- Concrete version chosen: Stage G2C proves the natural-exponent bridge from `absMomentNat` to Mathlib `MemLp` and `realLpNorm`, then names the currently proved factorial-growth predicate as `SubGaussianMomentNat`.
- Possible general version: prove the book's sharp `SubGaussianMoment` predicate directly for all finite `ENNReal` exponents.
- Reason for not generalizing yet: the available all-natural moment estimate is factorial-growth; converting it to the sharp `K * sqrt p` real-`Lp` predicate would require a new sharp moment estimate, not just an Lp coercion bridge.
- Measurability decision: `memLp_of_finiteAbsMomentNat` requires `IsRealRandomVariable P X` explicitly because `finiteAbsMomentNat` records only lintegral finiteness and does not bundle `AEStronglyMeasurable`.
- Exponent decision: the bridge requires `q != 0`; the `q = 0` `MemLp` case is purely measurability-oriented and is not the book's moment norm.
- Normal form decision: `lintegral_enorm_rpow_nat_eq_absMomentNat` is the finite-sum/coercion-free equality between Mathlib's `eLpNorm` integrand `‖X ω‖ₑ ^ (q : Real)` and `∫⁻ ω, ofReal (|X ω|^q)`.
- Lean/mathlib reuse: the proof uses `eLpNorm_lt_top_iff_lintegral_rpow_enorm_lt_top`, `eLpNorm_eq_lintegral_rpow_enorm_toReal`, `ENNReal.rpow_natCast`, `ofReal_norm_eq_enorm`, `ENNReal.ofReal_pow`, and `ENNReal.rpow_le_rpow`.
- Future upgrade path: sharpen the natural subGaussian moment bound to `sqrt(q)` growth before proving `SubGaussianMoment` from tails or ψ₂ bounds.

## Stage G2D natural moment linear growth

- Concrete version chosen: Stage G2D derives the best clean `realLpNorm` consequence currently available from the factorial estimate: `Psi2Bound P X K` gives `realLpNorm P X q <= 8*K*q`, and `SubGaussianTail P X K` gives `16*K*q` after the existing `K -> 2*K` scale loss.
- Possible general version: prove the book-style `realLpNorm P X q <= C*K*sqrt(q)` theorem from tails or ψ₂ control.
- Reason for not generalizing yet: the existing proof path has normal form `2 * exp(1/4) * K^q * q!`; taking `q`th roots and using `q! <= q^q` only yields linear growth.
- Constant decision: the numeric `8` absorbs `(2*exp(1/4))^(1/q)` using Mathlib's `Real.exp_one_lt_three`; the tail theorem doubles the scale and therefore uses `16`.
- Lean/mathlib reuse: `Nat.factorial_le_pow`, `Real.rpow_le_rpow`, `Real.mul_rpow`, `Real.rpow_mul`, `ENNReal.ofReal_mul`, and the existing `realLpNorm_nat_le_of_absMomentNat_le` bridge.
- Future upgrade path: prove a direct sharp tail-integral/Gamma moment estimate instead of passing through the factorial bound.

## Stage G2E sharp moment route design

- Concrete version chosen: record the sharp route as typed `Prop` targets, not unproved theorems: `powLeSqrtGrowthMulExpSqStatement`, `sqrtMomentGrowthOfPsi2Statement`, and `sqrtMomentGrowthOfSubGaussianTailStatement`.
- Possible general version: prove either the deterministic envelope `x^q <= (4*sqrt q)^q * exp(x^2/4)` or a layer-cake/Gamma estimate for Gaussian tails, then derive the real-`Lp` `sqrt(q)` theorem.
- Reason for not generalizing yet: Mathlib has the Gamma integral formula and layer-cake APIs, but the needed reusable upper bound on the Gamma expression, or the equivalent calculus optimization lemma, is not packaged in the current HighDimProb abstraction layer.
- Constant decision: the deterministic route targets envelope constant `4`; the real-`Lp` typed statements reserve constants `8` for `Psi2Bound` and `16` for `SubGaussianTail` after the existing `K -> 2*K` scale loss.
- Lean/mathlib reuse: searched and retained Mathlib's `MeasureTheory.lintegral_eq_lintegral_meas_le`, `integral_rpow_mul_exp_neg_rpow`, `integral_rpow_mul_exp_neg_mul_rpow`, `Real.Gamma` formulas, Gaussian integrability lemmas, and `Real.rpow`/`Real.sqrt` algebra as candidate infrastructure.
- Future upgrade path: Stage G2E-fix chooses the deterministic route first; Gamma upper bounds remain optional future infrastructure.

## Stage G2E-fix deterministic real inequality

- Concrete version chosen: add `HighDimProb.Analysis.RealInequalities` with only the real helpers needed for sharp subGaussian natural-moment growth.
- Possible general version: a larger real-analysis library for Gamma estimates, Gaussian moments, and calculus optimization.
- Reason for not generalizing yet: the deterministic proof using `log y <= y^2` is enough for the current probability bridge and avoids building a Gamma upper-bound layer.
- Constant decision: `pow_le_two_sqrt_mul_exp_sq` proves `x^q <= (2*sqrt q)^q * exp(x^2/4)` for `x >= 0`, `q >= 1`; the probability theorems use constants `4` for `Psi2Bound` and `8` for `SubGaussianTail`.
- Lean/mathlib reuse: `Real.log_le_self`, `Real.log_le_iff_le_exp`, `Real.log_pow`, `Real.exp_le_exp`, `Real.sq_sqrt`, `field_simp`, `ring`, and existing `lintegral_exp_sq_div_le_two_of_psi2Bound` / `realLpNorm_nat_le_of_absMomentNat_le`.
- Future upgrade path: connect the natural-exponent sqrt theorem to the existing `SubGaussianMoment` predicate, whose exponent is an `ENNReal` rather than a natural number.

## Stage G2F sharp natural moment interface

- Concrete version chosen: add `SubGaussianMomentNatSqrt` as a new natural-exponent real-`Lp` predicate and prove ψ₂/tail bridges into it.
- Possible general version: prove `Psi2Bound -> SubGaussianMoment` directly for every finite `p : ENNReal`.
- Reason for not generalizing yet: the proved sharp theorem is only at natural exponents, while `SubGaussianMoment` quantifies over all finite `ENNReal` exponents; forcing the bridge now would hide a genuine exponent-conversion theorem.
- Compatibility decision: keep the existing factorial-growth `SubGaussianMomentNat` name and meaning unchanged; the sharp natural predicate is a supplement, not a breaking rename.
- Constant decision: `subGaussianMomentNatSqrt_of_psi2Bound` uses scale `4*K`, and `subGaussianMomentNatSqrt_of_subGaussianTail` uses scale `8*K` after the existing `K -> 2*K` tail-to-ψ₂ loss.
- Lean/mathlib reuse: the stage reuses `realLpNorm_nat_le_sqrt_of_psi2Bound`, `realLpNorm_nat_le_sqrt_of_subGaussianTail`, simple positivity, and ring normalization; Mathlib `eLpNorm_le_eLpNorm_of_exponent_le` was identified as likely future infrastructure for all-real-exponent promotion.
- Future upgrade path: Stage G2F-cleanup should design the natural-to-real exponent bridge around ceiling, `ENNReal.toReal`, and sqrt comparisons before attempting `subGaussianMoment_of_psi2Bound`.

## Stage M-real-1 real-exponent SubGaussianMoment bridge

- Concrete version chosen: keep `SubGaussianMomentNatSqrt` unchanged and add a separate ceiling/monotonicity bridge from natural exponents to the existing finite-`ENNReal` `SubGaussianMoment` predicate.
- Possible general version: prove the moment formulation from tail or Orlicz control by a direct real-exponent integral calculation, with sharper constants.
- Compatibility decision: no existing theorem meanings changed; the new public bridge theorems are `subGaussianMoment_of_psi2Bound` and `subGaussianMoment_of_subGaussianTail`.
- Constant decision: the natural constants `4*K` and `8*K` become `8*K` and `16*K` because `sqrt(ceil p.toReal) <= 2 * sqrt(p.toReal)`.
- Lean/mathlib reuse: reuse Mathlib `MeasureTheory.eLpNorm_le_eLpNorm_of_exponent_le`, `ENNReal.ofReal_toReal`, `ENNReal.toReal_mono`, `Nat.le_ceil`, `Nat.ceil_lt_add_one`, `Real.sqrt_le_sqrt`, and `Real.sqrt_mul`.
- Follow-up path: Stage M-real-2 repeats the exponent-monotonicity pattern for the subExponential real-moment interface; after that, the remaining work is reverse/source MGF and full equivalence packaging.

## Stage M-real-2 real-exponent SubExponentialMoment bridge

- Concrete version chosen: keep `SubExponentialMoment` unchanged and prove the missing all-natural psi1 factorial moment route, then reuse the natural-ceiling/Lp monotonicity bridge for finite `ENNReal` exponents.
- Possible general version: introduce a separate natural-exponent subExponential moment predicate before proving the full interface.
- Reason for not adding a predicate: the existing `SubExponentialMoment` interface is compatible, and the public theorem family can expose the natural intermediate lemmas directly.
- Compatibility decision: no theorem meanings changed; `Psi1Bound -> SubExponentialMoment` uses scale `16*K`, while `SubExponentialTail -> SubExponentialMoment` uses scale `48*K` after the existing `3*K` tail-to-psi1 loss.
- Lean/mathlib reuse: reuse Mathlib `Real.pow_div_factorial_le_exp`, `Nat.factorial_le_pow`, `Real.rpow_le_rpow`, `Real.mul_rpow`, `MeasureTheory.eLpNorm_le_eLpNorm_of_exponent_le`, `ENNReal.toReal_mono`, `Nat.ceil`, and the existing psi1 exponential-integral bridge.
- Future upgrade path: Stage SC-final-update should refresh the scalar milestone/index now that both subGaussian and subExponential moment bridges are complete.

## Stage M3 scalar subGaussian proof spine closeout

- Concrete version chosen: close the scalar subGaussian proof spine as a documentation, import, and API-test milestone, not as a new theorem stage.
- Possible general version: prove a full equivalence theorem family and introduce a canonical `SubGaussian` predicate.
- Reason for not generalizing yet: at M3 time, reverse MGF, full real-exponent `SubGaussianMoment`, and finite-gauge/norm variants were still missing; Stage M-real-1 later resolves the full moment bridge.
- Import decision: `HighDimProb.Concentration.Implications` now re-exports the proved tail/Orlicz, natural-moment, MGF, and weighted Rademacher sum implication leaves; theorem ownership remains in the focused leaf files.
- Documentation decision: `docs/ScalarImplicationGraph.md` is table-driven so constants, statuses, and theorem names can be audited without reading proof files.
- Future upgrade path: the next deep proof route should target the reverse MGF bridge before any canonical predicate consolidation.

## Stage H1 Rademacher MGF atom

- Concrete version chosen: define a canonical Rademacher variable on `Bool` with `PMF.bernoulli (1/2)` as the measure.
- Possible general version: a full distribution API for arbitrary Rademacher variables or almost-sure two-point sign variables.
- Reason for not generalizing yet: the next proof branch only needs one atomic example before finite weighted Rademacher sums.
- Mathlib reuse: Mathlib has Bernoulli PMFs and a bounded zero-mean subGaussian MGF lemma, but no HighDimProb-facing Rademacher theorem.
- Constant decision: the MGF scale is `1`; the existing MGF-to-tail bridge yields tail scale `2`.
- Future upgrade path: weighted finite Rademacher sums should reuse Mathlib `HasSubgaussianMGF.add_of_indepFun` or a finite-sum wrapper once independence is packaged.

## Stage H0 Rademacher / Hoeffding readiness cleanup

- Concrete version chosen: keep the existing one-sign Rademacher atom unchanged and make the next branch plan explicit in `docs/RademacherPlan.md`.
- Possible general version: start weighted Rademacher sums or a full Hoeffding theorem immediately.
- Reason for not generalizing yet: the next proof needs finite product signs, coordinate independence, and MGF factorization; starting the inequality before those APIs are stable would mix object design with theorem proof.
- Audit decision: `HighDimProbTest/RademacherAPI.lean` is the focused test for the atom declarations, while branch and experimental import tests keep aggregate imports checked.
- Mathlib reuse found: Bernoulli PMFs and Hoeffding/subGaussian MGF lemmas exist; finite product and independence packaging remains the design point.
- Future upgrade path: Stage H2A should introduce the smallest finite product Rademacher family infrastructure needed for weighted sums.

## Stage H2A finite Rademacher product family

- Concrete version chosen: define `rademacherVectorMeasure n` as `Measure.pi (fun _ : Fin n => rademacherMeasure)` on `Fin n -> Bool`.
- PMF decision: expose `rademacherVectorPMF n` as `(rademacherVectorMeasure n).toPMF`, with `rademacherVectorPMF_toMeasure` proving it returns the product measure.
- Possible general version: build a general finite product PMF combinator or a broad independent-sign distribution hierarchy.
- Reason for not generalizing yet: Mathlib's independence theorem is already phrased for `Measure.pi`, and H2B only needs canonical product signs before weighted sums.
- Independence decision: prove `iIndepFun_rademacherCoord` now because it is direct from `ProbabilityTheory.iIndepFun_pi`.
- Lean/mathlib reuse: `Measure.pi`, `Measure.toPMF`, `Measure.toPMF_toMeasure`, `measurePreserving_eval`, `MeasurePreserving.map_eq`, `MeasureTheory.integral_map`, and `ProbabilityTheory.iIndepFun_pi`.
- Future upgrade path: H2B should use this coordinate family to define weighted sums and prove the centered MGF bound, without introducing Hoeffding tails yet.

## Stage H2B weighted finite Rademacher sum MGF

- Concrete version chosen: add `HighDimProb.Concentration.RademacherSums` for the weighted sum and its MGF theorem, while keeping the finite product distribution facts in `Distributions.RademacherFamily`.
- Possible general version: prove a broad independent-sum concentration theorem or a reusable product-integral MGF factorization API.
- Reason for not generalizing yet: Mathlib already has `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`, which gives exactly the variance-proxy addition needed for finite independent sums.
- MGF normal form decision: expose both the Mathlib proxy theorem `hasSubgaussianMGF_weightedRademacherSum` with proxy `sum_i a_i^2` and the HighDimProb predicate theorem `centeredSubGaussianMGF_weightedRademacherSum` with scale `sqrt (sum_i a_i^2)`.
- Zero-scale decision: the HighDimProb theorem assumes `0 < sum_i a_i^2` because `CenteredSubGaussianMGF` requires a strictly positive scale. The all-zero-weight vector should be handled separately in the Hoeffding tail stage.
- Lean/mathlib reuse: `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`, `ProbabilityTheory.HasSubgaussianMGF.const_mul`, `ProbabilityTheory.iIndepFun.comp`, and the H2A coordinate independence theorem.
- Future upgrade path: Stage H3 derives the Rademacher Hoeffding tail by composing the weighted-sum MGF theorem with the existing MGF-to-tail bridge.

## Stage H3 finite Rademacher Hoeffding tail

- Concrete version chosen: add the Rademacher-specific tail theorem and explicit Hoeffding restatement in `HighDimProb.Concentration.RademacherSums`.
- Possible general version: a bounded-variable Hoeffding theorem for arbitrary independent centered variables.
- Reason for not generalizing yet: the current branch has canonical finite Rademacher signs and a complete MGF bridge; bounded-variable assumptions and independent-sum interfaces need separate design.
- Constant decision: compose `centeredSubGaussianMGF_weightedRademacherSum` with `subGaussianTail_of_centeredSubGaussianMGF`, producing tail scale `2 * sqrt (sum_i a_i^2)` and explicit denominator `4 * sum_i a_i^2`.
- Zero-scale decision: theorems assume `0 < sum_i a_i^2`; the all-zero vector is a predicate-design cleanup because `SubGaussianTail` requires strictly positive scales.
- Lean/mathlib reuse: the proof reuses the existing MGF-to-tail theorem and uses `Real.sq_sqrt` plus ring normalization for the denominator.
- Future upgrade path: Stage H4 closes the branch by auditing docs/imports/tests and recording the zero-scale cleanup as a small API task.

## Stage H4 Rademacher / Hoeffding branch closeout

- Concrete version chosen: close the finite Rademacher concentration branch as an experimental mini-domain with `docs/RademacherMilestone.md`, import audits, and API coverage checks.
- Possible general version: start general bounded-variable Hoeffding or independent finite subGaussian sums immediately.
- Reason for not generalizing yet: the branch closeout should freeze the constants and import boundary before widening theorem scope.
- Import decision: keep the branch experimental; `HighDimProb.Distributions` owns atom/family objects, `HighDimProb.Concentration` owns weighted sums and tail consequences, and `HighDimProb` stable root remains unchanged.
- Test decision: focused tests cover every public declaration in the atom, family, and weighted-sum leaves; aggregate tests check discoverability.
- Future upgrade path: after the zero-weight cleanup, the next route should factor the independent finite subGaussian sum MGF pattern out of the Rademacher specialization.

## Stage H2-cleanup weighted Rademacher zero-weight case

- Concrete version chosen: keep the existing positive-square-sum MGF/tail/Hoeffding theorems unchanged and add explicit zero-weight helper theorems.
- Possible general version: redesign `CenteredSubGaussianMGF` and `SubGaussianTail` to allow zero scale.
- Reason for not generalizing yet: the current scalar implication graph assumes strictly positive scales, and changing predicate meanings would affect many existing theorem statements.
- Zero-case decision: prove the weighted sum is identically zero under either `forall i, a i = 0` or `sum_i a_i^2 = 0`, and prove absolute-tail probability is zero for strictly positive thresholds.
- Naming decision: add `hoeffding_rademacher_sum_of_pos_variance` as a user-facing alias that makes the positive-square-sum assumption explicit.
- Lean/mathlib reuse: `Finset.sum_eq_zero_iff_of_nonneg`, `sq_nonneg`, `sq_eq_zero_iff`, tail-event definitions, and `measure_empty`.
- Future upgrade path: Stage H5 should factor the independent finite subGaussian sum MGF pattern out of the Rademacher specialization.

## Stage H5 independent finite subGaussian sum MGF

- Concrete version chosen: add `HighDimProb.Concentration.SubGaussianSums` as the general scalar independent-sum MGF leaf.
- Possible general version: immediately prove general bounded-variable Hoeffding or a broad independent concentration hierarchy.
- Reason for not generalizing yet: the current proof only needs centered subGaussian MGF assumptions and Mathlib finite-sum independence; bounded-variable Hoeffding needs a separate lemma sourcing MGF control from bounded centered variables.
- Index decision: expose both Finset helper theorems and `[Fintype ι]` user-facing wrappers.
- Weighted decision: prove the weighted theorem in the same stage because Mathlib `HasSubgaussianMGF.const_mul` and `iIndepFun.comp` make it a direct extension of the unweighted theorem.
- Scale decision: unweighted scale is `sqrt (sum_i K_i^2)` and weighted scale is `sqrt (sum_i (a_i*K_i)^2)`, each with a positive proxy-sum assumption because HighDimProb MGF/tail predicates require strictly positive scales.
- Lean/mathlib reuse: `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`, `ProbabilityTheory.HasSubgaussianMGF.const_mul`, `ProbabilityTheory.iIndepFun.comp`, `Finset.measurable_sum`, and existing `subGaussianTail_of_centeredSubGaussianMGF`.
- Future upgrade path: Stage H6 should prove the bounded centered variable MGF lemma, then derive the general Hoeffding finite-sum theorem by composing with this new independent-sum layer.

## Stage H6 finite Hoeffding theorem for bounded centered variables

- Concrete version chosen: add `HighDimProb.Concentration.Hoeffding` with the one-variable bounded centered MGF wrapper, the finite independent-sum MGF theorem, the tail corollary, and an explicit unweighted Hoeffding bound.
- Possible general version: prove deterministic weighted bounded Hoeffding in the same stage, add lower-level Finset helper versions, or redesign exact zero-scale predicates.
- Reason for not generalizing yet: the unweighted theorem exercises the bounded-variable source lemma and the Stage H5 composition path; the weighted theorem is a direct but separate bookkeeping task with a new denominator normal form.
- Boundedness decision: expose both an a.e.-bounded theorem and a pointwise-bounded convenience wrapper. The a.e. form matches Mathlib's source lemma; the pointwise form uses `ae_of_all`.
- Constant decision: one variable has MGF scale `(b-a)/2`; finite sums use `sqrt (sum_i ((b_i-a_i)/2)^2)`; the existing MGF-to-tail bridge doubles this scale and the explicit theorem normalizes the denominator to `sum_i (b_i-a_i)^2`.
- Lean/mathlib reuse: `ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero`, Stage H5's `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos` and `subGaussianTail_sum_of_iIndepFun_of_pos`, `Real.sq_sqrt`, `Finset.mul_sum`, and ring normalization.
- Future upgrade path: Stage H7 should first prove the non-centered Wikipedia-form corollary by centering each bounded variable; deterministic weighted bounded Hoeffding should follow as a separate denominator-bookkeeping stage.

## Stage H6-sharp sharp finite Hoeffding constant

- Concrete version chosen: keep `CenteredSubGaussianMGF`, `SubGaussianTail`, `Psi2Bound`, and the existing scalar implication graph unchanged, and add Hoeffding-specific sharp Chernoff helpers in `HighDimProb.Concentration.Hoeffding`.
- Possible general version: redesign the global subGaussian scale convention or add a new public MGF proxy-variance predicate for all future MGF implications.
- Reason for not generalizing yet: the current predicates and implication theorems are already documented with conservative constants; changing them would silently alter existing theorem meanings and force a broad compatibility audit.
- Helper decision: no new predicate was introduced. The public helpers take the direct eighth-MGF hypothesis `E exp(lambda*Y) <= exp(lambda^2*V/8)` and prove sharp one-sided and two-sided tail bounds under `0 < V`.
- Constant decision: `hoeffding_sum_bounded_centered` remains the conservative bound with exponent `-t^2 / sum_i (b_i-a_i)^2`; `hoeffding_sum_bounded_centered_sharp` proves the classical/Wikipedia exponent `-2*t^2 / sum_i (b_i-a_i)^2`.
- Lean/mathlib reuse: the proof reuses Mathlib's bounded centered MGF theorem and `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`; the tail step uses local ENNReal Markov/Chernoff algebra and the existing absolute-tail subset/union helper.
- Future upgrade path: Stage H7 should prove the non-centered Wikipedia-form corollary by centering each bounded variable and reusing the sharp centered theorem. The deterministic weighted bounded theorem should then use the same sharp local route with denominator `sum_i (c_i * (b_i-a_i))^2`.

## Stage H7 non-centered Hoeffding corollary

- Concrete version chosen: derive `hoeffding_sum_bounded` by centering each bounded variable, shifting the interval bounds, and applying `hoeffding_sum_bounded_centered_sharp`.
- Possible general version: prove weighted and non-centered bounded Hoeffding together, or introduce a new global MGF proxy-variance predicate.
- Reason for not generalizing yet: the requested theorem only needs unweighted centering infrastructure, and changing global subGaussian conventions would silently affect existing theorem meanings.
- Helper decision: add `expect_finset_sum`, `iIndepFun_centered_of_iIndepFun`, `ae_mem_Icc_centered_of_ae_mem_Icc`, and `sum_centered_eq_sum_sub_expect_sum` as small public helpers because they describe reusable centering facts without creating a new predicate layer.
- Constant decision: `hoeffding_sum_bounded` matches the classical/Wikipedia exponent `-2*t^2 / sum_i (b_i-a_i)^2` for `sum_i X_i - E[sum_i X_i]`; `hoeffding_sum_bounded_centered` remains the conservative centered API, and `hoeffding_sum_bounded_centered_sharp` remains the sharp centered API.
- Lean/mathlib reuse: `MeasureTheory.integral_finset_sum`, `ProbabilityTheory.iIndepFun.comp`, finite-sum subtraction algebra, and the Stage H6-sharp centered theorem.
- Future upgrade path: Stage H8 should prove deterministic weighted bounded Hoeffding with the weighted denominator normal form.

## Stage H7-closeout Hoeffding branch milestone cleanup

- Concrete version chosen: close the finite Hoeffding theorem family with `docs/HoeffdingMilestone.md`, import checks, API-test coverage, and documentation consistency updates.
- Possible general version: start weighted bounded Hoeffding immediately after the non-centered theorem.
- Reason for not generalizing yet: the unweighted theorem family now has multiple constants and entry points; documenting the conservative, sharp centered, and non-centered roles before adding weights prevents theorem-meaning drift.
- Constant decision: keep `hoeffding_sum_bounded_centered` as the conservative generic-subGaussian-pipeline theorem with exponent `-t^2/V`; keep `hoeffding_sum_bounded_centered_sharp` and `hoeffding_sum_bounded` as the sharp `-2*t^2/V` Hoeffding forms.
- Import/test decision: `HighDimProb.Concentration` and `HighDimProb.Concentration.Implications` remain the aggregate experimental imports; focused and aggregate API tests check the theorem family, one-sided sharp helpers, and centering helpers.
- Future upgrade path: Stage H8 should prove deterministic weighted bounded Hoeffding without changing existing theorem meanings.

## Stage H8 weighted bounded Hoeffding theorem

- Concrete version chosen: prove both `hoeffding_weighted_sum_bounded_centered_sharp` and `hoeffding_weighted_sum_bounded` in `HighDimProb.Concentration.Hoeffding`.
- Possible general version: reduce directly to the unweighted theorem by defining `Y_i = c_i * X_i` and proving interval bounds for each transformed variable.
- Reason for not using that reduction: zero weights are allowed by the target theorem, but the existing unweighted theorem requires every interval width to be positive; `c_i = 0` would make the transformed interval width zero even when the total weighted denominator is positive.
- Constant decision: use the weighted finite-sum MGF proxy `sum_i (c_i * ((b_i-a_i)/2))^2`, normalize it to `(sum_i c_i^2 * (b_i-a_i)^2) / 4`, and apply the existing eighth-MGF Chernoff helper to get exponent `-2*t^2 / (sum_i c_i^2 * (b_i-a_i)^2)`.
- Negative-weight decision: arbitrary real weights are handled by Mathlib's `HasSubgaussianMGF.const_mul` through the existing weighted MGF theorem; signs disappear into squares, so no case split on `0 <= c_i` is needed.
- Centering decision: add the small public helper `sum_weighted_centered_eq_weighted_sum_sub_expect_weighted_sum`, mirroring the H7 unweighted centering helper under explicit integrability.
- Future upgrade path: Stage H9 should close out the Hoeffding branch documentation and import/test surface after the weighted theorem.

## Stage B1 subExponential finite-sum and Bernstein scaffold

- Concrete version chosen: add `HighDimProb.Concentration.SubExponentialSums` and `HighDimProb.Concentration.Bernstein` with a proved raw finite-sum MGF product theorem, a proof-friendly lintegral MGF predicate, local one-variable Chernoff tails, and typed `Prop` Bernstein statement targets.
- Possible general version: prove the full scalar Bernstein min-form tail bound for independent centered subExponential variables in one step.
- Reason for not generalizing yet: the existing `CenteredSubExponentialMGF` is an expectation-level predicate, so it composes over independent sums through Mathlib `iIndepFun.mgf_sum`, but it does not bundle the lintegral/integrability data needed for ENNReal tail proofs.
- Domain decision: the raw finite-sum theorem exposes an explicit `Kmax` domain `|lambda| <= 1 / Kmax`; the packaged predicate theorem uses conservative scale `sqrt (sum_i K_i^2)` and therefore the smaller domain `1 / sqrt (sum_i K_i^2)`.
- Constant decision: local Chernoff uses `exp (-(t^2 / (4*K^2)))` under `0 <= t` and `t <= K`; full Bernstein statements use an explicit positive placeholder `cBernstein`.
- Future upgrade path: Stage B1-fix resolves the lintegral finite-sum product theorem and reusable max-scale vocabulary; Stage B2 proves the full scalar min-form under the lintegral predicate.

## Stage B1-fix subExponential max-scale infrastructure

- Concrete version chosen: add `HighDimProb.Concentration.MaxScale` with real-valued `maxScale K` implemented as the coercion of `Finset.univ.sup (fun i => Real.toNNReal (K i))`, plus `varianceProxy K := sum_i K_i^2`.
- Possible general version: build a generic finite real maximum API or use subtype-indexed positive scales throughout the concentration branch.
- Reason for not generalizing yet: the Bernstein branch only needs a domain controller for positive subExponential scales, so a small `Real.toNNReal`-backed helper avoids overbuilding order theory around finite real maxima.
- Mathlib reuse: `Finset.le_sup`, `Finset.single_le_sum`, `Real.toNNReal`, `ProbabilityTheory.iIndepFun.mgf_sum`, `ProbabilityTheory.iIndepFun.integrable_exp_mul_sum`, `MeasureTheory.lintegral_ofReal_ne_top_iff_integrable`, and `MeasureTheory.ofReal_integral_eq_lintegral_ofReal`.
- Constant decision: normalized finite-sum MGF uses domain `|lambda| <= 1 / maxScale K` and exponent `varianceProxy K * lambda^2`; the local quadratic Bernstein corollary uses `t <= 2 * varianceProxy K / maxScale K` and exponent denominator `4 * varianceProxy K`.
- Future upgrade path: Stage B2 adds the large-deviation/linear-regime optimization and full scalar min-form theorem; raw-predicate and weighted variants remain separate future work.

## Stage B2 scalar Bernstein min-form

- Concrete version chosen: prove generic one-sided and two-sided min-form Chernoff bounds for any local lintegral MGF bound with variance proxy `V` and max-scale `B`, then instantiate them for finite independent `CenteredSubExponentialMGFLIntegral` sums via the B1-fix finite-sum MGF bridge.
- Possible general version: build an abstract Chernoff optimizer API for arbitrary convex MGF envelopes and derive Bernstein as one instance.
- Reason for not generalizing yet: the scalar Bernstein branch only needs the two explicit choices `lambda = t/(2V)` and `lambda = 1/B`; a generic optimizer would add proof overhead without serving the current theorem.
- Lean/mathlib reuse: `MeasureTheory.meas_ge_le_lintegral_div`, `Real.exp_le_exp`, `min_le_left`, `min_le_right`, `by_cases`, `field_simp`, `nlinarith`, `measure_union_le`, and the B1-fix lintegral finite-sum MGF theorem.
- Constant decision: the proved min-form uses `1/4 * min (t^2/V) (t/B)`. The small regime reuses exponent `-t^2/(4V)`, and the large regime proves exponent `-t/(2B)` before weakening to the `1/4` min-form.
- Future upgrade path: Stage B3 proves the weighted scalar Bernstein theorem with weighted variance proxy and max-scale vocabulary, reusing the generic B2 min-form helper; later Bernstein work should focus on raw-predicate bridges.

## Stage SC-closeout scalar concentration theorem family

- Concrete version chosen: add `docs/ScalarConcentrationMilestone.md`, update the scalar implication aggregate to re-export subExponential/Bernstein leaves, and add `HighDimProbTest.ScalarConcentrationMilestoneAPI` as a direct `import HighDimProb.Concentration` audit.
- Possible general version: continue immediately to weighted Bernstein or a larger concentration theorem family.
- Reason for not generalizing yet: Hoeffding and Bernstein now have multiple entry points and constants; documenting the stable theorem meanings before the next theorem branch reduces accidental API drift.
- Import/test decision: `HighDimProb.Concentration` is the experimental aggregate for the full scalar concentration theorem family; `HighDimProb.Concentration.Implications` is the scalar implication graph aggregate and now includes subExponential/Bernstein leaves.
- Constant decision: no constants are changed. The milestone document explicitly separates conservative Hoeffding, sharp Hoeffding, local Bernstein, and full Bernstein min-form constants.
- Future upgrade path: after Stage B3, the safe follow-up is scalar concentration final closeout rather than another theorem family.

## Stage B3 weighted scalar Bernstein theorem

- Concrete version chosen: prove deterministic weighted scalar Bernstein under `CenteredSubExponentialMGFLIntegral` assumptions using `weightedVarianceProxy c K` and `weightedMaxScale c K`.
- Possible general version: package every weighted variable `c_i * X_i` as a new `CenteredSubExponentialMGFLIntegral` variable with scale `|c_i| * K_i`.
- Reason for not using that packaging: the predicate requires a strictly positive scale, while the theorem should allow individual zero weights under positive total weighted proxies.
- MGF decision: prove scalar-multiple raw and lintegral MGF bounds with the original one-variable scale and domain `|lambda * c_i| <= 1 / K_i`, then prove the weighted finite-sum MGF product directly.
- Independence decision: reuse the existing `iIndepFun_weighted_of_iIndepFun` helper from the subGaussian-sum branch for deterministic scalar multiplication.
- Constant decision: reuse the Stage B2 generic min-form theorem unchanged, giving `1/4 * subExponentialBernsteinRate t (weightedVarianceProxy c K) (weightedMaxScale c K)`.
- Future upgrade path: raw-predicate Bernstein variants need a raw-to-lintegral bridge or equivalent source assumptions; matrix Bernstein and Hanson-Wright remain separate future branches.

## Stage SC-final scalar concentration branch closure

- Concrete version chosen: close the branch with a leaf audit, theorem index, test coverage map, and milestone document instead of adding another theorem family.
- Possible general version: promote `HighDimProb.Concentration` into the stable root after the current theorem families compile and are tested.
- Reason for not promoting: the branch still has deliberate gaps in reverse/source MGF implications, subExponential equivalence, exact scale-zero predicates, and raw-predicate Bernstein.
- Import decision: keep `HighDimProb.Concentration` and `HighDimProb.Distributions` experimental; keep `HighDimProb` as the stable scalar object-layer root.
- Test decision: no complex examples are added in SC-final because the indexed public theorem names already have focused `#check` coverage and aggregate import checks.
- Next-branch decision: Option C is resolved by Stage M-real-1, Stage M-real-2 resolves the analogous subExponential real-moment bridge, and Stage SC-final-update refreshes the scalar milestone docs.

## Stage SC-final-update scalar concentration closeout after moment bridges

- Concrete version chosen: update documentation, theorem index, test coverage map, and aggregate API checks after the full real/`ENNReal` subGaussian and subExponential moment bridges, without proving new theorem families.
- Possible general version: start matrix Bernstein, Hanson-Wright, WLLN/SLLN, or full equivalence packages immediately.
- Reason for not generalizing yet: the scalar theorem surface changed through the moment bridges; closeout docs need to stop advertising those bridges as future blockers before a larger branch starts.
- Import decision: `HighDimProb.Concentration` remains experimental but reaches the full moment bridge theorem names through `Concentration.MomentImplications` and `Concentration.Implications`.
- Test decision: focused `MomentImplicationsAPI` and aggregate `ConcentrationImplicationsAPI`/`ScalarConcentrationMilestoneAPI` checks cover `realLpNorm` finite-exponent bridges and full `SubGaussianMoment`/`SubExponentialMoment` wrappers.
- Future upgrade path: choose exactly one next major branch; the remaining scalar-only work is reverse/source MGF links, finite-gauge variants, raw-predicate Bernstein, and full equivalence packaging.

## Milestone Sprint S4 MGF implication branch

- Concrete version chosen: add `HighDimProb.Concentration.MGF` as the owner of forward MGF-to-tail/Orlicz/moment composition, while keeping `CenteredSubGaussianMGF` itself in the scalar predicate file.
- Possible general version: prove the full tail/Orlicz/moment/MGF equivalence family and promote a canonical `SubGaussian` predicate.
- Reason for not generalizing yet: S4 proved only the forward centered-MGF
  path. Reverse MGF implications and finite gauges remain independent theorem
  projects; the full real-exponent moment links are now resolved by
  Stages M-real-1 and M-real-2.
- MGF normal form decision: `CenteredSubGaussianMGFLIntegral` states `∫⁻ exp(lambda * X) <= exp(K^2 * lambda^2)`, a looser but book-style ENNReal bound obtained from Mathlib's `HasSubgaussianMGF` convention.
- Constant decision: one-sided Chernoff tails use denominator `4*K^2`, the two-sided tail scale is `2*K`, the induced ψ₂ scale is `4*K`, and the induced natural sqrt-moment scale is `16*K`.
- Lean/mathlib reuse: the proofs use Mathlib `HasSubgaussianMGF` for exponential integrability, `MeasureTheory.ofReal_integral_eq_lintegral_ofReal`, `MeasureTheory.meas_ge_le_lintegral_div`, `measure_union_le`, and existing HighDimProb tail-to-Orlicz and moment bridges.
- Future upgrade path: prove reverse MGF links or source the MGF predicate from ψ₂/tail hypotheses in a separate stage; do not collapse predicate forms until those directions are available.

## Stage MC4-cleanup matrix concentration statement honesty

- Concrete version chosen: remove the theorem-like Lean placeholders
  `matrixLaplaceTransformStatement` and `traceExpMomentBoundStatement` because
  they had body `True`, and keep matrix Laplace / trace exponential work as
  documentation-only TODOs in `docs/MatrixBernsteinProofPlan.md`.
- Statement decision: keep
  `operatorNorm_eq_spectralRadius_of_selfAdjointStatement` as a typed `Prop`
  because it mentions existing objects, but do not add typed Laplace or
  trace-exponential statements until the needed objects and assumptions can be
  stated honestly.
- Bernstein decision: refine `matrixBernsteinSelfAdjointStatement` to expose
  the probability-measure assumption, entrywise integrability, centered
  self-adjointness, independence, pointwise operator-norm boundedness, PSD
  variance proxy, variance proxy norm bound, nonnegative scales, positive
  constants, nonnegative threshold, and positive denominator.
- Integrability decision: add `IntegrableRandomMatrix` as a lightweight
  entrywise predicate in `HighDimProb.RandomMatrix.Expectation`; do not build a
  Bochner matrix-expectation layer.
- PSD decision: documentation now says
  `isPSD_matrixVarianceProxy_of_selfAdjoint_statement` is only a typed target.
  PSD remains blocked by PSD of self-adjoint squares, expectation preserving
  PSD, and finite sums preserving PSD.
- Future upgrade path: Stage MC4-psd should resolve the PSD square and
  variance-proxy algebra before returning to matrix Laplace or trace
  exponential vocabulary.

## Stage V1 Lean path visualization infrastructure

- Concrete version chosen: add a documentation-only visualization layer under
  `docs/visualizations/` plus a small import-graph generator in
  `scripts/visualize_imports.py`.
- Diagram decision: keep semantic theorem/proof-spine diagrams curated from the
  milestone and branch docs, because theorem status needs human wording such as
  `proven`, `typed Prop`, `conservative`, `sharp`, and `TODO`.
- Import decision: generate `docs/visualizations/import_graph.dot` from actual
  Lean import lines so the import graph can be refreshed without a full Lean
  parser.
- Dependency decision: the script uses only the Python standard library and no
  optional rendering dependency is added. Graphviz and Mermaid renderers remain
  optional viewer tools.
- Scope decision: no Lean declarations, theorem statements, theorem meanings,
  or proof statuses are changed in this stage.
- Future upgrade path: regenerate `import_graph.dot` after import changes and
  keep curated diagrams aligned with milestone closeouts.

## Stage J1 HighDimProb compile-time judge suite

- Concrete version chosen: add a separate `HighDimProbJudge` Lean library
  rather than mixing OJ-style checks into `HighDimProbTest`.
- Judge style decision: use a mix of name checks, selected exact type checks,
  and downstream-style theorem application examples. Large concentration
  theorems are checked by application examples instead of brittle full type
  assertions.
- Policy decision: add `scripts/judge_policy_check.py` using only the Python
  standard library. It checks forbidden Lean tokens, theorem-like `:= True`
  declarations, stable-root import boundaries, and complete imports from
  `HighDimProbJudge.lean`.
- Import decision: the judge imports public surfaces directly:
  `HighDimProb`, `HighDimProb.Concentration`, and `HighDimProb.RandomMatrix`.
- Scope decision: no Lean source theorem declarations, theorem meanings, or
  optional dependencies are changed.
- Future upgrade path: Stage J2 can add more judge cases for scalar implication
  graph names, branch import boundaries, and random-matrix typed statements.
