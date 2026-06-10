{
  description = "Mikado's NixOS system config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
     url = "github:nix-community/home-manager";
     inputs.nixpkgs.follows = "nixpkgs";
    };

    # Bootloader theme
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:guibou/nixGL";

    nix-citizen.url = "github:LovingMelody/nix-citizen";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";

  };

  outputs = { self, nixpkgs, nixgl, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system;
    };
  in {

    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/thinkpad/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
    packages = [
      pkgs.python3
      nixgl.packages.${system}.nixGLDefault
      ];
    };

    homeConfigurations.desktop.etc = { config, pkgs, ... }:
    let
      environment = {
        packages.x86_64-linux = with pkgs; [
          (nix-citizen.packages.${system}.rsi-launcher)
        ];
      };
    in environment;
    
  };
}
