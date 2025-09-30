{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wayland
    xwayland
    rofi
    hyprshot # Screenshot utility
    jq # JSON parser and manipulator
    grim # Screenshot tool
    slurp # Screenshot selector
    wl-clipboard # Wayland clipboard
    libnotify # Notification sender
    swaynotificationcenter # Notification daemon
    brightnessctl
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      ### MONITORS
      #monitor = <name>, <resolution@refresh_rate>, <position>
      monitor = [ 
        
        ", 1920x1080@60.01Hz, 0x0, 1" # PC Monitor
        
      ];

      # workspace = [ 
      #   "1, monitor:HDMI-A-1"
      #   "2, monitor:HDMI-A-1"
      #   "3, monitor:HDMI-A-1"
      #   "4, monitor:HDMI-A-1"
      #   "5, monitor:HDMI-A-1"
      #   "6, monitor:eDP-1"
      #   "7, monitor:eDP-1"
      #   "8, monitor:eDP-1"
      #   "9, monitor:eDP-1"
      #   "10, monitor:eDP-1"

      # ];

      ### MY PROGRAMS
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$fileManager" = "nemo";
      "$menu" = "rofi -show drun";

      ### AUTOSTART 
      exec-once = [ 
        "waybar"
        "hyprpaper"
        "swaync"
        "hypridle"
      ];

      ### ENVIRONMENT VARIABLES
      env = [ 
        "XCURSOR_THEME, WhiteSur-cursors"
        "XCURSOR_SIZE, 24"
        "WLR_NO_HARDWARE_CURSORS,1"
        "HYPRSHOT_DIR, /home/mika/Screenshots"
      ];

      ### LOOK AND FEEL
      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        "col.active_border" = "rgb(9ca2ae)";
        "col.inactive_border" = "rgb(0e1420)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = "yes, please :)";

        bezier = [ 
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [ 
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];

      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
  
      ### INPUT
      input = {
        kb_layout = "de";
        kb_variant = "us";
        kb_options = "";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      # gestures = {
      #       workspace_swipe = false;
      #     };

      # device = {
      #   name = "epic-mouse-v1";
      #   sensitivity = -0.5;
      # };

      ### KEYBINDINGS

      "$mainMod" = "SUPER";

      bind = [ 
        "$mainMod, T, exec, $terminal"
        "$mainMod, B, exec, $browser "
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, space, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, N, togglesplit, # dwindle"
        "$mainMod, F, fullscreen, "
        ", PRINT, exec, hyprshot -m window # Window screenshot"
        "shift, PRINT, exec, hyprshot -m region # Region screenshot"
        "$mainMod, L, exec, hyprlock # Lock screen with Hyprlock"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        # "$mainMod, 1, workspace, 1"
        # "$mainMod, 2, workspace, 2"
        # "$mainMod, 3, workspace, 3"
        # "$mainMod, 4, workspace, 4"
        # "$mainMod, 5, workspace, 5"
        # "$mainMod, 6, workspace, 6"
        # "$mainMod, 7, workspace, 7"
        # "$mainMod, 8, workspace, 8"
        # "$mainMod, 9, workspace, 9"
        # "$mainMod, 0, workspace, 10"
        # "$mainMod SHIFT, 1, movetoworkspace, 1"
        # "$mainMod SHIFT, 2, movetoworkspace, 2"
        # "$mainMod SHIFT, 3, movetoworkspace, 3"
        # "$mainMod SHIFT, 4, movetoworkspace, 4"
        # "$mainMod SHIFT, 5, movetoworkspace, 5"
        # "$mainMod SHIFT, 6, movetoworkspace, 6"
        # "$mainMod SHIFT, 7, movetoworkspace, 7"
        # "$mainMod SHIFT, 8, movetoworkspace, 8"
        # "$mainMod SHIFT, 9, movetoworkspace, 9"
        # "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, Page_Down, workspace, +1"
        "$mainMod, Page_Up, workspace, -1"
        "$mainMod SHIFT, Page_Down, movetoworkspace, +1"
        "$mainMod SHIFT, Page_Up, movetoworkspace, -1"
      ];

      bindm = [ 
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [ 
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [ 
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      ### WINDOWS AND WORKSPACES

      windowrulev2 = [ 
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0 "
      ];

    };
  };
}
