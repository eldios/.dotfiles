{ config, inputs, lib, pkgs, nixpkgs-unstable, peerix, portmaster, ... }:
let
  unstablePkgs = import nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  system = {
    stateVersion = "25.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    autoUpgrade.enable = true;
  };

  # Italy - Rome
  time.timeZone = lib.mkForce "Europe/Rome";

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services = {
    hardware = {
      openrgb = {
        enable = true;
        motherboard = "amd";
        package = pkgs.openrgb-with-all-plugins;
      };
    };

    fprintd = {
      enable = true;
    };

    # don’t shutdown when power button is short-pressed
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    peerix = {
      enable = true;
      package = peerix.packages.${pkgs.system}.peerix;
      openFirewall = false;
      #privateKeyFile = config.sops.secrets."keys/peerix/private".path;
      #publicKeyFile = config.sops.secrets."keys/peerix/public".path;
      #publicKey = "key1 key2 key3";
    };

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

    displayManager = {
      sddm.enable = false;

      sessionPackages = with unstablePkgs; [
        sway
        hyprland
      ];
    };

    xserver = {
      enable = true;
      autorun = true;

      videoDrivers = [ "amdgpu" ];

      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
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

    gvfs.enable = true;

    # CUPS
    printing.enable = true;
    # needed by CUPS for auto-discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  # run Android apps on linux
  virtualisation.docker.storageDriver = "btrfs";

  environment.systemPackages = (with pkgs; [
    clinfo
    gvfs
    i2c-tools
    jmtpfs
    openrgb-with-all-plugins
    qmk
    qmk-udev-rules
    qmk_hid
    sof-firmware
    v4l-utils
    via
    vial
  ]) ++ (with unstablePkgs; [ ]) ++ [
    portmaster.legacyPackages.${pkgs.system}.portmaster
  ];

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  # https://wiki.archlinux.org/title/GPGPU#ICD_loader_(libOpenCL.so)
  environment.etc."ld.so.conf.d/00-usrlib.conf".text = "/usr/lib";

  environment.sessionVariables = {
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    T_QPA_PLATFORM = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  environment.variables = {
    # If cursor is not visible, try to set this to "on".
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

    # https://wiki.archlinux.org/title/GPGPU
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        rocmPackages.clr.icd
        vaapiVdpau
      ];
    };

    amdgpu = {
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
        supportExperimental.enable = true;
      };
      opencl.enable = true;
      initrd.enable = true;
    };

    keyboard.qmk.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # audio
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true; # For PulseAudio applications
    alsa = {
      enable = true;
      support32Bit = true; # Good for compatibility
    };
    jack.enable = false; # PipeWire provides JACK library compatibility by default
    # so dedicated JACK server is not needed for most cases.
    wireplumber.enable = true; # Recommended session manager

    # You can rename 'noresample' to something more descriptive if you like,
    # e.g., 'custom-audio-properties'. The name becomes the .conf filename
    # in /etc/pipewire/pipewire.conf.d/
    extraConfig.pipewire."audio-quality-optimizations" = {
      "context.properties" = {
        # Core properties for bit-perfect playback and quality
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
        "default.clock.rate" = 48000; # Default rate when idle or unspecified
        "resample.quality" = 10; # Resampler quality (0-15 for SPA, 10 is very good, 15 is max)

        # Optional: Enforce a minimum buffer size for all streams for added stability.
        # This uses a newer PipeWire feature to override application requests for smaller quantums.
        # Your PipeWire version on NixOS (likely 0.3.83+ or 1.x) supports this.
        "vm.overrides" = {
          "default.clock.min-quantum" = 1024; # In samples. Default is 32.
          # 1024 samples at 48kHz = ~21.3ms buffer
          # 1024 samples at 192kHz = ~5.3ms buffer
          # "default.clock.quantum" = 2048; # You could also set a larger default quantum if desired.
          # Default is 1024.
        };

        # Other potential tweaks, usually not needed with modern DACs:
        # "alsa.no-htimestamp" = true; # Some ALSA drivers/devices might have issues with high-resolution timestamps.
        # Default is false (timestamps enabled). Try if you experience issues.
      };
    };
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
