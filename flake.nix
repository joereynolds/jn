{
  description = "Build and/or develop jn";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    jn = pkgs.callPackage ./default.nix {};
  in {
    packages.${system} = {
      inherit jn;
      default = jn;
    };

    devShell.${system} = pkgs.mkShell {
      inputsFrom = [jn];
      packages = with pkgs; [
        nim
        nimble
      ];

      shellHook = ''
        echo "Entered Nim dev shell"
        nim --version
      '';
    };
  };
}
