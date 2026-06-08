<!-- markdownlint-disable MD013 -->
# Dotfiles

Configurations that I use in a [flakes](https://wiki.nixos.org/wiki/Flakes) approach. You can if you want, but no one is forcing you to.

## Batteries Included

### Editor

- [Neovim](https://neovim.io/) with [LazyVim](https://www.lazyvim.org/)

### Terminal

- [WezTerm](https://wezfurlong.org/wezterm/)

### Font

- [Mononoki Nerd Font](https://madmalik.github.io/mononoki/)

### Shell

- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [tmux](https://github.com/tmux/tmux/wiki)

### Theme

- [Kanagawa](https://github.com/rebelot/kanagawa.nvim) (for Neovim and terminal)

See [docs/customization.md](docs/customization.md) for configuration details.

## Structure

- `flake.nix`: Flake entrypoint, defines system/home-manager configurations.
- `modules/home-manager/`: Home Manager modules and assets (Neovim, WezTerm, etc).
- `home/<user>/<host>.nix`: Per-user, per-host Home Manager configs.
- `overlays/`: Custom Nix overlays.

See [docs/architecture.md](docs/architecture.md) for a full architecture walkthrough.

## Installation

### Prerequisites

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Nix](https://nix.dev/install-nix) (with flakes enabled)

### Step 1: Clone Repository

Clone the repository to your directory of choosing.

```sh
git clone https://github.com/aglorei/dotfiles $HOME/github.com/aglorei/dotfiles
```

### Step 2: Enable Flakes

If flakes are not already enabled, opt in as an experimental feature [without additional command-line options](https://wiki.nixos.org/wiki/Flakes#Other_Distros,_without_Home-Manager).

### Steps 3–4: Configure and Activate

See [docs/onboarding.md](docs/onboarding.md) for adding a host configuration and activating it.

## Acknowledgements

- [Nix Starter Configurations](https://github.com/Misterio77/nix-starter-configs)
