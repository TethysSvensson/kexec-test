## How to?

* `./generate-kexec.sh`
* Copy contents of `resulst` directory to remote server
* Run the script `kexec-boot` on remote server (after installing kexec-tools)
* ssh as into machine using the private key in `./kexec-ssh-key`
* Configure filesystems on the new nixos system as usual
* `nixos-generate-config --root /mnt`
* Edit `/mnt/etc/nixos/configuration.nix`
* `nixos-install --no-root-passwd`
* `reboot`
* Make new entry for the new machine in `flake.nix`
* Remember to get the `hardware-configuration.nix` from the remote machine
* `nix run .#deploy-rs .`
