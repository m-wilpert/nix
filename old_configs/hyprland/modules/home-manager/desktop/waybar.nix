{ config, ... } :

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = { 
        layer = "top";
        position = "top";
        height = 50;
        spacing = 0;
      

        modules-left = [];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "clock" "tray" "network" "bluetooth" "pulseaudio" "backlight" "battery" "custom/power" ];

        "hyprland/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            active = "<span size='15pt'></span>";
            default = "<span size='15pt'></span>";
          };
        };
     
        clock = {
          interval = 1;
          timezone = "Europe/Berlin";
          format = "<span size='15pt'>  </span> {:%H:%M} ";
          tooltip = true;
          tooltip-format = "{:L%A %d.%m.%Y}";
        };

        network = {
          # format-wifi = "<span color='#00FFFF'> 󰖩  </span>{essid} ";
          # format-ethernet = "<span color='#7FFF00'>   </span>Wired ";
          # tooltip-format = "<span color='#FF1493'> 󰅧  </span>{bandwidthUpBytes}  <span color='#00BFFF'> 󰅢 </span>{bandwidthDownBytes}";
          # format-linked = "<span color='#FFA500'> 󱘖  </span>{ifname} (No IP) ";
          # format-disconnected = "<span color='#FF4040'>   </span>Disconnected ";
          # format-alt = "<span color='#00FFFF'> 󰖩  </span>{signalStrength}% ";
          format-wifi = "<span size='15pt'>󰖩</span>";
          format-ethernet = "<span size='15pt'></span>";
          tooltip-format = "{essid} <span color='#FF1493'> 󰅧  </span>{bandwidthUpBytes}  <span color='#00BFFF'> 󰅢 </span>{bandwidthDownBytes}";
          format-linked = "<span size='15pt'>󱘖</span>";
          format-disconnected = "<span size='15pt'></span>";
          # format-alt = "󰖩";
          on-click = "kitty nmtui";
          interval = 1;
        };
     
        pulseaudio = {
          format = "<span size='15pt'>{icon}</span> {volume}% ";
          format-muted = "<span size='15pt'>󰖁</span> 0% ";
          format-icons = {
            headphone = "<span color='#dcdfe1'>  </span>";
            hands-free = "<span color='#dcdfe1'>  </span>";
            headset = "<span color='#dcdfe1'>  </span>";
            phone = "<span color='#dcdfe1'>  </span>";
            portable = "<span color='#dcdfe1'>  </span>";
            car = "<span color='#dcdfe1'>  </span>";
            default = [
              "<span color='#dcdfe1'>  </span>"
              "<span color='#dcdfe1'>  </span>"
              "<span color='#dcdfe1'>  </span>"
            ];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl -- set-sink-mute 0 toggle";
          tooltip = true;
        };
     
     
        tray = {
          icon-size = 17;
          spacing = 6;
        };
     
        backlight = {
          device = "intel_backlight";
          format = "<span size='15pt'>{icon}</span> {percent}% ";
          tooltip = true;
          format-icons = [
            "󰃞"
            "󰃝"
            "󰃟"
            "󰃠"
          ];
        };
     
        bluetooth = {
          on-click = "blueman-manager";
          format = "<span size='15pt'></span>";
          format-connected = "<span size='15pt'></span>";
          format-connected-battery = "<span size='15pt'></span> {device_battery_percentage}% ";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
        };
          # format = "<span color='#28CD41'> {icon}  </span>{capacity}% ";
          format = "<span size='15pt'>{icon}</span> {capacity}% ";
          format-charging = " 󱐋{capacity}% ";
	        interval = 1;
          format-icons = [ "" "" "" "" "" ];
          tooltip = true;
        };

        "custom/power" = {
          format = "<span size='15pt'></span>";#"<span color='#FF4040'>    </span>";
          on-click = "wlogout -b 5 -r 1";
          tooltip = true;
        };
      };
    };

    style = ''
      * {
        font-family: "CaskaydiaCove Nerd Font Mono", "Font Awesome 6 Free", "Font Awesome 6 Free Solid";
        font-weight: bold;
        font-size: 14px;
        color: #dcdfe1;
      }

      /* Waybar */
      #waybar {
        background-color: rgba(0, 0, 0, 0);
        border: none;
        box-shadow: none;
      }

      /* Workspaces */
      #workspaces{
        background-color: #323844;
        margin: 0px 0px;
        padding: 4px 4px; 
        border-radius: 8px;
        border-width: 0px;
      }

      #clock{
        background-color: #323844;
        margin: 0px 0px;
        padding: 4px 4px; 
        border-radius: 10px 0px 0px 10px;
        border-width: 0px;
      }

      #tray{
        background-color: #323844;
        margin: 0px 0px;
        padding: 4px 4px; 
        border-radius: 0px;
        border-width: 0px;
      }
      
      #network{
        background-color: #323844;
        margin: 0px 0px;
        padding: 4px 4px; 
        border-radius: 0px;
        border-width: 0px;
      }
      
      #bluetooth{
        background-color: #323844;
        margin: 0px 0px;
        padding: 4px 4px; 
        border-radius: 0px;
        border-width: 0px;
      }

      #pulseaudio{
        background-color: #323844;
        margin: 0px 0px;
        padding: 4px 4px; 
        border-radius: 0px;
        border-width: 0px;
      }

      #backlight{
        background-color: #323844;
        margin: 0px 0px;
        padding: 4px 4px; 
        border-radius: 0px;
        border-width: 0px;
      }

      #battery{
        background-color: #323844;
        margin: 0px 0px;
        padding: 0px 4px; 
        border-radius: 0px;
        border-width: 0px;
      }

      #custom-power{
        background-color: #323844;
        margin: 0px 10px 0px 0px;
        padding: 0px 6px; 
        border-radius: 0px 10px 10px 0px;
        border-width: 0px;
      }
      
      #workspaces button:hover{
        background-color: rgba(97, 175, 239, 0.2);
        padding: 0px;
        margin: 0px;
        border-radius: 10px;
      }
      
      #workspaces button.active {
        background-color: #151B27;
        /*background-color: #AEB4C0;*/
        color: #ffffff;
        padding: 0px;
        margin: 0px;
        border-radius: 10px;
      }
      
      #workspaces button {
        background: transparent;
        border: none;
        color: #888888;
        padding: 0px;
        margin: 0px;
        font-weight: bold;
      }
      
      #window {
        font-weight: 500;
        font-style: italic;
      }
    '';
  };
}
