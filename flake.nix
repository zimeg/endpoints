{
  description = "a collection of API methods";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      each =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-darwin"
          "x86_64-linux"
          "aarch64-darwin"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = each (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.biome
            pkgs.nodejs
          ];
        };
      });
      packages = each (pkgs: {
        default = pkgs.stdenv.mkDerivation {
          name = "endpoints";
          src = ./.;
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/share/endpoints $out/bin
            cp -r $src/calendar $src/server.js $src/package.json $out/share/endpoints/
            echo '#!/bin/sh' > $out/bin/endpoints
            echo "exec ${pkgs.nodejs}/bin/node $out/share/endpoints/server.js" >> $out/bin/endpoints
            chmod +x $out/bin/endpoints
          '';
        };
      });
    };
}
