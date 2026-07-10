# RandomMatrix Architecture

This page defines module ownership and dependency direction for the supported
finite-dimensional RandomMatrix surface. It is an architecture contract, not
a theorem index; use [`RandomMatrixAPI.md`](RandomMatrixAPI.md) for theorem
families and exact import guidance.

## Public Import Layers

| Layer | Preferred import | Ownership |
|---|---|---|
| Base | `HighDimProb.RandomMatrix` | objects, algebra, order, spectra, trace-exp vocabulary, statements |
| Analysis | `HighDimProb.RandomMatrix.Provider.Analysis` | deterministic matrix calculus, resolvents, relative entropy, Lieb/Epstein, Golden--Thompson |
| Conditioning | `HighDimProb.RandomMatrix.Provider.Conditioning` | kernels, frozen-parameter conditional expectation, natural histories |
| Concentration | `HighDimProb.RandomMatrix.Provider.Concentration` | integrability compression, trace-MGF, tail assembly, scoped Matrix Bernstein |
| Broad provider facade | `HighDimProb.RandomMatrix.Provider` | all three provider layers |
| Compatibility | `HighDimProb.RandomMatrix.LiebProvider` | historical broad provider import; no new ownership |

`HighDimProb.RandomMatrix.MatrixBernsteinProvider` remains the narrow endpoint
import for generated-history operator-norm and high-probability Matrix
Bernstein results.

## Dependency Direction

```text
HighDimProb.RandomMatrix
        |
        +--> Provider.Analysis ---------+
        |                               |
        +--> Provider.Conditioning -----+--> Provider.Concentration
                                                |
                                                +--> Provider
```

The intended dependency rules are:

1. Base modules do not import provider facades.
2. Deterministic analysis does not import conditioning or concentration.
3. Conditioning may use base statements but does not own Bernstein assembly.
4. Concentration may depend on analysis and conditioning.
5. Applications and examples import the narrowest layer they consume.
6. `LiebProvider` remains compatible but is not an ownership boundary.

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

Support is theorem-contract specific. The finite-dimensional left/right
Lieb/Epstein route, Golden--Thompson, Bernstein CFC, and generated-history
Matrix Bernstein endpoints are proved under their stated hypotheses. Arbitrary
external histories, automatic application-specific variance proxies,
assumption-weaker integrability, and unconditional full Matrix Bernstein are
outside this supported scope unless a referenced theorem states otherwise.
