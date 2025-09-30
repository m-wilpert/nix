{ config, pkgs, ... }:

{
  # Define user accounts.
  users.users.mika = {
    isNormalUser = true;
    description = "Mika";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [];
  };

  # Sets trusted users
  nix.settings.trusted-users = [ "root" "mika"];

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mika";

}
