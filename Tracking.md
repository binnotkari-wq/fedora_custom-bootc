# 13/08/2026 PRET POUR UN PREMIER BUILD !

# Modifications apportées à fedora_reference_bootc

## Construction du container

./Containerfile

Tous les commentaires d'exemples sont supprimés.

---
## Nommage

./image_template.env

IMAGE_NAME adapté

---

## Modification de build.sh

./build_files/build.sh

Tous les commentaires d'exemples sont supprimés.
On appelle les différents scripts de customisation.

---
## Configuration de Anaconda (intervient pour le build de l'ISO)

./disk_config/disk.toml

Diminution de la taille minimum du disque d'installation (15 GiB au lieu de 20 GiB)

./disk_config/iso-gnome.toml

Nom de l'image adapté

---
## Validation

- build container Github Actions : OK
- build container local : OK
- build ISO Github Actions : OK
- build ISO local : OK
- switch container Github Actions : OK
- switch container local :
- installation ISO Github Actions :
- installation ISO local : OK

1) vérifier les jouornaux pour détecter des erreurs
2) vérifier la bonne prise en compte des tweaks performance
3) vérifier que le système est propre (pas de traces de build)