> Scope: this is the ProofRoadmap research/benchmark proposal, not the active Lean proof roadmap; see [`docs/TODO.md`](docs/TODO.md).

 **我们提出一套 proof-roadmap engineering 方法：用声明依赖图定量分析大定理如何被拆分、抽象、复用、闭合，并构造一个工具 + benchmark 来评测 LLM 是否真的能参与研究级 Lean 库建设。**

---

# 1. 领域里大家现在怎么做

现有 formal math benchmark 大多还是“给 theorem statement，让模型补 proof”。ProofNet 是 undergraduate-level autoformalization/formal proving benchmark；PutnamBench 是 Putnam 竞赛题 formalization；FormalMATH 是 5,560 个 Lean4 formal problems，覆盖高中竞赛到本科定理。它们的核心评测对象仍然是单个 theorem/proof 的成功率。([arXiv][1])

LeanDojo 这类工具更偏“提取 proof states、tactics、premises、AST、file dependencies，然后做 premise selection / retrieval-augmented proving”。它解决的是模型如何在大库里找 premise 和交互式证明，而不是衡量一个 formalization 项目有没有好的 abstraction boundary。([leandojo.org][2])

现在领域已经开始意识到“单 theorem benchmark 不够”。TheoremBench 明确说现有评测过度集中在 competition-style problems，不能很好捕捉 dependency-rich mathematical developments；它提供 main theorem 和 supporting subtheorems 两种形式，从而评估 partial progress。([arXiv][3]) LeanMarathon 更进一步，把 long-horizon autoformalization 的失败模式总结为 statement drift、dependency tangling、context decay、local repair corrupting distant work，并使用 evolving blueprint / proof DAG 来组织多 agent formalization。([arXiv][4])

还有一条线是 repository-scale benchmark。SorryDB 从真实 Lean formalization projects 中抽取 open tasks，目标是让 benchmark 更贴近日常 formalization 使用场景。([arXiv][5]) VeriSoftBench 也强调保留真实 repository context、cross-file dependencies、project-defined abstractions，因为 Mathlib-style benchmark 上调好的 prover 不一定能迁移到真实项目。([arXiv][6])

同时，formal benchmark 的质量问题也变成热点。最新 benchmark audit 工作指出，Lean kernel 只保证 proof 证明了 formal statement，但不保证这个 statement 忠实表达了原始数学问题，也不保证 evaluation harness 能抵抗 vacuous theorem、missing hypotheses、adversarial shortcut 等问题。([arXiv][7]) Lean Atlas 也提出类似问题：type checker 不验证 proposition/definition 是否表达 intended mathematical content，因此 AI formalization 会出现 semantic hallucination。([arXiv][8])

所以领域趋势很清楚：

> benchmark 正在从 “prove isolated theorem” 走向 “repository context + proof DAG + statement fidelity + downstream usability”。

HighDimProb 正好可以站在这个趋势上。

---

# 2. 我们要解决的 gap

你现在的 gap 可以非常清楚地写成四个。

**Gap 1：现有 benchmark 测 proof completion，不测 theorem factorization。**
TheoremBench 已经开始用 supporting subtheorems 评估 partial progress，但这些 subtheorems更多是 proof structure 的展开；它还不是在问：“哪些 lemma 应该被设计成 reusable API？哪些只是 aux split？哪些 assumption 应该成为 provider boundary？”([arXiv][3])

**Gap 2：现有工具测 premise retrieval，不测 abstraction quality。**
LeanDojo 能提取 proof states、tactics、premises、AST 和 file dependencies，这对 retrieval prover 很重要；但它没有定义 decomposition、reuse、closedness、provider/consumer boundary、application theorem 这些库工程指标。([leandojo.org][2])

**Gap 3：现有 formalization paper 常证明 endpoint，但不审计 proof roadmap。**
SLT 仓库确实有 roadmap，也确实写了“decompose proofs into small lemmas”的 recipe；它还声称包含 Hanson-Wright、Lieb、Matrix Bernstein 等结果。([GitHub][9]) 但它的 README 也明确说没有 separate test suite，clean `lake build` 就是 verification。([GitHub][9]) 这不是说它错；而是说它没有把 downstream API stability、statement surface、roadmap fidelity 和 hidden judge 作为独立 artifact。

---

# 3. 文章的中心 thesis

我建议全文围绕这一句话展开：

> **Research-level formalization is not merely proof search; it is theorem-roadmap engineering.**

中文版本：

> **研究级形式化不是单纯 proof search，而是 theorem roadmap 的设计、审计和维护。**

再展开成更具体的 HighDimProb 版本：

> **HighDimProb demonstrates that formalizing high-dimensional probability requires choosing the right abstraction boundaries: aux lemmas for local proof decomposition, reusable bridge/provider/consumer interfaces for future theorems, and downstream judge files that verify the public API remains usable. We introduce a graph-based tool to measure these properties and a benchmark to evaluate whether LLM agents benefit from such roadmap information.**

这个主线比“我们证明了更多 theorem”更稳，也更难被已有工作覆盖。

---

# 4. 工具 roadmap：ProofRoadmap / HDP-Atlas

工具可以叫：

> **ProofRoadmap**
> **LeanProofAtlas**
> **HDP-Atlas**
> **RoadmapGraph**

我最推荐 **ProofRoadmap**，因为它不局限于 HighDimProb，但 HighDimProb 是第一个 hard case study。

工具输入一个 Lean repo，输出：

1. declaration dependency graph；
2. decomposition / abstraction / closedness / proof-intensity 指标；
3. theorem route report；
4. candidate benchmark tasks；
5. downstream judge coverage report。

## 4.1 数据抽取层

基于 Lean repo 构建声明图：

[
G=(V,E)
]

每个点是 declaration，每条边是“声明 (b) 的证明或定义依赖声明 (a)”。这可以对接 LeanDojo 风格的数据抽取，因为 LeanDojo 已经支持从 Lean repo 中提取 AST、file dependencies、proof states、tactics 和 fine-grained premise annotations。([leandojo.org][2])

每个 node 存：

```text
name
file
module
namespace
kind: theorem / lemma / def / abbrev / structure / instance
statement
proof block span
attributes: simp, aesop, ext, norm_cast, ...
imports
direct dependencies
transitive downstream users
judge coverage
topic label
interface label
```

interface label 可以用 rule-based + human-audited classifier：

```text
Aux
Bridge
Provider
Consumer
Wrapper
Statement
Assumptions
Application theorem
Simp normalization
Typed-prop / scaffold
```

## 4.2 指标层

你给的定义已经很好，我建议稍微规范化成 paper-ready 版本。

### Decomposition score

不要只做二值分类，可以做一个连续分数：

[
Decomp(u)
=========

\mathbf{1}[\rho_F(u)\le 1]
\cdot
(1-\widehat H_T(u))
\cdot
(1-Generic(u))
\cdot
Locality(u)
]

其中：

[
\rho_F(u)=|{\text{downstream files using }u}|
]

[
\widehat H_T(u)=
\frac{-\sum_t p_t(u)\log p_t(u)}{\log |\mathcal T|}
]

`Generic(u)` 衡量 statement 是否像通用接口，比如是否有 `Provider`、`Bridge`、`Assumptions`、多态参数、record hypotheses、generic `Prop` family 等。
`Locality(u)` 衡量它是否只在一个 route/cluster 内使用。

解释：

> 高 decomposition score 的声明通常是 proof split：它帮助证明一个局部大 theorem，但本身不是公共 API。

### Abstraction / reuse score

[
Reuse(u)
========

\log(1+#refs(u))
+
\log(1+#files(u))
+
\lambda #apps(u)
+
\mu Generic(u)
+
\nu CrossTopic(u)
]

其中：

* `#refs(u)` 是直接引用次数；
* `#files(u)` 是跨文件复用数；
* `#apps(u)` 是 application theorem 中使用它的次数；
* `Generic(u)` 衡量它是否是 provider/bridge/wrapper/interface；
* `CrossTopic(u)` 衡量它是否跨 topic 使用。

解释：

> 高 Reuse score 的声明不是 aux split，而是 abstraction boundary。

这正好能解释你统计里最强的点：HighDimProb 不是只有 theorem count，而是有明显的 provider/bridge/wrapper/application theorem 层。

### Closedness

你给的 closedness 很好：

[
Closed(T)=1-\frac{#\text{high-level provider assumptions}}{#\text{all assumptions}+1}
]

但我建议加一个分层：

```text
C0: typed-prop / scaffold only
C1: conditional consumer with explicit provider assumptions
C2: closed under library-level hard assumptions
C3: closed from textbook assumptions
C4: downstream-facing closed theorem
```

这样不会把 HighDimProb 的 conditional theorem 写成弱点，而是变成成熟度地图。

### Proof intensity

你给的 PI 可以直接用：

[
PI = \mathbb{E}[\log(1+L_T)] + P(L_T>100) + 3P(L_T>500)
]

但建议再加两个图指标：

[
Depth(T)=\max_{u\leadsto T} \text{path length}
]

[
FanIn(T)=|{u:u\leadsto T}|
]

原因是：一个 theorem 的 proof block 不长，不代表数学简单。它可能依赖大量底层 bridge 和 provider。HighDimProb 的很多“短证明”可能恰恰说明 abstraction 做得好。

### Judge coverage

这个是你和 SLT 区分的关键指标：

[
JudgeCov(u)=
\mathbf{1}[\text{u appears in downstream judge/import/use file}]
]

或 route-level：

[
JudgeCov(R)=
\frac{#\text{public route declarations covered by judge}}{#\text{public route declarations}}
]

HighDimProb 的 judge 文档已经明确说它是 compile-time OJ-style layer，用下游用户方式 import selected public APIs，并检查 public theorem names、scalar concentration、Orlicz/tail、moment bridges、random-matrix PSD/order、sample covariance、variance proxy、operator-norm measurability、matrix concentration statements，以及 forbidden tokens / fake declarations / import boundary 等 policy。([GitHub][11])

这个可以成为论文很强的一句话：

> **Lean build checks proofs; HighDimProbJudge checks whether the library remains usable as a library.**

---

# 5. Benchmark roadmap：HDP-RoadmapBench

benchmark 不应该只是“给 theorem，证明”。应该做成证明工具效果的实验平台。

核心设计：

> 同一个 LLM agent，在没有 ProofRoadmap 工具和有 ProofRoadmap 工具的情况下，完成同一批 HighDimProb repository-scale tasks。看工具是否提升成功率、减少 statement drift、提升复用质量、提升 judge pass rate。

## 5.1 Benchmark tracks

我建议分六个 track。

| Track              | 测什么                                         | 任务形式                                             | 主要指标                             |
| ------------------ | ------------------------------------------- | ------------------------------------------------ | -------------------------------- |
| **HDP-Use**        | API 使用能力                                    | 给 downstream theorem，要求调用已有 API                  | compile + judge pass             |
| **HDP-Simp**       | normalization / simp / equivalence lemma 使用 | 给小目标，要求用已有 bridge/simp lemma                     | proof success + proof length     |
| **HDP-Bridge**     | 补 reusable bridge lemma                     | 给 statement，要求证明并被两个下游文件复用                       | build + hidden downstream        |
| **HDP-Decompose**  | 大定理拆分能力                                     | 给 endpoint theorem，让模型提出 lemma DAG               | gold-roadmap match + human audit |
| **HDP-Closedness** | 降低 provider assumption                      | 给 conditional theorem，要求消去一个 provider assumption | closedness gain                  |
| **HDP-Repair**     | 维护真实库                                       | 给 broken branch，要求修 build/test/judge             | build + policy + diff scope      |

最有原创性的不是 HDP-Use，而是 **HDP-Decompose** 和 **HDP-Closedness**。

## 5.2 工具效果实验

设计成 A/B：

```text
Baseline agent:
  - README + relevant files + Lean errors

Tool-assisted agent:
  - README + relevant files + Lean errors
  - ProofRoadmap report:
      dependency neighborhood
      candidate premises
      route cluster
      existing bridge/provider/wrapper declarations
      closedness blockers
      judge surface
      similar proved lemmas
```

评测：

[
\Delta Pass@k
]

[
\Delta JudgePass
]

[
\Delta Closedness
]

[
\Delta ReuseScore
]

[
\Delta StatementDrift
]

[
\Delta DiffSize
]

这里最重要的是：不要只看 proof pass rate。要看模型有没有产生“可复用的库贡献”。

## 5.3 Benchmark split

建议三层 split：

```text
Public-dev:
  已公开 route，用于调 prompt/tool。

Private-test:
  隐藏 downstream judge files，防止模型只过公开测试。

Future-commit:
  从后续 HighDimProb commit 中抽任务，模拟真实库演化。
```

这能回应 contamination 问题。ArXivLean 用近期 arXiv 论文构造可刷新 benchmark 来减少 contamination；你的 future-commit split 是 Lean repository 版的同类思想。([matharena.ai][12])

---

# 6. 和 SLT 怎么比较

不要把比较写成“SLT 很扯”。论文里这样写更有力：

> **SLT is endpoint-oriented and build-verified; HighDimProb is roadmap-oriented and downstream-judge-verified.**

更具体：

| 维度            | SLT                                                                 | HighDimProb / 本文                                                      |
| ------------- | ------------------------------------------------------------------- | --------------------------------------------------------------------- |
| 主要目标          | SLT / empirical-process formalization                               | HDP / random-matrix concentration roadmap                             |
| 验证方式          | README 写明 no separate test suite，clean `lake build` is verification | build + tests + downstream judge + policy check                       |
| decomposition | recipe 中建议拆小 lemma                                                  | 用 graph metrics 定量区分 aux decomposition vs reusable abstraction        |
| roadmap       | 有 human-readable implementation roadmap                             | proof DAG + closedness + provider/consumer boundary + benchmark tasks |
| benchmark     | 发布 traced theorem dataset                                           | 发布 repository-scale roadmap benchmark                                 |
| API fidelity  | 未见独立 downstream judge                                               | judge imports as outside user                                         |
| 比较重点          | theorem endpoints / proof traces                                    | theorem-roadmap engineering / API stability / LLM tool effect         |

SLT README 确实列了 implementation roadmap、major results、dataset，并且说它有 865 traced theorems、18,669 tactic steps、300M tokens。([GitHub][9]) 所以不要否认它有 dataset 或 roadmap。你的攻击点应该是：

> 它的 roadmap 是说明文档；我们的 roadmap 是可计算对象。
> 它的 decomposition 是经验 recipe；我们的 decomposition 是可测指标。
> 它的 verification 是 build；我们的 verification 加了 downstream judge 和 policy。
> 它的 dataset 是 proof traces；我们的 benchmark 是 repository-scale roadmap tasks。

这样非常稳。

---

# 7. 用你现有统计讲故事

你现在的表可以作为 preliminary evidence，但要加一句：

> We treat these as coarse regex/proxy statistics and release exact scripts and frozen commits for reproducibility.

按你目前 proxy，最有价值的不是 theorem-like 总数，而是后三行：

| 指标                      | HighDimProb |  SLT |
| ----------------------- | ----------: | ---: |
| interface/proxy 抽象声明    |        约 96 |  约 0 |
| provider/bridge/wrapper |       约 143 |  约 0 |
| application theorem     |        约 98 |  约 0 |
| 所有声明跨文件复用中位数            |        2 文件 | 0 文件 |

这说明 HighDimProb 的结构不是“堆证明”，而是有明显的 API boundary 层。
但文章里要谨慎说：

> These labels are naming-pattern proxies, not final semantic labels. We validate them by human annotation on a stratified sample.

否则 reviewer 会说 regex 统计不可信。

我建议把最终统计做成三张图：

**图 1：Reuse distribution**
x 轴是 downstream file count，y 轴是 declaration count。HighDimProb 如果中位数真是 2，SLT 是 0，这图很有冲击力。

**图 2：Closedness vs Abstraction scatter**
每个 theorem 一个点。
SLT 可能很多点在“high closedness, low abstraction”；HighDimProb 可能很多点在“medium/low closedness, high abstraction”。
这能客观表达：

> SLT endpoint closure 强；HighDimProb roadmap abstraction 强。

**图 3：Proof roadmap DAG case study**
选 Matrix Bernstein / Lieb / sample covariance 其中一条路线，画出：

```text
simp / normalization
→ bridge
→ provider
→ consumer
→ application theorem
→ judge file
```

这个图会比 theorem count 更有说服力。

---

# 8. 论文实验设计

我建议设置 5 个 RQ。

## RQ1：graph metrics 能否区分 aux split 和 reusable abstraction？

做法：

1. 从 HighDimProb + SLT 各抽一批 declarations。
2. 人工标注：aux / reusable abstraction / endpoint / application / scaffold。
3. 用你的 (Decomp)、(Reuse)、(Closedness)、(PI) 预测标签。
4. 报告 precision / recall / F1。

这证明工具不是随便统计 LOC。

## RQ2：HighDimProb 和 SLT 的 formalization style 是否不同？

做法：

1. 固定两个 repo commit。
2. 跑 ProofRoadmap。
3. 比较：

   * theorem-like declarations；
   * long proof distribution；
   * cross-file reuse；
   * provider/bridge/wrapper density；
   * application theorem density；
   * judge coverage；
   * closedness distribution。

结论不要写“谁更好”，写：

> The two libraries optimize different axes: endpoint closure vs roadmap abstraction.

## RQ3：ProofRoadmap 是否提升 LLM agent 的 repository tasks？

做法：

```text
condition A: LLM + raw repo context
condition B: LLM + raw repo context + ProofRoadmap report
```

任务：

* prove leaf lemma；
* use existing bridge；
* repair broken theorem；
* reduce one provider assumption；
* write downstream judge usage file；
* propose lemma decomposition for endpoint.

指标：

* build pass；
* judge pass；
* policy pass；
* proof success；
* statement drift rate；
* unnecessary new declaration count；
* reuse score of new declarations；
* closedness improvement。

这个 RQ 是“工具 + benchmark”的核心。

## RQ4：Benchmark 是否比普通 theorem benchmark 更能暴露 failure modes？

比较模型在：

* isolated theorem tasks；
* repository-context tasks；
* roadmap tasks。

你很可能会发现：模型能证明一些局部 lemma，但不会选择正确 abstraction boundary；或者会写一个 theorem 过当前 file，却破坏 downstream judge。这个 failure mode 正是现有 benchmark 测不到的。

## RQ5：judge 是否能抓住 build 抓不到的问题？

这里要谨慎：Lean build 已经会抓 proof correctness。judge 抓的是 public API 和 policy。可以设计几类 mutation：

```text
rename public theorem
move experimental import into stable root
weaken application-facing wrapper
replace public theorem body with trivial True-bodied fake declaration
remove bridge from public route
expose anonymous negated random-matrix family
```

HighDimProbJudge 文档已经列出这些 policy 检查方向。([GitHub][11])

---

# 9. 论文结构 roadmap

## Title

我建议：

> **ProofRoadmap: Measuring and Benchmarking Theorem-Roadmap Engineering in Lean**

副标题：

> **A Case Study in High-Dimensional Probability and Random Matrix Concentration**

如果更强调库：

> **HighDimProb: A Roadmap-Aware Lean 4 Library and Benchmark for High-Dimensional Probability**

我更喜欢第一个，因为它把“工具 + benchmark”放到主标题里。

## Abstract skeleton

可以这样写：

> Formalizing research-level mathematics in Lean is not merely a theorem-proving problem. Large theorems must be factored into intermediate statements that are provable, reusable, faithful to the intended mathematics, and stable under downstream use. We introduce ProofRoadmap, a graph-based tool for extracting declaration dependency graphs from Lean repositories and measuring decomposition, abstraction, closedness, proof intensity, and judge coverage. We instantiate the framework on HighDimProb, a Lean 4 library for high-dimensional probability and random-matrix concentration. The resulting benchmark, HDP-RoadmapBench, evaluates LLM agents not only on proof completion, but also on roadmap-guided tasks such as bridge construction, provider-consumer composition, closedness improvement, and downstream API repair. Experiments compare HighDimProb with a recent Lean statistical-learning-theory library and show that roadmap information improves LLM performance on repository-scale formalization tasks.

## Section 1：Introduction

主张：

```text
Formalization = proof search + library design + roadmap maintenance.
```

指出现有 benchmark 的不足，引用 ProofNet / PutnamBench / FormalMATH / TheoremBench / LeanMarathon。

## Section 2：Related Work

分四类：

1. isolated formal theorem benchmarks；
2. Lean extraction/proving tools；
3. long-horizon / repository-scale formalization；
4. benchmark fidelity and semantic audit。

## Section 3：Theorem-roadmap model

正式定义：

* declaration graph；
* downstream usage；
* topic entropy；
* decomposition score；
* reuse score；
* closedness；
* proof intensity；
* judge coverage。

## Section 4：ProofRoadmap tool

写系统架构：

```text
Lean extraction
→ dependency graph
→ declaration classifier
→ metric computation
→ route report
→ benchmark task generator
```

## Section 5：HighDimProb as a case study

介绍 HighDimProb 的路线：

* scalar concentration；
* random matrix order/PSD；
* variance proxy；
* sample covariance；
* trace-MGF；
* Matrix Bernstein；
* Klein/Lieb route；
* downstream judge。

HighDimProb README 已经明确它是 Lean 4 高维概率库，目标是在 Mathlib 上加 thin layer of names/wrappers/examples/theorem interfaces，RandomMatrix 和 Matrix Bernstein 仍在 active development。([GitHub][13]) 这个诚实状态可以转化成论文卖点：它不是只展示完成品，而是展示研究级 proof roadmap。

## Section 6：HDP-RoadmapBench

介绍 benchmark tracks、manifest、hidden judge、evaluation protocol。

## Section 7：Experiments

回答 RQ1–RQ5。

## Section 8：Case study

选一个硬路线：

```text
Matrix Bernstein route
```

或：

```text
Klein → Gibbs → Lieb provider route
```

展示：

* naive endpoint proof 不可行；
* ProofRoadmap 如何识别 missing bridge；
* 哪些声明是 aux split；
* 哪些声明是 reusable abstraction；
* judge 如何保证 public route。

## Section 9：Limitations

诚实写：

* graph extraction 可能漏掉 elaborator-generated dependencies；
* naming-pattern classifier 需要人工校验；
* closedness 不等于数学重要性；
* provider assumptions 有时是合理 abstraction，不是缺陷；
* benchmark 初期会偏向 HighDimProb 风格。

这个会增加可信度。

---

# 10. 你现在应该优先做的 artifact

按优先级：

## Artifact A：冻结 commit + 统计脚本

输出：

```text
metrics/highdimprob.json
metrics/slt.json
metrics/highdimprob_vs_slt.md
```

必须包含：

```text
repo URL
commit SHA
Lean version
Mathlib version
date
script version
```

## Artifact B：声明分类器

先不用太复杂，rule-based 就够：

```text
Provider: name contains Provider or field contains provider-like Prop
Bridge: name contains bridge / iff / equivalence / to / of / transport
Wrapper: name contains wrapper / compact / user-facing / use
Statement: name contains Statement or returns Prop
Assumptions: structure or abbrev collecting hypotheses
Application: file path contains Examples / Applications / PrecisionDA / SampleCovarianceTailUsage
Simp: @[simp]
```

然后人工抽样校验。

## Artifact C：route-level gold labels

先选 5 条路线：

1. scalar Bernstein；
2. subGaussian sums；
3. sample covariance bounded-row；
4. variance proxy exact-row；
5. Matrix Bernstein / Lieb hardbone。

每条路线手工写：

```yaml
route: sample_covariance_bounded_row
endpoint:
  - ...
aux_lemmas:
  - ...
bridges:
  - ...
providers:
  - ...
consumers:
  - ...
applications:
  - ...
judge_files:
  - ...
blocked:
  - ...
```

这就是 benchmark 的 gold roadmap。

## Artifact D：HDP-RoadmapBench manifest

每题一个 JSON/YAML：

```yaml
task_id: hdp_bridge_017
track: HDP-Bridge
repo_commit: ...
allowed_files:
  - HighDimProb/RandomMatrix/...
forbidden:
  - sorry
  - admit
  - axiom
  - unsafe
target:
  file: ...
  declaration: ...
success:
  - lake build
  - lake test
  - lake build HighDimProbJudge
  - python scripts/judge_policy_check.py
metrics:
  - proof_success
  - judge_pass
  - reuse_score_delta
  - closedness_delta
hidden_tests:
  - ...
```

## Artifact E：tool-assisted prompt format

比如：

```text
ROUTE SUMMARY
- target route: SampleCovarianceTail
- existing providers: ...
- existing bridges: ...
- candidate premises: ...
- current closedness blockers: ...
- downstream judge files: ...

TASK
Prove the following bridge lemma without changing public statements.
```

这样 benchmark 才能证明工具有用。

---

# 11. 关于“他们没有 judge 怎么保证仓库是对的”

论文里要非常精确：

**Lean build 保证当前 formal statements 的 proof correctness。**
不能说没有 judge 就“不对”。

但可以说：

> A clean build does not guarantee downstream API stability, semantic faithfulness of theorem surfaces, non-vacuity, or robustness against benchmark shortcuts.

这个说法有文献支持：benchmark audit 工作明确指出，kernel 只检查 formal statement 的证明，不检查 statement 是否忠实表达 intended informal problem，也不保证 evaluation harness 抵抗 trivial/adversarial solutions。([arXiv][7])

所以你可以这样写：

> SLT-style build verification is necessary but not sufficient for a repository intended as a reusable library or benchmark. HighDimProb adds downstream judge files and policy checks to test whether public theorem names, import boundaries, and application-facing APIs remain usable by external clients.

HighDimProb 的 README 也明确说 judge suite 用外部用户方式 import library，适合在修改 public theorem names 或 module boundaries 时检查。([GitHub][13])

---

# 12. 最终定位

我会把这篇文章定位成：

> **工具论文 + benchmark 论文 + 高维概率 case study**

不是单纯 formalization paper。

最核心贡献写成四条：

1. **A graph-theoretic framework for theorem-roadmap engineering**
   用声明依赖图定义 decomposition、reuse、closedness、proof intensity、judge coverage。

2. **ProofRoadmap, a tool for auditing Lean repositories**
   自动生成 proof DAG、route report、abstraction/reuse statistics、benchmark candidates。

3. **HDP-RoadmapBench, a repository-scale benchmark for LLM agents**
   不只测 theorem proving，还测 decomposition、bridge construction、closedness improvement、API repair、downstream judge passing。

4. **A case study on HighDimProb vs SLT**
   说明两个库在 theorem endpoints、abstraction boundary、reuse、closedness、judge coverage 上的不同 formalization style。

一句话版：

> **我们不是只证明高维概率定理；我们把“如何把高维概率大定理拆成可复用 Lean 证明路线”这件事本身工具化、量化、benchmark 化。**

这就是你这篇文章最有价值的地方。

[1]: https://arxiv.org/abs/2302.12433?utm_source=chatgpt.com "[2302.12433] ProofNet: Autoformalizing and Formally ..."
[2]: https://leandojo.org/leandojo.html?utm_source=chatgpt.com "LeanDojo: AI-Assisted Theorem Proving in Lean"
[3]: https://arxiv.org/abs/2606.09450?utm_source=chatgpt.com "TheoremBench: Evaluating LLMs on Theorem Proving in Formal Mathematics"
[4]: https://arxiv.org/abs/2606.05400?utm_source=chatgpt.com "LeanMarathon: Toward Reliable AI Co-Mathematicians through Long-Horizon Lean Autoformalization"
[5]: https://arxiv.org/html/2603.02668v1?utm_source=chatgpt.com "Can AI Provers Complete Real-World Lean Theorems?"
[6]: https://arxiv.org/html/2602.18307v1?utm_source=chatgpt.com "Repository-Scale Formal Verification Benchmarks for Lean"
[7]: https://arxiv.org/abs/2606.29493?utm_source=chatgpt.com "Faults in Our Formal Benchmarking: Dataset Defects and Evaluation Failures in Lean Theorem Proving"
[8]: https://arxiv.org/abs/2604.16347?utm_source=chatgpt.com "Lean Atlas: An Integrated Proof Environment for Scalable ..."
[9]: https://github.com/YuanheZ/lean-stat-learning-theory "GitHub - YuanheZ/lean-stat-learning-theory: [ICML2026] The first comprehensive Lean 4 formalization of statistical learning theory, featuring Gaussian Lipschitz concentration and Dudley's entropy integral-establishes a reusable foundation for formalizing ML theory. · GitHub"
[10]: https://arxiv.org/html/2602.01291v1?utm_source=chatgpt.com "A Benchmark for Formalizing Applied Mathematics in Lean 4"
[11]: https://raw.githubusercontent.com/dududuguo/HighDimProb/main/docs/JudgeSystem.md "raw.githubusercontent.com"
[12]: https://matharena.ai/arxivlean/?utm_source=chatgpt.com "ArXivLean"
[13]: https://github.com/dududuguo/HighDimProb "GitHub - dududuguo/HighDimProb: Lean 4 formalizations for high-dimensional probability, random matrices, concentration inequalities, and matrix Bernstein bounds. · GitHub"
