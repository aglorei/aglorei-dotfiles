<!-- markdownlint-disable MD013 -->
# Architecture

## Layer Overview

```
flake.nix
  └── home/<user>/<host>.nix
        └── home/<user>/global/default.nix
              └── modules/home-manager/commons.nix
                    └── modules/home-manager/assets/
```

| Layer | Responsibility |
|---|---|
| `flake.nix` | Entry point; defines inputs, `mkHomeConfig`, and `homeConfigurations` |
| `home/<user>/<host>.nix` | Per-host settings: `home.homeDirectory`, `home.stateVersion` |
| `home/<user>/global/default.nix` | Per-user drop-in: git, GPG, SSH, user-specific packages |
| `modules/home-manager/commons.nix` | Shared base: packages, asset symlinking, zsh, starship |
| `modules/home-manager/assets/` | Raw config files symlinked into `$XDG_CONFIG_HOME` |

## flake.nix

Defines two inputs, `nixpkgs` (stable) and `nixpkgs-unstable`, and the `mkHomeConfig` helper, which wraps `homeManagerConfiguration` and accepts a `system` string and a list of `modulePaths`. Each entry in `homeConfigurations` is a `"username@hostname"` string mapped to a `mkHomeConfig` call.

## home/\<user\>/\<host\>.nix

The per-host file has two jobs: import `./global` and set the two host-specific values.

```nix
{ config, ... }: {
  imports = [ ./global ];

  home.homeDirectory = "/Users/${config.home.username}";
  home.stateVersion = "26.05";
}
```

> **`home.stateVersion`** should be set to the NixOS release at the time of first activation and never updated afterward. It governs state migration behavior in Home Manager; changing it after the fact can corrupt managed state.

## home/\<user\>/global/default.nix

A personal drop-in. The only required wiring is importing `outputs.homeManagerModules.commons` and applying `outputs.overlays.unstable-packages`. Everything else (git identity, GPG agent, SSH config, additional packages) is user-defined.

```nix
{ pkgs, outputs, ... }: {
  imports = [ outputs.homeManagerModules.commons ];

  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];

  home.username = "your-username";
  # user-specific config here
}
```

## modules/home-manager/commons.nix

The shared base module. Installs common packages via `home.packages`, symlinks asset directories into `$XDG_CONFIG_HOME` via `home.file`, and configures zsh (with Oh My Zsh) and starship. Everything in this module applies to all users.

## modules/home-manager/assets/

Raw configuration files symlinked into place at activation:

| Tool | Asset path | Destination |
|---|---|---|
| btop | `assets/btop/` | `$XDG_CONFIG_HOME/btop/` |
| fastfetch | `assets/fastfetch/` | `$XDG_CONFIG_HOME/fastfetch/` |
| Neovim | `assets/nvim/` | `$XDG_CONFIG_HOME/nvim/` |
| WezTerm | `assets/wezterm/wezterm.lua` | `$XDG_CONFIG_HOME/wezterm/wezterm.lua` |
| tmux | `assets/tmux/tmux.conf` | `~/.tmux.conf` |
| git ignore | `assets/git/ignore` | `$XDG_CONFIG_HOME/git/ignore` |

Starship is configured directly in `commons.nix` via `programs.starship.settings`; there is no linked file.

## overlays/default.nix

Defines the `unstable-packages` overlay, which makes the `nixpkgs-unstable` package set available as `pkgs.unstable`. Applied in `home/<user>/global/default.nix` via `nixpkgs.overlays`. Access unstable packages in any module as `pkgs.unstable.<name>`.
