# Scalar Implication Graph

This graph records only proved scalar concentration implications. It does not
define canonical `SubGaussian` or `SubExponential` predicates.

## SubGaussian

- `Psi2Bound -> SubGaussianTail`: proven by `subGaussianTail_of_psi2Bound`.
- `SubGaussianTail -> Psi2Bound`: proven by `psi2Bound_of_subGaussianTail` with scale `K -> 2 * K`.
- Moment formulation links: TODO.
- MGF formulation links: TODO.
- Finite-gauge/norm formulation links: TODO.

## SubExponential

- `Psi1Bound -> SubExponentialTail`: proven by `subExponentialTail_of_psi1Bound`.
- `SubExponentialTail -> Psi1Bound`: proven by `psi1Bound_of_subExponentialTail` with scale `K -> 3 * K`.
- Moment formulation links: TODO.
- MGF formulation links: TODO.
- Finite-gauge/norm formulation links: TODO.

## Policy

- Keep formulation-specific predicates until all major links are proved.
- Record constant losses in theorem names or documentation.
- Do not promote a canonical predicate from this graph without proof coverage,
  tests, and a status update.
