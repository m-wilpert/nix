{ config, pkgs, inputs, ... }:

{
  imports = [ 
      ./hardware-configuration.nix
      ./system-modules
      ../../modules/nixos
      inputs.home-manager.nixosModules.default 
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-d77f25e7-47d7-4a33-a45c-f8fe835a0029".device = "/dev/disk/by-uuid/d77f25e7-47d7-4a33-a45c-f8fe835a0029";
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    # themePackages = [ pkgs.plymouth-themes ];
    theme = "breeze";
  };


  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  home-manager = {
    extraSpecialArgs = { inherit inputs; }; # Passes inputs to HM modules
    useGlobalPkgs = true; # NixOS and HM use the same global packages
    users = {
      "mika" = { 
        imports = [
          ../../hosts/thinkpad/home.nix
          #inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
    backupFileExtension = "backup";
  };

  # Automate store optimisation
  nix.optimise.automatic = true;

  # Automate garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.libinput.enable = true;

  # Enables Hyprland at system-level to avoid troubles with SDDM
  programs.hyprland.enable = true;

  # Fix SDDM not starting any DE session
  services.dbus.packages = with pkgs; [ dconf ];
  
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    # Prevent cursor from becoming invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
  };
  
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];
  hardware.nvidia.open = true;  # see the note above

  # xdg.portal = {
  #   enable = true;
  #   config.common.default = "*";
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #     xdg-desktop-portal-wlr
  #   ];
  # };

  # systemd.user.services = {
  #   # GTK portal for FileChooser dialogs
  #   xdg-desktop-portal-gtk = {
  #     description = "GTK XDG Desktop Portal";
  #     after = [ "graphical-session.target" ];
  #     wantedBy = [ "default.target" ];
  #     serviceConfig = {
  #       ExecStart = "${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk";
  #       Restart = "on-failure";
  #     };
  #   };

  #   # WLR portal for Wayland integration
  #   xdg-desktop-portal-wlr = {
  #     description = "WLR XDG Desktop Portal";
  #     after = [ "graphical-session.target" ];
  #     wantedBy = [ "default.target" ];
  #     serviceConfig = {
  #       ExecStart = "${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr";
  #       Restart = "on-failure";
  #     };
  #   };
  # };

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    git
    home-manager
    starship
    nix-prefetch
    nix-prefetch-github
    exfatprogs
    jmtpfs
    mtpfs
    gvfs
    #gvfs-mtp
  ];

  # Enabled services
  services = {
    openssh.enable = true;
    printing.enable = true;
    mullvad-vpn.enable = true;
    upower.enable = true;
    flatpak.enable = true;
  };

  # In configuration.nix
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
  '';

  # services.logind.settings.Login = ''
  #   HandlePowerKey=suspend-then-hibernate
  #   HandlePowerKeyLongPress=poweroff
  #   HandleLidSwitch=suspend-then-hibernate
  #   HandleLidSwitchExternalPower=suspend-then-hibernate
  #   HandleLidSwitchDocked=ignore
  # '';
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';

  system.stateVersion = "25.05"; # Do not change
}
