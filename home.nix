{ config, lib, pkgs, specialArgs, ... }:
rec {
  home = {

    packages = with pkgs; [
      bash
      cowsay
      git-secret
      hello
      # pre-commit
    ];
  };

  # # Install the gitconfig file, as .gitconfig in the home directory
  # file = {
  #   "pre-commit-scripts.sh" = {
  #     source =./pre-commit-scripts.sh;
  #     recursive = true;
  #   };
  # };

  programs = {
    git = {
      enable = true;
      userName = "crthilakraj";
      userEmail = "crthilakraj@gmail.com";
      hooks = {
        # pre-commit = "~/pre-commit-scripts.sh";
        # pkgs.writeShellScriptBin "pre-commit-scripts.sh" ''
        #   set -e

        #   exit 1
        # '';
      };
    };
  };

  ## dotfiles


}