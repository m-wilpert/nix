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

    # SDDM theme 
    sddm-sugar-candy-nix.url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";

    # Neovim Nix Framework NVF
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/thinkpad/configuration.nix
          inputs.home-manager.nixosModules.default
	        inputs.nvf.nixosModules.default
          inputs.sddm-sugar-candy-nix.nixosModules.default
        ];
      };
    }; 
  };
}
