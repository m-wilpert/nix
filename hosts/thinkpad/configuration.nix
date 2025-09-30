{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];


  #############################################################
  #####################  SYSTEM SETTINGS  #####################
  #############################################################


  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    systemd-boot.enable = false;
    grub.useOSProber = true;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      theme = inputs.nixos-grub-themes.packages.${pkgs.system}.nixos;
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-d77f25e7-47d7-4a33-a45c-f8fe835a0029".device = "/dev/disk/by-uuid/d77f25e7-47d7-4a33-a45c-f8fe835a0029";
  boot.initrd.systemd.enable = true;


  boot.plymouth = {
    enable = true;
    # themePackages = [ pkgs.plymouth-themes ];
    theme = "breeze";
  };

  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.hostName = "thinkpad";
  
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

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

  users.users.mika = {
    isNormalUser = true;
    description = "Mika";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mika";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;


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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "us";
  };

  # Configure console keymap
  console.keyMap = "us";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
  # Suspend-then-hibernate config
  services.logind.settings.Login = {
    HandlePowerKey="suspend-then-hibernate";
    HandlePowerKeyLongPress="poweroff";
    HandleLidSwitch="suspend-then-hibernate";
    HandleLidSwitchExternalPower="suspend-then-hibernate";
    HandleLidSwitchDocked="ignore";
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';


  ###############################################################
  #####################  SOFTWARE SETTINGS  #####################
  ###############################################################


  home-manager = {
   extraSpecialArgs = { inherit inputs; }; # Passes inputs to HM modules
   useGlobalPkgs = true; # NixOS and HM use the same global packages
   users = {
     "mika" = { 
       imports = [
         ./home.nix
         #inputs.self.outputs.homeManagerModules.default
       ];
     };
   };
   backupFileExtension = "backup";
  };

  nixpkgs.config.allowUnfree = true;

  # to use cosmic store to manage flatpaks uncomment the following, rebuild and then run "flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
  # services.flatpak.enable = true;
  
  services.mullvad-vpn.enable = true;

  programs.firefox = {
    enable = true;
    preferences = {"widget.gtk.libadwaita-colors.enabled" = false;};
  };

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    alacritty
    alacritty-theme
    git
    neovim
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  system.stateVersion = "25.05"; # Dont touch

}
