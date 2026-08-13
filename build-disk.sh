#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="/cargo/local_cache/bootc/isos"

# S'assurer que le dossier de sortie existe
mkdir -p "$OUTPUT_DIR"

echo "==> Build de l'ISO bootc avec configuration iso-gnome.toml..."

sudo podman run \
  --rm \
  --privileged \
  --pull=newer \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  -v "$OUTPUT_DIR:/output" \
  -v "$REPO_DIR/disk_config/iso-gnome.toml:/config.toml:ro" \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type anaconda-iso \
  --config /config.toml \
  --rootfs btrfs \
  --use-librepo=True \
  localhost/fedora_custom-bootc:latest

# Ajuster les permissions du fichier de sortie à l'utilisateur courant (simule l'étape chown du YAML)
sudo chown -R "$(id -u):$(id -g)" "$OUTPUT_DIR"

echo "==> ISO générée avec succès dans $OUTPUT_DIR !"
