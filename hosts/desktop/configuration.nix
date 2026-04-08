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

    efi = {
      canTouchEfiVariables = true;
      #efiSysMountPoint = "/boot/efi";
    };

    grub = {
      enable = true;
      device = "nodev"; # "nodev" is used for UEFI
      efiSupport = true;
      useOSProber = true;
      #theme = inputs.nixos-grub-themes.packages.${pkgs.system}.nixos;
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #boot.plymouth = {
  #  enable = true;
  #  # themePackages = [ pkgs.plymouth-themes ];
  #  theme = "breeze";
  #};

  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings = {
    # Increase download buffer size (default is 64MB)
    download-buffer-size = 256000000; #256MB
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.hostName = "NixDesktop";
  
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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mika";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;  # see the note above
    # modesetting.enable = true;
    # powerManagement.enable = true;
    # powerManagement.finegrained = false;
    # nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # systemd.services."systemd-suspend" = {
  #   serviceConfig = {
  #     Environment=''"SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false"'';
  #   };
  # };

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
  # services.logind.settings.Login = {
  #   HandlePowerKey="suspend-then-hibernate";
  #   HandlePowerKeyLongPress="poweroff";
  # };

  # systemd.sleep.extraConfig = ''
  #   HibernateDelaySec=2h
  # '';

  #systemd.sleep.settings.Sleep

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

  services.openssh.enable = true;
  
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.flatpak.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nix-ld.enable = true;

  #services.sunshine = {
  #  enable = true;
  #  autoStart = true;
  #  capSysAdmin = true;
  #  openFirewall = true;
  #  
  #};

  programs.firefox = {
    enable = true;
  };

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    p7zip
    ryubing
    direnv
    uv
];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
  };

  system.stateVersion = "25.11"; # Dont touch

}
