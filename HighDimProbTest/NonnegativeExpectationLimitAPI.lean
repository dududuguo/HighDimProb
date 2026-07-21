import HighDimProb.Analysis.NonnegativeExpectationLimit

set_option autoImplicit false

namespace HighDimProbTest

open Filter MeasureTheory Topology
open HighDimProb

#check @HighDimProb.integrable_of_ae_tendsto_of_nonneg_of_integral_le
#check @HighDimProb.integrable_of_tendsto_of_nonneg_of_integral_le
#check @HighDimProb.integrable_of_ae_tendsto_of_nonneg_of_integral_bound_tendsto

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {f : Nat -> Omega -> Real} {fLimit : Omega -> Real} {C : Real}
    (hMeas : forall n, Measurable (f n))
    (hLimitMeas : Measurable fLimit)
    (hNonneg : forall n, 0 ≤ᵐ[P] f n)
    (hLimitNonneg : 0 ≤ᵐ[P] fLimit)
    (hTendsto : ∀ᵐ omega ∂P,
      Tendsto (fun n => f n omega) atTop (𝓝 (fLimit omega)))
    (hIntegrable : forall n, Integrable (f n) P)
    (hC : 0 <= C)
    (hBound : forall n, (∫ omega, f n omega ∂P) <= C) :
    Integrable fLimit P ∧ (∫ omega, fLimit omega ∂P) <= C :=
  integrable_of_ae_tendsto_of_nonneg_of_integral_le
    hMeas hLimitMeas hNonneg hLimitNonneg hTendsto hIntegrable hC hBound

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {f : Nat -> Omega -> Real} {fLimit : Omega -> Real} {C : Real}
    (hMeas : forall n, Measurable (f n))
    (hLimitMeas : Measurable fLimit)
    (hNonneg : forall n omega, 0 <= f n omega)
    (hLimitNonneg : forall omega, 0 <= fLimit omega)
    (hTendsto : forall omega,
      Tendsto (fun n => f n omega) atTop (𝓝 (fLimit omega)))
    (hIntegrable : forall n, Integrable (f n) P)
    (hC : 0 <= C)
    (hBound : forall n, (∫ omega, f n omega ∂P) <= C) :
    Integrable fLimit P ∧ (∫ omega, fLimit omega ∂P) <= C :=
  integrable_of_tendsto_of_nonneg_of_integral_le
    hMeas hLimitMeas hNonneg hLimitNonneg hTendsto hIntegrable hC hBound

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {f : Nat -> Omega -> Real} {fLimit : Omega -> Real}
    {CSeq : Nat -> Real} {C : Real}
    (hMeas : forall n, Measurable (f n))
    (hLimitMeas : Measurable fLimit)
    (hNonneg : forall n, 0 ≤ᵐ[P] f n)
    (hLimitNonneg : 0 ≤ᵐ[P] fLimit)
    (hTendsto : ∀ᵐ omega ∂P,
      Tendsto (fun n => f n omega) atTop (𝓝 (fLimit omega)))
    (hIntegrable : forall n, Integrable (f n) P)
    (hCSeqNonneg : forall n, 0 <= CSeq n)
    (hCSeqTendsto : Tendsto CSeq atTop (𝓝 C))
    (hBound : forall n, (∫ omega, f n omega ∂P) <= CSeq n)
    (hC : 0 <= C) :
    Integrable fLimit P ∧ (∫ omega, fLimit omega ∂P) <= C :=
  integrable_of_ae_tendsto_of_nonneg_of_integral_bound_tendsto
    hMeas hLimitMeas hNonneg hLimitNonneg hTendsto hIntegrable
    hCSeqNonneg hCSeqTendsto hBound hC

end HighDimProbTest
