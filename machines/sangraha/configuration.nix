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
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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


}
