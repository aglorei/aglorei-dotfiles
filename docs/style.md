<!-- markdownlint-disable MD013 -->
# Style Guide

## Commit Messages

This repo uses [Conventional Commits](https://www.conventionalcommits.org/). Capitalize the first word after the type prefix:

```
feat: Add new host config
fix: Correct stateVersion for mikasa
chore: Update nixpkgs input
docs: Add architecture overview
refactor: Extract shared overlay helper
ci: Gate deploy on successful build
```

Common types: `feat`, `fix`, `chore`, `docs`, `refactor`, `ci`.

## Nix

**Attribute sets:** one attribute per line for multi-attribute sets.

```nix
# good
programs.git = {
  enable = true;
  settings = { ... };
};

# avoid
programs.git = { enable = true; settings = { ... }; };
```

**Function arguments:** destructure only what the module uses.

```nix
# good
{ pkgs, config, ... }: { ... }

# avoid: lists unused args
{ pkgs, config, lib, inputs, outputs, ... }: { ... }
```

**String interpolation:** prefer `${}` over concatenation.

```nix
# good
"${config.xdg.configHome}/nvim"

# avoid
config.xdg.configHome + "/nvim"
```

**`let...in`:** keep bindings close to where they're used rather than hoisting everything to the top of the file.

**Comments:** explain *why*, not *what*. If removing the comment wouldn't confuse a future reader, don't write it.

## YAML

YAML style is enforced by `yamllint` in CI using `.yamllint.yml` as the config. There is no local install; the `build` workflow is the authoritative check.
