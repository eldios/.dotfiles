{ config, lib, pkgs, nixos-hardware, home-manager, ... }:

{
  imports =
    [
      # select hardware from https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
      nixos-hardware.nixosModules.common-cpu-intel
      nixos-hardware.nixosModules.common-gpu-intel

      ../../../common/nixos/locale.nix
      ../../../common/nixos/users.nix
      ../../../common/nixos/system.nix

      ../../../common/nixos/virtualisation.nix

      ./hardware-configuration.nix

      ./boot.nix
      ./system.nix
      ./network.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.eldios = import ../home-manager/home.nix;

        # Optionally, use home-manager.extraSpecialArgs to pass
        # arguments to home.nix
      }
    ];
}

# vim: set ts=2 sw=2 et ai list nu