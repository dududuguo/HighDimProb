# Paper Skeleton — ProofRoadmap

> 用法:每个 `[TODO]` 是一个待填坑;每个 ▸ 是"这一段该说什么"的段落级提示。
> 定稿语言为英文;本骨架的中文提示翻成英文后删除。
> 全局红线:不出现任何 "first formalization of Lieb / Matrix Bernstein" 类声明;所有对 SLT 的事实描述只引其论文/README 原文;**任何"SLT 假设形态如何"的表述,必须先在冻结 SHA 上完成逐条 hypothesis diff(design.md §1.4),论文只呈现 diff 表本身**。
> v2 变化(2026-07-10):endpoint 平价假设成立(full Lieb 已跟进);核心差异化升级为 **history interface / model genericity**——见 design.md §2.2 "一个机制、两种解耦"。

---

## 0. 全局写作约定(填之前先读)

**固定术语**(全文只用这些拼写,不造同义词):

| 术语 | 含义 | 禁用的同义写法 |
| --- | --- | --- |
| roadmap graph | 声明依赖图 G=(V,E) | dependency DAG, proof graph |
| interface label | Aux/Bridge/Provider/Consumer/Wrapper/Statement/Application/Simp/Scaffold | role, category |
| hardbone | ledger 中登记的 typed Prop 假设 | axiom, assumption(泛指时可用) |
| provider protocol | ledger + conditional consumer + exact-witness discharge + BLOCKED_CLEAN | provider pattern |
| closedness ladder | C0–C4 | maturity level |
| downstream judge | 以外部用户方式 import 公共 API 的编译期检查层 | test suite |
| statement surface | 下游可见的定理名 + 假设列表 | API shape |
| history interface | 用户提供的 σ-代数族 `mHist : Fin m → MeasurableSpace Ω` + 类型化证书槽位(条件化/可测/独立/可积/MGF 比较) | filtration API, conditioning interface |
| certificate | consumer 定理显式 premise 中的一条类型化事实(只说"需满足什么",不说"如何证") | side condition, obligation |
| generated history | 前缀坐标生成的默认 `mHist`;标准 iIndepFun 情形下全部证书自动出让 | natural filtration(泛指数学对象时可用) |
| model-generic | endpoint 定理对任意 `(Ω, F, P)` 与用户 `mHist` 多态 | model-free, abstract |

**符号约定**:`G=(V,E)`;声明 `u,v`;定理/路线 `T,R`;指标 `Decomp(u)`, `Reuse(u)`, `Closed(T)`, `PI(T)`, `JudgeCov(·)`;概率空间 `(Ω, F, P)`,历史族 `mHist`。[TODO: 定稿前跑一遍符号一致性检查]

**固定句式**(对照 SLT 时只用这几种口径):
- "The two libraries optimize different axes: endpoint closure versus roadmap abstraction."
- "SLT is endpoint-oriented and build-verified; HighDimProb is roadmap-oriented and downstream-judge-verified."
- 模型轴(**待 Table 1b hypothesis diff 确认后启用**):"SLT instantiates the sample space; HighDimProb parameterizes it: consumer theorems are stated over an arbitrary probability space and consume user-supplied certificates through an explicit history interface."

**中心论证句(全文反复回扣)**:explicit-premise discipline yields two orthogonal decouplings — *temporal* (theorems are consumable before their proofs exist) and *model* (theorems remain generic over the user's probability space after their proofs land)。

---

## Title

**ProofRoadmap: Measuring and Benchmarking Theorem-Roadmap Engineering in Lean**
*— A Case Study in High-Dimensional Probability*

[TODO: 备选标题 ×2,投稿前 A/B]

## Abstract(≈180 词,7 句模板)

1. 问题句:research-level formalization 的瓶颈不是单个证明,而是大定理的拆分与维护。[TODO]
2. 现状句:complete endpoint proofs of matrix concentration in Lean 4 now exist in more than one library [SLT; ours];开放的问题从"能否证"变成"如何工程化——两种架构在可复用性、可消费性、可审计性上可测地不同"。[TODO]
3. 方法句:we introduce ProofRoadmap — roadmap graph + 五指标 + provider protocol 形式定义,并证明该协议提供 temporal 与 model 两种解耦。[TODO]
4. 实例句:instantiated on HighDimProb — whose Matrix Bernstein endpoint is stated over an arbitrary probability space via an explicit history interface — 以 SLT 为对照语料:same theorem, same depth, opposite architectures。[TODO]
5. Benchmark 句:HDP-RoadmapBench,7 tracks(含 model-instantiation 任务),tasks drawn from real repository evolution,hidden judge,three-way split。[TODO]
6. 结果句:[TODO: 填 RQ1 F1 / RQ3 ΔPass@k、ΔJudgePass 主数字]
7. 发布句:tool + benchmark + frozen commits + scripts 全部公开。[TODO: URL]

---

## 1. Introduction(6 段)

**P1 — 钩子**
▸ 同一个 Lieb→Matrix Bernstein,同等深度证完,两种架构:一边是千行级单体 lemma 链、零 interface 声明、零 example、`lake build` 即验证;一边是 statement ledger + provider/consumer + history interface + judge——定理未证完时下游即可条件消费,证完后同一定理对任意概率空间的用户模型开放(不必重写成 product-space 坐标形式)。哪个是"更好的 formalization"?kernel 与 `lake build` 对此完全沉默,现有 benchmark 也无法回答。
[TODO]

**P2 — 领域现状与缺口**
▸ 现有 benchmark 测 proof completion(ProofNet/PutnamBench/FormalMATH);新趋势承认 repository context(TheoremBench/LeanMarathon/SorryDB/VeriSoftBench);benchmark audit 指出 kernel 不保证 statement fidelity。但没人量化 abstraction boundary 的选择与维护。
[TODO]

**P3 — thesis**
▸ 一句话命题:research-level formalization is theorem-roadmap engineering — designing, auditing, and maintaining the decomposition into **reusable, conditionally-consumable, downstream-verified** statements。三个形容词分别指向指标、provider protocol、judge。
▸ 紧接中心论证句:同一条显式前提纪律买到两种解耦——temporal(conditional closure)与 model(history interface 使 endpoint 对 `(Ω, F, P)` 多态);后者化解"证完之后 roadmap 结构就没用了"的天然质疑。
[TODO]

**P4 — 我们做了什么**(方法一段话预览:模型→工具→对照→benchmark→A/B 实验→case study)
[TODO]

**P5 — 主要发现预览**(3 个数字 + 1 个 failure mode 发现)
[TODO: 实验完成后填]

**P6 — 贡献列表**(4 条 bullet)
1. A graph-theoretic framework for theorem-roadmap engineering(含 provider protocol、closedness ladder 与 **history interface** 的形式定义,及 "one discipline, two decouplings" 命题)。
2. ProofRoadmap: an auditing tool for Lean repositories。
3. HDP-RoadmapBench: a repository-scale benchmark with tasks drawn from live repository evolution(含 model-instantiation 任务型)。
4. A controlled style study: two libraries, one theorem, same depth(HighDimProb vs SLT)— 含 Bernstein 入口定理的 side-by-side hypothesis diff,以及 model-generic Matrix Bernstein 消费层作为库级 artifact。
[TODO: 措辞打磨]

---

## 2. Related Work(4 小节 + 1 段)

**2.1 Isolated formal theorem benchmarks** ▸ ProofNet, PutnamBench, FormalMATH。共同点:评单个 proof 成功率。[TODO]

**2.2 Lean extraction and proving tools** ▸ LeanDojo:premise/AST/states 提取;对比点:测 retrieval,不测 abstraction quality。[TODO]

**2.3 Repository-scale and long-horizon formalization** ▸ TheoremBench(subtheorems/partial progress)、LeanMarathon(statement drift、dependency tangling)、SorryDB、VeriSoftBench。逐条写"它测什么/不测什么"。[TODO]

**2.4 Benchmark fidelity and semantic audit** ▸ kernel 只证 formal statement;vacuous theorem / adversarial shortcut 问题;Lean Atlas semantic hallucination。这是 judge coverage 指标的文献支点。[TODO]

**2.5 SLT(单独一段)** ▸ 如实描述:formalization paper,human–AI workflow,traced-theorem dataset;repo 后续闭合 Lieb/MatBern endpoints。定位句:orthogonal — 它是被测对象/对照语料,不是竞品工具。[TODO]

---

## 3. The Theorem-Roadmap Model

**3.1 Roadmap graph** ▸ 定义 G=(V,E)、node 属性表、interface labels(9 类)。[TODO: 从 design.md/roadmap.md 搬公式]

**3.2 Metrics**
- Decomp(u):公式 + 一句直觉("proof split, not public API")[TODO]
- Reuse(u):公式 + 直觉("abstraction boundary")[TODO]
- Closedness ladder C0–C4:定义表 + 关键命题:*closedness 提升 = 保持 statement surface 不变的图重写* [TODO]
- Proof intensity PI + Depth + FanIn:为什么短证明≠简单数学 [TODO]
- JudgeCov:声明级 + 路线级 [TODO]

**3.3 The provider protocol**(本节是理论核心,写成 Definition + 不变量)
▸ Definition: hardbone = typed Prop `*_statement` 登记于 ledger;consumer 只能以显式 premise 消费;provider 出让方式 = exact witness ∨ BLOCKED_CLEAN;discharge 不变量 = 下游 statement surface 不变、judge 通过。
▸ 一段说明为何 endpoint 仓库无法事后补上这个结构。
[TODO]

**3.4 Running example** ▸ 用 STATEMENTS.md 里 RM-LIEB 链(S11→S16)画一个小图,标出各 label 与 closedness。[TODO: 图 0]

**3.5 From conditional closure to model genericity**(v2 新增,理论部分第二个非平凡陈述)
▸ Definition(history interface):`mHist : Fin m → MeasurableSpace Ω` + 证书槽位表(逐步条件化 / 历史可测 / 历史-步独立 / 条件期望分解 / 可积・自伴・正性 / MGF 比较),每个槽位给出仓库中对应的 `*_statement` 名。
▸ 观察:certificate 与 hardbone premise 是同一形式对象(typed Prop 显式 premise);区别只在语义——前者由用户模型出让,后者由 provider 出让。因此 conditional closure 与 model genericity 是同一协议的两个推论(temporal / model decoupling)。
▸ Proposition(generated-history section):generated history 下全部证书可从 iIndepFun + 自伴 + 可积的原始素材自动出让(`*_generatedHistory_of_bernsteinPrimitives*` 系列)——即库预设模型是接口的一个 section/特例,而非前提。一句话回应"接口把负担转嫁给用户"。
▸ 收尾一句:复用榜前五全部是 history interface 的证书槽位(§5 数据),接口是被下游用出来的 abstraction boundary,不是事后叙事。
[TODO]

---

## 4. The ProofRoadmap Tool

**4.1 Pipeline** ▸ extraction → graph → classifier → metrics → route report → benchmark task generator(一张流程图)。[TODO: 图 4.1]

**4.2 Extraction** ▸ 数据来源(Lean elaborator / LeanDojo 式提取);哪些依赖可能漏(elaborator-generated),如何处理。[TODO]

**4.3 Declaration classifier** ▸ rule-based 规则表 + human audit 协议(分层抽样、双标注、κ)。诚实声明 proxy 性质。[TODO]

**4.4 Route report 与 task generator** ▸ 输出格式各给一个真实示例(截断)。[TODO]

---

## 5. Two Libraries, One Theorem(风格对照,承接 RQ1/RQ2)

**5.1 Setup** ▸ 冻结 commit(表:repo/SHA/Lean/Mathlib/date);两库以同等深度到达同一 endpoint(Matrix Bernstein via Lieb)——每侧完成度按 claim ladder 落款(sorry 计数、`#print axioms`)。[TODO]

**5.2 Aggregate statistics** ▸ 表 1。预填数字见 design.md §8(2026-07-10 preliminary,冻结 SHA 后重跑):LOC 近乎平价(53.7k vs 56.1k)而结构完全分离——interface/provider 249 vs 0、application 99 vs 0、example 522 vs 0、aux lemma 38 vs 1106、最大单块 216 vs 1368 行、>500 行证明 0 vs 4、中位长度 12 vs 13。加脚注:naming-pattern proxies + human validation;LOC/计数只支撑 scale 句,质量结论只挂在复用/closedness/judge 上。[TODO]

**5.2b Hypothesis-shape diff(Table 1b,v2 新增)**
▸ Bernstein 入口定理 side-by-side 前提对照:SLT `matrix_bernstein_inequality_hdp_all` vs 我方 arbitrary-history consumer。逐行列:样本空间形态(任意 `Ω` vs 构造模型?)、独立性/历史结构(用户参数 vs 内部生成?)、中间层(trace-MGF 迭代)是否公共可消费。**先做 diff 再写结论;design.md §1.4 给了三种结论各自的写法。**[TODO: 表 1b]

**5.3 三张主图**
- 图 1 Reuse distribution(downstream file count 直方图;预填:median 2 / p90 4 / p95 5 / max 16;标出前五名全部是 history-interface 证书槽位,如 `troppMasterTraceMGFFiniteFamily_statement` 82 refs / 11 files)[TODO]
- 图 2 Closedness × Abstraction scatter [TODO]
- 图 3 一条路线的 roadmap DAG(simp→bridge→provider→consumer→application→judge)[TODO]

**5.4 Reading** ▸ 只用固定句式下结论;明确"不是谁更好"。两个必写观察:(a) 复杂度分布——中位相同、尾部相反(单体千行块 vs 接口图);(b) 复用榜与 history interface 的重合是 model-decoupling 命题的实证闭环。[TODO]

---

## 6. HDP-RoadmapBench

**6.1 Design principles** ▸ 三条:任务来自真实仓库演化;成功判据 = build+test+judge+policy(不只 proof pass);评"库贡献质量"而非"证明成功率"。[TODO]

**6.2 Tracks** ▸ 表:7 tracks(Use/Simp/Bridge/Decompose/Closedness/Repair/**Hardbone**)× (测什么/任务形式/指标)。Hardbone track 单独一段:任务来自 live ledger,可解性由外部 endpoint 证明存在性保证。**HDP-Use 增设 model-instantiation 子型**(v2):给定非 product-space 用户模型 + 证书槽位表,要求出让全部证书并调通 arbitrary-history consumer;gold 形态 = `arbitraryHistory_quadraticForm_tail_usage`;public-dev 放 generated-history 情形,private-test 放真非标准模型。[TODO]

**6.3 Task manifest** ▸ YAML 示例一个(真实任务,截断)。[TODO]

**6.4 Splits and contamination** ▸ public-dev / private-test(hidden judge)/ future-commit;与 SLT 公开 dataset 的去重检查。[TODO]

**6.5 Metrics** ▸ Pass@k, JudgePass, Closedness gain, ReuseScore of new declarations, StatementDrift, DiffSize。每个一句定义。[TODO]

---

## 7. Experiments

**7.0 Setup** ▸ 模型列表、agent harness、预算、重复次数、显著性检验方式。[TODO]

**RQ1 指标能否区分 aux split 与 reusable abstraction?**
▸ 人工标注协议 → P/R/F1 表 → 错误分析一段。[TODO: 表 2]

**RQ2 两库 formalization style 是否可测地不同?**
▸ 指回 §5,补充统计显著性。[TODO]

**RQ3 roadmap 信息是否提升 agent 表现?(核心实验)**
▸ A/B 条件定义 → 主表(Δ 各指标 × tracks)→ 消融(只给 neighborhood / blockers / judge surface)→ 案例一则。[TODO: 表 3、表 4]

**RQ4 roadmap tasks 是否暴露 isolated benchmark 测不到的 failure modes?**
▸ 对比三种任务形态;归纳 failure mode 分类表(如:局部可证但选错 boundary;过 file 但破坏 judge)。[TODO: 表 5]

**RQ5 judge 能否抓住 build 抓不到的问题?**
▸ mutation 清单(rename public theorem / True-bodied fake / import boundary / weaken wrapper …)→ build vs judge 检出率表。[TODO: 表 6]

---

## 8. Case Study: The Lieb Route

▸ 本节是叙事高潮,按时间线写五幕:

**8.1 The endpoint view** ▸ SLT 的单体闭合长什么样(行数、文件结构、复用数据,全部引用其公开仓库,不贬低)。[TODO]

**8.2 The roadmap view** ▸ HighDimProb 侧:hardbone 登记 → 条件桥(Epstein→Lieb→Jensen→Tropp)全部先证 → 下游在 Lieb 未证时已可消费。[TODO]

**8.3 BLOCKED_CLEAN 如何止损死路** ▸ 二阶导数/sign-principle 路线的三份 blocker 报告;audit 结论"不是 calculus leaf";随后转向 Klein→Gibbs→joint convexity——该路线后被 SLT 独立采用并证完,说明 roadmap 审计提前识别了正确路线。[TODO: 时间线图,图 7]

**8.4 Closedness evolution** ▸ 用 git 历史画该路线 C0→C1→[TODO: 投稿时状态] 的阶梯演化;若已闭合(v2 endpoint 平价假设),写"原位替换、statement surface 零改动、judge 全绿"——这是 temporal decoupling 的完整生命周期实证。[TODO: 图 8]

**8.5 The payoff: arbitrary-history consumption**(v2 新增,收官幕)
▸ 展示 `arbitraryHistory_quadraticForm_tail_usage` 的完整前提列表(框图或代码块,~25 条证书按槽位分组着色),旁边并排 generated-history 的一行实例化。
▸ 论证句:同一条显式前提纪律,在 Lieb 未证完时让下游可用(8.2),证完后让 endpoint 对任意 `(Ω, F, P)` 可用(本幕)——"one discipline, two decouplings" 在一条路线的时间线上全部兑现。
▸ 收尾回扣 P1 的钩子问题。[TODO: 图 9]

---

## 9. Limitations

▸ 每条一两句,不辩解:
1. extraction 可能漏 elaborator-generated 依赖;
2. classifier 是 naming proxy + 人工校验;
3. closedness ≠ 数学重要性;provider assumption 可以是合理抽象;
4. benchmark v1 偏向 HighDimProb 风格,外部仓库泛化留待后续;
5. 工具、gold label、benchmark 同源作者(缓解:公开标注协议、κ、RQ5 无标签实验);
6. model-genericity 声明的范围只限 Matrix Bernstein 管线;非标准模型下的证书出让成本只经 benchmark 任务间接测量,未做用户研究。
[TODO]

---

## 10. Conclusion(1 段)

▸ 回扣 thesis + 一句话版本(v2):"SLT-style work shows these theorems *can* be closed in Lean; we show what architecture makes them usable *before* they close, generic over the user's probability space *after* they close, and auditable throughout — and make all three measurable."
[TODO]

---

## Appendix 清单

- A. 指标公式完整定义与实现细节 [TODO]
- B. classifier 规则全表 + 标注协议 + κ [TODO]
- C. 5 条 gold roadmap 全文(YAML)[TODO]
- D. benchmark 全部 task manifest 字段说明 [TODO]
- E. judge mutation 全清单与检出明细 [TODO]
- F. agent prompt 模板(baseline / tool-assisted)[TODO]
- G. 冻结 commit、版本、复现命令 [TODO]

## 图表总清单(投稿前核对)

| 编号 | 内容 | 状态 |
| --- | --- | --- |
| 图 0 | RM-LIEB 链 running example(+ history interface 槽位列) | [TODO] |
| 图 4.1 | 工具 pipeline | [TODO] |
| 图 1–3 | reuse 分布(预填数据有)/ closedness×abstraction / 路线 DAG | [TODO] |
| 图 7–8 | Lieb 时间线 / closedness 演化 | [TODO] |
| 图 9 | arbitrary-history 证书全景 vs generated-history 一行实例化(§8.5) | [TODO] |
| 表 1 | 双库聚合统计(预填数据见 design.md §8;冻结 SHA 后重跑) | [TODO] |
| 表 1b | Bernstein 入口定理 hypothesis diff(**先 diff 后下结论**) | [TODO] |
| 表 2 | RQ1 P/R/F1 | [TODO] |
| 表 3–4 | RQ3 主表 + 消融 | [TODO] |
| 表 5 | failure mode 分类 | [TODO] |
| 表 6 | RQ5 mutation 检出 | [TODO] |
