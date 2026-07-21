import HighDimProb.RandomProcess
import HighDimProb.MetricEntropy

set_option autoImplicit false

namespace HighDimProb

open Bornology

/-!
# Sample-path regularity

The predicates in this file are deliberately independent of measures and
random-variable measurability. They describe a pathwise property of a family
`X : T -> Omega -> E`; when `X` is a `RandomProcess`, the process layer can
use them without adding probability assumptions to the path contract.
-/

/-- Every sample path of `X` is continuous on `K`. -/
def HasContinuousSamplePathsOn
    {Omega T E : Type*} [UniformSpace T] [UniformSpace E]
    (X : T -> Omega -> E) (K : Set T) : Prop :=
  forall omega, ContinuousOn (fun t => X t omega) K

/-- Every sample path of `X` is uniformly continuous on `K`. -/
def HasUniformlyContinuousSamplePathsOn
    {Omega T E : Type*} [UniformSpace T] [UniformSpace E]
    (X : T -> Omega -> E) (K : Set T) : Prop :=
  forall omega, UniformContinuousOn (fun t => X t omega) K

/-- Uniformly continuous sample paths are continuous sample paths. -/
theorem HasUniformlyContinuousSamplePathsOn.continuousSamplePathsOn
    {Omega T E : Type*} [UniformSpace T] [UniformSpace E]
    {X : T -> Omega -> E} {K : Set T}
    (hX : HasUniformlyContinuousSamplePathsOn X K) :
    HasContinuousSamplePathsOn X K := by
  intro omega
  exact (hX omega).continuousOn

/-- On a compact index set, continuous sample paths are uniformly continuous. -/
theorem HasContinuousSamplePathsOn.uniformlyContinuousSamplePathsOn_of_isCompact
    {Omega T E : Type*} [UniformSpace T] [UniformSpace E]
    {X : T -> Omega -> E} {K : Set T} (hX : HasContinuousSamplePathsOn X K)
    (hK : IsCompact K) : HasUniformlyContinuousSamplePathsOn X K := by
  intro omega
  exact hK.uniformContinuousOn_of_continuous (hX omega)

/-- A uniformly continuous map sends a totally bounded set to a bounded image,
even when its uniform continuity is only assumed on that set. -/
theorem TotallyBounded.isBounded_image_of_uniformContinuousOn
    {T E : Type*} [UniformSpace T] [PseudoMetricSpace E]
    {K : Set T} {f : T -> E} (hK : TotallyBounded K)
    (hf : UniformContinuousOn f K) : IsBounded (f '' K) := by
  have hKSubtype : TotallyBounded (Set.univ : Set K) := by
    simpa using
      (totallyBounded_preimage
        ((isUniformEmbedding_subtype_val
          (p := fun t : T => t ∈ K)).isUniformInducing) hK)
  have hfSubtype : UniformContinuous (K.restrict f) := hf.restrict
  have hImageSubtype :
      TotallyBounded ((K.restrict f) '' (Set.univ : Set K)) :=
    hKSubtype.image hfSubtype
  have hImageSubtypeBounded :
      IsBounded ((K.restrict f) '' (Set.univ : Set K)) :=
    hImageSubtype.isBounded
  have hImageEq :
      (K.restrict f) '' (Set.univ : Set K) = f '' K := by
    ext y
    constructor
    · rintro ⟨t, -, rfl⟩
      exact ⟨(t : T), t.property, rfl⟩
    · rintro ⟨t, ht, rfl⟩
      exact ⟨⟨t, ht⟩, Set.mem_univ _, rfl⟩
  rw [← hImageEq]
  exact hImageSubtypeBounded

/-- A uniformly continuous real-valued map on a totally bounded set has a
bounded-above image. -/
theorem TotallyBounded.bddAbove_image_of_uniformContinuousOn
    {T : Type*} [UniformSpace T] {K : Set T} {f : T -> Real}
    (hK : TotallyBounded K) (hf : UniformContinuousOn f K) :
    BddAbove (f '' K) := by
  exact (isBounded_iff_bddBelow_bddAbove.mp
    (TotallyBounded.isBounded_image_of_uniformContinuousOn hK hf)).2

/-- The anchored absolute increment along a real-valued sample path. -/
def anchoredAbsIncrement
    {Omega T : Type*} (X : T -> Omega -> Real) (t0 : T) (omega : Omega)
    (t : T) : Real :=
  |X t omega - X t0 omega|

/-- Anchored absolute increments are nonnegative at every sample and index. -/
theorem anchoredAbsIncrement_nonneg
    {Omega T : Type*} (X : T -> Omega -> Real) (t0 : T) (omega : Omega)
    (t : T) :
    0 <= anchoredAbsIncrement X t0 omega t := by
  exact abs_nonneg _

/-- Uniformly continuous real-valued sample paths remain uniformly continuous
after taking an anchored absolute increment. -/
theorem uniformlyContinuousOn_anchoredAbsIncrement
    {Omega T : Type*} [PseudoMetricSpace T]
    {X : T -> Omega -> Real} {K : Set T}
    (hX : HasUniformlyContinuousSamplePathsOn X K) (t0 : T) (omega : Omega) :
    UniformContinuousOn (anchoredAbsIncrement X t0 omega) K := by
  have hdist :=
    (LipschitzWith.dist_left (X t0 omega)).uniformContinuous.comp_uniformContinuousOn
      (hX omega)
  simpa only [Function.comp_apply, anchoredAbsIncrement, Real.dist_eq] using hdist

/-- The anchored absolute increment has bounded image on a totally bounded
index set, for every sample. -/
theorem isBounded_anchoredAbsIncrement_image
    {Omega T : Type*} [PseudoMetricSpace T]
    {X : T -> Omega -> Real} {K : Set T}
    (hK : TotallyBounded K) (hX : HasUniformlyContinuousSamplePathsOn X K)
    (t0 : T) (omega : Omega) :
    IsBounded (anchoredAbsIncrement X t0 omega '' K) :=
  TotallyBounded.isBounded_image_of_uniformContinuousOn hK
    (uniformlyContinuousOn_anchoredAbsIncrement hX t0 omega)

/-- The anchored absolute increment has a bounded-above image on a totally
bounded index set, for every sample. -/
theorem bddAbove_anchoredAbsIncrement_image
    {Omega T : Type*} [PseudoMetricSpace T]
    {X : T -> Omega -> Real} {K : Set T}
    (hK : TotallyBounded K) (hX : HasUniformlyContinuousSamplePathsOn X K)
    (t0 : T) (omega : Omega) :
    BddAbove (anchoredAbsIncrement X t0 omega '' K) :=
  TotallyBounded.bddAbove_image_of_uniformContinuousOn hK
    (uniformlyContinuousOn_anchoredAbsIncrement hX t0 omega)

end HighDimProb
