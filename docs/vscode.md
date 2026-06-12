<!-- markdownlint-disable MD013 -->
# VS Code

A vim-first VS Code configuration for machines that are not managed by Home Manager (for example, a Windows machine where nix is unavailable). The configuration lives in [`modules/home-manager/assets/vscode/`](../modules/home-manager/assets/vscode/) and is applied by downloading the files into place; there are no scripts and no automation.

The modal editing layer is [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim), which embeds a real headless neovim instance rather than emulating vim. Combined with LazyVim's `vscode` extra, the same neovim configuration in [`modules/home-manager/assets/nvim/`](../modules/home-manager/assets/nvim/) drives editing inside VS Code.

## 1. Install neovim (user-level)

vscode-neovim requires a real `nvim` executable on the machine.

**Windows** (no administrator rights required):

```powershell
curl.exe --location --remote-name https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip
Expand-Archive nvim-win64.zip -DestinationPath $env:LOCALAPPDATA
```

Then add it to the user PATH so VS Code can find it:

```powershell
[Environment]::SetEnvironmentVariable("Path", "$env:LOCALAPPDATA\nvim-win64\bin;" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
```

Sign out and back in (or restart VS Code from a fresh shell) for the PATH change to take effect. Verify with `nvim --version`.

**macOS / Linux**: neovim is already provided by Home Manager on managed hosts. On unmanaged hosts, install it with the system package manager and confirm `nvim` resolves on PATH.

## 2. Pull the VS Code config

Download the two files into the VS Code user directory.

**Windows** (`%APPDATA%\Code\User\`):

```powershell
curl.exe --location --output "$env:APPDATA\Code\User\settings.json" https://raw.githubusercontent.com/aglorei/dotfiles/main/modules/home-manager/assets/vscode/settings.json
curl.exe --location --output "$env:APPDATA\Code\User\keybindings.json" https://raw.githubusercontent.com/aglorei/dotfiles/main/modules/home-manager/assets/vscode/keybindings.json
```

**macOS** (`~/Library/Application Support/Code/User/`):

```sh
curl --location --output "$HOME/Library/Application Support/Code/User/settings.json" https://raw.githubusercontent.com/aglorei/dotfiles/main/modules/home-manager/assets/vscode/settings.json
curl --location --output "$HOME/Library/Application Support/Code/User/keybindings.json" https://raw.githubusercontent.com/aglorei/dotfiles/main/modules/home-manager/assets/vscode/keybindings.json
```

Machine-specific overrides (for example, an explicit `vscode-neovim.neovimExecutablePaths.win32` if PATH discovery is not viable) are edited directly into the downloaded copy and stay local to that machine.

## 3. Pull the nvim config and enable the vscode extra

Place the nvim configuration from this repository into the OS config directory.

**Windows** (`%LOCALAPPDATA%\nvim\`):

```powershell
git clone --depth 1 https://github.com/aglorei/dotfiles.git "$env:TEMP\dotfiles"
Copy-Item -Recurse -Force "$env:TEMP\dotfiles\modules\home-manager\assets\nvim\*" "$env:LOCALAPPDATA\nvim\"
```

Run `nvim` once in a terminal so lazy.nvim bootstraps and installs plugins. Then enable LazyVim's `vscode` extra for this machine: run `:LazyExtras`, move to the `vscode` entry, and press `x` to toggle it on. This persists to the machine-local `lazyvim.json` (alternatively, add `"lazyvim.plugins.extras.vscode"` to the `extras` array of that file by hand).

LazyVim extras are machine-local state by design in this setup: the repository guarantees the base configuration, and each machine enables the extras it needs. The `vscode` extra only activates inside VS Code (`vim.g.vscode`), so terminal neovim on the same machine is unaffected.

## 4. Install extensions

```sh
code --install-extension asvetliakov.vscode-neovim
```

Where relevant:

```sh
code --install-extension amazonwebservices.amazon-q-vscode
```

If a real neovim binary cannot be installed on the machine, `vscodevim.vim` is the emulation fallback; it requires no binary but is less faithful to vim behavior.

## 5. Optional: install Mononoki Nerd Font (user-level)

Download `Mononoki.zip` from the [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases), extract it, select the `.ttf` files, right-click, and choose "Install for current user" (no administrator rights required on Windows 10 1809 or later). `settings.json` falls back to Consolas and Cascadia Code when the font is absent.

## 6. Survival map for a vim user

The vscode-neovim extension translates neovim window commands into VS Code editor group commands, so LazyVim's `ctrl+h/j/k/l` window navigation works across editor splits. The checked-in `keybindings.json` extends the same keys to the terminal and sidebar, and adds `ctrl+j`/`ctrl+k` navigation in lists, Quick Open, and the suggest widget. Note that `ctrl+j`/`ctrl+k` in the integrated terminal shadow the readline newline and kill-line bindings.

| Habit | VS Code equivalent |
| --- | --- |
| Telescope find files | Quick Open: `ctrl+p` |
| Telescope live grep | Search view: `ctrl+shift+f` |
| `:vsplit` / `:split` | vscode-neovim translates `ctrl+w v` / `ctrl+w s` into editor groups |
| Buffer switching | `ctrl+p` (recent files float to the top), or `ctrl+tab` |
| File explorer | `ctrl+shift+e` (sidebar), `ctrl+h`/`ctrl+l` to move focus in and out |
| Integrated terminal | `` ctrl+` `` to toggle, `ctrl+h/j/k/l` to escape back to the editor |
| Command palette | `ctrl+shift+p` (the `:command` analog) |
| Code actions | LazyVim LSP mappings are inert; use `ctrl+.` |
| Go to definition / references | `gd` and `gr` work via vscode-neovim's VS Code bindings |

Editing-focused plugins (mini.surround, mini.ai, mini.comment, treesitter text objects, flit, leap, yanky) remain active through the `vscode` extra, so motions, surrounds, and text objects behave like terminal neovim. UI plugins (neo-tree, bufferline, lualine, telescope, completion, LSP) are disabled inside VS Code because VS Code owns those concerns.

## 7. Future: managing this config with Home Manager

On nix-managed hosts, these files can be symlinked the same way the nvim config is wired in [`modules/home-manager/commons.nix`](../modules/home-manager/commons.nix) (a `home.file` entry targeting the VS Code user directory), or managed through the `programs.vscode` module. This is deliberately not done yet; the config currently targets unmanaged machines only.
