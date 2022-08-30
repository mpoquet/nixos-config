{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=cc634d9aa08ed89c9ff655de06ab2e593c72ebc1";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./laptop-irit.nix ];
    };
  };
}