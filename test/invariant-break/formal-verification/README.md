# Formal Verification Tools

## Certora

Run with:

```
make certora
```

At the home directory.

## Halmos 

Run with:

```
make halmos
```

At the home directory.

## Kontrol 

Run with:

```
make kontrol-build
make kontrol-prove
```

At the home directory.

### What is `lemmas.k`?

`lemmas.k` is a file with additional lemmas (ie, rules) that help Kontrol with EVM-specific reasoning — they're in the process of adding these lemmas to Kontrol, but for now you have to add them manually.

### Notes

- `--fail-fast`: instructs Kontrol to stop exploration once we've identified a failing node;
- `--use-booster` tells it to use the (faster) booster backend;
- `--counterexample-information` requests Kontrol to generate a model, i.e., a counterexample for a failing node;
- `--auto-abstract-gas` abstracts any gas-related computations if infiniteGas is enabled (btw, it is enabled by default, so you don't have to use kevm.infiniteGas() cheatcode); in many cases, it speeds up the execution.
