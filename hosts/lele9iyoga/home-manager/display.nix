{ pkgs, ... }:
{
  imports = [
    ../../../common/home-manager/eldios/programs/i3.nix
    ../../../common/home-manager/eldios/programs/mako.nix
    ../../../common/home-manager/eldios/programs/sway.nix
    ../../../common/home-manager/eldios/programs/hyprland.nix
    ../../../common/home-manager/eldios/programs/waybar.nix
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme = {
        name = "gtk";
    };
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      # cursor theme
      #package = pkgs.bibata-cursors;
      #package = pkgs.whitesur-cursors;
      package = pkgs.capitaine-cursors;
      #package = pkgs.phinger-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
  };

} # EOF
# vim: set ts=2 sw=2 et ai list nu
