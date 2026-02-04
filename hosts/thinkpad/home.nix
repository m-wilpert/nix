{ config, pkgs, inputs, ... }:

{
  # imports = [
    
  # ];

  home = { 
    username = "mika";
    homeDirectory = "/home/mika";
    stateVersion = "25.05"; # Do not change
  };

  home.packages = with pkgs; [
    obsidian
    #discord
    mpv # Video utility
    #spotify
    #gimp
    #qimgv # Image viewer
    pavucontrol
    libreoffice
    octaveFull
    #bitwarden-desktop
    #blueman
    #freecad
    #stirling-pdf # PDF editor
    #mullvad-vpn
    #qbittorrent
    signal-desktop
    zapzap
    vscode
    #prismlauncher
    android-tools
    heimdall-gui
    #### GNOME ####
    gnome-tweaks
    gnomeExtensions.top-bar-organizer
    #gnomeExtensions.hibernate-status-button # abandoned
    gnomeExtensions.appindicator
    gnomeExtensions.dash-in-panel
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs; [
          gnomeExtensions.top-bar-organizer.extensionUuid
          #gnomeExtensions.hibernate-status-button # abandoned
          gnomeExtensions.appindicator.extensionUuid
          gnomeExtensions.dash-in-panel.extensionUuid
        ];
      };
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "adwaita";
  #   style.name = "adwaita-dark";
  # };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Mika Wilpert";
      user.email = "mika.wilpert@gmail.com";
    };
  };

  programs.anki = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix#thinkpad";
      update = "sudo nix flake update --flake ~/nix && sudo nixos-rebuild switch --flake ~/nix#thinkpad";
    };
  };

  # home.sessionVariables = {
  #   TERMINAL = "alacritty";
  #   EDITOR = "nvim";
  #   VISUAL = "nvim";
  # };

  # home.sessionPath = [
  # ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
