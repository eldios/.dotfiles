{ pkgs, ... }:
{
  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 5;
    };

    supportedFilesystems = [ "zfs" ];

    #kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_6_7;
    kernelParams =
    [
      "nohibernate"
      "zfs.zfs_arc_max=6442856000"
    ];

    initrd = {
      supportedFilesystems = [ "zfs" ];
      kernelModules = [ "uas" "usbcore" "usb_storage" "usbhid" "vfat" "nls_cp437" "nls_iso8859_1" ];

      luks = {
        devices = {
          "K" = {
            device = "/dev/nvme0n1p2"; # << LUKS partition
          };
        };
      };
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable             = true;
        device             = "nodev";
        efiSupport         = true;
        zfsSupport         = true;
        enableCryptodisk   = true;
        configurationLimit = 14;
      };
    };
  };
}

# vim: set ts=2 sw=2 et ai list nu
