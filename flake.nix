{
  description = "a collection of API methods";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        llrt = let
          os = if pkgs.stdenv.isDarwin then "darwin" else "linux";
          arch = if pkgs.stdenv.isAarch64 then "arm64" else "x64";
          sha256Map = {
            "darwin-arm64" = "1gr37czvcc5w9p291q0ac8kb0nnmgyavnnwy9bjmlhskr5svjylr";
            "darwin-x64" = "0falxrp8v3kjfmasirrp6d7lmfdnpxc64gf9zbjhhlshndafqvbw";
            "linux-arm64" = "0sqiiks1yv8a8kr5w4xhsk10fk6nvjl80h52fppjcd505mxfjkh0";
            "linux-x64" = "0kl6a7m7mpva4fff69vr90x5m33yk2hyvxchzik9c5ii5ip2mpgh";
          };
        in pkgs.stdenv.mkDerivation {
          name = "llrt";
          src = pkgs.fetchurl {
            url = "https://github.com/awslabs/llrt/releases/download/v0.1.10-beta/llrt-${os}-${arch}.zip";
            sha256 = pkgs.lib.getAttr "${os}-${arch}" sha256Map;
          };
          buildInputs = [ pkgs.unzip ];
          unpackPhase = "unzip $src";
          installPhase = ''
            mkdir -p $out/bin
            cp llrt $out/bin/llrt
          '';
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
            llrt
            llrtLambda
            pkgs.awscli2
            pkgs.opentofu
          ];
          shellHook = ''
            mkdir -p .dist
            cp -f ${llrtLambda}/llrt-lambda-arm.zip .dist
          '';
        };
      });
}
