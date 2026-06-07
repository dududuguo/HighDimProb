# MB-S7A Final Validation Summary

MB-S7A is the semantic spectral bridge milestone.

## API Outcomes
- `lambdaMaxOrdered` is the canonical ordered endpoint wrapper.
- Legacy `lambdaMax` remains available for compatibility.
- `SpectralUpperBound` and `RayleighUpperBound` are the semantic predicates for
  downstream spectral bounds.
- `scalarUpperTailEvent` and `matrixUpperBoundTailEvent` are the generic
  upper-tail event vocabulary.

## Proven
- Generic bridge from `SpectralUpperBound` to `RayleighUpperBound`.
- Generic Rayleigh/spectral upper-tail event bridges.
- `lambdaMaxOrdered_spectralUpperBound`.
- `lambdaMaxOrderedPSDUpperBound`.
- `lambdaMaxOrdered_rayleighUpperBound`.

## Still Not Proved
- Legacy `lambdaMax = lambdaMaxOrdered` compatibility.
- Trace-mgf.
- Golden-Thompson / Lieb.
- Matrix Bernstein.

## Current Next Safe Task
MB-S8-real-rhs-bridge: connect the lintegral matrix Laplace theorem to the
existing real trace-exp moment/RHS vocabulary, without proving trace-mgf or
Matrix Bernstein.
