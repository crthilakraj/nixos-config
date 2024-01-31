# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: let
  username = "tchikmagalore";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "sangraha"; # Define your hostname.
  networking.wireless.environmentFile = config.sops.secrets."wireless".path;
  networking.wireless.networks = {
    enable = true;
    "@name@" = {
      psk = "@pass@";
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "deadgraveacute";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      git
      sops
      age
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXMaiggm/K/Sa15wps/K2h5b/J/NDUYBotKhVRdoN5sI6WNcQWO29d/3/vLJgLN2ca4nS9np96E0G1+ZFG+hO+gL9BIviL37J6LsQLwEGiTrbnpZ8eATA6drv1IOeVSTJFuY8CzjerbrTD8u5v7kU8/Ib81x3wBLW5TC6KRL7sUWWNfgqP2WNfou6QraVDojTlWiqgNIuQiqIOGw6KX8plB5fRlGe4e23WoHBfC6lV+eBR9KEjzhVppegDkXP1tpDHr5Tca0x6+I8QAu7WEMNl5nIB9o4IMwXTxrikRv3WN0HzCLCzjlYBNUDlOxAwADs8qErHBeRLPtP/Btd+w7Az8SQVCswtDgA0FHlXGiWBiDznBNhXtrsj98QY17yII9LQgTpdSO4u15X0nGS1uOtxJZCukWcX7/pXsybzqIfH/tbC6Deh0Nd3ogyzZaNT5v89u6VNfvVTaVOsF7yE796qqUOlVhovIF0DrFhq7UW9703qTJa57lGyy4ekD1hB06k= tchikmagalore@tchikmagalore"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQy3qxLd5bkldwmWxNdBrvp6gUDzrDp9p9Me3C5HoJp3m+OqiLekmlRo5XxgVcmr2KqKnHCd+y4cOnhE9wI6PgLeobIBhCYSxwa+0lYbOxlOa1qA2KSK4rlwc3EoYIxKl8RT0LeD5RVyzs+AO8pyGEsdg4L3nu0TtX7GdPQlngB2qmToXZ+tTI+V3qBS+vzWIXrqzNLRvutIi+Y8vFY+EFhhFG+IDXENN4kVoIBRundORBCbmn8WTkXO2ASVf3ibhaTIrFSC0/yoR4t/313uOrzJpf7RcRq1TZF94KfT4EqREydcakkn0iX7UsITHfQP7xmwDI4WduKbqa7cfBp5vj2F4qxeqtzvUrRvVS5xGOvIUM/DvfJeIjuAYLohxm8o7JWevuNHDUu0g78JhayVaYVArEph1z47CpO7/JRo6WdMhZIPtU+RQwkVV/HtEAU0yfjZm7LXzsMIOnjF/NbwDKpTwtCnOzKALml3A8ZOrWvmYQT9qsmqZv2dIHJ9RLfvU= thc2mu@NST-C-00007"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.forwardX11 = true;
  };

  # firewall settings
  networking.firewall ={
    enable = true;
    allowedTCPPorts = [5000];
    allowedUDPPorts = [];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # vscode server settings
  services.vscode-server.enable = true;

  #sops setting
  sops.defaultSopsFile = ./secrets.yml;
  sops.age.keyFile = "${config.users.users.tchikmagalore.home}/.config/sops/age/system.txt";
  sops.secrets."wireless" = {
    mode = "0440";
    owner = config.users.users.nobody.name;
  };

  ## nix settings
  nix.settings.experimental-features = [ "nix-command" ];
  nix.settings.trusted-public-keys = [
    "abivruddi:4KY+yYoLr8MvG1VPmaVqj+ye5jHqyQKLv6cShSueyLo="
  ];

  ## nix-serve config
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/binary-cache.pem";
    port = 5000;
  };

}
