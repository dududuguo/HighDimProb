import HighDimProb.Concentration.SubGaussianMax

/-!
# Empirical-process nets and finite chaining

The metric-entropy API now supplies the finite nets, their exact covering-number
cardinalities, parent maps, and compatible paths.  Consequently an empirical-
process argument can start at the level of a sub-Gaussian increment hypothesis
and feed those objects directly into the finite-chaining bound.

TODO: start this example from a `RandomSample` once the main library provides
the missing empirical-process bridge.  In particular, `HighDimProb` still
needs:

* empirical-mean and centered empirical-process constructors built from
  `sampleEvaluation`;
* measurability, integrability, and pointwise expansion lemmas for those
  constructors;
* transport of sample independence through evaluation, subtraction,
  centering, finite summation, and normalization; and
* a theorem deriving `HasSubGaussianMGFIncrements` for the centered empirical
  process from standard bounded-difference or Lipschitz assumptions on the
  function class.

Once these APIs exist, the resulting process can replace the abstract `X`
below and use the metric-entropy/chaining part of this example unchanged.
-/

namespace HighDimProb.Examples.EmpiricalProcessNetUsage

open MeasureTheory

noncomputable section

/-- At dyadic scales the metric-entropy API produces all data needed for chaining:
optimal finite levels, adjacent parent maps, and a path from every terminal
net point back through the coarser levels. -/
example {T : Type*} [PseudoMetricSpace T] {F : Set T} {L : ℕ} {R : ℝ}
    (hR : 0 < R) (hF : TotallyBounded F) :
    ∃ levels : Fin (L + 1) → Finset T,
      ∃ parent : Fin L → T → T,
        (∀ i, IsInternalEpsilonNet F (levels i : Set T)
          (dyadicRadius R (i : ℕ))) ∧
        (∀ i : Fin (L + 1), coveringNumber F (dyadicRadius R (i : ℕ)) =
          ((levels i).card : ENat)) ∧
        (∀ x, x ∈ levels (Fin.last L) →
          ∃ path : Fin (L + 1) → T,
            path (Fin.last L) = x ∧
            (∀ j, path j ∈ levels j) ∧
            (∀ k : Fin L,
              path (Fin.castSucc k) = parent k (path (Fin.succ k)) ∧
              dist (path (Fin.succ k))
                (parent k (path (Fin.succ k))) ≤
                  dyadicRadius R (Fin.castSucc k : ℕ))) := by
  obtain ⟨levels, parent, hnet, hcard, _, _, _, hpath⟩ :=
    exists_finset_internalNetFamily_parentMap_path_of_totallyBounded
      (fun i => dyadicRadius_pos hR i) hF
  exact ⟨levels, parent, hnet, hcard, hpath⟩

/-- Once a compatible dyadic path is chosen, the sub-Gaussian maximum API
turns its increments directly into the truncated covering-number entropy
integral. -/
example {Ω T : Type*} [MeasurableSpace Ω] [PseudoMetricSpace T]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω T ℝ} {F : Set T} {L : ℕ} {R σ : ℝ}
    (path : Fin (L + 1) → T)
    (nextLevel : Fin L → Finset T)
    (parent : Fin L → T → T)
    (hmem : ∀ k : Fin L, path (Fin.succ k) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      path (Fin.castSucc k) = parent k (path (Fin.succ k)))
    (hMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hR : 0 < R)
    (hdist : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ dyadicRadius R (Fin.castSucc k : ℕ))
    (hcard : ∀ k : Fin L,
      coveringNumber F (dyadicRadius R ((k : ℕ) + 1)) =
        ((nextLevel k).card : ENat))
    (hfinite : coveringNumber F (dyadicRadius R (L + 1)) ≠ ⊤) :
    expect P (fun ω =>
        |X (path (Fin.last L)) ω - X (path 0) ω|) ≤
      4 * σ *
        (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber F t).toNat : ℝ)))) := by
  exact expect_abs_sub_dyadic_path_le_truncatedEntropyIntegral
    path nextLevel parent hmem hparent hMeas hX hσ hR hdist hcard hfinite

end

end HighDimProb.Examples.EmpiricalProcessNetUsage
