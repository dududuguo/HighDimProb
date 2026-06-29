# HighDimProb Wiki 页面对照表

根据 `C:\Projects\HighDimProb\HighDimProb` 目录下的所有 Lean 文件中的定理/概念，找到的 Wikipedia 页面如下：

---

## 根目录文件

| Lean 文件 | 核心概念/定理 | Wikipedia 页面 |
|-----------|-------------|----------------|
| `Basic.lean` | 事件 (Event)、可测事件 | https://en.wikipedia.org/wiki/Probability_space (可测空间/事件) |
| `ProbabilitySpace.lean` | 概率空间 | https://en.wikipedia.org/wiki/Probability_space |
| `RandomVariable.lean` | 随机变量 | https://en.wikipedia.org/wiki/Random_variable |
| `Distribution.lean` | 概率分布 | https://en.wikipedia.org/wiki/Probability_distribution |
| `Expectation.lean` | 期望 / LOTUS | https://en.wikipedia.org/wiki/Expected_value / https://en.wikipedia.org/wiki/Law_of_the_unconscious_statistician |
| `Tail.lean` | 尾部事件 / 尾部概率 | https://en.wikipedia.org/wiki/Fat-tailed_distribution (尾部概念) |
| `Moment.lean` | 矩 | https://en.wikipedia.org/wiki/Moment_(mathematics) |
| `Variance.lean` → `Scalar/Variance.lean` | 方差 / 协方差 | https://en.wikipedia.org/wiki/Variance / https://en.wikipedia.org/wiki/Covariance |
| `Covariance.lean` | 协方差 | https://en.wikipedia.org/wiki/Covariance |
| `Orlicz.lean` | Orlicz 函数 ψ₁, ψ₂ | https://en.wikipedia.org/wiki/Orlicz_space |
| `SubGaussian.lean` | 次高斯分布 | https://en.wikipedia.org/wiki/Sub-Gaussian_distribution |
| `SubExponential.lean` | 次指数分布 | https://en.wikipedia.org/wiki/Heavy-tailed_distribution |
| `Lp.lean` | Lᵖ 空间 | https://en.wikipedia.org/wiki/Lp_space |
| `Nets.lean` | ε-网 / 覆盖数 | https://en.wikipedia.org/wiki/Covering_number |
| `MetricEntropy.lean` | 度量熵 / 覆盖数 / 填装数 | https://en.wikipedia.org/wiki/Metric_entropy |
| `Isotropic.lean` | 各向同性随机向量 | https://en.wikipedia.org/wiki/Isotropic_vector |
| `GaussianWidth.lean` | 高斯宽度 | https://en.wikipedia.org/wiki/Gaussian_width (404 — 可能无独立页面) |
| `Geometry.lean` | 几何概念 | https://en.wikipedia.org/wiki/Convex_geometry |
| `EmpiricalProcess.lean` | 经验过程 | https://en.wikipedia.org/wiki/Empirical_process |
| `SignalRecovery.lean` | 信号恢复 | https://en.wikipedia.org/wiki/Signal_recovery |
| `RandomProcess.lean` | 随机过程 | https://en.wikipedia.org/wiki/Stochastic_process |
| `RandomVector.lean` | 随机向量 | https://en.wikipedia.org/wiki/Multivariate_random_variable |
| `SubGaussianVector.lean` | 次高斯随机向量 | https://en.wikipedia.org/wiki/Sub-Gaussian_distribution |
| `RandomMatrix.lean` | 随机矩阵 | https://en.wikipedia.org/wiki/Random_matrix |
| `Vector.lean` | 随机向量汇总 | https://en.wikipedia.org/wiki/Multivariate_random_variable |
| `Scalar.lean` | 标量概率汇总 | — (汇总页, 无独立概念) |
| `Process.lean` | 随机过程汇总 | — (汇总页) |
| `Statements.lean` | 定理陈述汇总 | — (汇总页) |
| `BookStatements.lean` | 书籍定理规格 | — (规格文件, 无独立概念) |
| `Experimental.lean` | 实验模块 | — |
| `Tactic.lean` | 策略命名空间 | — |
| `Analysis.lean` | 数学分析辅助 | https://en.wikipedia.org/wiki/Real_analysis |

## Concentration/ 目录

| Lean 文件 | 核心概念/定理 | Wikipedia 页面 |
|-----------|-------------|----------------|
| `Concentration/Basic.lean` | 尾部事件基本引理 | — (基础引理) |
| `Concentration/Markov.lean` | **Markov 不等式** | https://en.wikipedia.org/wiki/Markov_inequality |
| `Concentration/Chebyshev.lean` | **Chebyshev 不等式** | https://en.wikipedia.org/wiki/Chebyshev%27s_inequality |
| `Concentration/Hoeffding.lean` | **Hoeffding 不等式** (含 Chernoff 方法) | https://en.wikipedia.org/wiki/Hoeffding_inequality + https://en.wikipedia.org/wiki/Chernoff_bound |
| `Concentration/Bernstein.lean` | **Bernstein 不等式** (次指数集中) | https://en.wikipedia.org/wiki/Bernstein_inequalities_(probability_theory) |
| `Concentration/MGF.lean` | 矩母函数 → 尾部 (CenteredSubGaussianMGF) | https://en.wikipedia.org/wiki/Moment-generating_function |
| `Concentration/OrliczToTail.lean` | Orlicz → 尾部不等式 | https://en.wikipedia.org/wiki/Orlicz_space |
| `Concentration/TailToOrlicz.lean` | 尾部 → Orlicz | — (证明边界) |
| `Concentration/Implications.lean` | 标量蕴含图 | — |
| `Concentration/MomentImplications.lean` | 矩蕴含关系 | — |
| `Concentration/LayerCake.lean` | 千层饼表示法 | https://en.wikipedia.org/wiki/Layer_cake_representation (或 "Layer_cake_(mathematics)" 无独立页面) |
| `Concentration/SubGaussianSums.lean` | 次高斯变量和 | https://en.wikipedia.org/wiki/Sub-Gaussian_distribution |
| `Concentration/SubExponentialSums.lean` | 次指数变量和 | https://en.wikipedia.org/wiki/Heavy-tailed_distribution |
| `Concentration/RademacherSums.lean` | Rademacher 变量加权和 | https://en.wikipedia.org/wiki/Rademacher_distribution |
| `Concentration/MaxScale.lean` | 最大尺度/方差代理 | — (辅助定义) |

## Distributions/ 目录

| Lean 文件 | 核心概念/定理 | Wikipedia 页面 |
|-----------|-------------|----------------|
| `Distributions/Rademacher.lean` | Rademacher 变量 | https://en.wikipedia.org/wiki/Rademacher_distribution |
| `Distributions/RademacherFamily.lean` | 有限 Rademacher 族 | https://en.wikipedia.org/wiki/Rademacher_distribution |

## LimitTheorems/ 目录

| Lean 文件 | 核心概念/定理 | Wikipedia 页面 |
|-----------|-------------|----------------|
| `LimitTheorems/Basic.lean` | 样本均值/样本和 | https://en.wikipedia.org/wiki/Sample_mean_and_covariance |
| `LimitTheorems/WeakLaw.lean` | **弱大数定律** | https://en.wikipedia.org/wiki/Law_of_large_numbers |
| `LimitTheorems/Assumptions.lean` | 极限定理假设 | — (假设词汇) |

## RandomMatrix/ 目录

| Lean 文件 | 核心概念/定理 | Wikipedia 页面 |
|-----------|-------------|----------------|
| `RandomMatrix/Basic.lean` | 随机矩阵基元 | https://en.wikipedia.org/wiki/Random_matrix |
| `RandomMatrix/RowsCols.lean` | 矩阵行与列 | — |
| `RandomMatrix/Action.lean` | 矩阵-向量作用 | — |
| `RandomMatrix/Norms.lean` | 矩阵范数 | https://en.wikipedia.org/wiki/Matrix_norm |
| `RandomMatrix/Assumptions.lean` | 随机矩阵假设 | — |
| `RandomMatrix/SampleCovariance.lean` | 样本协方差矩阵 | https://en.wikipedia.org/wiki/Sample_covariance_matrix |
| `RandomMatrix/QuadraticForm.lean` | 二次型 | https://en.wikipedia.org/wiki/Quadratic_form |
| `RandomMatrix/Algebra.lean` | 矩阵代数桥 | — |
| `RandomMatrix/UnitSphere.lean` | 单位球面 | https://en.wikipedia.org/wiki/Unit_sphere |
| `RandomMatrix/OperatorNorm.lean` | 算子范数 | https://en.wikipedia.org/wiki/Operator_norm |
| `RandomMatrix/SelfAdjoint.lean` | 自伴矩阵 | https://en.wikipedia.org/wiki/Self-adjoint_operator |
| `RandomMatrix/MatrixOrder.lean` | PSD / Loewner 序 | — |
| `RandomMatrix/Expectation.lean` | 矩阵逐元素期望 | — |
| `RandomMatrix/Sums.lean` | 随机矩阵有限和 | — |
| `RandomMatrix/VarianceProxy.lean` | 矩阵方差代理 | — |
| `RandomMatrix/Statements.lean` | 定理陈述层 | — |
| `RandomMatrix/ConcentrationStatements.lean` | 矩阵集中假设 | — |

## Scalar/ 目录

| Lean 文件 | 核心概念/定理 | Wikipedia 页面 |
|-----------|-------------|----------------|
| `Scalar/Centering.lean` | 标量中心化 | — (中心化概念) |
| `Scalar/Variance.lean` | 标量方差 | https://en.wikipedia.org/wiki/Variance |

## Examples/ 目录

| Lean 文件 | 核心概念 | Wikipedia 页面 |
|-----------|---------|----------------|
| `Examples/BasicUsage.lean` | 基本使用示例 | — |
| `Examples/NetsUsage.lean` | 网/覆盖数示例 | — |
| `Examples/OrliczUsage.lean` | Orlicz 示例 | — |
| `Examples/RandomMatrixUsage.lean` | 随机矩阵示例 | — |
| `Examples/RandomVariableUsage.lean` | 随机变量示例 | — |
| `Examples/RandomVectorUsage.lean` | 随机向量示例 | — |
| `Examples/TailUsage.lean` | 尾部不等式示例 | — |

---

## 核心定理的 Wikipedia 页面总结

| # | 经典定理 | Lean 文件 | Wikipedia URL |
|---|---------|-----------|-------------|
| 1 | Markov 不等式 | `Concentration/Markov.lean` | https://en.wikipedia.org/wiki/Markov_inequality |
| 2 | Chebyshev 不等式 | `Concentration/Chebyshev.lean` | https://en.wikipedia.org/wiki/Chebyshev%27s_inequality |
| 3 | Hoeffding 不等式 | `Concentration/Hoeffding.lean` | https://en.wikipedia.org/wiki/Hoeffding_inequality |
| 4 | Bernstein 不等式 | `Concentration/Bernstein.lean` | https://en.wikipedia.org/wiki/Bernstein_inequalities_(probability_theory) |
| 5 | Chernoff 界 | `Concentration/Bernstein.lean` + `Concentration/Hoeffding.lean` | https://en.wikipedia.org/wiki/Chernoff_bound |
| 6 | 弱大数定律 | `LimitTheorems/WeakLaw.lean` | https://en.wikipedia.org/wiki/Law_of_large_numbers |
| 7 | 次高斯分布 | `SubGaussian.lean`, `Concentration/SubGaussianSums.lean` | https://en.wikipedia.org/wiki/Sub-Gaussian_distribution |
| 8 | 次指数分布 | `SubExponential.lean`, `Concentration/SubExponentialSums.lean` | https://en.wikipedia.org/wiki/Heavy-tailed_distribution |
| 9 | Orlicz 空间 | `Orlicz.lean`, `Concentration/OrliczToTail.lean` | https://en.wikipedia.org/wiki/Orlicz_space |
| 10 | 矩母函数 | `Concentration/MGF.lean` | https://en.wikipedia.org/wiki/Moment-generating_function |
| 11 | Rademacher 分布 | `Distributions/Rademacher.lean` | https://en.wikipedia.org/wiki/Rademacher_distribution |
| 12 | 覆盖数 / 度量熵 | `Nets.lean`, `MetricEntropy.lean` | https://en.wikipedia.org/wiki/Covering_number / https://en.wikipedia.org/wiki/Metric_entropy |
| 13 | 集中不等式 (综述) | (全局) | https://en.wikipedia.org/wiki/Concentration_inequality |
| 14 | 随机矩阵 (综述) | `RandomMatrix/` 目录 | https://en.wikipedia.org/wiki/Random_matrix |
| 15 | 算子范数 | `RandomMatrix/OperatorNorm.lean` | https://en.wikipedia.org/wiki/Operator_norm |
| 16 | 矩阵范数 | `RandomMatrix/Norms.lean` | https://en.wikipedia.org/wiki/Matrix_norm |
| 17 | 样本协方差矩阵 | `RandomMatrix/SampleCovariance.lean` | https://en.wikipedia.org/wiki/Sample_covariance_matrix |
| 18 | 自伴算子 | `RandomMatrix/SelfAdjoint.lean` | https://en.wikipedia.org/wiki/Self-adjoint_operator |
