# Small Proof Battery

Stage S3 tested whether existing branch APIs support small reusable proofs without starting large theorem families.

## Branches Tested

- Scalar tail/concentration
- Scalar centering and variance
- Geometry and metric entropy
- Random vector/isotropic predicates
- Random matrix finite-sum vocabulary

## Proofs Completed

- `markov_inequality_ae_nonneg`
- `lintegral_ofReal_eq_ofReal_expect_ae_nonneg`
- `variance_nonneg`
- `variance_centered_eq_variance`
- `externalCoveringNumber_le_encard_of_isEpsilonNet`
- `externalCoveringNumber_le_card_of_isEpsilonNet`
- `coveringNumber_le_encard_of_isInternalEpsilonNet`
- `coveringNumber_le_card_of_isInternalEpsilonNet`
- `IsotropicCovariance.centeredVector`
- `frobeniusSq_nonneg`
- `sampleCovarianceEntry_diag_nonneg`

## Existing Proofs Reused

- `upperTailProb_antitone`
- `lowerTailProb_monotone`
- `absTailProb_antitone`
- `centered_centered`
- `centeredVector_iff_forall_centered_coord`
- `isotropicSecondMomentMatrix_iff_isotropicSecondMoment`
- `isInternalEpsilonNet_of_maximalEpsilonSeparatedIn`

## Blocked Stretch Proof

- `quadraticForm_sampleCovariance_nonneg`

Blocker: the current explicit definitions need a bridge rewriting the quadratic form of `sampleCovariance A` into a scaled sum of squared row dot products. This should be handled in a focused random-matrix algebra stage, not hidden inside a proof battery.

## Infrastructure Lessons

- A.e.-nonnegative Markov fits the current wrappers once the lintegral-to-expectation bridge accepts an a.e. nonnegativity hypothesis.
- Scalar centering and variance are now well placed in scalar-owned leaves.
- Covering-number bridge lemmas should keep external and internal net APIs separate.
- Random matrix diagonal and Frobenius nonnegativity proofs are easy with explicit finite sums.
- PSD-style random matrix facts need a reusable finite-sum algebra layer.

## Ready For Deeper Work

Scalar concentration and metric entropy bridges are ready for narrower follow-up lemmas. Random matrix sample-covariance PSD facts should wait for Stage RM2 algebra bridge cleanup.
