#!/bin/bash

set -ouex pipefail

### ntsync : chargement au boot
echo "ntsync" > /etc/modules-load.d/ntsync.conf

### earlyoom (le paquet est installé dans softwares.sh)
systemctl enable earlyoom

### swappiness agressif pour favoriser ZRAM avant le swap disque
cat > /etc/sysctl.d/99-swappiness.conf << 'EOF'
vm.swappiness = 150
EOF

### ZRAM : zstd, 100% de la RAM (au lieu du défaut lzo-rle plafonné à 8 Go)
cat > /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
compression-algorithm=zstd
swap-priority=100
zram-size=100 / 100 * ram
EOF

### Kernel arg : compression btrfs forcée en zstd:3 (zstd:1 par défaut)
### les options kargs ne remplacent pas les existantes, mais si ajoutent sans fusion
### Cela fait un doublon de kargs qui est sans conséquence compress-force=zstd:3
### est bien actif (test sur fichier avant et apres l'ajout des kaargs
mkdir -p /usr/lib/bootc/kargs.d
cat > /usr/lib/bootc/kargs.d/10-btrfs-compress.toml << 'EOF'
kargs = ["rootflags=subvol=root,compress-force=zstd:3"]
EOF


### Intégré par défaut par fédora :
# zram en lzo-rle (on veut zstd)
# compression btrfs zstd niveau 1 (on veut niveau 3)
# relatime (mieux que noatime)
# gamemode : installé par défaut.
# fstrim.timer : déjà activé et actif (hebdomadaire)
# discard=async : déjà présent sur tous les montages btrfs et à travers LUKS

### pas intégrales en bootc :
# impossible d'assigner des groupes à un compte qui n'existe pas. Ça devra se faire après coup, à la main ou via un petit script post-premier-boot
# - user : extraGroups = [ "libvirtd" "kvm" ]; 
