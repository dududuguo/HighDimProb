# Statement Assumption Ledger

This file lists hard analytic assumptions that progress-first RandomMatrix
contracts are allowed to consume explicitly while separate provider work fills
them in.  Entries here are not claims that the assumptions are proved.

## RM-LIEB-S8: Tropp one-step `K` bound from explicit Lieb/log-order inputs

Consumer theorem:

- `troppMasterTraceMGFStep_trace_bound_of_liebJensen_logOrder`

This theorem composes existing thin consumers and requires the following hard
facts as explicit premises:

- `troppMasterTraceMGFStep_of_liebJensen_statement H Z`, the source-level
  statement target reducing the Tropp one-step primitive to Lieb/Jensen facts.
- `liebJensenTraceExp_statement H (fun omega => matrixExp (Z omega))`, the
  Jensen consequence of Lieb trace-exponential concavity for the exponential
  random matrix.
- `forall omega, matrixExpLogSelfAdjointNormalization_statement (Z omega)`, the
  pointwise `log (exp Z) = Z` normalization target.
- `troppLogExpComparisonToK_of_logOrderKChain_statement H
  (matrixExpect P (fun omega => matrixExp (Z omega))) K`, the statement-chain
  target for replacing the logarithmic one-step RHS by a deterministic `K`.
- `matrixLog_le_of_le_matrixExp_statement
  (matrixExpect P (fun omega => matrixExp (Z omega))) K`, the explicit
  operator-log/log-domain bridge for the matrix MGF mean.
- `traceMatrixExp_mono_add_selfAdjoint_statement H
  (CFC.log (matrixExpect P (fun omega => matrixExp (Z omega)))) K`, the
  trace-exponential monotonicity step after adding the history matrix.
- The ordinary side conditions consumed by `troppMasterTraceMGFStep_statement`
  and `troppLogExpComparisonToK_statement`: self-adjointness, random
  self-adjointness, trace integrability, matrix-exp integrability, strict
  positivity of the matrix-exp mean, self-adjointness of `K`, and the MGF
  Loewner comparison against `matrixExp K`.

Non-goals for this consumer:

- It does not prove Lieb concavity, Jensen, operator-log monotonicity,
  trace-exp monotonicity, Golden-Thompson, conditional expectation,
  integrability propagation, variance-proxy control, or full Matrix Bernstein.
