{
  description = "Multiplayer fix for AoE 2: DE";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;

  outputs = { self, nixpkgs, ... }:
  {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "proton_aoe2de_mpfix";
        src = self;
        installPhase = ''
          patch -p1 < nixos.patch
          mkdir -p $out/bin
          mv run.sh $out/bin/run.sh
        '';
      };
  };
}