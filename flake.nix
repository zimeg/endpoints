{
  description = "a collection of API methods";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zimeg.url = "github:zimeg/nur-packages";
  };
  outputs = { flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        llrtLambda = pkgs.stdenv.mkDerivation {
          name = "llrtLambda";
          src = pkgs.fetchurl {
            url = "https://github.com/awslabs/llrt/releases/download/v0.1.10-beta/llrt-lambda-arm64.zip";
            sha256 = "1yh928cv4xsi2xp14rbsnkj0zcd6nnxnhfdnfi2kb6w1zrfd70is";
          };
          unpackPhase = "true";
          installPhase = ''
            mkdir -p $out
            cp $src $out/llrt-lambda-arm.zip
          '';
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            inputs.zimeg.packages.${pkgs.system}.llrt
            llrtLambda
            pkgs.awscli2
            pkgs.opentofu
          ];
          shellHook = ''
            mkdir -p .dist
            cp -f ${llrtLambda}/llrt-lambda-arm.zip .dist
          '';
        };
        packages = {
          tofu = pkgs.writeShellScriptBin "tofu" ''
            ${pkgs.opentofu}/bin/tofu $@
          '';
        };
      });
}
