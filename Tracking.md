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

2) vérifier la bonne prise en compte des tweaks performance
3) vérifier que le système est propre (pas de traces de build)

## Analyse d'erreurs et imperfections

### 18/08/2026 VM

#### Build
Une seule erreur silencieuse dans le build :
+ flatpak remote-delete --system fedora --force
error: Remote "fedora" not found in the system installation

Corrigé et commenté dans trimming.sh
Vérifier l'absence d'erreur au prochain build.

#### Boot

Analyse de Claude (conversation Analyser les messages système Linux pour détecter les erreurs) d'apres le script check_system_health.sh en comparant le bootc custom avec le résultat sur Silverblue ISO d'origine :
RAS! Mon bootc présente même moins de bruit que l'installation faite avec l'ISO standard Silverblue.

#### Shutdown

Analyse de Claude (conversation Analyser les messages système Linux pour détecter les erreurs) d'apres le script check_system_health.sh en comparant le bootc custom avec le résultat sur Silverblue ISO d'origine :
RAS! Mon bootc présente même moins de bruit que l'installation faite avec l'ISO standard Silverblue.
Un message de gnome-settings-daemon qui ne trouve pas le service orca (qui n'existe plus puisque désinstallé), sans aucune conséquence.

#### Running