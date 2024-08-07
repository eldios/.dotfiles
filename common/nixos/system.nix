{ inputs, pkgs, config, lib, ... }:
{
  zramSwap.enable = true;
  systemd.services.zfs-mount.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.variables.EDITOR = "nvim";
  programs = {
    zsh.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      configure = {
        customRC = ''
          set modeline
          colorscheme gruvbox
          set nu list sw=2 ts=2 expandtab
        '';
        package.myVimPackage = with pkgs.vimPlugins; {
          start = [
            vim-nix
            gruvbox
          ];
        };
      };
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # nix
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      # Nix Settings
      auto-optimise-store = true; # Auto Optimize nix store.
      experimental-features = [ "nix-command" "flakes" ]; # Enable experimental features.
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  services = {
    fwupd.enable = true;

    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowAgentForwarding = true;
      };
    };

    smartd = {
      enable = true;
      autodetect = true;
    };

    fstrim = {
      enable = true;
      interval = "daily";
    };

    pcscd.enable = true;

    tailscale.enable = true;

  };

  environment.systemPackages = with pkgs; [
    # hard reqs
    binutils
    btrfs-progs
    git
    libgcc
    nix-tree
    pinentry-curses # required by GPG
    python3
    ripgrep
    screen
    smartmontools
    tmux
    wget
    zfs

    # utils
    age
    btop
    byobu
    colorls # like `ls --color=auto -F` but cooler
    cryptomator
    fastfetch
    ffmpeg
    gnumake
    htop
    just
    lshw
    manix
    mdadm
    rclone
    sops
    yubikey-personalization

    # WAYLAND + SWAY
    dbus # make dbus-update-activation-environment available in the path
    glib # gsettings
  ];

  security = {
    polkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}

# vim: set ts=2 sw=2 et ai list nu
