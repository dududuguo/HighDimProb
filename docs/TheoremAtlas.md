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
operator-norm, sample-covariance, and crude variance-proxy routes.

Important current names are listed in [`RandomMatrixAPI.md`](RandomMatrixAPI.md).

## Not Yet Proved

- Full Tropp/Lieb machinery.
- Full Bernstein CFC primitive.
- Golden-Thompson route.
- Full unconditional Matrix Bernstein theorem.
- Tropp/CFC-free sample-covariance operator-norm concentration.

## Maintenance Rule

Keep this file as a compact index. Put only short historical summaries in
`archive.md`, and put exact API-name details in the relevant API index.
