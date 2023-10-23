{ config, lib, pkgs, specialArgs, ... }:
{
  home = {
    packages = [
      pkgs.cowsay
      pkgs.hello
    ];
  };
}