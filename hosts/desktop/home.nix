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
    qimgv # Image viewer
    pavucontrol
    libreoffice
    #bitwarden-desktop
    #blueman
    #freecad
    #stirling-pdf # PDF editor
    #mullvad-vpn
    #qbittorrent
    #signal-desktop
    vscode
    prismlauncher
    android-tools
    heimdall-gui
    ### GNOME ###
    gnome-tweaks
    gnomeExtensions.top-bar-organizer
    gnomeExtensions.hibernate-status-button
    gnomeExtensions.appindicator
    gnomeExtensions.dash-in-panel
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "top-bar-organizer@julian.gse.jsts.xyz"
        "hibernate-status@dromi"
      ];
    };
  };

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

  programs.lutris = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix#desktop";
      update = "sudo nix flake update --flake ~/nix && sudo nixos-rebuild switch --flake ~/nix#desktop";
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
