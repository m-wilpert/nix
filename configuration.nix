# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "homelab"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };
  # enable autologin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "admin";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    python314
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    lemonade #ssh clipboard manager
    btop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # systemd.timers."duckdns" = {
  #   wantedBy = [ "timers.target" ];
  #     timerConfig = {
  #       OnBootSec = "5m";
	# OnUnitActiveSec = "5m";
	# Unit = "duckdns.service";
  #     };
  # };

  # systemd.services."duckdns" = {
  #   description = "DuckDNS updater";
  #   script = ''
  #     ${pkgs.curl}/bin/curl -s "https://www.duckdns.org/update?domains=kartoffelsack&token=1c86e4fc-7df3-45bd-ac89-88b65de4011b&ip=" -o /home/admin/duckdns/duck.log
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "admin";
  #   };
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.mullvad-vpn.enable = true;

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "admin";
    dataDir = "/home/admin/copyparty/media";
    configDir = "/home/admin/jellyfin";
  };

  services.copyparty = {
    enable = true;
    user = "admin";
    settings = {
      # file indexing
      e2dsa = true;
      # media metadata indexing
      e2ts = true;
      # zeroconf, announce enabled services on the LAN (mdns and ssdp)
      z = true;
      #
    };
    accounts = {
      mika = {
        passwordFile = "/home/admin/nix/mika_password";
      };
    };
    volumes = {
      "/" = {
        path = "/home/admin/copyparty";
        access = {
          rwmda= [ "mika" ];
        };
        flags = {
          
        };
      };
    };
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
      "tuya"
      "tplink_tapo"
      "tplink"
    ];
    config = {
      default_config = {};
    };
  }; 

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3923 8123 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
