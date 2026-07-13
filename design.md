# design.md - High-Dimensional Probability in Lean 4 论文设计

状态：v5（2026-07-10）。

当前写作基线：

- HighDimProb：`7ba52a77e2abb5a9db7c221cd19b0a177fcc000b`。
- 对照论文：AI4SLT（ICML 2026）。必须区分其论文核心与后续扩展仓库。

本版不再把论文定位为工程工具或仓库比较。文章的主体是：

> **HighDimProb provides a reusable Lean 4 foundation for high-dimensional probability, connecting scalar concentration, finite-dimensional geometry, random vectors and processes, noncommutative matrix analysis, matrix concentration, and modern covariance/Gram-matrix applications within one formal theory.**

Lieb concavity 和 Matrix Bernstein 是最深的技术主线，但不是整篇文章的全部贡献。

---

# 0. 核心判断

## 0.1 这篇文章应该是什么

这应当是一篇与 AI4SLT 同类型的**数学形式化论文**：

- 先说明一个重要数学领域为什么需要统一的形式基础；
- 再给出整库覆盖的理论层次；
- 每层挑选代表性主定理；
- 解释这些层如何组合成最终应用；
- 最后讨论 Lean 形式化暴露出的隐含假设、Mathlib 缺口和可复用抽象。

文章不需要证明 HighDimProb 在所有维度上“优于”SLT。需要证明的是：

> HighDimProb formalizes a different and broader mathematical foundation: not a single statistical-learning pipeline, but a reusable high-dimensional probability library whose scalar, geometric, probabilistic, and noncommutative layers can be recombined across applications.

## 0.2 一句话贡献

> **We develop a machine-checked and reusable Lean 4 foundation for high-dimensional probability, from scalar concentration and geometric reductions to a complete matrix-concentration pipeline culminating in Lieb concavity and Matrix Bernstein, together with applications to covariance and Gram-type random matrices.**

## 0.3 技术中心

论文的技术中心不是单独的 Lieb 定理，而是下面这条完整链：

\[
\text{relative entropy and matrix convexity}
\Longrightarrow
\text{Lieb concavity}
\Longrightarrow
\text{one-step trace-MGF bound}
\Longrightarrow
\text{finite-family conditional iteration}
\Longrightarrow
\text{Matrix Bernstein}
\Longrightarrow
\text{covariance/Gram applications}.
\]

这条链嵌在更大的 HighDimProb 基础中：scalar concentration 提供尾界、矩、Orlicz 和 MGF 语言；geometry/vector/process 层提供把高维对象降到有限标量事件的工具；random-matrix 层完成非交换提升。

---

# 1. 相对 baseline 应该怎样 claim

## 1.1 AI4SLT 的写法

AI4SLT 的核心叙事是：

1. 统计学习理论依赖 empirical process theory；
2. Lean/Mathlib 缺少完整基础；
3. 作者从 Gaussian concentration、Dudley 一直形式化到 least-squares rate；
4. 因而得到一个可复用的 formal SLT foundation；
5. human 负责数学分解，AI 执行证明。

它的说服力来自**完整理论链 + 一个最终统计学习应用**，而不是定理数量或工程指标。

## 1.2 HighDimProb 应采用的对应结构

HighDimProb 的对应叙事应是：

1. 高维概率是现代统计与学习理论的共同底层语言；
2. 其形式化不能停留在孤立尾界，因为实际证明需要在 tail、moment、Orlicz、MGF、net、operator norm 和 matrix trace 之间反复切换；
3. 我们建立一个分层 Lean 4 基础，把这些证明模式放进同一数学体系；
4. 最深的非交换路线从 full Lieb concavity 推到 arbitrary finite-family Matrix Bernstein；
5. 同一基础进一步实例化到 sample covariance、random features、NTK、attention feature Gram、empirical Fisher、gradient covariance 和 LoRA subspace covariance。

对应关系是：

| AI4SLT paper | HighDimProb paper |
| --- | --- |
| empirical-process foundation | high-dimensional probability foundation |
| Gaussian concentration | scalar concentration calculus |
| Dudley/chaining | geometry, nets, entropy and process interfaces |
| least-squares application | covariance and Gram-matrix applications |
| one end-to-end SLT chain | scalar-to-geometric-to-matrix concentration hierarchy |

## 1.3 不能使用的对比

- 不能说 SLT 的公开 Bernstein endpoint 被锁在 product space。
- 不能说 SLT 没有数学分解或 reusable lemmas。
- 不能以 LOC、lemma 数或文件数证明数学质量。
- 不能把后续 SLT 仓库加入的 Lieb/Matrix Bernstein 倒写成其 ICML 论文核心。
- 不能声称“first formalization”而不做跨 prover 的完整检索。

## 1.4 可以使用的差异

- **Scope**：HighDimProb 的论文对象是整个 HDP 基础，而 AI4SLT 论文对象是 empirical-process-based SLT。
- **Theory organization**：HighDimProb 把 scalar、geometry、process、vector 和 random-matrix concentration 作为可组合层。
- **Conditional formulation**：matrix trace-MGF iteration 可以在原概率空间上通过显式 history 条件来表述；标准 independent family 是生成自然历史后的 corollary。
- **Application breadth**：同一个 random-matrix theorem surface 服务多种 covariance/Gram constructions。
- **Public theorem form**：Matrix Bernstein 最终以 arbitrary finite index family 和 high-probability threshold 形式给出。

这些是数学陈述和理论组织上的差异，不需要包装成工程贡献。

---

# 2. 抽象、覆盖与整库理论层次

HighDimProb 的核心贡献不能只写成“定理很多”或“接口可复用”。需要把抽象的作用表述成一个可以检验的数学命题：**哪些应用经过何种保持语义的构造，可以进入同一个高维概率定理界面？**

## 2.1 覆盖不是一个从应用到接口的普通满射

固定一个应用类 \(\mathsf{App}\)。一个元素 \(A : \mathsf{App}\) 不只是应用名称，而应包含该应用的数学数据、目标随机对象和希望证明的结论。再固定 HighDimProb 的一个公开理论界面 \(L\)，并定义

\[
\mathsf{Cert}_L(A)
:=
\sum_{H:\mathsf{HDPInterface}}
\bigl(\mathsf{Sem}(H)\simeq \mathsf{Target}(A)\bigr)
\times
\mathsf{Hyp}_L(H).
\]

这里：

- \(H\) 是进入通用定理所需的抽象高维概率对象；
- \(\mathsf{Sem}(H)\simeq \mathsf{Target}(A)\) 是语义保持证明，可以是等式、同构或事件之间足够强的双向搬运；
- \(\mathsf{Hyp}_L(H)\) 是通用定理需要的 measurability、integrability、centering、independence、radius 和 variance certificates。

定义带证书的应用类型

\[
\mathsf{CertifiedApp}_L
:=
\sum_{A:\mathsf{App}} \mathsf{Cert}_L(A),
\]

以及遗忘证书的投影

\[
\pi_L : \mathsf{CertifiedApp}_L \to \mathsf{App},
\qquad
\pi_L(A,c)=A.
\]

于是可以给出精确定义：

> **Direct coverage.** 库 \(L\) 直接覆盖应用类 \(\mathsf{App}\)，当且仅当 \(\pi_L\) 是满射，即
> \[
> \forall A:\mathsf{App},\quad \mathsf{Cert}_L(A)\neq\varnothing.
> \]

在 Lean 的构造性语境中，更自然也更强的对象不是裸满射证明，而是一个截面

\[
s_L : \prod_{A:\mathsf{App}} \mathsf{Cert}_L(A),
\qquad
\sigma_L(A):=(A,s_L(A)),
\]

满足

\[
\pi_L\circ\sigma_L=\mathrm{id}_{\mathsf{App}}.
\]

因此 \(\pi_L\) 是一个 **split surjection**。截面 \(s_L\) 不只断言证书存在，还给出如何从任意 admissible application 构造证书的统一方法。这才对应“我们提供数学工具，而 LoRA、NTK 等由这些工具构造出来”的严格版本。

对应的 Lean 骨架已经可以直接成立：

```lean
variable (App : Type u) (Cert : App -> Type v)

abbrev CertifiedApp := Sigma Cert

def forget : CertifiedApp App Cert -> App := Sigma.fst

def chooseCert (build : (A : App) -> Cert A) :
    App -> CertifiedApp App Cert :=
  fun A => Sigma.mk A (build A)

theorem chooseCert_rightInverse (build : (A : App) -> Cert A) :
    Function.RightInverse (chooseCert App Cert build) (forget App Cert) := by
  intro A
  rfl

theorem forget_surjective (build : (A : App) -> Cert A) :
    Function.Surjective (forget App Cert) :=
  (chooseCert_rightInverse App Cert build).surjective
```

这里 `forget_surjective` 本身几乎是形式逻辑；真正有数学内容的 theorem 是 `build : (A : App) -> Cert A`。因此论文不应把“证明满射”包装成困难结果，而应展示对哪个非平凡 admissible class 构造了统一 certificate builder，以及 builder 复用了哪些 HighDimProb theorem。

不能把 \(\mathsf{App}\) 定义成“所有 ML 模型”。任何 concentration theorem 都需要假设。正确的定义域应是带有最小数学前提的 admissible class，例如 bounded independent rank-one feature models。文章的强度来自这个类足够一般，而不是删除必要假设。

## 2.2 复用和覆盖是两个不同性质

“多个应用共用一个抽象”与“抽象覆盖所有目标应用”不能混写：

1. **Abstraction/compression**：LoRA、NTK、random features、gradient covariance、attention Gram 和 empirical Fisher 经过各自的语义适配后，都因子化到同一个 centered rank-one covariance schema。这说明分类映射是多对一的，或者至少多个语义不同的对象落入同一结构类；它表达的是复用，而不是满射。
2. **Coverage/expressivity**：对预先固定的应用类，每个对象都能构造出一个接口证书。这由 \(\pi_L\) 的满射性或截面表达。

论文应同时证明二者：前者说明抽象真正压缩了重复数学，后者说明这种压缩没有把目标应用排除在外。

## 2.3 Rank-one 应用族上的截面

定义一个抽象 rank-one feature model

\[
M=(\Omega,\mathcal F,P,I,V,X),
\qquad
X_i:\Omega\to V,
\]

其中 \(I\) 有限，\(V\) 是有限维实或复内积空间。对应的 centered summands 为

\[
Z_i
=
X_iX_i^* - \mathbb E[X_iX_i^*].
\]

将 integrability、independence、pointwise radius bound 和 variance-proxy bound 放入 \(\mathsf{AdmissibleRankOne}\) 的数据中。HighDimProb 应展示如下统一构造：

\[
\begin{aligned}
\mathsf{rankOneLift}:
\mathsf{AdmissibleRankOne}
&\longrightarrow
\mathsf{CertifiedSelfAdjointFamily},\\
M
&\longmapsto
\bigl((Z_i)_{i\in I},\text{centering/self-adjoint certificates}\bigr),
\end{aligned}
\]

并继续组合为

\[
\mathsf{AdmissibleRankOne}
\xrightarrow{\mathsf{rankOneLift}}
\mathsf{BernsteinInput}
\xrightarrow{\mathsf{MatrixBernstein}}
\mathsf{TailBound}.
\]

LoRA、NTK 等应用分别只需构造第一段模型特有的箭头：

\[
\begin{array}{ccc}
\mathsf{LoRA} & \xrightarrow{\rho_{\mathrm{LoRA}}} & \mathsf{AdmissibleRankOne}\\
\mathsf{NTK} & \xrightarrow{\rho_{\mathrm{NTK}}} & \mathsf{AdmissibleRankOne}\\
\mathsf{RandomFeature} & \xrightarrow{\rho_{\mathrm{RF}}} & \mathsf{AdmissibleRankOne}\\
\mathsf{Gradient/Fisher/Attention} & \xrightarrow{\rho} & \mathsf{AdmissibleRankOne}.
\end{array}
\]

仓库中 `ntkGramOuter_eq_rankOneOuter`、`featureKernelOuter_eq_rankOneOuter` 和 `gradientOuter_eq_rankOneOuter` 给出共同表示的直接证据。重写后的 LoRA application 更进一步：它已经从模型层输入自动构造 Bernstein primitives 并闭合最终 operator-norm tail，因此不再只是 structural instantiation。

### 2.3.1 LoRA 已闭合一个 tail-level application constructor

令 \(m=\texttt{batch}\)、\(p=r+1\)，\(Q\in\mathbb R^{p\times(d+1)}\) 为 adapter compression，\(g_b\) 为 full-gradient sample，并定义

\[
x_b=Qg_b,
\qquad
Z_b=x_bx_b^\top-\mathbb E[x_bx_b^\top].
\]

`LoRACovarianceInputs` 只要求 concrete adapter-gradient family 的 random-vector 条件、coordinate-\(L^2\) 条件、统一平方范数界

\[
\|x_b(\omega)\|_2^2\le R,
\]

以及 centered summands 的 independence。定理 `loraCovariance_operatorNormTail` 随后自动构造：

- centered rank-one 表示；
- summand 与 square integrability；
- centered/self-adjoint certificate；
- pointwise radius \(2R\)；
- variance-proxy norm bound；
- generated-history Matrix Bernstein endpoint。

因此当前 LoRA 路线已经实现

\[
\mathsf{LoRAInput}
\longrightarrow
\mathsf{CenteredRankOneFamily}
\longrightarrow
\mathsf{BernsteinPrimitives}
\longrightarrow
\mathsf{OperatorNormTail}.
\]

这正是论文应展示的 abstraction-to-application 路径。它不是在 application theorem 中重新证明 Lieb 或 Tropp，而是把具体梯度模型因子化到通用 rank-one 和 Matrix Bernstein 层。

### 2.3.2 展开后的精确概率界

当前 `centeredRankOneVarianceProxyNormRHS` 展开为

\[
m(2R)^2=4mR^2.
\]

因此 `loraCovariance_operatorNormTail` 的数学形式是

\[
\mathbb P\!\left(
\left\|\sum_{b=1}^m Z_b\right\|_{\mathrm{op}}\ge t
\right)
\le
2p\exp\!\left(
-\frac{t^2}{8mR^2+\frac43Rt}
\right).
\]

令

\[
\widehat\Sigma_Q
=\frac1m\sum_{b=1}^m x_bx_b^\top,
\qquad
\overline\Sigma_Q
=\frac1m\sum_{b=1}^m\mathbb E[x_bx_b^\top].
\]

则归一化后

\[
\mathbb P\!\left(
\|\widehat\Sigma_Q-\overline\Sigma_Q\|_{\mathrm{op}}\ge\varepsilon
\right)
\le
2p\exp\!\left(
-\frac{m\varepsilon^2}{8R^2+\frac43R\varepsilon}
\right).
\]

设 \(L=\log(2p/\delta)\)。对应的 exact high-probability threshold 为

\[
\varepsilon_{\mathrm{HDP}}
=
\frac{2RL}{3m}
+R\sqrt{\frac{8L}{m}+\frac{4L^2}{9m^2}},
\]

并可简化为

\[
\varepsilon_{\mathrm{HDP}}
\le
2\sqrt2R\sqrt{\frac Lm}
+\frac{4RL}{3m}.
\]

### 2.3.3 与论文中 bounded covariance 界的关系

这与使用 Matrix Bernstein 推出的 bounded empirical covariance 界具有相同的样本量、维度和失败概率阶：

\[
R\left(
\sqrt{\frac{\log(p/\delta)}m}
+\frac{\log(p/\delta)}m
\right).
\]

例如，*Representation-Guided Parameter-Efficient LLM Unlearning* 的 covariance theorem 在 \(\|h\|_2\le M\) 下给出

\[
\|\widehat\Sigma-\Sigma\|_{\mathrm{op}}
\le
M^2\sqrt{\frac{2L}{m}}
+\frac{4M^2L}{3m}.
\]

取 \(R=M^2\)、\(p=r+1\) 后，两者同阶，但当前 HighDimProb 的平方根项常数大两倍。原因不是 Matrix Bernstein endpoint，而是当前 LoRA proof 使用通用 bound

\[
\left\|\sum_b\mathbb E Z_b^2\right\|
\le 4mR^2,
\]

而论文利用 rank-one identity 得到更尖锐的

\[
\mathbb E[(xx^\top-\Sigma)^2]
=
\mathbb E[\|x\|_2^2xx^\top]-\Sigma^2
\preceq R\Sigma,
\]

从而在 \(\|\Sigma\|\le R\) 时使用 \(mR^2\)。所以当前结论与文献在 rate 上一致，在 sharp constant 上尚未完全一致。

### 2.3.4 论文真正需要的上下谱界

operator-norm concentration 立即蕴含 Loewner sandwich

\[
\overline\Sigma_Q-\varepsilon I
\preceq
\widehat\Sigma_Q
\preceq
\overline\Sigma_Q+\varepsilon I,
\]

以及

\[
\lambda_{\min}(\widehat\Sigma_Q)
\ge
\lambda_{\min}(\overline\Sigma_Q)-\varepsilon,
\qquad
\lambda_{\max}(\widehat\Sigma_Q)
\le
\lambda_{\max}(\overline\Sigma_Q)+\varepsilon.
\]

文件中的 `rankOneMatrix_adapterFeature` 已证明

\[
(Qg)(Qg)^\top=Q(gg^\top)Q^\top,
\]

而 `adapterCompression_matrixLE` 已证明 Loewner order 在 \(A\mapsto QAQ^\top\) 下保持。这使得 full-gradient covariance 的 population bounds 可以进一步压缩到 adapter subspace。若 \(QQ^\top=I_p\) 且

\[
\mu I\preceq\Sigma_g\preceq LI,
\]

则得到最清楚的 application conclusion：

\[
(\mu-\varepsilon)I_p
\preceq
\widehat\Sigma_Q
\preceq
(L+\varepsilon)I_p.
\]

当前 Lean 文件尚未把 normalized covariance、high-probability threshold 和这个 Loewner/eigenvalue sandwich 包装成最终 corollary。它们是 presentation-level closure；若还要与 bounded-covariance 文献的常数完全对齐，则需再闭合 sharp centered rank-one variance bridge。

这个 LoRA theorem 已足以作为“一个模型的深度 consumer”。若再把 NTK 或 random-feature application 改写成同样的 natural-input constructor，就能用至少两个语义不同的 adapters 支撑 rank-one application class 上的 coverage claim。

### 2.3.5 与现有 LoRA 理论的对象边界

不能把当前结果直接写成已有 LoRA--NTK theorem 的形式化。二者控制不同的随机性：

- Malladi et al. 的 LoRA kernel result 令 LoRA projection 随机，控制固定数据集上 full NTK 与 LoRA NTK 的 pairwise Gram entries；概率来自随机初始化的 projection；
- 当前 `loraCovariance_operatorNormTail` 固定 \(Q\)，控制随机 mini-batch 产生的 adapter-gradient empirical covariance；概率来自数据或梯度抽样。

因此当前 theorem 是 LoRA 理论的互补 concentration statement，而不是对 JL-based kernel-preservation theorem 的重述。论文中最准确的名称是：

> **Concentration of empirical gradient covariance in a fixed adapter subspace.**

当前 `AdapterCompression` 也是一般线性 compression，并没有在类型中编码标准 LoRA 的双线性参数化 \(\Delta W=BA\)。若希望把语义进一步收紧到标准 LoRA，需要从 LoRA Jacobian 构造相应 \(Q\)，再证明其 gradient transformation 等于 `adapterFeature`。

这也给 history abstraction 一个自然的深层应用：训练时 \(Q_t\) 随历史更新，可以把 \(Q_t\) 视为 history-measurable state，并要求 fresh mini-batch 与历史独立。这样 conditional trace-MGF interface 有望给出逐步的 adapter-gradient covariance concentration；当前文件则是固定 \(Q\) 的单步版本。

## 2.4 PrecisionDA 提供深度而不是另一个名称

PrecisionDA 不应塞进同一个 rank-one 表格后只算作“第八个例子”。它展示的是一条更深的应用构造：

\[
\mathsf{DataMatrix}
\to
\mathsf{SampleCovariance}
\to
\mathsf{ShiftedCovariance}
\to
\mathsf{PrecisionResolvent}
\to
\mathsf{LeaveOneOutDecomposition}
\to
\mathsf{TailStatement}.
\]

这条路径使用 sample covariance、rank-one update、resolvent difference、Sherman--Morrison/Woodbury、trace/Frobenius errors 和 leave-one-out measurability。它证明 HighDimProb 不仅能给现代 ML 对象换一个名字后调用 Bernstein，还能用库中的数学层深入重建一篇统计论文的模型和证明分解。

这里必须区分两种闭合度：

- deterministic modeling closed：对象、恒等式和 leave-one-out/resolvent 分解已经由库定理推出；
- probabilistic endpoint closed：provider-shaped tail hypotheses 已由上游 concentration theory 实际 discharge。

只有第二项完成时，才能把 PrecisionDA 写成 end-to-end concentration application；否则它仍然是很强的 deep modeling case study，但不能把 assumed provider 写成已证明结论。

## 2.5 范畴论解释：目前应称“categorically structured”，而不是范畴论结果

上面的结构确实具有范畴论味道：应用和抽象接口可视为对象，保持语义的 adapter 可视为态射，应用证明由态射复合得到；遗忘映射对应从带证书对象到裸模型的 functor。

但在没有明确定义 morphisms、identity、composition、isomorphism 和 functor laws 之前，论文不能声称建立了一个 category-theoretic formalization。当前最准确的说法是：

> HighDimProb exposes a dependent, compositional abstraction in which model-specific constructions factor through certified high-dimensional-probability interfaces.

如果后续定义范畴 \(\mathbf{Cert}_L\) 与 \(\mathbf{App}\)，则正确目标是证明遗忘函子

\[
U:\mathbf{Cert}_L\to\mathbf{App}
\]

在选定应用子范畴上 essentially surjective；若还能构造 functorial section \(S\) 使 \(U\circ S\cong\mathrm{Id}\)，则得到比对象级满射更强的自然、统一构造。`full` 和 `faithful` 是关于态射的另外两个性质，不能与“覆盖应用”混为一谈。

## 2.6 与 SLT baseline 的可证比较

“SLT 无法覆盖”不能解释为数学上永远无法扩展。可检验的定义应是：在固定 commit 和固定 public theorem surface 下，不增加新的核心概率定理，某个应用是否已有 direct instantiation path。

对任意库 \(L\) 和固定目标集 \(\mathcal A\)，定义

\[
\mathsf{Cov}(L;\mathcal A)
=
\{A\in\mathcal A\mid \mathsf{Cert}_L(A)\text{ inhabited}\}.
\]

若要严格声称 HighDimProb 的覆盖更强，应展示

\[
\mathsf{Cov}(\mathsf{SLT};\mathcal A)
\subsetneq
\mathsf{Cov}(\mathsf{HighDimProb};\mathcal A),
\]

对 AI4SLT **论文范围**，重写后的 LoRA application 已经给出一个明确 witness。令

\[
A_{\mathrm{LoRA}}
=
\text{bounded empirical gradient covariance in a fixed adapter subspace}.
\]

HighDimProb 已通过 `loraCovariance_operatorNormTail` 构造

\[
\mathsf{Cert}_{\mathsf{HighDimProb}}(A_{\mathrm{LoRA}}).
\]

AI4SLT 论文公开的 theorem stack 是 Gaussian Lipschitz concentration、covering/entropy、Dudley、localized empirical processes 和 least-squares rate。其论文范围不包含 random-matrix expectation、self-adjoint/PSD/Loewner calculus、matrix Laplace transform、Lieb concavity、Matrix Bernstein 或 centered rank-one covariance adapter。因此，在不增加新的核心概率与矩阵理论时，没有

\[
\mathsf{Cert}_{\mathsf{AI4SLT\ paper}}(A_{\mathrm{LoRA}})
\]

的 direct instantiation path。

AI4SLT 的 net 与 scalar concentration 思路原则上可以重新开发另一条证明：把 operator norm 写成 sphere 上 quadratic forms 的 supremum，再做 finite-net reduction。但 bounded quadratic-form Bernstein、随机协方差的 measurability 和整个 uniform reduction 仍需新增；直接 union bound 通常还会引入 covering-number 规模，而不是当前 Matrix Bernstein 的 dimension prefactor。因此这不是复用其现有 endpoint 得到同一个结论。

对 AI4SLT **后续扩展仓库**必须另做 pinned-commit audit。即使后续仓库加入 Matrix Bernstein，它仍需新增 LoRA gradient model、rank-one centering、integrability、radius/variance 和 compression adapters 才能得到与当前文件相同的 natural-input theorem。文章不能把“论文范围没有直接路径”扩大成“对方仓库永远无法扩展”。

第二类更深 witness 仍可选择 PrecisionDA：它需要 covariance--resolvent--leave-one-out 组合，而 baseline 论文没有相应数学对象与 bridge。

这项差异首先是 pinned artifact 上的接口覆盖事实，不是“对方数学上不可能证明”的元定理。论文最稳健的写法是：

> Under the pinned public interfaces, HighDimProb provides a direct certified instantiation path for the witness, whereas the baseline artifact provides no analogous path without extending its formal theory.

LoRA 可以作为 paper-scope witness 写入正文；若比较当前仓库，则仍须完成逐 theorem 的 baseline audit。

建议把整库压成五个数学层，而不是按源码目录介绍。

## Layer I：Scalar concentration calculus

**数学问题**：如何在尾概率、矩增长、Orlicz norm、MGF 控制和独立和之间转换？

**核心内容**：

- Markov、Chebyshev、layer-cake；
- tail-to-moment 与 moment-to-tail；
- Orlicz-to-tail 与 tail-to-Orlicz；
- fixed-scale sub-Gaussian/sub-exponential implication chains；
- MGF 控制与 Chernoff 方法；
- independent sub-Gaussian sums、Rademacher sums、Hoeffding；
- maxima 与 scale aggregation；
- scalar Bernstein。

**这一层的论文作用**：提供全库统一的 concentration language。不能把它写成“基础工具列表”，应写成一个 conversion calculus：不同应用给出的输入不同，但最终都可以转换到 tail bound。

## Layer II：Finite-dimensional geometry, vectors, and processes

**数学问题**：如何把高维随机对象的 uniform control 化为有限或标量控制？

**核心内容**：

- random vectors 与 coordinate/projection vocabulary；
- nets、covering/packing、metric entropy；
- Gaussian width 与 empirical-process vocabulary；
- 从 net 上控制到全空间控制的几何 reduction；
- 向量范数、二次型和 operator norm 事件的连接。

**这一层的论文作用**：解释“高维”从哪里出现。Scalar concentration 控制一个方向；geometry/process 层负责控制所有方向。

## Layer III：Deterministic noncommutative analysis

**数学问题**：标量 MGF 方法为何不能直接搬到矩阵，怎样处理非交换指数与对数？

**核心内容**：

- self-adjoint、PSD/Loewner order、operator norm 与 spectral events；
- matrix exponential/logarithm 和 trace；
- matrix expectation 与 Bochner integral bridges；
- Klein inequality 与 Gibbs variational principle；
- relative entropy joint convexity；
- left-right representation；
- full Lieb trace-exponential concavity；
- Golden-Thompson inequality；
- trace-exponential monotonicity和 spectral/Laplace reductions。

**这一层的论文作用**：这是从标量概率到随机矩阵的非交换分析核心。Full Lieb 是本层主定理，不是整篇文章的唯一主定理。

## Layer IV：Conditional matrix concentration

**数学问题**：如何把 one-step Lieb/Jensen inequality 迭代成 finite-family trace-MGF bound？

**核心内容**：

- one-step master trace-MGF inequality；
- 用户指定 history/state 的 conditional-step theorem；
- history measurability、step independence 和 conditional expectation decomposition；
- generated natural history for independent families；
- individual Bernstein matrix-MGF comparison；
- finite-family trace-MGF recursion；
- positive/negative tails、operator norm、zero-variance boundary；
- arbitrary finite index transport；
- canonical Matrix Bernstein 和 \(1-\delta\) high-probability form。

**这一层的论文作用**：它把 deterministic Lieb 与 probabilistic independence 接起来。论文中的真正结构性结果应写成：

> An abstract conditional trace-MGF theorem is proved first; the usual independent-family Matrix Bernstein inequality is then obtained by constructing the canonical history and discharging its conditions.

## Layer V：Statistical and ML-facing applications

**数学问题**：通用 concentration theorem 如何变成读者真正使用的 covariance/Gram bounds？

**代表对象**：

- sample covariance；
- centered rank-one covariance；
- random-feature kernel matrices；
- NTK Gram matrices；
- attention feature Gram matrices；
- empirical Fisher matrices；
- gradient covariance；
- LoRA adapter-subspace covariance；
- precision-domain covariance/trace expansions。

**这一层的论文作用**：证明前四层不是一条只服务单一 endpoint 的证明。应用不必全部给最强新界；它们的作用是展示同一抽象如何覆盖不同现代模型。

---

# 3. 论文的主定理栈

正文不应列几百个声明，而应选择七个 theorem groups。

| 编号 | 论文中的 theorem group | 连接的层 |
| --- | --- | --- |
| T1 | Tail, moment, Orlicz, and MGF implication principles | Scalar language |
| T2 | Concentration for independent scalar sums, including Hoeffding and Bernstein | Scalar concentration |
| T3 | Geometric/net reductions from directional control to norm or uniform control | Geometry and processes |
| T4 | Relative-entropy route to full Lieb concavity and Golden-Thompson | Deterministic matrix analysis |
| T5 | One-step and conditional finite-family trace-MGF master theorem | Conditional matrix concentration |
| T6 | Self-adjoint Matrix Bernstein for arbitrary finite families, including optimized and high-probability forms | Matrix concentration endpoint |
| T7 | Certified application factorization: rank-one breadth and PrecisionDA depth | Applications and abstraction |

写作时，T1-T3 说明整个库的广度，T4-T6 提供技术深度，T7 提供最终用途。这样文章不会退化成“Lieb formalization report”。

---

# 4. 核心贡献的最终写法

建议 Introduction 中给四项贡献，而不是工程术语：

1. **An application-independent and compositional foundation for high-dimensional probability.**  
   We develop a unified Lean 4 theory spanning scalar concentration, finite-dimensional geometry, random vectors and processes, and random-matrix concentration. Model-specific constructions factor through certified high-dimensional-probability interfaces rather than a fixed learning task.

2. **A complete noncommutative concentration pipeline.**  
   We formalize the deterministic analytic backbone from relative entropy and left-right representations to full Lieb concavity and Golden-Thompson, and connect it to the matrix Laplace-transform method.

3. **A conditional-to-independent Matrix Bernstein theory.**  
   We first prove a history-parameterized conditional trace-MGF principle on an arbitrary probability space, then derive the standard independent-family Matrix Bernstein inequality for arbitrary finite index types, including optimized tail and \(1-\delta\) forms.

4. **Expressivity demonstrated by breadth and depth.**  
   A shared centered rank-one construction covers covariance and Gram-type objects from random features, NTK, attention, empirical Fisher, gradients, and low-rank adaptation, while a PrecisionDA case study uses covariance, resolvent, rank-one-update, and leave-one-out abstractions to model a substantially deeper statistical argument.

可以把 formalization lessons 作为第五项次要贡献：

5. **Formalization lessons.**  
   The development identifies the measurability, integrability, positivity, zero-variance, and representation assumptions that are routinely implicit in textbook arguments.

第 5 项不能压过前四项。

---

# 5. Introduction 的逐段写作流程

Introduction 建议写七段，每段只完成一个逻辑动作。

## Paragraph 1：领域重要性

从高维概率在现代统计、学习理论、随机矩阵和数据科学中的基础作用开场。重点不是列应用名词，而是提出共同数学模式：

> Modern learning theory repeatedly asks how random high-dimensional objects concentrate around deterministic structure.

随后给出三个代表对象：随机向量范数、经验协方差、随机 Gram 矩阵。

## Paragraph 2：为什么需要“体系”而不是孤立定理

说明真实 HDP 证明会连续跨越多种表示：

\[
\text{moment/Orlicz assumptions}
\to
\text{MGF control}
\to
\text{directional tails}
\to
\text{net or spectral reduction}
\to
\text{uniform/operator-norm bound}.
\]

矩阵情形还需要 trace exponential、operator order 和 Lieb concavity。由此自然推出：形式化瓶颈不是某一个不等式，而是缺少一个可以组合的基础。

## Paragraph 3：现有工作与空缺

承认已有 Lean 形式化已经覆盖 Gaussian concentration、Dudley、statistical learning theory，以及近期的 Lieb/Matrix Bernstein endpoint。然后收紧空缺：

> What remains missing is a unified, application-facing formal foundation that connects the scalar, geometric, process, and noncommutative layers of high-dimensional probability.

这句话比“别人没证明某定理”更稳定，也能容纳 SLT 后续仓库扩展。

## Paragraph 4：我们的回答

一句话引入 HighDimProb，然后用五层结构概括整库：

> HighDimProb is organized as a mathematical hierarchy: scalar concentration, finite-dimensional geometry, random vectors and processes, noncommutative matrix analysis, and application-level covariance/Gram concentration.

不要在这里写文件数、tests、judges 或 provider。

## Paragraph 5：技术高潮

用一段讲清最难路线：

- relative entropy and left-right representation；
- full Lieb concavity；
- one-step trace-MGF inequality；
- conditional finite-family iteration；
- generated history for independent summands；
- optimized Matrix Bernstein and high-probability form。

这一段负责证明文章有技术深度。

## Paragraph 6：应用闭环

应用证据采用“广度 + 深度”两级，而不是随意选择三个名字：

1. **Breadth**：用一张交换图说明 sample covariance、random features、NTK、attention、Fisher、gradient 和 LoRA 如何经过各自 adapter 落入 centered rank-one/Bernstein schema；正文详细展开其中一个，其余进入统一表格。
2. **Depth**：用 PrecisionDA 展示 DataMatrix、sample covariance、shifted inverse、rank-one update、resolvent 和 leave-one-out decomposition 如何组合成论文级模型。

前者证明复用，后者证明抽象不会把应用压扁成只有一个 endpoint。若 PrecisionDA 的 probabilistic providers 尚未全部 discharge，正文必须把它标为 deep modeling case study，而不是 end-to-end tail theorem。

## Paragraph 7：贡献列表和边界

放 §4 的四项主要贡献。最后加一句边界：

> Our contribution is not a new proof of the underlying classical inequalities, but a machine-checked theory that exposes their common abstractions and makes the full chain reusable across high-dimensional models.

这既承认数学经典性，又保留形式化工作的学术价值。

---

# 6. 正文结构

## §2 Mathematical Overview

先给整库 dependency figure 和 notation：

- probability space \((\Omega,\mathcal{F},P)\)；
- scalar random variables、random vectors、random matrices；
- tail/MGF/Orlicz conventions；
- matrix operator norm、Loewner order、trace、matrix exponential；
- direct coverage、certificate projection 和 split-surjection 定义；
- 五层理论图。

本节只解释结构，不证明定理。

## §3 Scalar Concentration Calculus

组织方式不要按源码模块，而按输入输出：

### 3.1 From tails to moments and Orlicz control

讲 layer-cake 和 tail integration，以及 tail/moment/Orlicz 的转换方向。

### 3.2 From MGF control to concentration

讲 Chernoff method 和 centered MGF。

### 3.3 Sums and canonical inequalities

给 sub-Gaussian sums、Rademacher/Hoeffding、sub-exponential sums 和 scalar Bernstein。

本节结尾说明：后面每个高维应用最终都把问题归约到这里的 scalar control 或其 matrix analogue。

## §4 Geometry, Random Vectors, and Processes

### 4.1 Nets and covering arguments

解释一个方向上的 tail 如何通过 net 变成 uniform bound。

### 4.2 Random-vector and process interfaces

统一写 projections、suprema、empirical process 和 Gaussian-width vocabulary。

### 4.3 Why geometry is a separate layer

强调 concentration 提供概率衰减，geometry 决定需要 union bound/entropy 控制多少方向。这个概念分工是本节的核心。

## §5 Deterministic Matrix Analysis

### 5.1 Matrix functional calculus and order

建立 exp/log、self-adjointness、strict positivity、Loewner order 与 trace monotonicity。

### 5.2 Relative entropy

Klein inequality、Gibbs principle 和 joint convexity。

### 5.3 Full Lieb concavity

正文给 theorem statement 和 proof architecture：

\[
\text{Klein}
\to
\text{Gibbs}
\to
\text{left-right representation}
\to
\text{joint convexity}
\to
\text{Lieb}.
\]

长的 derivative/resolvent/CFC 技术放 appendix。正文必须让读者看见数学路线，而不是 Lean tactic。

### 5.4 Golden-Thompson and matrix Laplace ingredients

把 Golden-Thompson、trace-exponential monotonicity和 spectral domination 作为下一节的入口。

## §6 Conditional Matrix Concentration

这是全文核心 section。

### 6.1 One-step Lieb/Jensen inequality

给出

\[
\mathbb{E}\operatorname{tr}\exp(H+Z)
\leq
\operatorname{tr}\exp
\left(H+\log\mathbb{E}\exp Z\right)
\]

及完整的 self-adjointness、positivity、measurability 和 integrability 条件。

### 6.2 History-parameterized finite-family theorem

先写一般 theorem：给定 history \(\mathcal{F}_i\)、state \(H_i\)、current step
\(Z_i\) 和 one-step certificates，trace-MGF 可以逐步 telescope。

这是文章最重要的抽象之一。它应作为数学主定理，而不是“API 设计”。

### 6.3 Independent families as a corollary

对独立随机矩阵族构造 canonical natural history，证明每一步与过去独立，并 discharge §6.2 的条件。这样标准 independent theorem 成为 general conditional theorem 的 corollary。

这里可以与 product-law transport 路线做一段温和对比：两者都在任意概率空间给出 endpoint，但本文选择直接在原空间上表达 conditional iteration。

### 6.4 Individual matrix MGF bound

由 bounded self-adjointness、centering 和 second moment 得到

\[
\mathbb{E}e^{\theta X_i}
\preceq
\exp\!\left(g(\theta,R)\,\mathbb{E}X_i^2\right),
\qquad
g(\theta,R)
=
\frac{\theta^2/2}{1-|\theta|R/3}.
\]

### 6.5 Matrix Bernstein

组合 trace-MGF、matrix Laplace、positive/negative tails 和 scalar optimization，得到双侧 operator-norm tail：

\[
\mathbb{P}
\left\{
\left\|\sum_i X_i\right\|\geq t
\right\}
\leq
2n\exp
\left(
-\frac{t^2}
{2\sigma^2+\frac{2}{3}Rt}
\right).
\]

随后给 arbitrary finite-index transport、zero-variance branch 和精确的
\(1-\delta\) threshold corollary。

## §7 Applications

### 7.1 Breadth: a common rank-one factorization

正文给出一张交换图。每个 ML/统计对象先经模型特有 adapter 进入 centered rank-one family，然后共享以下三步：

1. 证明 centered/self-adjoint/independent；
2. 计算 operator-norm radius 与 variance proxy；
3. 调用 Matrix Bernstein，并将事件搬回原应用语义。

详细证明一个代表模型；其余模型用 exact Lean declarations 证明它们确实复用了同一中间 schema。

### 7.2 Depth: PrecisionDA

沿 covariance、shifted precision resolvent、rank-one update 和 leave-one-out analysis 展开一个完整的模型构造。用单独的 dependency diagram 区分 deterministic identities、probability providers 和最终 tail conclusion。这样 application section 同时展示 theory 的多模型覆盖和单模型表达深度。

## §8 Formalization Discussion

最后才讨论形式化经验：

- textbook 中被省略的 positivity、integrability、zero-variance 条件；
- scalar expectation 与 matrix/Bochner expectation 的桥；
- finite index 与 arbitrary finite type 的搬运；
- Mathlib 中 matrix functional calculus 的边界。

AI 辅助、测试和开发流程放在这一节或 appendix，不作为主贡献。

---

# 7. 证明如何划分成子模块

论文里的 proof decomposition 应使用下面八个数学模块。

| 模块 | 输入 | 主证明任务 | 输出 |
| --- | --- | --- | --- |
| M1 Concentration language | probability basics | tail/moment/Orlicz/MGF conversions | reusable scalar assumptions and tails |
| M2 Scalar sums | independence + MGF bounds | factorization and Chernoff optimization | Hoeffding/Bernstein families |
| M3 Geometry | directional control + nets | approximation and finite reduction | uniform/vector/operator control |
| M4 Matrix order and calculus | self-adjoint matrices | exp/log/order/trace/derivatives | deterministic matrix toolkit |
| M5 Entropy-to-Lieb | M4 | Klein, Gibbs, joint convexity, left-right route | full Lieb concavity |
| M6 Conditional trace-MGF | M5 + conditional expectation | one-step Jensen and telescoping history | finite-family master theorem |
| M7 Bernstein endpoint | M6 + individual MGF | Laplace, sign split, optimization | optimized/high-probability Matrix Bernstein |
| M8 Applications | M1-M7 | model-specific radius and variance control | covariance/Gram bounds |

划分原则：

- 每个模块都有一个清楚的 mathematical output；
- 下一个模块只依赖上一个模块的 theorem statement；
- 形式化技术细节不能成为顶层模块；
- 同一个数学概念只在一个模块中定义；
- application 只承担模型特有估计，不重证 concentration machinery。

这张表应成为论文 Figure 1 的基础。

---

# 8. Abstract 的写作骨架

Abstract 用五步，不写 LOC、定理数或工程指标。

1. **Context**：HDP 是统计与学习理论的基础。
2. **Gap**：现有形式化缺少连接 scalar、geometry 和 matrix concentration 的统一基础。
3. **What**：我们给出 HighDimProb。
4. **Technical depth**：full Lieb 到 arbitrary finite-family Matrix Bernstein。
5. **Use and lesson**：用 rank-one 应用族展示广度，用 PrecisionDA 展示深度，并暴露 textbook assumptions。

英文草案：

> High-dimensional probability provides the concentration and random-matrix tools underlying modern statistics and learning theory, yet its formalization remains fragmented across isolated inequalities and application-specific developments. We present HighDimProb, an application-independent Lean 4 foundation that connects scalar concentration, finite-dimensional geometry, random vectors and processes, and noncommutative matrix concentration through certified, compositional interfaces. The scalar layer organizes tail, moment, Orlicz, and moment-generating-function arguments into composable theorem families. The matrix layer formalizes the analytic chain from relative entropy and left-right representations to full Lieb concavity and Golden-Thompson, then derives a history-parameterized trace-MGF principle and the self-adjoint Matrix Bernstein inequality for arbitrary finite families, including optimized and high-probability forms. We demonstrate breadth by factoring covariance and Gram-type objects from random features, neural tangent kernels, attention, gradients, and low-rank adaptation through a common centered rank-one construction, and depth through a precision-matrix case study based on resolvent and leave-one-out analysis. The formalization makes explicit the measurability, integrability, positivity, and degenerate-variance conditions hidden in standard paper proofs, and provides a common foundation for future machine-checked developments in high-dimensional statistics and learning theory.

投稿前根据正文最终覆盖范围收紧应用列表，不能让 abstract 比正文更广。

---

# 9. Figure 和 Table 设计

## Figure 1：Theory hierarchy

五层 DAG：

```text
Scalar probability and concentration
        |
        +--> Geometry / vectors / processes
        |
        +--> Matrix order and functional calculus
                    |
             Relative entropy / Lieb
                    |
          Conditional trace-MGF theorem
                    |
              Matrix Bernstein
                    |
       Covariance and Gram applications
```

## Figure 2：Conditional-to-independent specialization

左侧是用户给定 history 的 general theorem，右侧是 independent family 生成
canonical history；两条箭头汇入同一个 trace-MGF conclusion。

## Figure 3：Certified application coverage

上半部分画多个模型特有 adapter 汇入 centered rank-one/Bernstein schema；下半部分画

\[
\mathsf{CertifiedApp}_L
\mathrel{\mathop{\rightleftarrows}^{\pi_L}_{\sigma_L}}
\mathsf{App},
\qquad
\pi_L\circ\sigma_L=\mathrm{id},
\]

用来区分“多模型复用同一 schema”和“目标应用类上的 split-surjective coverage”。

## Table 1：Formalized mathematical coverage

按五层列 representative theorem、reference source、Lean counterpart 和 paper section。不要列全部声明。

## Table 2：Application instantiations

列：

- model；
- semantic adapter；
- shared intermediate schema；
- discharged certificates；
- assumed certificates；
- resulting concentration form。

## Table 3：与相关形式化的范围对照

只比较 paper scope：

- scalar concentration；
- empirical processes；
- finite-dimensional geometry；
- matrix analysis；
- Matrix Bernstein；
- application class；
- direct instantiation witness under the pinned public interface。

表注中明确 SLT 当前仓库已超过其 ICML paper scope，避免误导。

---

# 10. 当前“库与文章”的真正 gap

现在最主要的 gap 已经不是缺少 Lieb 或 Matrix Bernstein proof，而是**文章选择和组织尚未冻结**。

| 层 | 库中已有的文章素材 | 写作上仍需完成 |
| --- | --- | --- |
| Scalar | concentration implication chains、sum inequalities | 选定 2-3 个主 theorem groups，明确哪些是完整 equivalence、哪些只是 implication |
| Geometry/process | nets、entropy、vector/process vocabulary | 选一个真正端到端的 geometric reduction，避免只写 vocabulary |
| Matrix analysis | full Lieb、Golden-Thompson、order/spectral/trace | 写出可读的数学 proof sketch，把 CFC/resolvent 技术放 appendix |
| Matrix concentration | conditional trace-MGF、generated history、canonical Bernstein、高概率形式 | 把一般 conditional theorem 和 independent corollary写成正文主线 |
| Applications | LoRA natural-input tail constructor；多个 covariance/Gram structural examples；PrecisionDA deterministic/resolvent development | 为 LoRA 补 normalized high-probability 与 Loewner/eigenvalue corollary；闭合一个第二模型的 natural-input constructor；逐项区分 PrecisionDA 已闭合结论与 provider assumptions |

这张表应交给写库的人核对：他们不需要评价工程是否符合某个 schema，只需要回答“每个数学层最能代表库的 theorem 和 application 是什么，是否足以支撑正文叙事”。

---

# 11. 实际写稿流程

1. **冻结一句话 thesis。** 使用 §0.2，不再在“工程论文/数学论文”之间摇摆。
2. **冻结七个 theorem groups。** 每组只选一个主 statement 和最多两个 supporting lemmas。
3. **画 Figure 1。** 如果某个模块无法放进 DAG，说明它不属于主文。
4. **先写 §6。** Lieb-to-Bernstein 是技术最完整的部分，先确定数学深度和篇幅。
5. **再写 §3-§4。** 选择能够真正接到应用的 scalar/geometry 主线，不做 API 目录。
6. **写 breadth + depth applications。** Rank-one 家族按 adapter/certificate/result 展示覆盖；PrecisionDA 按 deterministic/provider/endpoint 展示深度。
7. **最后写 Introduction 和 Abstract。** 只有正文确定后才能决定“整个库”究竟能 claim 到什么范围。
8. **做 Lean-mirror audit。** 每个正文 theorem 对应 exact declaration、commit、axioms 和 hypothesis diff。
9. **再决定是否补证明。** 只有主文 theorem group 缺关键连接时才继续证明；不为增加数量扩张。

---

# 12. 最终定位

不建议：

> We built a better-engineered Matrix Bernstein library than prior work.

建议：

> **We formalize an application-independent foundation for high-dimensional probability in Lean 4. Its central contribution is a certified compositional theory: model-specific constructions factor through reusable scalar, geometric, and noncommutative interfaces, while split-surjective coverage on explicitly defined application classes makes the scope of this abstraction mathematically testable.**

中文版本：

> **这篇文章的贡献是整个 HighDimProb 理论体系及其可检验的抽象能力：标量集中提供语言，几何与过程提供高维化，矩阵分析解决非交换障碍，条件 trace-MGF 导出 Matrix Bernstein；模型特有的构造再通过带证书的接口进入同一理论。LoRA、NTK 等展示 rank-one 抽象的覆盖广度，PrecisionDA 展示组合这些数学工具重建深层统计模型的能力。Lieb 是技术高点，而应用类上的可构造覆盖与整库的可组合基础共同构成核心主张。**
