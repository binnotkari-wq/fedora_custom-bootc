#!/bin/bash

set -ouex pipefail

### Activation des services d'installation et update de brew (provisionnés par universal blue)
systemctl preset brew-setup.service
systemctl preset brew-update.timer
systemctl preset brew-upgrade.timer
