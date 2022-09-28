#!/usr/bin/env bash

set -eu -o pipefail

ssh-keygen -t ed25519 -C '' -N '' -f ./kexec-ssh-key || true
git add -f ./kexec-ssh-key.pub
nix build .#kexecImage
git reset -- ./kexec-ssh-key.pub
