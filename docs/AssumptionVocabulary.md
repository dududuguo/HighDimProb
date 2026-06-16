# Assumption Vocabulary

This audit records which mathematical assumptions already have HighDimProb
declarations and which are still missing. It is a planning document only.

For RandomMatrix, `HighDimProb.RandomMatrix.Assumptions` is the
theorem-interface layer: it contains named assumption predicates and thin
adapters consumed by concentration statements. Core objects and algebra should
remain in the object modules such as `Basic`, `Expectation`, `SelfAdjoint`,
`MatrixOrder`, and `OperatorNorm`.

## Scalar

| Assumption | Existing declaration | Missing declaration | Mathlib object | Target module | Priority | Blockers |
| --- | --- | --- | --- | --- | --- | --- |
| pointwise nonnegative | direct hypothesis `forall omega, 0 <= X omega` | named predicate optional | order on `Real` | `HighDimProb.Concentration.Basic` | low | Current direct hypothesis is usable for Markov. |
| a.e. nonnegative | none | `AEStronglyNonnegative` or wrapper | `0 <=?[P] X` | `HighDimProb.Concentration.Basic` | medium | Need policy for pointwise vs a.e. APIs. |
| integrable | `IntegrableRealRandomVariable P X` | none | `Integrable X P` | `HighDimProb.Expectation` | done | Existing wrapper works. |
| square-integrable | `MemLpRealRandomVariable P X 2` | optional named alias | `MemLp X 2 P` | `HighDimProb.Lp` | low | Chebyshev uses the current wrapper. |
| centered | `Centered P X` | none | integral zero | `HighDimProb.Scalar.Centering` | done | Scalar centering is re-exported for concentration. |
| variance finite | none | named finite-variance predicate | `MemLp X 2 P` / variance | `HighDimProb.Scalar.Variance` | medium | Decide whether finite variance is `MemLp 2` or a variance-specific predicate. |
| independent Rademacher coordinates | `iIndepFun_rademacherCoord` | weighted-sum assumption wrapper optional later | `ProbabilityTheory.iIndepFun_pi` | `HighDimProb.Distributions.RademacherFamily` | done for canonical product signs | Applies only to the canonical product Rademacher space `Fin n -> Bool`, not arbitrary scalar samples. |
| independent weighted Rademacher terms | `iIndepFun_weightedRademacherTerms` | no assumption wrapper; deterministic weights are parameters | `ProbabilityTheory.iIndepFun.comp` | `HighDimProb.Concentration.RademacherSums` | done for canonical product signs | Used by `hasSubgaussianMGF_weightedRademacherSum`; not a generic independent-sum API. |
| independent centered subGaussian family | direct hypothesis `ProbabilityTheory.iIndepFun X P` | optional HighDimProb concentration assumption wrapper | `ProbabilityTheory.iIndepFun` | `HighDimProb.Concentration.SubGaussianSums` | done for finite MGF sums | Stage H5 proves finite unweighted and weighted MGF/tail closure from this direct Mathlib assumption; it does not bundle measurability or moment assumptions. |
| independent bounded centered family | direct hypotheses `ProbabilityTheory.iIndepFun X P`, `Centered P (X i)`, and `X i` a.e. in `Set.Icc (a i) (b i)` | optional bundled bounded-centered sample wrapper | `ProbabilityTheory.iIndepFun`, `Set.Icc`, a.e. interval membership | `HighDimProb.Concentration.Hoeffding` | done for finite unweighted Hoeffding | Stage H6 proves the one-variable bounded MGF wrapper, finite-sum MGF/tail theorem, and conservative explicit unweighted Hoeffding bound; Stage H6-sharp adds the sharp classical/Wikipedia centered bound; Stage H7 adds the non-centered bound around `E[sum_i X_i]`; deterministic weighted bounded Hoeffding remains Stage H8. |

## Vector

| Assumption | Existing declaration | Missing declaration | Mathlib object | Target module | Priority | Blockers |
| --- | --- | --- | --- | --- | --- | --- |
| centered vector | `CenteredVector P X` | none | coordinate functions | `HighDimProb.Covariance` | done | Coordinate bridge is proven. |
| isotropic vector | `IsotropicSecondMoment`, `IsotropicCovariance`, `IsotropicMarginal` | canonical isotropic predicate policy | matrix equality / covariance | `HighDimProb.Isotropic` | medium | Formulation choice remains separate. |
| subGaussian vector | `SubGaussianVectorOrlicz`, `SubGaussianVectorTail`, `SubGaussianVectorMoment` | implication graph | scalar formulations over marginals | `HighDimProb.SubGaussianVector` | medium | Scalar implication graph exists; vector lifting is future work. |
| independent coordinates | none | `IndependentCoords` | Mathlib independence APIs | future `HighDimProb.Vector.Independence` | high | Need finite-family independence policy. |
| iid coordinates | none | `IIDCoords` | `IdentDistrib`, independence | future `HighDimProb.Vector.Independence` | high | Depends on coordinate independence and distribution wrappers. |

## Matrix

| Assumption | Existing declaration | Missing declaration | Mathlib object | Target module | Priority | Blockers |
| --- | --- | --- | --- | --- | --- | --- |
| centered entries | `CenteredEntries P A` | none | scalar `Centered` | `HighDimProb.RandomMatrix.Assumptions` | done | Entrywise centeredness exists. |
| independent entries | none | `IndependentEntries` | Mathlib finite-family independence | future `HighDimProb.RandomMatrix.Independence` | high | Need policy for entry-indexed families. |
| iid entries | none | `IIDEntries` | independence + identical distribution | future `HighDimProb.RandomMatrix.Independence` | high | Depends on `IndependentEntries` and distribution equality. |
| independent rows | none | `IndependentRows` | Mathlib finite-family independence | future `HighDimProb.RandomMatrix.Independence` | high | Needed for sample covariance and matrix deviation statements. |
| iid rows | none | `IIDRows` | independence + row laws | future `HighDimProb.RandomMatrix.Independence` | high | Needs row-vector distribution vocabulary. |
| isotropic rows | `IsotropicRowsSecondMoment`, `IsotropicRowsCovariance` | none | row-vector isotropic predicates | `HighDimProb.RandomMatrix.Assumptions` | done | Existing row predicates are sufficient for statement prerequisites. |
| subGaussian rows | `SubGaussianRowsOrlicz` | tail/moment row variants optional | scalar/vector subGaussian predicates | `HighDimProb.RandomMatrix.Assumptions` | done/medium | Orlicz row form exists; other formulations can be added after vector implication lifting. |
| bounded operator norm | `BoundedOperatorNorm`, `PointwiseOperatorNormBound`, `isRealRandomVariable_operatorNorm` | a.e. versus pointwise policy refinements only | Mathlib matrix norm | `HighDimProb.RandomMatrix.Assumptions`, `HighDimProb.RandomMatrix.OperatorNorm` | done/medium | Pointwise predicates and measurability bridges exist; `AeOperatorNormBound` is kept separate so statements do not hide the distinction. |
| symmetric/self-adjoint random matrix | `RandomSymmetricMatrix`, `RandomSelfAdjointMatrix` | none | `Matrix.IsSymm`, `Matrix.IsHermitian` | `HighDimProb.RandomMatrix.SelfAdjoint` | done | Stage MC1 implements pointwise matrix predicates and random-matrix wrappers. |
| PSD random matrix | `RandomPSDMatrix`, `IsPSDMatrix`, `MatrixLE` | Gram/row-Gram PSD wrappers optional | explicit quadratic forms | `HighDimProb.RandomMatrix.MatrixOrder` | done/medium | Stage MC1 chooses explicit PSD/order vocabulary and proves sample covariance PSD. |
| matrix-valued independence | `IndependentRandomMatrices` | independent entries/rows remain separate | `ProbabilityTheory.iIndepFun` | `HighDimProb.RandomMatrix.ConcentrationStatements` | done/medium | Stage MC1 adds a product measurable-space instance for matrices; row/entry sampling assumptions remain future work. |

## Immediate Consequences

- Matrix concentration theorem statements now typecheck as `Prop`s in
  `HighDimProb.RandomMatrix.ConcentrationStatements`, but proofs remain blocked.
- Operator-norm measurability, centered operator-norm contraction, named
  centered rank-one adapters, sample covariance row rank-one centering bridges,
  and crude variance-proxy control from pointwise operator-norm bounds are now
  proved. The bounded-row sample-covariance quadratic-form wrapper derives the
  positive-side variance proxy using
  `sampleCovarianceCenteredRankOneVarianceProxyBound`; independence,
  square/exponential/trace integrability, Tropp, and CFC assumptions remain
  explicit. RM-S6 adds deterministic rank-one kernel/nullspace
  bridges in `Spectral.lean`, RM-S7E/RM-S7F add the conditional
  sample-covariance operator-norm event bridge and tail wrapper, and RM-ON-S4
  adds the nonempty operator-norm Matrix Bernstein wrapper while keeping
  variance proxy, Tropp, CFC, independence, and integrability assumptions
  explicit. RM-ON-S5 adds the nonempty sample-covariance operator-norm wrapper
  without an explicit spectral-bridge assumption. The arbitrary-dimensional
  bridge leaf adds the corrected `0 < t` spectral bridge and arbitrary
  operator-norm Matrix Bernstein/sample-covariance wrappers while keeping
  Tropp, CFC, independence, and integrability assumptions explicit. The
  current arbitrary-dimensional route is positive-threshold only; the negative
  family adapter branch is complete, and the next RandomMatrix branch is
  `RM-negative-exp-trace-primitive-audit`.
- Scalar concentration can continue toward moment/MGF links without depending
  on the matrix assumption layer.
