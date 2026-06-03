{
  pkgs,
  config,
  outputs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.commons
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
  };

  home.username = "aglorei";

  # Cryptography
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  # SCM
  programs.git = {
    enable = true;
    settings = {
      user.name = config.home.username;
      user.email = "10876966+aglorei@users.noreply.github.com";
      init.defaultBranch = "main";
      commit.gpgSign = true;
      core.editor = "nvim";
      core.excludesFile = "${config.xdg.configHome}/git/ignore";
      user.signing.key = "E9D93DFD65E441AC3F30E71F7C210B28ED8839A2";
    };
  };

  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = ["config.local"];
  };
}
