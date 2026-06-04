<!-- markdownlint-disable MD013 -->
# Onboarding

## Adding a Host for an Existing User

**1. Add an entry to `homeConfigurations` in `flake.nix`:**

```nix
homeConfigurations = {
  "username@hostname" = mkHomeConfig {
    system = "aarch64-darwin"; # or x86_64-linux, x86_64-darwin
    modulePaths = [
      ./home/username/hostname.nix
    ];
  };
};
```

**2. Create `home/<user>/<host>.nix`:**

```nix
{ config, ... }: {
  imports = [ ./global ];

  home.homeDirectory = "/Users/${config.home.username}"; # or /home/... on Linux
  home.stateVersion = "26.05"; # set to the current NixOS release; never update after first activation
}
```

**3. Validate and activate:**

```sh
nix flake check
nix run home-manager/release-26.05 -- switch --flake .#username@hostname
```

## Adding a New User

Everything in the previous section, plus:

**Create `home/<user>/global/default.nix`:**

```nix
{ pkgs, outputs, ... }: {
  imports = [ outputs.homeManagerModules.commons ];

  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];

  home.username = "your-username";

  # User-specific config: git identity, GPG agent, SSH, additional packages, etc.
}
```

`global/default.nix` is a personal drop-in. Importing `commons` and applying the overlay are the only required pieces; everything else is up to the user. See [`docs/architecture.md`](architecture.md) for how the layers compose.
