# Lean documentation and import graph tooling

This repository is wired to use two upstream Lean tools:

- `doc-gen4` for mathlib-style declaration documentation.
- `importGraph` for official Lean import graph output.

## doc-gen4

The documentation build lives in `docbuild/`.

`docbuild/lakefile.toml` pins `leanprover/doc-gen4` to `v4.29.1`, matching
`lean-toolchain`.

Run:

```powershell
.\tools\build_docgen4.ps1
```

Or from Bash/Git Bash:

```bash
./tools/build_docgen4.sh
```

The expected output root is:

```text
docbuild\.lake\build\doc\index.html
```

The `HighDimProb` Lake library has two documentation roots:

- `HighDimProb` for the stable import surface.
- `HighDimProb.Experimental` for the explicitly experimental API surface.

This is a documentation visibility choice only. It does not make
`import HighDimProb` import experimental declarations.

On this Windows setup, `doc-gen4` successfully builds the documentation
database and many module pages, but currently crashes in the final
`doc-gen4.exe fromDb` phase with exit code `3221225477` (Windows access
violation). The partial pages are under:

```text
docbuild\.lake\build\doc\
```

The current failure is in the upstream native HTML generation stage, not in
the `HighDimProb` Lean sources.

## importGraph

`importGraph` is already available through the mathlib dependency and is
materialized at `.lake/packages/importGraph`.

Run:

```powershell
.\tools\build_import_graph.ps1
```

Or from Bash/Git Bash:

```bash
./tools/build_import_graph.sh
```

This generates:

```text
docs\visualizations\lake_import_graph.dot
docs\visualizations\lake_import_graph.html
```

These files are the raw official import graph output.
