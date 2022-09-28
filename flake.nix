{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, deploy-rs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        kexec = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = [ ./configs/kexec.nix ];
        };
        some-random-system = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./configs/some-random-system.nix
            ./hardware-configs/some-random-system.nix
          ];
        };
      };

      checks.${system} = {
        kexecImage = self.packages.${system}.kexecImage;
      } // (deploy-rs.lib.${system}.deployChecks self.deploy);

      packages.${system} = {
        kexecImage = self.nixosConfigurations.kexec.config.system.build.kexecTree;
        deploy-rs = pkgs.writeScriptBin "deploy-rs" ''
          #!/bin/sh
          exec ${deploy-rs.defaultPackage.${system}}/bin/deploy "$@"
        '';
      };

      deploy.nodes.some-random-system = {
        hostname = "kexec-test";
        profiles.system = {
          sshUser = "root";
          fastConnection = true;
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.some-random-system;
        };
      };
    };
}
