# Theorem Atlas

This is the current theorem-family index. Old atlas detail was collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Status Vocabulary

- `proven`: implemented as a Lean theorem or lemma.
- `typed-prop`: represented as a compiled statement object, not proved.
- `scaffold`: vocabulary or statement layer only.
- `blocked`: waiting on real mathematical infrastructure.

## Scalar Concentration

The scalar concentration layer is the most mature part of the library. It
contains proved Markov/Chebyshev wrappers, Orlicz-to-tail and tail-to-Orlicz
bridges, moment implications, Rademacher/Hoeffding routes, and scalar Bernstein
families. See [`ScalarConcentrationTheoremIndex.md`](ScalarConcentrationTheoremIndex.md)
for the denser scalar index.

## RandomMatrix

The RandomMatrix layer is experimental. The current Matrix Bernstein route has
proved useful wrappers under explicit primitive assumptions, including
trace-MGF, quadratic-form, optimized scalar RHS, positive-threshold
operator-norm, sample-covariance, crude variance-proxy routes, and
prefix/state endpoint bookkeeping wrappers for the Tropp conditional-step
route. The TraceExp layer also has a natural `Fin m` trace-state route that
derives the finite-family Tropp provider and trace-MGF provider from explicit
natural conditional-step data. The sample-covariance surface includes named
negative-side provider-transfer adapters for opposite-parameter exp/trace/CFC
assumptions; these are adapter lemmas, not unconditional provider proofs.

Important current names are listed in [`RandomMatrixAPI.md`](RandomMatrixAPI.md).
The hardbone statement atlas in
[`HardboneStatements.lean`](../HighDimProb/RandomMatrix/HardboneStatements.lean)
names CFC, log/order, Tropp/Lieb, conditioning, integrability,
variance-proxy, and dimension/rank blockers as `typed-prop` targets. Selected
consumer wrappers are proven thin applications of those targets; they do not
close the hard theorem families. The Bernstein CFC route is now proved as
`bernsteinMatrixExp_le_quadratic`, via scalar Bernstein, spectrum localization,
Bernstein-specific CFC order transfer, and expression normalization. The
trace-MGF provider surface includes
`matrixBernsteinTraceMGFWithBernsteinCoeff_under_troppPrimitive`, which reuses
that CFC proof while keeping Tropp/Lieb and integrability assumptions explicit.
The preferred optimized Matrix Bernstein wrappers use
`MatrixBernsteinPositiveSideTroppAssumptions` and
`MatrixBernsteinNegativeSideTroppAssumptions` to avoid exposing pointwise CFC
fields in generic call sites. The sample-covariance route now also has
CFC-free `_of_troppPrimitive` / `_of_troppPrimitives` wrappers that reuse
`bernsteinMatrixExp_le_quadratic` while keeping Tropp/Lieb and integrability
assumptions explicit.
The finite-family conditioning chain now has the thin witness
`troppConditionalStep_of_iIndepFun`; it forwards the explicit per-index
conditional-expectation provider and does not prove the history, independence,
or conditional-expectation inputs themselves.

## Not Yet Proved

- Full Tropp/Lieb machinery.
- Golden-Thompson route.
- Full unconditional Matrix Bernstein theorem.
- Natural history measurability, independence conditioning,
  conditional-expectation reduction, and trace-exp integrability propagation for
  the conditional-step Tropp route.
- Proofs of the remaining hardbone statement targets for log/order,
  Tropp/Lieb, integrability, variance-proxy sharpening, and
  dimension/rank refinements.
- A public-friendly Matrix Bernstein wrapper directly over the natural-state
  route.

## Maintenance Rule

Keep this file as a compact index. Put only short historical summaries in
`archive.md`, and put exact API-name details in the relevant API index.
