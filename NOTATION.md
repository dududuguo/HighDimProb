# Notation Policy

HighDimProb prefers readable mathematical notation when it is already standard in Mathlib or common Lean probability code.

## Unicode

Allowed common symbols include:

- `ℕ` for natural numbers
- `ℝ` for real numbers
- `Ω` for sample spaces
- `ε` for epsilon/radius parameters
- `μ` for generic measures
- `P` for probability measures

Avoid obscure Unicode, visually confusable symbols, and notation that is hard to type or search.

## Variable Conventions

- `Ω`: sample space
- `P`: probability measure
- `X Y`: scalar random variables
- `A`: random matrix
- `m n`: finite dimensions
- `i j k`: finite indices
- `K`: scale parameter

## Locality

- Keep notation local or scoped when possible.
- Do not introduce new notation before the underlying API stabilizes.
- Prefer explicit names over notation for experimental declarations.
- Avoid package-wide notation for theorem-statement layers or proof pilots.

## Stability

Notation is part of the API. New notation requires the same review discipline as a new abstraction, including tests and documentation.
