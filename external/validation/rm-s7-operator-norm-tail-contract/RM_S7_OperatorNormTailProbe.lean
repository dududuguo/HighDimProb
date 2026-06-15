import HighDimProb.RandomMatrix.ConcentrationStatements
import HighDimProb.RandomMatrix.Laplace
import HighDimProb.RandomMatrix.Spectral

/-!
# RM-S7 operator-norm tail contract probe

This file is validation-only. It checks the currently exposed API route from
the optimized quadratic-form Matrix Bernstein theorem toward lambda-max and
self-adjoint operator-norm tail events.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

#check matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy

#check matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives

#check quadraticFormUpperTailEvent
#check quadraticFormLowerTailEvent
#check twoSidedQuadraticFormTailEvent
#check quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent
#check quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent

#check lambdaMax
#check lambdaMaxOrdered
#check lambdaMaxUpperTailEvent
#check lambdaMaxOrderedUpperTailEvent
#check lambdaMaxOrdered_is_greatest_eigenvalue
#check lambdaMaxOrdered_spectralUpperBound
#check lambdaMaxOrderedPSDUpperBound
#check lambdaMaxOrdered_rayleighUpperBound
#check matrixQuadraticForm_le_lambdaMax_statement
#check matrixQuadraticForm_le_lambdaMaxOrdered_statement
#check quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax
#check quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered

#check operatorNorm
#check deterministicOperatorNorm
#check SelfAdjointOperatorNormTailEvent
#check selfAdjointOperatorNormTailEvent
#check selfAdjointOperatorNormTailViaQuadraticFormStatement
#check operatorNorm_eq_max_abs_lambda_statement

#check lambdaMaxOrdered_traceExpDominatesUpperBound
#check traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
#check matrixLaplaceTransformLIntegral_of_randomSelfAdjoint

/-- Candidate missing bridge: ordered lambda-max upper tail should reduce to
the existing explicit quadratic-form upper-tail event. -/
abbrev rmS7_lambdaMaxOrderedTailSubsetQuadraticFormCandidate
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1))
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) (t : Real) : Prop :=
  lambdaMaxOrderedUpperTailEvent A hA t <= quadraticFormUpperTailEvent A t

/-- Candidate missing bridge: self-adjoint operator-norm tail should reduce to
the existing two-sided quadratic-form event. -/
abbrev rmS7_operatorNormTailSubsetTwoSidedQFCandidate
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (t : Real) : Prop :=
  (forall omega, IsSelfAdjointMatrix (A omega)) ->
    0 <= t ->
      SelfAdjointOperatorNormTailEvent A t <= twoSidedQuadraticFormTailEvent A t

#check rmS7_lambdaMaxOrderedTailSubsetQuadraticFormCandidate
#check rmS7_operatorNormTailSubsetTwoSidedQFCandidate

end

end HighDimProb
