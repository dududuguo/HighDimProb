import HighDimProb.Concentration.DudleyEntropyIntegral

namespace HighDimProbTest

open HighDimProb
open MeasureTheory

set_option autoImplicit false

#check @HighDimProb.dudleyEntropyIntegrand
#check @HighDimProb.dudleyEntropyIntegrand_nonneg
#check @HighDimProb.dudleyEntropyIntegral
#check @HighDimProb.truncatedDudleyEntropyIntegral_le_dudleyEntropyIntegral
#check @HighDimProb.dyadicRadius_tendsto_zero
#check @HighDimProb.dudleyEntropyIntegral_nonneg
#check @HighDimProb.four_mul_sigma_mul_dudleyEntropyIntegral_nonneg

example {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (t : Real) :
    0 <= dudleyEntropyIntegrand K t :=
  dudleyEntropyIntegrand_nonneg K t

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {R : Real} (L : Nat) (hR : 0 < R)
    (hInt : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R) :
    (∫ t in dyadicRadius R (L + 1)..R, dudleyEntropyIntegrand K t) <=
      dudleyEntropyIntegral K R :=
  truncatedDudleyEntropyIntegral_le_dudleyEntropyIntegral L hR hInt

example {R : Real} :
    Filter.Tendsto (fun i : Nat => dyadicRadius R i) Filter.atTop (nhds 0) :=
  dyadicRadius_tendsto_zero

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {R : Real} (hR : 0 <= R)
    (hInt : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R) :
    0 <= dudleyEntropyIntegral K R :=
  dudleyEntropyIntegral_nonneg K hR hInt

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {R sigma : Real} (hR : 0 <= R) (hsigma : 0 <= sigma)
    (hInt : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R) :
    0 <= 4 * sigma * dudleyEntropyIntegral K R :=
  four_mul_sigma_mul_dudleyEntropyIntegral_nonneg K hR hsigma hInt

end HighDimProbTest
