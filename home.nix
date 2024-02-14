{ config, lib, pkgs, specialArgs, ... }:
rec {
  home = {

    packages = with pkgs; [
      bash
      cowsay
      git-secret
      hello
      meslo-lg
      bashInteractive
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

  programs.git = {
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

  programs.terminator.enable = true;

  # zsh
  programs.zsh = {
    enable = true;
    plugins = [
      {
        # A prompt will appear the first time to configure it properly
        # make sure to select MesloLGS NF as the font in Konsole
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";

    };
  };


  fonts.fontconfig.enable = true;

  programs.direnv.enable = true;
  programs.vscode = rec {
    enable = true;
    package = pkgs.vscode;
    extensions = with (pkgs.forVSCodeVersion package.version).vscode-marketplace; [
      arrterian.nix-env-selector
      jnoortheen.nix-ide
      mhutchie.git-graph
      mkhl.direnv
      ms-python.flake8
      # ms-vscode-remote.remote-ssh
      # ms-vscode.cmake-tools
      ms-vscode.cpptools-extension-pack
      oderwat.indent-rainbow
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "files.trimTrailingWhitespace" = "true";
      "editor.stickyScroll.enabled" = "true";
    };
  };

  ## dotfiles

}