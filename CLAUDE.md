<!-- markdownlint-disable MD013 -->
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Validation

Before applying any configuration change, verify the flake is valid:

```sh
nix flake check
```

## Applying Configuration

To activate the home configuration for the current user and host:

```sh
nix run home-manager/release-26.05 -- switch --flake .#$(whoami)@$(hostname -s)
```

> **Note:** This command mutates the live environment. It should only be run by the user, never autonomously by an agent.

To update flake inputs (e.g., nixpkgs, home-manager):

```sh
nix flake update
```

When updating flake inputs, also update the `home-manager/release-26.05` reference in this file and in the switch command above to match the new release.

## Linting

YAML files are linted with yamllint (run in CI on every PR and push to main):

```sh
yamllint --format github --strict .
```

## Architecture

Layers: `flake.nix` → `home/<user>/<host>.nix` → `home/<user>/global/default.nix` → `modules/home-manager/commons.nix` → `modules/home-manager/assets/`. Do not update `home.stateVersion` after initial deployment. Unstable packages are available as `pkgs.unstable.<name>` via the overlay in `overlays/default.nix`.

See [`docs/architecture.md`](docs/architecture.md) for the full walkthrough.

## Adding a New Host or User

1. Add `"username@hostname"` to `homeConfigurations` in `flake.nix`.
2. Create `home/<user>/<host>.nix`: import `./global`, set `home.homeDirectory` and `home.stateVersion`.
3. Create `home/<user>/global/default.nix`: import `outputs.homeManagerModules.commons`, apply `outputs.overlays.unstable-packages`.

See [`docs/onboarding.md`](docs/onboarding.md) for the full procedure with examples.

## Commit Style

Use [Conventional Commits](https://www.conventionalcommits.org/). Capitalize the first word after the type prefix: `docs: Add validation step`. See [`docs/style.md`](docs/style.md) for the full style guide including Nix conventions.

## CI / Release

- **build** workflow: runs `yamllint` and `nix flake check` on PRs and pushes to `main`, plus weekly on Wednesdays.
- **deploy** workflow: triggers `release-please` after a successful `build` on `main`.

See [`docs/ci.md`](docs/ci.md) for the full workflow inventory.
