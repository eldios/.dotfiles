{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      virt-manager
    ];
  };
} # EOF
# vim: set ts=2 sw=2 et ai list nu
