import HighDimProb.RandomMatrix.Concentration

open MeasureTheory
open HighDimProb

#check MatrixSubGaussianMGF
#check subGaussian_quadraticFormUpperTail_under_troppPrimitive

example {Omega I : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega (n + 1) (n + 1))
    (V : I -> Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (sigmaSq t : Real)
    (hsig : 0 < sigmaSq) (ht : 0 <= t)
    (hVSA : forall i, IsSelfAdjointMatrix (V i))
    (hSpec :
      lambdaMaxOrdered (Finset.univ.sum V) (isSelfAdjointMatrix_sum hVSA) <=
        sigmaSq)
    (hRand : forall i, IsRandomMatrix P (X i))
    (hSA : forall i, RandomSelfAdjointMatrix P (X i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hSG : forall i, MatrixSubGaussianMGF P (X i) (V i))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement (P := P) X
        (fun i => ((t / sigmaSq) ^ 2 / 2) • V i)
        (Finset.univ.sum V) (t / sigmaSq) 0)
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (fun omega => matrixExp ((t / sigmaSq) • X i omega)))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) (t / sigmaSq))) :
    P (quadraticFormUpperTailEvent (randomMatrixSum X) t) <=
      ENNReal.ofReal ((n + 1 : Real) * Real.exp (-(t ^ 2 / (2 * sigmaSq)))) := by
  exact subGaussian_quadraticFormUpperTail_under_troppPrimitive
    X V sigmaSq t hsig ht hVSA hSpec hRand hSA hIndep hSG hTropp hExpInt hTraceInt
