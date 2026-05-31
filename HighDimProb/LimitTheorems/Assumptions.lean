import HighDimProb.LimitTheorems.Basic
import Mathlib.Probability.IdentDistrib
import Mathlib.Probability.Independence.Basic

/-!
# Assumption vocabulary for limit theorems

This module records thin, Mathlib-backed assumption wrappers for future weak-law
proofs. It intentionally does not prove independence consequences or variance
formulas.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- Mathlib-backed independence vocabulary for scalar random-variable families. -/
abbrev IndependentSample {Omega ι : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (X : ι -> RealRandomVariable Omega) : Prop :=
  ProbabilityTheory.iIndepFun X P

/-- Pairwise independence vocabulary for finite scalar samples. -/
abbrev PairwiseIndependentFinSample {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {n : Nat} (X : Fin n -> RealRandomVariable Omega) : Prop :=
  Set.Pairwise (Set.univ : Set (Fin n)) fun i j =>
    ProbabilityTheory.IndepFun (X i) (X j) P

/-- Identical distribution vocabulary for scalar random-variable families. -/
abbrev IdenticallyDistributedSample {Omega ι : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (X : ι -> RealRandomVariable Omega) : Prop :=
  forall i j : ι, ProbabilityTheory.IdentDistrib (X i) (X j) P P

/-- Iid vocabulary for scalar random-variable families. -/
abbrev IidSample {Omega ι : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (X : ι -> RealRandomVariable Omega) : Prop :=
  IndependentSample P X ∧ IdenticallyDistributedSample P X

/-- Independence vocabulary specialized to finite samples indexed by `Fin n`. -/
abbrev IndependentFinSample {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {n : Nat} (X : Fin n -> RealRandomVariable Omega) : Prop :=
  IndependentSample P X

/-- Identical distribution vocabulary specialized to finite samples indexed by `Fin n`. -/
abbrev IdenticallyDistributedFinSample {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {n : Nat} (X : Fin n -> RealRandomVariable Omega) : Prop :=
  IdenticallyDistributedSample P X

/-- Iid vocabulary specialized to finite samples indexed by `Fin n`. -/
abbrev IidFinSample {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {n : Nat} (X : Fin n -> RealRandomVariable Omega) : Prop :=
  IidSample P X

/-- Independence vocabulary specialized to sequences indexed by `Nat`. -/
abbrev IndependentSequence {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (X : Nat -> RealRandomVariable Omega) : Prop :=
  IndependentSample P X

/-- Identical distribution vocabulary specialized to sequences indexed by `Nat`. -/
abbrev IdenticallyDistributedSequence {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (X : Nat -> RealRandomVariable Omega) : Prop :=
  IdenticallyDistributedSample P X

/-- Iid vocabulary specialized to sequences indexed by `Nat`. -/
abbrev IidSequence {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (X : Nat -> RealRandomVariable Omega) : Prop :=
  IidSample P X

end

end HighDimProb
