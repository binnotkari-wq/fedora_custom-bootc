#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

# Permissions des fichiers copiés depuis system_files
chmod 755 /etc/scripts/system-update.sh
chmod 755 /etc/scripts/bootc-welcome.sh
chmod 644 /etc/profile.d/10-environment.sh
chmod 755 /etc/skel/Modèles/Script.sh

# activation des préférences dconf injectées
dconf update
