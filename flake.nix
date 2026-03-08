{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    copyparty.url = "github:9001/copyparty";
  };

  outputs = { self, nixpkgs, copyparty }: {
    
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        copyparty.nixosModules.default
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ copyparty.overlays.default ];
          environment.systemPackages = [ pkgs.copyparty ];
        })
      ];
    };    

  };
}
