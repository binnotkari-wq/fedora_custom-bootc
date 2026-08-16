# 13/08/2026 PRET POUR UN PREMIER BUILD !

# Modifications apportées à fedora_reference_bootc

## Construction du container

./Containerfile

Facutlatitf, et desactivé : ajoute de l'image locale en tant que source pour faire un build offline (cf tuto), au besoin :

```
# FROM localhost/fedora_reference-bootc:latest
```

> pointe vers l'image déjà présente dans le storage podman (chargée en local précédement via podman load)  — aucune requête réseau vers GHCR n'est faite tant que le tag existe localement.



Facultatif, et desactivé : on provisionne l'OCI avec les fichiers d'installation de brew (process universal blue). Doit être spécifié après FROM "OCI source choisi" (on peut essayer de mettre ces fichiers en local. Pour être vraiment offline.)
Privilégier une distrobox si on veut utiliser des outils CLI qui ne sont pas dans l'OCI. De plus, cela permet d'harmoniser avec nixos (brew pas installable).

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
- build ISO local :
- switch container Github Actions : OK
- switch container local :
- installation ISO Github Actions :
- installation ISO local :