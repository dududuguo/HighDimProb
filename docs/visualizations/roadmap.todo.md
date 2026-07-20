# Theory Roadmap — Leaf-Level Formalization Tasks
> 生成于 2026-06-28
> 共 59 个叶任务（从原 22 个概念桶细化）
> ✅ 38 已完成 • 🔄 10 进行中 • 🚫 4 阻塞 • ⏳ 7 待开始

## 粒度口径

- 一个 roadmap 条目应对应一个 Lean 叶模块组、provider contract、example/test surface，或文档化 blocker；避免用“随机矩阵”“集中不等式”这类教材章节级概念作为最小任务。
- 状态以当前仓库文档和文件为准：已存在并被索引/测试的叶标为 `integrated`；仍是当前 RandomMatrix/Matrix Bernstein 工作面的标为 `in_progress`；文档明确不能声称已证明的 provider 缺口标为 `blocked`；后续 theorem family 标为 `pending`。
- Git 审计结果：当前只有未跟踪文档/可视化产物：`docs/visualizations/roadmap.html`、`docs/visualizations/roadmap.todo.md`、`wiki_pages_found.md`。

## Depth 0 (仓库与导入面)

- [ ] 🔄 **git-change-audit** — git 变更审计与未跟踪产物登记
  - 状态: `in_progress` / 进行中
  - 模块/文档: `docs/visualizations/roadmap.todo.md; docs/visualizations/roadmap.html; wiki_pages_found.md`
- [x] ✅ **stable-root-import** — 稳定根导入面：Init / Scalar / Statements (依赖: git-change-audit)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb.lean; HighDimProb/Init.lean; HighDimProb/Scalar.lean; HighDimProb/Statements.lean`
- [x] ✅ **experimental-aggregate** — 实验聚合导入面：Vector / Geometry / Concentration / RandomMatrix / LimitTheorems / Process (依赖: stable-root-import)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Experimental.lean`
- [x] ✅ **docs-status-indices** — 当前状态索引：Status / TODO / LeafPlan / API 文档保持短链路 (依赖: git-change-audit)
  - 状态: `integrated` / 已完成
  - 模块/文档: `docs/user/Status.md; docs/maintainers/TODO.md; docs/archive/LeafPlan.md; docs/user/APIOverview.md`
- [ ] 🔄 **wiki-concept-index** — Wikipedia 概念对照表用于外部概念索引，不作为证明进度来源 (依赖: git-change-audit)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `wiki_pages_found.md`

## Depth 1 (标量概率对象)

- [x] ✅ **probability-space-events** — 概率空间、事件和可测事件对象层 (依赖: stable-root-import)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Basic.lean; HighDimProb/ProbabilitySpace.lean`
- [x] ✅ **random-variable-distribution** — 随机变量、分布和期望桥接 (依赖: probability-space-events)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomVariable.lean; HighDimProb/Distribution.lean; HighDimProb/Expectation.lean`
- [x] ✅ **tail-moment-variance-covariance** — 尾部、矩、方差、协方差基础 API (依赖: random-variable-distribution)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Tail.lean; HighDimProb/Moment.lean; HighDimProb/Scalar/Variance.lean; HighDimProb/Covariance.lean`
- [x] ✅ **lp-orlicz-scale** — Lp 与 Orlicz 标量尺度 (依赖: tail-moment-variance-covariance)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Lp.lean; HighDimProb/Orlicz.lean`
- [x] ✅ **random-family-vocabulary** — RandomFamily / Process / Sample 词汇层；不含 filtrations 或 conditioning (依赖: random-variable-distribution)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomFamily.lean; HighDimProb/RandomProcess.lean; HighDimProb/Process.lean`
- [x] ✅ **analysis-carriers** — 实不等式、自伴载体和正域分析辅助 (依赖: stable-root-import)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Analysis.lean; HighDimProb/Analysis/*.lean`

## Depth 2 (标量集中脊柱)

- [x] ✅ **concentration-basic-tail** — 集中基础尾部事件与通用引理 (依赖: tail-moment-variance-covariance)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Concentration/Basic.lean`
- [x] ✅ **layer-cake-markov-chebyshev** — Layer cake、Markov、Chebyshev 叶模块 (依赖: concentration-basic-tail)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Concentration/LayerCake.lean; Markov.lean; Chebyshev.lean`
- [x] ✅ **mgf-tail-cycle** — MGF 到尾部与尾部到 Orlicz/MGF 的桥接 (依赖: lp-orlicz-scale, layer-cake-markov-chebyshev)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Concentration/MGF.lean; OrliczToTail.lean; TailToOrlicz.lean`
- [x] ✅ **moment-implications** — 矩、Orlicz、固定尺度次高斯/次指数蕴含图 (依赖: mgf-tail-cycle)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Concentration/MomentImplications.lean; Implications.lean`
- [x] ✅ **subgaussian-sums** — 次高斯变量和与固定尺度矩桥 (依赖: moment-implications)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/SubGaussian.lean; HighDimProb/Concentration/SubGaussianSums.lean`
- [x] ✅ **subexponential-sums** — 次指数变量和、最大尺度和 Bernstein 原料 (依赖: moment-implications)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/SubExponential.lean; HighDimProb/Concentration/SubExponentialSums.lean; MaxScale.lean`
- [x] ✅ **rademacher-hoeffding** — Rademacher 分布/族、Rademacher 和、Hoeffding (依赖: subgaussian-sums)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Distributions/*.lean; Concentration/RademacherSums.lean; Hoeffding.lean`
- [x] ✅ **scalar-bernstein** — 标量 Bernstein min-form 与加权版本 (依赖: subexponential-sums, mgf-tail-cycle)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Concentration/Bernstein.lean`

## Depth 3 (几何/向量/极限定理)

- [x] ✅ **nets-metric-entropy** — Nets、覆盖/填装数、度量熵声明 (依赖: analysis-carriers)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Nets.lean; MetricEntropy.lean; MetricEntropyStatements.lean`
- [x] ✅ **gaussian-width-geometry** — 高斯宽度和几何词汇层 (依赖: nets-metric-entropy, subgaussian-sums)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/GaussianWidth.lean; HighDimProb/Geometry.lean`
- [x] ✅ **random-vector-isotropy** — 随机向量、各向同性和向量聚合 API (依赖: random-variable-distribution, lp-orlicz-scale)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomVector.lean; Isotropic.lean; Vector.lean`
- [x] ✅ **subgaussian-vector** — 次高斯随机向量接口 (依赖: random-vector-isotropy, subgaussian-sums)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/SubGaussianVector.lean`
- [x] ✅ **empirical-process-vocabulary** — 经验过程与过程侧词汇 (依赖: random-family-vocabulary, nets-metric-entropy)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/EmpiricalProcess.lean; HighDimProb/Process.lean`
- [x] ✅ **weak-law-scaffold** — 样本均值、弱大数定律和假设词汇 (依赖: random-variable-distribution, scalar-bernstein)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/LimitTheorems/*.lean`
- [x] ✅ **signal-recovery-statements** — 信号恢复/陈述层占位与术语索引 (依赖: gaussian-width-geometry, subgaussian-vector)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/SignalRecovery.lean; HighDimProb/BookStatements.lean; docs/maintainers/STATEMENTS.md`

## Depth 4 (随机矩阵基础层)

- [x] ✅ **rm-basic-rowscols-action** — 随机矩阵基元、行列和矩阵-向量作用 (依赖: random-vector-isotropy)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/Basic.lean; RowsCols.lean; Action.lean`
- [x] ✅ **rm-norms-operatornorm-unitsphere** — 矩阵范数、算子范数和单位球面 (依赖: rm-basic-rowscols-action, nets-metric-entropy)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/Norms.lean; OperatorNorm.lean; UnitSphere.lean`
- [x] ✅ **rm-selfadjoint-order-spectral** — 自伴、PSD/Loewner 序和谱桥 (依赖: analysis-carriers, rm-norms-operatornorm-unitsphere)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/SelfAdjoint.lean; MatrixOrder.lean; Spectral.lean`
- [x] ✅ **rm-expectation-sums-vp** — 矩阵期望、有限和、方差代理 (依赖: rm-selfadjoint-order-spectral, random-family-vocabulary)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/Expectation.lean; Sums.lean; VarianceProxy.lean`
- [x] ✅ **rm-quadratic-samplecovariance** — 二次型、样本协方差和随机矩阵代数 (依赖: rm-expectation-sums-vp, random-vector-isotropy)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/QuadraticForm.lean; SampleCovariance.lean; Algebra.lean`
- [x] ✅ **rm-statement-atlas** — RandomMatrix statement atlas / hardbone typed targets (依赖: rm-quadratic-samplecovariance, scalar-bernstein)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/Statements.lean; ConcentrationStatements.lean; HardboneStatements.lean`

## Depth 5 (TraceExp / Tropp 提供者层)

- [x] ✅ **trace-exp-core** — TraceExp 核心 API 与 Laplace 路由 (依赖: rm-statement-atlas)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/TraceExp.lean; Laplace.lean`
- [x] ✅ **trace-exp-monotonicity** — trace-exp 导数、单调性和 provider witness (依赖: trace-exp-core, rm-selfadjoint-order-spectral)
  - 状态: `integrated` / 已完成
  - 模块/文档: `TraceExpDerivative.lean; TraceExpMonotonicity.lean; TraceExpMonotonicityProvider.lean`
- [x] ✅ **cstar-log-order-transport** — CStar transport、矩阵 log provider 与 log/order bridge (依赖: trace-exp-monotonicity, analysis-carriers)
  - 状态: `integrated` / 已完成
  - 模块/文档: `CStarBridge.lean; CStarOrderTransport.lean; MatrixLogProvider.lean; TraceExpLogOrderProvider.lean`
- [x] ✅ **tropp-state-bookkeeping** — prefix/suffix partial sum 和 natural trace state bookkeeping (依赖: trace-exp-core, rm-expectation-sums-vp)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/Sums.lean; TraceExpTroppStepProvider.lean`
- [ ] 🔄 **trace-mgf-consumer** — 有限族 trace-MGF consumer 与条件步骤组合 (依赖: tropp-state-bookkeeping, cstar-log-order-transport)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/TraceExp.lean; docs/maintainers/STATEMENTS.md`
- [ ] 🔄 **provider-facades** — Lieb/Tropp provider-facing import layer (依赖: trace-mgf-consumer)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/LiebProvider.lean; EpsteinProvider.lean; NaturalHistoryProvider.lean`
- [x] ✅ **support-dimension-bridges** — rank/support/excess-support trace bound consumers (依赖: trace-exp-monotonicity)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/RandomMatrix/SupportProvider.lean; HardboneStatements.lean`

## Depth 6 (矩阵 Bernstein / 样本协方差消费者)

- [ ] 🔄 **matrix-bernstein-assumption-bundles** — CFC-free Matrix Bernstein Tropp assumption bundles (依赖: provider-facades, scalar-bernstein)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- [ ] 🔄 **matrix-bernstein-tail-wrappers** — 二次型、two-sided、operator-norm Matrix Bernstein tail wrappers (依赖: matrix-bernstein-assumption-bundles, trace-mgf-consumer)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/ConcentrationStatements.lean; Laplace.lean`
- [ ] 🔄 **sample-covariance-compact-route** — 读者优先的 bounded-row sample-covariance target/record route (依赖: matrix-bernstein-tail-wrappers, rm-quadratic-samplecovariance)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/SampleCovariance.lean; ConcentrationStatements.lean`
- [ ] 🔄 **exact-row-centered-square-infra** — exact-row centered-square wrapper/bundle infrastructure (依赖: sample-covariance-compact-route)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/SampleCovariance.lean; VarianceProxy.lean`
- [ ] 🔄 **negative-side-transfer** — negative-side exact-row variance-proxy transfer adapters (依赖: exact-row-centered-square-infra)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/SampleCovariance.lean`
- [x] ✅ **reader-example-routes** — 读者级 RandomMatrix / sample covariance / feature-kernel examples (依赖: sample-covariance-compact-route)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Examples/RandomMatrix/*.lean; HighDimProb/Examples/RandomMatrixUsage.lean`
- [x] ✅ **judge-api-coverage** — HighDimProbTest 与 HighDimProbJudge 覆盖 public route (依赖: reader-example-routes, matrix-bernstein-tail-wrappers)
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProbTest/*.lean; HighDimProbJudge/**/*.lean`

## Depth 7 (当前硬骨头提供者缺口)

- [ ] 🚫 **epstein-lieb-concavity** — Epstein/Lieb concavity provider：当前显式假设，未证明 (依赖: provider-facades)
  - 状态: `blocked` / 阻塞
  - 模块/文档: `HighDimProb/RandomMatrix/EpsteinProvider.lean; LiebProvider.lean`
- [ ] 🚫 **conditioning-independence-bridge** — 有限族 independence / conditional-expectation bridge (依赖: trace-mgf-consumer, random-family-vocabulary)
  - 状态: `blocked` / 阻塞
  - 模块/文档: `HighDimProb/RandomMatrix/TraceExpTroppStepProvider.lean`
- [ ] 🚫 **trace-exp-integrability-propagation** — trace-exp integrability propagation provider (依赖: trace-exp-core, provider-facades)
  - 状态: `blocked` / 阻塞
  - 模块/文档: `HighDimProb/RandomMatrix/TraceExpIntegrabilityProvider.lean`
- [ ] 🔄 **natural-history-measurability** — natural history measurability / suffix-entry provider (依赖: tropp-state-bookkeeping)
  - 状态: `in_progress` / 进行中
  - 模块/文档: `HighDimProb/RandomMatrix/NaturalHistoryProvider.lean`
- [ ] 🚫 **variance-proxy-sharp-provider** — sample covariance hardbone sharp-chain provider 缺口 (依赖: exact-row-centered-square-infra)
  - 状态: `blocked` / 阻塞
  - 模块/文档: `HighDimProb/RandomMatrix/VarianceProxy.lean; SampleCovariance.lean`
- [ ] ⏳ **support-provider-construction** — 非平凡 support domination / excess support construction (依赖: support-dimension-bridges)
  - 状态: `pending` / 待开始
  - 模块/文档: `HighDimProb/RandomMatrix/SupportProvider.lean`
- [ ] ⏳ **tail-event-domination** — trace-MGF route 到 tail-event 的 domination 前提消解 (依赖: matrix-bernstein-tail-wrappers)
  - 状态: `pending` / 待开始
  - 模块/文档: `HighDimProb/RandomMatrix/Laplace.lean; ConcentrationStatements.lean`

## Depth 8 (后续定理族与稳定化)

- [ ] ⏳ **full-matrix-bernstein** — 完整 Matrix Bernstein 定理：仅在 provider 缺口关闭后推进 (依赖: epstein-lieb-concavity, conditioning-independence-bridge, trace-exp-integrability-propagation, variance-proxy-sharp-provider, tail-event-domination)
  - 状态: `pending` / 待开始
  - 模块/文档: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- [x] ✅ **hanson-wright** — 有限实矩阵 Hanson-Wright 中心二次型双侧尾界
  - 状态: `integrated` / 已完成
  - 模块/文档: `HighDimProb/Concentration/HansonWright.lean; HighDimProbTest/HansonWrightAPI.lean`
- [ ] ⏳ **covariance-estimation** — 协方差估计与 operator-norm deviation theorem family (依赖: sample-covariance-compact-route, full-matrix-bernstein)
  - 状态: `pending` / 待开始
  - 模块/文档: `docs/archive/LeafPlan.md; HighDimProb/RandomMatrix/SampleCovariance.lean`
- [ ] ⏳ **jl-rip-statements** — Johnson-Lindenstrauss / RIP / signal recovery statements (依赖: gaussian-width-geometry, covariance-estimation)
  - 状态: `pending` / 待开始
  - 模块/文档: `HighDimProb/SignalRecovery.lean; docs/archive/LeafPlan.md`
- [ ] ⏳ **strong-law-process-chaining** — SLLN、subGaussian increments 和 chaining/VC 过程族 (依赖: weak-law-scaffold, empirical-process-vocabulary)
  - 状态: `pending` / 待开始
  - 模块/文档: `HighDimProb/LimitTheorems/*.lean; HighDimProb/Process.lean`
- [ ] ⏳ **stable-promotion-audit** — 实验模块升入稳定根的测试/文档/API 审计 (依赖: full-matrix-bernstein, covariance-estimation, strong-law-process-chaining)
  - 状态: `pending` / 待开始
  - 模块/文档: `docs/architecture/ModuleTree.md; docs/maintainers/TestPlan.md`
