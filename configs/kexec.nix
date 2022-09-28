{ pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys =
    if builtins.pathExists ../kexec-ssh-key.pub
    then [ (builtins.readFile ../kexec-ssh-key.pub) ]
    else [ ];

  system.stateVersion = "22.10";
}
