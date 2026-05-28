# Physical Migration Plan

## Current Policy

- Logical branch aggregates exist now.
- Physical migration happens only when a branch becomes large enough.
- `HighDimProb/RandomMatrix/` is already physically migrated.
- `Scalar`, `Vector`, `Geometry`, `Process`, and `Statements` are not physically migrated yet.

## Suggested Migration Order

1. Concentration, because it is new and can start physically clean.
2. RandomMatrix, already done.
3. Vector.
4. Geometry.
5. Scalar.
6. Process.
7. Statements.

## Migration Rules

- Migrate one branch per PR or commit.
- Update imports in package modules and tests.
- Do not make mathematical changes during migration.
- Run `lake build`.
- Run `lake test`.
- Keep compatibility aliases or forwarding imports if downstream users need them.
- Update `docs/ModuleTree.md`, `docs/BranchRegistry.md`, and `docs/Status.md` with the migration result.

