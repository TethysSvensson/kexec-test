{ pkgs, ... }:
{
  networking.hostName = "some-random-system";
  time.timeZone = "Europe/Copenhagen";

  system.stateVersion = "22.05";

  boot.loader = {
    grub.enable = false;
    grub.device = "nodev";
    systemd-boot.enable = true;
    grub.configurationLimit = 3;
    systemd-boot.configurationLimit = 10;
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys =
    [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG07q+BoggQcuvzksnVrfh7ybO1CMRyMXp1wIE6Z4MoG" ];
}
