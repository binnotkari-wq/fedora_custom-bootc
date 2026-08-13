<<<<<<< HEAD
# Modifications apportées au template universale blue
=======
# Modifications apportées à Fedora Reference
>>>>>>> b80a7b4 (Auto-sync [len-380] : 2026-08-13 02:13:33)


## Construction du container

<<<<<<< HEAD

./Containerfile

OCI source chois : fédora officiel

On ajoute rm -rf /usr/etc pour nettoyer ce dossier dans lequel il peut rester des résidus de configuration intermédiaire de paquets qu'on ajoute au container (c'est le process bootc, ce nettoyage est nécessaire pour n'importe quel build bootc). Lorsque le container est déployé, le contenu de /usr/etc se superpose à /etc/, on le nettoie donc au préalable. (07/08/2026 : test nécessaire en switch et ISO).

```
FROM quay.io/fedora-ostree-desktops/silverblue:44
```

    /ctx/build.sh && rm -rf /usr/etc
=======
./Containerfile

Build local :
```
FROM localhost/fedora_reference-bootc:latest
```

>pointe vers l'image déjà présente dans le storage podman (chargée en local précédement via podman load)  — aucune requête réseau vers GHCR n'est faite tant que le tag existe localement


On provisionne l'OCI avec les fichiers d'installation de brew (process universal blue). Doit être spécifié après FROM "OCI source choisi"

```
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /
```

> essayer de mettre ces fichiers en local. Pour être vraiment offline.
>>>>>>> b80a7b4 (Auto-sync [len-380] : 2026-08-13 02:13:33)

---
## Nommage
./image_template.env

<<<<<<< HEAD
```
IMAGE_NAME=fedora_reference-bootc
REPO_ORGANIZATION="binnotkari-wq"
```

---
## Configuration du workflow container

On limite le build automatisé à une fois par mois.

./.github/workflows/build.yml

```
    - cron: '0 3 1 * *'  # le 1er de chaque mois à 3h00 UTC
  # push:                # build auto désactivé pour économiser du temps Actions
  #   branches:
  #     - main
  #   paths-ignore:
  #    - '**/README.md'
```

---
## Configuration du worlflow ISO

On veut un build d'après iso-gnome.toml, et on ne veut pas de génération d'image qcow (seulement l'iso), le build se fait sur un hôte avec btrfs.

./.github/workflows/build-disk.yml

```
      - './disk_config/iso-gnome.toml'

              disk-type: ["anaconda-iso"]

          config-file: ${{ matrix.disk-type == 'anaconda-iso' && './disk_config/iso-gnome.toml' || './disk_config/disk.toml' }}
          
          additional-args: --use-librepo=True --rootfs btrfs
```

---
## On commente les exemples de modififications

./build_files/build.sh

```
# dnf5 install -y tmux
# systemctl enable podman.socket
=======
IMAGE_NAME adapté

---

## Simplification de build.sh (renommé en environment.sh) et permissions

./build_files/environment.sh

Tous les commentaires d'exemples sont supprimés.
Les permissions des fichiers injectés depuis system_files sont appliquées.
dconf est mis à jour.

```
chmod 755 /etc/scripts/system-update.sh
chmod 755 /etc/scripts/bootc-welcome.sh
chmod 644 /etc/profile.d/10-environment.sh
chmod 755 /etc/skel/Modèles/Script.sh
dconf update
>>>>>>> b80a7b4 (Auto-sync [len-380] : 2026-08-13 02:13:33)
```

---
## Configuration de Anaconda (intervient pour le build de l'ISO)
<<<<<<< HEAD
On spécifie la localisation (en l'absence de spécification, tout est en anglais) :

- on met à disposition le francais
- on ajoute le module de localization

> à noter : si on le spécifie rien, anaconda sera en anglais, mais au premier démarrage de l'OS on pourra choisir la langue de l'OS.

- on switch sur le canal online (sinon, le canal restera sur une source localhost).

./disk_config/iso-gnome.toml

```
# Configuration de la localisation pour l'installateur
lang fr_FR.UTF-8
keyboard fr
timezone Europe/Paris
```

```
bootc switch --mutate-in-place --transport registry ghcr.io/binnotkari-wq/fedora_reference-bootc:latest
```

```
  "org.fedoraproject.Anaconda.Modules.Localization",
```
=======

./disk_config/iso-gnome.toml

Nom de l'image adapté
>>>>>>> b80a7b4 (Auto-sync [len-380] : 2026-08-13 02:13:33)

---
## Validation

<<<<<<< HEAD
- build container Github Actions : OK
- build container local : OK
- build ISO Github Actions : OK
- build ISO local : OK
- switch container Github Actions :
- switch container local :
- installation ISO Github Actions : OK
- installation ISO local : OK
=======
- build container Github Actions :
- build container local :
- build ISO Github Actions :
- build ISO local :
- switch container Github Actions :
- switch container local :
- installation ISO Github Actions :
- installation ISO local :
>>>>>>> b80a7b4 (Auto-sync [len-380] : 2026-08-13 02:13:33)
