#!/bin/bash

set -ouex pipefail

### Ajout de Flathub (statique, prêt à l'emploi si besoin plus tard). En mode offline, on utilise le fichier pré-téléchargé
### https://github.com/ublue-os/main/blob/main/build_files/install.sh
mkdir -p /etc/flatpak/remotes.d/
if [ -f /run/bin-cache/flathub.flatpakrepo ]; then
    cp /run/bin-cache/flathub.flatpakrepo /etc/flatpak/remotes.d/flathub.flatpakrepo
else
    curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo \
        https://dl.flathub.org/repo/flathub.flatpakrepo
fi


### cosign n'est pas disponibles dans les repos rpm, donc on récupère les binaires standalone depuis github https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/#installing-cosign-with-the-cosign-binary
### # On le place dans /usr/bin et non /usr/local/bin qui n'existe dans dans l'OCI (n'existe qu'une fois que le système est installé)
### En mode offline, on utilise le binaire pré-téléchargé
if [ -f /run/bin-cache/cosign-linux-amd64 ]; then
    cp /run/bin-cache/cosign-linux-amd64 /usr/bin/cosign
else
    curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
    mv cosign-linux-amd64 /usr/bin/cosign
fi
chmod +x /usr/bin/cosign


### llama-cpp-vulkan n'est pas disponibles dans les repos rpm et lamma-cpp (non vulkan) télécharge rocm (2go de dépendances).
### Donc on récupère les binaires standalone depuis github, uniquement llama-server et llama-cli (build Vulkan)
### En mode offline, on utilise le binaire pré-téléchargé
mkdir -p /tmp/llama-cpp-extract
if [ -f /run/bin-cache/llama-cpp.tar.gz ]; then
    cp /run/bin-cache/llama-cpp.tar.gz /tmp/llama-cpp.tar.gz
else
    LLAMA_URL=$(curl -s "https://api.github.com/repos/ggml-org/llama.cpp/releases?per_page=10" \
      | grep -Po '"browser_download_url": "\K[^"]*ubuntu-vulkan-x64\.tar\.gz' | head -1)
    curl -Lo /tmp/llama-cpp.tar.gz "$LLAMA_URL"
fi
tar -xzf /tmp/llama-cpp.tar.gz -C /tmp/llama-cpp-extract
# Binaires souhaités uniquement
find /tmp/llama-cpp-extract -name 'llama-server' -exec install -Dm755 {} /usr/bin/llama-server \;
find /tmp/llama-cpp-extract -name 'llama-cli' -exec install -Dm755 {} /usr/bin/llama-cli \;
# Bibliothèques partagées (cp -a préserve les liens symboliques attendus par ldconfig)
find /tmp/llama-cpp-extract -name '*.so*' -exec cp -a {} /usr/lib64/ \;
ldconfig
rm -rf /tmp/llama-cpp.tar.gz /tmp/llama-cpp-extract


### Packages rpm (+plugins gnome). weak_deps : on ne veut pas de paquets suggérés supplémentaires.
### En mode offline, on utilise le repo local des rpm pré-téléchargé

PACKAGES=(
  gnome-shell-extension-dash-to-panel
  earlyoom
  createrepo_c
  distrobox
  bat
  powertop
  lm_sensors
  stress-ng
  s-tui
  libva-utils
  shellcheck
  dialog
  zenity
  kiwix-tools
  aria2
  yt-dlp
  mc
  btop
  fd-find
  fzf
  tldr
  glow
  zoxide
  )
  
if [ -d /run/rpm-cache ]; then
    printf '[cargo-local]\nname=CARGO local cache\nbaseurl=file:///run/rpm-cache\nenabled=1\ngpgcheck=0\npriority=1\n' \
        > /etc/yum.repos.d/cargo-local.repo
    dnf5 install -y --setopt=install_weak_deps=False --disablerepo='*' --enablerepo=cargo-local "${PACKAGES[@]}"
else
    dnf5 install -y --setopt=install_weak_deps=False "${PACKAGES[@]}"
fi

rm -f /etc/yum.repos.d/cargo-local.repo


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
