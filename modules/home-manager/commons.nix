{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    # Archive
    pkgs.unzip

    # Client
    pkgs.awscli2
    pkgs.azure-cli
    pkgs.gh
    pkgs.github-copilot-cli
    pkgs.google-cloud-sdk

    # Containers
    pkgs.kubectl

    # Diagnostic
    pkgs.btop
    pkgs.fastfetch
    pkgs.pstree

    # Editor
    pkgs.neovim

    # Fonts
    pkgs.nerd-fonts.mononoki

    # Network
    pkgs.arp-scan
    pkgs.inetutils
    pkgs.nmap
    pkgs.wireshark

    # NodeJS
    pkgs.nodejs

    # Python
    pkgs.poetry
    pkgs.python3

    # Rust
    pkgs.cargo

    # Terminal
    pkgs.tmux

    # Terraform
    pkgs.terraform
    pkgs.terraform-docs

    # Utility
    pkgs.fasd
    pkgs.fd
    pkgs.fzf
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
  ];

  home.file = {
    # Diagnostic
    "${config.xdg.configHome}/btop" = {
      source = ./assets/btop;
      recursive = true;
    };

    "${config.xdg.configHome}/fastfetch" = {
      source = ./assets/fastfetch;
      recursive = true;
    };

    # Editor
    "${config.xdg.configHome}/nvim" = {
      source = ./assets/nvim;
      recursive = true;
    };

    # SCM
    "${config.xdg.configHome}/git/ignore".source = ./assets/git/ignore;

    # Terminal
    "${config.xdg.configHome}/wezterm/wezterm.lua".source = ./assets/wezterm/wezterm.lua;
    ".tmux.conf".source = ./assets/tmux/tmux.conf;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Home-Manager
  programs.home-manager.enable = true;

  # Prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.symbol = "  ";
      buf.symbol = " ";
      c.symbol = " ";
      cmake.symbol = " ";
      conda.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";
      directory.read_only = " 󰌾";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      git_branch.symbol = " ";
      git_commit.tag_symbol = "  ";
      golang.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      hostname.ssh_symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      ocaml.symbol = " ";
      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Kali = " ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        RockyLinux = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
      };
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      pijul_channel.symbol = " ";
      python.symbol = " ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      rust.symbol = "󱘗 ";
      scala.symbol = " ";
      swift.symbol = " ";
      zig.symbol = " ";
      gradle.symbol = " ";
    };
  };

  # Shell
  programs.zsh = {
    enable = true;
    shellAliases = {
      # list
      ls = "ls -G";
      ll = "ls -alhHF";

      # grep
      egrep = "egrep --color";
      fgrep = "fgrep --color";
      grep = "grep --color";

      # file utils
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
      ln = "ln -i";

      # tmux
      hack = "tmux a -t hack || tmux new -s hack";
    };
    syntaxHighlighting.enable = true;
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = ["git" "fasd" "fzf"];
  };
}
