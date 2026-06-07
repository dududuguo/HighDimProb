import HighDimProb.RandomMatrix.Laplace

namespace HighDimProb

open MeasureTheory

noncomputable section

def probe_traceExpThresholdEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (Y : RandomMatrix Omega n n) (theta t : Real) : Set Omega :=
  {omega | ENNReal.ofReal (Real.exp (theta * t)) <=
    ENNReal.ofReal (traceExpIntegrand Y theta omega)}

def probe_matrixLaplaceRHSLIntegralDiv {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (theta t : Real) : ENNReal :=
  traceExpMomentLIntegral P Y theta /
    ENNReal.ofReal (Real.exp (theta * t))

theorem probe_traceExpThresholdEvent_lintegral_bound {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P) :
    P (probe_traceExpThresholdEvent Y theta t) <=
      probe_matrixLaplaceRHSLIntegralDiv P Y theta t := by
  exact MeasureTheory.meas_ge_le_lintegral_div hMeas
    (ENNReal.ofReal_ne_zero_iff.mpr (Real.exp_pos (theta * t)))
    ENNReal.ofReal_ne_top

theorem probe_matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
    (hSubset :
      quadraticFormUpperTailEvent Y t ⊆
        probe_traceExpThresholdEvent Y theta t) :
    P (quadraticFormUpperTailEvent Y t) <=
      probe_matrixLaplaceRHSLIntegralDiv P Y theta t := by
  calc
    P (quadraticFormUpperTailEvent Y t)
        <= P (probe_traceExpThresholdEvent Y theta t) :=
          measure_mono hSubset
    _ <= probe_matrixLaplaceRHSLIntegralDiv P Y theta t :=
          probe_traceExpThresholdEvent_lintegral_bound Y theta t hMeas

theorem probe_matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real) :
    probe_matrixLaplaceRHSLIntegralDiv P Y theta t =
      matrixLaplaceRHSLIntegral P Y theta t := by
  rw [probe_matrixLaplaceRHSLIntegralDiv, matrixLaplaceRHSLIntegral]
  rw [div_eq_mul_inv]
  rw [← ENNReal.ofReal_inv_of_pos (Real.exp_pos (theta * t))]
  rw [← Real.exp_neg]
  rw [mul_comm]

end

end HighDimProb
