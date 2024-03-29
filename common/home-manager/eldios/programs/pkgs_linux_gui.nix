# vim: set ts=2 sw=2 et ai list nu
{ lib, pkgs, nixpkgs-unstable, ... }:
let
  unstablePkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;

  # obsidian - 2nd brain - patch taken from https://github.com/NixOS/nixpkgs/issues/273611
  obsidian = lib.throwIf (lib.versionOlder "1.4.16" pkgs.obsidian.version) "Obsidian no longer requires EOL Electron" (
    pkgs.obsidian.override {
      electron = pkgs.electron_25.overrideAttrs (_: {
        preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
        meta.knownVulnerabilities = [ ]; # NixOS/nixpkgs#273611
      });
    }
  );
in
{
  home = {
    packages = ([ obsidian ]) ++ (with pkgs; [
      # utils
      cava
      cavalier
      graphviz
      playerctl
      yazi

      # GUI stuff
      alacritty # gpu accelerated terminal
      alacritty-theme # alacritty themes
      beeper
      bitwarden
      brave
      cryptomator
      discord
      geoclue2
      kitty
      light # brightness control
      openlens
      paperview
      pavucontrol
      redshift
      signal-desktop
      slack
      spotify-unwrapped
      steam
      syncthing
      syncthing-cli
      syncthing-tray
      telegram-desktop
      variety
      vscode
      whatsapp-for-linux
      widevine-cdm
      zoom-us

      # 3D printing
      super-slicer
      prusa-slicer
      cura

    ]) # EOM pkgs
    ++ ( with unstablePkgs; [
      vesktop # discord + some fixes
      mailspring
    ]); # EOM unstablePkgs
  }; # EOM home
}

# vim: set ts=2 sw=2 et ai list nu
