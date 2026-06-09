# Validation Logs

This folder keeps the small validation record that is useful in the public
repository.

It is not part of the Lean package, and it is not required for `lake build` or
`lake test`. Treat these files as background records for maintainers, not as the
public API.

Current contents:

- `matrix-bernstein-mainline-mb-s9/MILESTONE_SUMMARY.md`: current public
  Matrix Bernstein milestone summary.

Before committing new material here:

- Prefer a short milestone summary over a full scratch directory.
- Remove local paths, generated caches, and tool transcripts that are not useful
  later.
- Make sure the corresponding public state is reflected in `docs/Status.md` or
  the relevant API document.

New validation run directories are ignored by default. Keep scratch runs local,
or archive them outside the main repository. Force-add a new directory only when
it is intentionally part of the public development record.
