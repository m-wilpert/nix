{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

  home = { 
    username = "mika";
    homeDirectory = "/home/mika";
    stateVersion = "25.05"; # Do not change
  };

  home.packages = with pkgs; [
    dconf
  ];

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    HYPRSHOT_DIR = /home/mika/Screenshots;
  };

  home.sessionPath = [
    "/Nixos/scripts"
    "/Nixos/scripts/nixos"
    "/Nixos/scripts/system"
    "/Nixos/scripts/hypr"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
