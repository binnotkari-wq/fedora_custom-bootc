#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Exécution des modules

### installation des rpm, binaire de llama, repo flathub
/ctx/softwares.sh

### fichiers injectés dans /etc et /usr (configs, scripts, skels, services...)
/ctx/environment.sh

### améliorations des performances
/ctx/tweaks.sh

### suppression des logiciels et services non souhaités
/ctx/trimming.sh
