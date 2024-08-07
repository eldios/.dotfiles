{ inputs, config, lib, pkgs, nixpkgs-unstable, ... }:
let
  unstablePkgs = import nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  secretspath = builtins.toString inputs.secrets;
in
{
  system = {
    stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    autoUpgrade.enable = true;
  };

  time.timeZone = lib.mkForce "Europe/Rome";

  sops.secrets = {
    "passwords/lele9iyoga/eldios" = {
      sopsFile = "${secretspath}/lele9iyoga.yaml";
      neededForUsers = true;
    };

    "keys/ssh/eldios/lele9iyoga/public" = {
      sopsFile = "${secretspath}/lele9iyoga.yaml";
    };
    "keys/ssh/eldios/lele9iyoga/private" = {
      sopsFile = "${secretspath}/lele9iyoga.yaml";
    };
  };

  services = {
    # BEGIN - laptop related stuff
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    # END - laptop related stuff
    btrfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
    };

    cloudflared.enable = true;

    xserver = {
      enable = true;
      autorun = true;

      displayManager = {
        sddm.enable = false;

        gdm.enable = true;
        gdm.wayland = true;

        sessionPackages = with unstablePkgs; [
          sway
          hyprland
        ];
      };

      windowManager = {
        i3 = {
          enable = true;
          extraPackages = with pkgs; [
            dmenu
            i3status
            i3lock
            i3blocks
          ];
        };
      };
    };

    # save and manage secrets and passwords
    gnome.gnome-keyring.enable = true;

    # CUPS
    printing.enable = true;
    # needed by CUPS for auto-discovery
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };

  # run Android apps on linux
  virtualisation.waydroid.enable = false;
  virtualisation.docker.storageDriver = "btrfs";

  environment.systemPackages = with pkgs; [
    sof-firmware
    qmk
    qmk-udev-rules
    qmk_hid
    vial
  ];

  programs = {
    steam.enable = true;
    streamdeck-ui = {
      enable = true;
      autoStart = true;
      package = unstablePkgs.streamdeck-ui;
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    uinput.enable = true; # needed by xRemap

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    opengl = {
      enable = true;
      driSupport = true;
      #driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        #vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime
        intel-graphics-compiler
        intel-ocl
        opencl-info
        opencl-headers
      ];
    };

    keyboard.qmk.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      #pkgs.xdg-desktop-portal-hyprland
    ];
  };

  users.users.eldios = {
    hashedPasswordFile = config.sops.secrets."passwords/lele9iyoga/eldios".path;

    extraGroups = [
      "input" # needed by xRemap
      "uinput" # needed by xRemap
    ];
  };

  # audio
  sound.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = false;
  };
  services.blueman = {
    enable = true;
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;

  services.udev.packages = [ pkgs.via ];

  security = {
    pam.services.swaylock = { };
  };

}

# vim: set ts=2 sw=2 et ai list nu
