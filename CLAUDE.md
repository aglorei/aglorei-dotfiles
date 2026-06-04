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

**`flake.nix`** is the entry point. It defines `homeConfigurations` as a map of `"username@hostname"` strings to Home Manager configurations built via `mkHomeConfig { system, modulePaths }`. Each entry composes modules from `home/<user>/` and `modules/home-manager/`.

**`home/<user>/<host>.nix`** is the per-host config. It imports `./global` and sets `home.homeDirectory` and `home.stateVersion`. Do not update `home.stateVersion` after initial deployment — it should reflect the NixOS release when that user's config was first activated, not the current release.

**`home/<user>/global/default.nix`** imports `outputs.homeManagerModules.commons` and sets user-level config: git (with GPG signing), GPG agent (`pinentry-curses`), and SSH. SSH is configured with `enableDefaultConfig = false` and `includes = ["config.local"]` so machine-specific host entries can live in an untracked `~/.ssh/config.local`.

**`modules/home-manager/commons.nix`** is the shared base. It installs all common packages (`home.packages`), links asset files into `$XDG_CONFIG_HOME` via `home.file`, and configures zsh (with Oh My Zsh), starship, and shell aliases.

**`modules/home-manager/assets/`** contains raw config files for tools (Neovim/LazyVim, WezTerm, tmux, btop, fastfetch, git ignore). These are symlinked into place by `commons.nix`.

**`overlays/default.nix`** defines the `unstable-packages` overlay, which exposes `pkgs.unstable` backed by `nixpkgs-unstable`. Access unstable packages in any module as `pkgs.unstable.<name>`. The overlay is applied per-user in `home/<user>/global/default.nix` via `nixpkgs.overlays`.

## Adding a New Host or User

1. Add an entry to `homeConfigurations` in `flake.nix` with the `"username@hostname"` key.
2. Create `home/<user>/<host>.nix` (import `./global`, set `home.homeDirectory` and `home.stateVersion`).
3. Create `home/<user>/global/default.nix` for user-specific packages, git config, etc. Import `outputs.homeManagerModules.commons` and apply `outputs.overlays.unstable-packages`.

## Commit Style

Use [Conventional Commits](https://www.conventionalcommits.org/). Capitalize the first word after the type prefix:

```
docs: Add validation step
feat: Add new host config
chore: Update nixpkgs input
```

## CI / Release

- **build** workflow: runs `yamllint` on PRs and pushes to `main`, plus weekly on Wednesdays.
- **deploy** workflow: triggers `release-please` after a successful build on `main` to manage changelog and releases.
