# References

This page is a lightweight reference map for the project. It is not meant to be
a bibliography for a paper, and it is not a replacement for the Lean source.

The rule is simple: references explain the mathematical background; Mathlib and
the files in `HighDimProb/` decide what the current formal API actually is.

Please do not commit full copies of books, papers, lecture notes, or OCR dumps
unless their license clearly allows redistribution here. Prefer citations and
links.

## Core Background

- Patrick Billingsley, *Probability and Measure*, 3rd ed., Wiley, 1995.
- Olav Kallenberg, *Foundations of Modern Probability*, 3rd ed., Springer,
  2021.
- Rick Durrett, *Probability: Theory and Examples*, 5th ed., Cambridge
  University Press, 2019.
- Roman Vershynin, *High-Dimensional Probability: An Introduction with
  Applications in Data Science*, Cambridge University Press, 2018.
- Stephane Boucheron, Gabor Lugosi, and Pascal Massart, *Concentration
  Inequalities: A Nonasymptotic Theory of Independence*, Oxford University
  Press, 2013.
- Michel Ledoux, *The Concentration of Measure Phenomenon*, American
  Mathematical Society, 2001.
- Martin J. Wainwright, *High-Dimensional Statistics: A Non-Asymptotic
  Viewpoint*, Cambridge University Press, 2019.
- Aad W. van der Vaart and Jon A. Wellner, *Weak Convergence and Empirical
  Processes*, Springer, 1996.
- Joel A. Tropp, "User-Friendly Tail Bounds for Sums of Random Matrices",
  *Foundations of Computational Mathematics*, 2012.
- Joel A. Tropp, *An Introduction to Matrix Concentration Inequalities*,
  *Foundations and Trends in Machine Learning*, 2015.
- Terence Tao, *Topics in Random Matrix Theory*, American Mathematical Society,
  2012.
- Simon Foucart and Holger Rauhut, *A Mathematical Introduction to Compressive
  Sensing*, Birkhauser, 2013.

## MVP Coverage Map

### Probability And Scalar Objects

Relevant modules:

- `HighDimProb.Basic`
- `HighDimProb.ProbabilitySpace`
- `HighDimProb.RandomVariable`
- `HighDimProb.Distribution`
- `HighDimProb.Expectation`
- `HighDimProb.Tail`
- `HighDimProb.Lp`
- `HighDimProb.Moment`
- `HighDimProb.Scalar`

Useful background:

- Billingsley and Kallenberg for measure-theoretic probability, random
  variables, distributions, expectation, and convergence vocabulary.
- Durrett for standard probability notation and classical inequalities.
- Mathlib's probability, measure, integration, moments, and independence APIs
  are the first implementation reference.

### Orlicz, SubGaussian, And SubExponential Vocabulary

Relevant modules:

- `HighDimProb.Orlicz`
- `HighDimProb.SubGaussian`
- `HighDimProb.SubExponential`
- `HighDimProb.Concentration.OrliczToTail`
- `HighDimProb.Concentration.TailToOrlicz`
- `HighDimProb.Concentration.MGF`
- `HighDimProb.Concentration.MomentImplications`

Useful background:

- Vershynin for psi-norms, subGaussian and subExponential formulations, and the
  common tail/moment/MGF equivalence picture.
- Boucheron-Lugosi-Massart and Ledoux for concentration-side uses of
  exponential moments and tail bounds.

### Scalar Concentration

Relevant modules:

- `HighDimProb.Concentration.Markov`
- `HighDimProb.Concentration.Chebyshev`
- `HighDimProb.Concentration.Hoeffding`
- `HighDimProb.Concentration.Bernstein`
- `HighDimProb.Concentration.SubGaussianSums`
- `HighDimProb.Concentration.SubExponentialSums`
- `HighDimProb.Concentration.RademacherSums`
- `HighDimProb.Distributions.Rademacher`
- `HighDimProb.Distributions.RademacherFamily`

Useful background:

- Boucheron-Lugosi-Massart for the main concentration-inequality perspective.
- Vershynin for the high-dimensional probability normalization of
  subGaussian/subExponential sums.
- Hoeffding's 1963 paper for bounded independent sums.
- Classical Bernstein inequalities as treated in modern concentration texts.

### Random Vectors, Nets, And Metric Entropy

Relevant modules:

- `HighDimProb.RandomVector`
- `HighDimProb.Covariance`
- `HighDimProb.Isotropic`
- `HighDimProb.SubGaussianVector`
- `HighDimProb.Nets`
- `HighDimProb.MetricEntropy`
- `HighDimProb.MetricEntropyStatements`
- `HighDimProb.GaussianWidth`

Useful background:

- Vershynin for random vectors, isotropicity, nets, covering numbers, and
  subGaussian vector vocabulary.
- Wainwright for high-dimensional statistics notation and non-asymptotic
  viewpoint.
- van der Vaart-Wellner for empirical-process and entropy background.

### Random Matrices And Matrix Concentration

Relevant modules:

- `HighDimProb.RandomMatrix`
- `HighDimProb.RandomMatrix.Spectral`
- `HighDimProb.RandomMatrix.TraceExp`
- `HighDimProb.RandomMatrix.Laplace`
- `HighDimProb.RandomMatrix.VarianceProxy`
- `HighDimProb.RandomMatrix.ConcentrationStatements`

Useful background:

- Tropp's matrix concentration papers for matrix Laplace, trace exponential
  methods, variance proxies, and Matrix Bernstein-style bounds.
- Tao for random matrix theory background.
- Vershynin for non-asymptotic random matrix estimates.
- Roland Speicher, *Random Matrices*, lecture notes, Saarland University,
  winter 2019/20. Course page:
  <https://www.math.uni-sb.de/ag/speicher/web_video/index.html>

### Limit Theorems, Processes, And Signal Recovery

Relevant modules:

- `HighDimProb.LimitTheorems`
- `HighDimProb.RandomProcess`
- `HighDimProb.EmpiricalProcess`
- `HighDimProb.SignalRecovery`

Useful background:

- Billingsley, Kallenberg, and Durrett for laws of large numbers and classical
  convergence vocabulary.
- van der Vaart-Wellner for empirical-process background.
- Foucart-Rauhut for compressed sensing and signal-recovery vocabulary.
- Wainwright and Vershynin for high-dimensional statistics context.

## Local Source Policy

The repository may keep small notes that point to outside sources. It should not
vendor large source texts into the main tree. If a future task needs a large
reference corpus, put it in a separate archive, a submodule with a clear
license, or a local ignored directory.
