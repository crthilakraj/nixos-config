{configs, pkgs, lib, ...}:
{
  boot.loader.grub.device = "/dev/sda";
  boot.loader.systemd-boot.enable = true; # (for UEFI systems only)
}