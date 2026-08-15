#!/bin/bash

set -ouex pipefail

### Ajout de Flathub (statique, prêt à l'emploi si besoin plus tard)
### https://github.com/ublue-os/main/blob/main/build_files/install.sh
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

### cosign (signature pour la construction de containers via github action) n'est pas disponibles dans les repos rpm.
### Donc on récupère les binaires standalone depuis github https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/#installing-cosign-with-the-cosign-binary

curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
mv cosign-linux-amd64 /usr/local/bin/cosign


### llama-cpp-vulkan n'est pas disponibles dans les repos rpm et lamma-cpp (non vulkan) télécharge rocm (2go de dépendances).
### Donc on récupère les binaires standalone depuis github, uniquement llama-server et llama-cli (build Vulkan)
LLAMA_URL=$(curl -s "https://api.github.com/repos/ggml-org/llama.cpp/releases?per_page=10" \
  | grep -Po '"browser_download_url": "\K[^"]*ubuntu-vulkan-x64\.tar\.gz' | head -1)
curl -Lo /tmp/llama-cpp.tar.gz "$LLAMA_URL"

mkdir -p /tmp/llama-cpp-extract
tar -xzf /tmp/llama-cpp.tar.gz -C /tmp/llama-cpp-extract

# Binaires souhaités uniquement
find /tmp/llama-cpp-extract -name 'llama-server' -exec install -Dm755 {} /usr/bin/llama-server \;
find /tmp/llama-cpp-extract -name 'llama-cli' -exec install -Dm755 {} /usr/bin/llama-cli \;

# Bibliothèques partagées (cp -a préserve les liens symboliques attendus par ldconfig)
find /tmp/llama-cpp-extract -name '*.so*' -exec cp -a {} /usr/lib64/ \;
ldconfig

rm -rf /tmp/llama-cpp.tar.gz /tmp/llama-cpp-extract


### Logiciels CLI. weak_deps : on ne veut pas de paquets suggérés supplémentaires.
dnf5 install -y --setopt=install_weak_deps=False \
  gnome-shell-extension-dash-to-panel \
  distrobox \
  bat \
  powertop \
  lm_sensors \
  stress-ng \
  s-tui \
  libva-utils \
  shellcheck \
  dialog \
  zenity \
  kiwix-tools \
  aria2 \
  yt-dlp \
  ffmpeg-free \
  mc \
  btop \
  fd-find \
  fzf \
  tldr \
  glow \
  zoxide


# simulation sur un bootc silverblue 44 épuré : 
# dnf5 install --downloadonly -y \
# distrobox bat powertop lm_sensors stress-ng s-tui libva-utils shellcheck \
# dialog zenity kiwix-tools aria2 yt-dlp mc btop fd-find fzf tldr zoxide
# Résumé de la transaction :
# Installation :    102 paquets
# La taille totale des paquets entrants est de 47 MiB. Un téléchargement de 42 MiB est nécessaire.
# Après cette opération, 167 MiB supplémentaires seront utilisés (+150 MiB, -0 B).
# L'opération ne fera que télécharger les paquets pour la transaction.

# NB : git, wget, pciutils, iw, usbutils, compsize, libnotify, hunspell, tree, python314, podman sont déjà inclus par défaut.
# Les applications GUI ont tous la correction orthographique activée en français. Pas la peine de rajouter des dictionnaires hunspell.
