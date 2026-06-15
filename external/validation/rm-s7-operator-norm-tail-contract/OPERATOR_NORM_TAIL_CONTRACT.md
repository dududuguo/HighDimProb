# RM-S7 Operator-Norm Tail Contract

## Answers

1. Strongest current quadratic-form tail theorem:

   The strongest proved theorem is
   `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.
   It bounds
   `P (quadraticFormUpperTailEvent (randomMatrixSum A) t)` by the optimized
   bounded-Bernstein scalar RHS under explicit centered self-adjoint family,
   independence, integrability, pointwise operator-norm, variance-proxy,
   Bernstein CFC, and finite-family Tropp primitive assumptions.

   The strongest sample-covariance specialization is
   `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`.
   It transports the same optimized theorem through the normalized centered
   rank-one sample covariance sum, with variance proxy and primitive
   assumptions still explicit.

2. Lambda-max/operator-norm event vocabulary exists:

   Existing lambda vocabulary includes `lambdaMax`, `lambdaMaxOrdered`,
   `lambdaMaxUpperTailEvent`, `lambdaMaxOrderedUpperTailEvent`, and the generic
   `matrixUpperBoundTailEvent`.

   Existing quadratic-form and two-sided vocabulary includes
   `quadraticFormUpperTailEvent`, `quadraticFormLowerTailEvent`, and
   `twoSidedQuadraticFormTailEvent`.

   Existing operator-norm vocabulary includes `operatorNorm`,
   `deterministicOperatorNorm`, `SelfAdjointOperatorNormTailEvent`, and
   `selfAdjointOperatorNormTailEvent`.

3. Lambda-max tail reducible to quadratic-form tail using current APIs:

   No. Current APIs prove the forward upper-bound direction from explicit
   quadratic-form tail into lambda-max tail:
   `quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered`.

   The needed probability-transfer direction for applying the current
   quadratic-form tail theorem is the reverse subset:
   `lambdaMaxOrderedUpperTailEvent A hA t <= quadraticFormUpperTailEvent A t`.
   No existing theorem with that direction was found.

4. Operator-norm tail reducible to two-sided quadratic-form tail:

   Not yet as a proved API. The typed target
   `selfAdjointOperatorNormTailViaQuadraticFormStatement` records exactly this
   intended reduction:
   self-adjointness plus `0 <= t` should imply
   `SelfAdjointOperatorNormTailEvent A t <= twoSidedQuadraticFormTailEvent A t`.
   It remains a typed statement target, not a proved theorem.

5. Finite-net reduction needed:

   No for this route. The source route for Matrix Bernstein first controls
   `lambda_max(S)`, repeats for `-S`, and combines through the self-adjoint
   identity for operator norm. The HighDimProb API already has spectral and
   Rayleigh vocabulary for the deterministic bridge. Finite nets are useful in
   other random-matrix arguments, but they are not the smallest missing bridge
   from the current quadratic-form Matrix Bernstein theorem.

6. Smallest next theorem:

   Prove the deterministic ordered endpoint reverse event bridge:

   ```lean
   theorem lambdaMaxOrderedUpperTailEvent_subset_quadraticFormUpperTailEvent
       {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
       (A : RandomMatrix Omega (n + 1) (n + 1))
       (t : Real)
       (hA : forall omega, IsSelfAdjointMatrix (A omega)) :
       lambdaMaxOrderedUpperTailEvent A hA t <=
         quadraticFormUpperTailEvent A t := by
     ...
   ```

   A lower-level deterministic form may be better if the proof needs explicit
   eigenvector attainment:

   ```lean
   theorem lambdaMaxOrdered_le_iff_exists_unit_quadraticForm_ge
       {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
       (hA : IsSelfAdjointMatrix A) (t : Real) :
       t <= lambdaMaxOrdered A hA <->
         exists x : Fin (n + 1) -> Real,
           IsUnitVector x /\ t <= matrixQuadraticForm A x := by
     ...
   ```

## Classification

`SPECTRAL_RAYLEIGH_BRIDGE_REQUIRED`

## Blockers

- The reverse lambda-max event bridge is absent.
- `selfAdjointOperatorNormTailViaQuadraticFormStatement` remains typed only.
- `operatorNorm_eq_max_abs_lambda_statement` remains typed only for the legacy
  `lambdaMax`/`lambdaMin` route.

## Not Needed Next

- No new quadratic-form tail event definition.
- No new lambda-max or operator-norm definition.
- No finite-net reduction.
- No new Matrix Bernstein primitive.

## Next Safe Task

Prove the ordered lambda-max reverse event bridge from Mathlib/HighDimProb
spectral attainment into the existing explicit unit-vector
`quadraticFormUpperTailEvent`.
