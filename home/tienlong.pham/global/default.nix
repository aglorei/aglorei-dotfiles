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

  home.username = "tienlong.pham";

  # Cryptography
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  # SCM
  programs.git = {
    enable = true;
    includes = [{path = "${config.xdg.configHome}/git/config.local";}];
    settings = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      core.excludesFile = "${config.xdg.configHome}/git/ignore";
    };
  };

  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = ["config.local"];
  };
}
