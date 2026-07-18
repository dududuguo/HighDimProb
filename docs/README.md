# Documentation

This is the canonical index for HighDimProb documentation. Lean source files,
compiled examples, generated API docs, and `#check` remain authoritative for
exact declarations and signatures.

## Start Here

- [Project overview and installation](../README.md)
- [Import and API overview](user/APIOverview.md)
- [Supported scope and limitations](user/Status.md)
- [RandomMatrix caller API](user/RandomMatrixAPI.md)
- [Compiled examples](../HighDimProb/Examples/)
- [Contribution guide](../CONTRIBUTING.md)
- [Contributor workflow](maintainers/Workflow.md)

Downstream matrix-concentration code should normally import
`HighDimProb.RandomMatrix.Concentration`. `Provider.*` modules are expert and
implementation boundaries, not the default caller surface.

## User Documentation

- [API overview](user/APIOverview.md): choose the smallest supported import.
- [RandomMatrix API](user/RandomMatrixAPI.md): caller endpoints and assumptions.
- [Status](user/Status.md): currently supported scope and explicit limitations.

## Architecture

- [RandomMatrix architecture](architecture/RandomMatrixArchitecture.md): module
  ownership, dependency direction, and the public/provider boundary.
- [Module tree](architecture/ModuleTree.md): repository module layout.
- [Branch registry](architecture/BranchRegistry.md): branch ownership and
  promotion criteria.

## Reference

- [Term map](reference/TermMap.md): concept-to-source routing.
- [Theorem atlas](reference/TheoremAtlas.md): theorem-family coverage.
- [References](reference/References.md): mathematical sources and provenance.

## Maintainers

- [Workflow](maintainers/Workflow.md),
  [test plan](maintainers/TestPlan.md), and
  [judge system](maintainers/JudgeSystem.md)
- [Lean tooling](maintainers/LeanTooling.md) and
  [automation policy](maintainers/Automation.md)
- [RandomMatrix statement ledger](maintainers/STATEMENTS.md) and
  [assumption vocabulary](maintainers/AssumptionVocabulary.md)
- [Abstraction log](maintainers/AbstractionLog.md)
- [Active TODO](maintainers/TODO.md)

`maintainers/TODO.md` is the only active task authority. Do not infer current
work from proof-plan or historical documents.

## Archive And Visualizations

- [Archive index](archive/README.md): historical plans, milestones, and proof
  notes that do not describe current project state.
- [Visualizations](visualizations/index.md): curated module and proof-route
  diagrams.

Avoid adding theorem inventories or progress logs to this index. Stable routing
belongs in the documents above, exact APIs in Lean and generated docs, proof
evidence in `external/validation`, and usage demonstrations in examples.
