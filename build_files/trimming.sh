#!/bin/bash

set -ouex pipefail

### Suppression du remote flatpak fedora et de son service de re-création au boot
### Objectif : image sans aucun flatpak préconfiguré, validation du mécanisme de rebase
### https://github.com/ublue-os/main/blob/main/build_files/install.sh
dnf5 remove -y fedora-flathub-remote
flatpak remote-delete --system fedora --force || true

### Suppression de logiciels RPM non désirés
# dépendances vérifiées sur un système installé :
# rpm -qa | grep -iE 'firefox|gnome-tour|gnome-software|^qt|qgnomeplatform'
# rpm -q --whatrequires gnome-software
# rpm -q --whatrequires qt5-qtwayland qt6-qtwayland
# firefox est conservé en natif. La version flatak est limitée, notamment au
# niveau des policies.
# firefox \
# firefox-langpacks \
dnf5 remove -y \
  gnome-tour \
  gnome-software \
  gnome-software-rpm-ostree \
  malcontent \
  qt5-qtbase \
  qt6-qtbase

### Suppression d'Orca et de la synthèse vocale (non utilisés)
dnf5 remove -y \
  orca \
  speech-dispatcher \
  speech-dispatcher-espeak-ng \
  speech-dispatcher-libs \
  speech-dispatcher-utils \
  espeak-ng

### Suppression des extensions GNOME Shell par défaut et de la session classique associée
### rpm -qa | grep -iE 'gnome-shell-extension*'
### ainsi que rpm -q --whatrequires pour chauqe paquet
dnf5 remove -y \
  gnome-classic-session \
  gnome-shell-extension-apps-menu \
  gnome-shell-extension-launch-new-instance \
  gnome-shell-extension-places-menu \
  gnome-shell-extension-window-list \
  gnome-shell-extension-background-logo

### Services système : désactivation classique
systemctl disable \
  NetworkManager-wait-online.service \
  ModemManager.service

### Services système : masquage (statique ou activation par socket/dbus)
systemctl mask \
  geoclue.service \
  gssproxy.service \
  sssd-kcm.service sssd-kcm.socket \
  pcscd.service pcscd.socket

### Services utilisateur (--global : pas de session active pendant le build)
systemctl --global mask \
  evolution-addressbook-factory.service \
  evolution-calendar-factory.service \
  evolution-alarm-notify.service \
  evolution-source-registry.service \
  evolution-user-prompter.service \
  org.gnome.SettingsDaemon.Smartcard.service \
  org.gnome.SettingsDaemon.Smartcard.target \
  org.gnome.SettingsDaemon.Wwan.service \
  org.gnome.SettingsDaemon.Wwan.target

### Nettoyage de dnf
dnf5 autoremove -y
dnf5 clean all
