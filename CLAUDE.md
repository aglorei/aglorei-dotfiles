<!-- markdownlint-disable MD013 -->
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Applying Configuration

To activate the home configuration for the current user and host:

```sh
nix run home-manager/release-25.05 -- switch --flake .#$(whoami)@$(hostname -s)
```

To update flake inputs (e.g., nixpkgs, home-manager):

```sh
nix flake update
```

## Linting

YAML files are linted with yamllint (run in CI on every PR and push to main):

```sh
yamllint --format github --strict .
```

## Architecture

**`flake.nix`** is the entry point. It defines `homeConfigurations` as a map of `"username@hostname"` strings to Home Manager configurations built via `mkHomeConfig { system, modulePaths }`. Each entry composes modules from `home/<user>/` and `modules/home-manager/`.

**`home/<user>/<host>.nix`** is the per-host config. It imports `./global` (which imports the shared `outputs.homeManagerModules.commons` module) and sets host-specific values like `home.homeDirectory` and `home.stateVersion`. User-level packages, git config, GPG, and SSH live in `home/<user>/global/default.nix`.

**`modules/home-manager/commons.nix`** is the shared base. It installs all common packages (`home.packages`), links asset files into `$XDG_CONFIG_HOME` via `home.file`, and configures zsh (with Oh My Zsh), starship, and shell aliases.

**`modules/home-manager/assets/`** contains raw config files for tools (Neovim/LazyVim, WezTerm, tmux, starship, btop, fastfetch, git ignore). These are symlinked into place by `commons.nix`.

**`overlays/default.nix`** defines three overlays: `additions` (custom pkgs), `modifications` (overrides), and `unstable-packages` (exposes `pkgs.unstable` backed by `nixpkgs-unstable`). Access unstable packages in any module as `pkgs.unstable.<name>`.

**`pkgs/default.nix`** and **`overlays/default.nix`** work together: `overlays.additions` imports pkgs through the final nixpkgs set, making custom packages available as `pkgs.<name>`.

## Adding a New Host or User

1. Add an entry to `homeConfigurations` in `flake.nix` with the `"username@hostname"` key.
2. Create `home/<user>/<host>.nix` (import `./global`, set `home.homeDirectory` and `home.stateVersion`).
3. Create `home/<user>/global/default.nix` for user-specific packages, git config, etc.

## CI / Release

- **build** workflow: runs `yamllint` on PRs and pushes to `main`, plus weekly on Wednesdays.
- **deploy** workflow: triggers `release-please` after a successful build on `main` to manage changelog and releases.
