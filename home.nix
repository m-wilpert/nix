{ config, pkgs, inputs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Mika Wilpert";
    userEmail = "mika.wilpert@gmail.com";
  };
  
  programs.kitty.enable = true;

  programs.waybar.enable = true;
  
  stylix.targets.waybar.addCss = true;

  programs.waybar.settings.main = {
    modules-center = ["hyprland/workspaces"];
    modules-right = ["clock" "tray" "network" "bluetooth" "pulseaudio" "battery"];
  };
  
  programs.firefox = {
    enable = true;
    profiles.mika = {
      bookmarks = {
        force = true;
        settings = [
          {
            name = "";
            url = "www.youtube.com";
          }
        ];
      };
      
      settings = {
        "browser.download.panel.shown" = true;
      };

      search.engines = {
        
      };

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
      ];
    };
  };
  stylix.targets.firefox.profileNames = ["mika"];

  programs.neovim.enable = true;
  
  programs.wofi.enable = true;

  #wayland.windowManager.hyprland.settings = {
  #};

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mika";
  home.homeDirectory = "/home/mika";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    #rofi-wayland
    kdePackages.dolphin
    hyprpaper
    libnotify
    mako
    btop
    libreoffice
    discord
    spotifyd
    obsidian
    gimp
    zathura 
    #evince
    imv 
    #loupe
    mullvad-vpn
    qbittorrent
    signal-desktop
    

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

    ".config/hypr/hyprpaper.conf".text = ''
      preload = /home/${config.home.username}/nixos-config/bladerunner.png
      preload = /home/${config.home.username}/nixos-config/bladerunner_3.jpg
      wallpaper = ,/home/${config.home.username}/nixos-config/bladerunner.png
      splash = false
    '';


    ".config/hypr/hyprland.conf".text = ''
      monitor = , preferred, auto, 1
    
      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24  

      exec-once = waybar
      exec-once = hypridle
      exec-once = hyprpaper
      exec-once = mako
      exec-once = nm-applet
    
      general {
        gaps_in = 5
        gaps_out = 20
        border_size = 2
        resize_on_border = false
        allow_tearing = false
        layout = dwindle
      }

      decoration {
        rounding = 10
        rounding_power = 2
        active_opacity = 1.0
        inactive_opacity = 1.0
        blur {
          enabled = true
          size = 3
          passes = 1
          vibrancy = 0.1696
        }
      }

      dwindle {
        pseudotile = true
        preserve_split = true
      }

      master {
        new_status = master
      }

      input {
        kb_layout = de
        kb_variant = us
        follow_mouse = 1
        sensitivity = 0
        touchpad {
          natural_scroll = true
        }
      }

      $mainMod = SUPER

      bind = $mainMod, T, exec, kitty
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, F, exec, dolphin
      bind = $mainMod, space, exec, wofi --show drun
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, J, togglesplit,
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
    
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = , XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
      bindel = , XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      windowrule = suppressevent maximize, class:.*
      windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

    '';


    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mika/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #stylix = {
  #  enable = true;
  #  autoEnable = false;
  #};

}
