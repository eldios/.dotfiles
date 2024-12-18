{ inputs, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }:

{
  imports =
    [
      # select hardware from https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
      # mininixos
      #nixos-hardware.nixosModules.common-cpu-amd
      # nucone
      nixos-hardware.nixosModules.intel-nuc-8i7beh
      nixos-hardware.nixosModules.common-cpu-intel

      nixos-hardware.nixosModules.common-pc-ssd

      ../../../common/nixos/sops.nix

      ../../../common/nixos/locale.nix

      ../../../common/nixos/users.nix
      ../../../common/nixos/system.nix

      ../../../common/nixos/programs/neovim.nix
      ../../../common/nixos/programs/zsh.nix

      ../../../common/nixos/virtualisation.nix

      ./hardware-configuration.nix

      ./boot.nix
      ./system.nix
      ./network.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.users.eldios = import ../home-manager/home.nix;

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit
            inputs
            nixpkgs
            nixpkgs-unstable
            home-manager
            nixos-hardware
            ;
        };
      }
    ];
}

# vim: set ts=2 sw=2 et ai list nu
