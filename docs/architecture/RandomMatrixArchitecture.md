# RandomMatrix Architecture

This page defines module ownership and dependency direction for the supported
finite-dimensional RandomMatrix surface. It is an architecture contract, not
a theorem index or the repository-wide import map; use
[`APIOverview.md`](../user/APIOverview.md) for general routing and
[`RandomMatrixAPI.md`](../user/RandomMatrixAPI.md) for theorem families and exact
import guidance.

## User-Facing Public Imports

| Layer | Preferred import | Ownership |
|---|---|---|
| Base | `HighDimProb.RandomMatrix` | objects, algebra, order, spectra, trace-exp vocabulary, statements |
| Concentration | `HighDimProb.RandomMatrix.Concentration` | public trace-MGF, tail, Matrix Bernstein, and sample-covariance theorem surface |

`HighDimProb.RandomMatrix.Concentration` is the default downstream import. The
`Provider.*` hierarchy is expert implementation infrastructure; use its narrow
layers for provider development or reuse of those proof boundaries. The public
concentration facade preserves explicit primitive, measurability,
integrability, independence, radius, variance-proxy, and parameter-domain
hypotheses where the exported theorem requires them. It is not an unconditional
Matrix Bernstein theorem.

## Expert And Internal Provider Boundaries

| Layer | Import | Ownership |
|---|---|---|
| Analysis provider | `HighDimProb.RandomMatrix.Provider.Analysis` | deterministic matrix calculus, resolvents, relative entropy, Lieb/Epstein, Golden--Thompson |
| Conditioning provider | `HighDimProb.RandomMatrix.Provider.Conditioning` | kernels, frozen-parameter conditional expectation, natural histories |
| Concentration provider | `HighDimProb.RandomMatrix.Provider.Concentration` | implementation assembly re-exported by the public concentration facade |
| Broad provider facade | `HighDimProb.RandomMatrix.Provider` | all three expert provider layers |
| Compatibility | `HighDimProb.RandomMatrix.LiebProvider` | historical broad provider import; no new ownership |

`HighDimProb.RandomMatrix.MatrixBernsteinProvider` is the implementation leaf
for generated-history operator-norm and high-probability Matrix Bernstein
results. Normal downstream consumers should use the public concentration facade.

## Dependency Direction

```text
HighDimProb.RandomMatrix
        |
        +--> Provider.Analysis ---------+
        |                               |
        +--> Provider.Conditioning -----+--> Provider.Concentration
                                                +--> RandomMatrix.Concentration
                                                |
                                                +--> Provider (expert facade)
```

The intended dependency rules are:

1. Base modules do not import provider facades.
2. Deterministic analysis does not import conditioning or concentration.
3. Conditioning may use base statements but does not own Bernstein assembly.
4. Concentration may depend on analysis and conditioning.
5. The public concentration facade re-exports concentration assembly without
   owning declarations.
6. Applications and downstream examples use the public facade; provider-proof
   development imports the narrowest expert layer it consumes.
7. `LiebProvider` remains compatible but is not an ownership boundary.

## File Ownership

Leaf modules continue to own declarations. Facades contain imports and module
documentation only. New declarations belong in the narrowest leaf matching
their mathematics:

- deterministic matrix/CFC/resolvent facts: an analysis provider leaf;
- sigma-algebra, kernel, or conditional expectation facts: a conditioning leaf;
- trace-MGF, tail, or Bernstein composition: a concentration leaf;
- application vocabulary: `HighDimProb/Examples` or `HighDimProb/Applications`.

Do not place declarations in `Provider.lean`, the three layer facades, or
`LiebProvider.lean`.

## Compatibility And Physical Layout

Existing flat `*Provider.lean` paths remain public. Logical facades are
introduced before physical file moves so downstream imports do not break.
A future physical migration may move a coherent leaf family only when:

- its facade boundary has remained stable;
- compatibility modules preserve old imports when practical;
- source, test, judge, example, and documentation imports are updated together;
- focused builds, `lake build`, and `lake test` pass.

The large `ConcentrationStatements.lean` file is a candidate for a separate
contract-driven split, but it is not moved as part of the facade refactor.

## Mathematical Scope

Support remains theorem-contract specific on both the public facade and expert
provider imports. The finite-dimensional left/right Lieb/Epstein route,
Golden--Thompson, Bernstein CFC, and generated-history Matrix Bernstein
endpoints are proved under their stated hypotheses. Arbitrary external
histories, automatic application-specific variance proxies, assumption-weaker
integrability, and unconditional full Matrix Bernstein are outside this
supported scope unless a referenced theorem states otherwise.
