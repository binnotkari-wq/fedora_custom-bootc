# 13/08/2026 PRET POUR UN PREMIER BUILD !

# Modifications apportées à fedora_reference_bootc

## Construction du container

./Containerfile

Build local :
```
FROM localhost/fedora_reference-bootc:latest
```

> pointe vers l'image déjà présente dans le storage podman (chargée en local précédement via podman load)  — aucune requête réseau vers GHCR n'est faite tant que le tag existe localement

Puis on exécute les scripts de customisation. A chaque RUN de script, on met en place les bind mounts des dossier de cache (les éventuels fichiers temporaires et résidus produits lors de l'execution des scripts seront donc wipés à la fin du RUN sans jamais faire partie d'un layer de l'OCI.

Claude 13/08/2026 "Refactoriser Containerfile avec script shell" :

*Le stage ctx (FROM scratch AS ctx) et le --mount=type=bind,from=ctx, et type=cache... existent pour une raison précise : ne jamais faire apparaître build_files/ comme layer dans l'image finale, même temporairement. Avec un bind mount, les fichiers sont visibles uniquement pendant l'exécution de ce RUN précis — dès que le RUN se termine, ils disparaissent, sans laisser de résidu ni de layer à nettoyer après coup.*

Facultatif, et desactivé : on provisionne l'OCI avec les fichiers d'installation de brew (process universal blue). Doit être spécifié après FROM "OCI source choisi" (on peut essayer de mettre ces fichiers en local. Pour être vraiment offline.)
Privilégier une distrobox si on veut utiliser des outils CLI qui ne sont pas dans l'OCI. De plus, cela permet d'harmoniser avec nixos (brew pas installable).

---
## Nommage

./image_template.env

IMAGE_NAME adapté

---

## Simplification de build.sh (renommé en environment.sh) et permissions

./build_files/environment.sh

Tous les commentaires d'exemples sont supprimés.
Les permissions des fichiers injectés depuis system_files sont appliquées.
dconf est mis à jour.

---
## Configuration de Anaconda (intervient pour le build de l'ISO)

./disk_config/disk.toml

Diminution de la taille minimum du disque d'installation (15 GiB au lieu de 20 GiB)

./disk_config/iso-gnome.toml

Nom de l'image adapté

---
## Validation

- build container Github Actions :
- build container local :
- build ISO Github Actions :
- build ISO local :
- switch container Github Actions :
- switch container local :
- installation ISO Github Actions :
- installation ISO local :