<!-- markdownlint-disable MD013 -->
# Customization

## Asset Overview

`modules/home-manager/commons.nix` symlinks these files into place at activation:

| Tool | Repo path | Destination |
|---|---|---|
| btop | `modules/home-manager/assets/btop/` | `$XDG_CONFIG_HOME/btop/` |
| fastfetch | `modules/home-manager/assets/fastfetch/` | `$XDG_CONFIG_HOME/fastfetch/` |
| Neovim | `modules/home-manager/assets/nvim/` | `$XDG_CONFIG_HOME/nvim/` |
| WezTerm | `modules/home-manager/assets/wezterm/wezterm.lua` | `$XDG_CONFIG_HOME/wezterm/wezterm.lua` |
| tmux | `modules/home-manager/assets/tmux/tmux.conf` | `~/.tmux.conf` |
| git ignore | `modules/home-manager/assets/git/ignore` | `$XDG_CONFIG_HOME/git/ignore` |

Starship is configured directly in `commons.nix` via `programs.starship.settings`; there is no standalone config file to edit.

## Neovim (LazyVim)

Entry point: `modules/home-manager/assets/nvim/init.lua` bootstraps [LazyVim](https://www.lazyvim.org/).

```
modules/home-manager/assets/nvim/
  init.lua               # LazyVim bootstrap
  lua/
    config/
      autocmds.lua
      keymaps.lua
      options.lua
      lazy.lua
    plugins/
      kanagawa.lua       # colorscheme
```

To add a plugin, create a new file under `lua/plugins/` following the [LazyVim plugin spec](https://www.lazyvim.org/configuration/plugins).

## WezTerm

Single config file: `assets/wezterm/wezterm.lua`. Color scheme is set to Kanagawa.

## tmux

Config file: `assets/tmux/tmux.conf`. The shell alias `hack` (defined in `commons.nix`) attaches to or creates a session named `hack`: `tmux a -t hack || tmux new -s hack`.

## Starship

Configured inline in `commons.nix` under `programs.starship.settings`. To add or remove prompt modules, edit that block directly.

## btop

Config and theme files live in `assets/btop/`. The Kanagawa theme is at `assets/btop/themes/kanagawa.theme`.

## fastfetch

Config at `assets/fastfetch/config.jsonc`.

## Theme Cohesion

[Kanagawa](https://github.com/rebelot/kanagawa.nvim) is used across Neovim (`lua/plugins/kanagawa.lua`) and WezTerm. To swap themes, update both.

## Unstable Packages

The `unstable-packages` overlay exposes `nixpkgs-unstable` as `pkgs.unstable`. To add an unstable package, reference it in `home.packages` within `commons.nix` or your user's `global/default.nix`:

```nix
home.packages = [
  pkgs.unstable.some-package
];
```

The overlay is applied in each user's `global/default.nix`. See [`docs/architecture.md`](architecture.md) for details.

## GitHub Copilot CLI

Installed from `pkgs.github-copilot-cli`. Authenticate and grant the required Copilot scope:

```sh
gh auth login
gh auth refresh -h github.com -s copilot
```

Then use:

```sh
gh copilot suggest "create a tarball of the current directory"
gh copilot explain "git rebase -i HEAD~3"
```
