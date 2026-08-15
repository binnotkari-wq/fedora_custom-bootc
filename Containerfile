# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# Base Image
FROM quay.io/fedora-ostree-desktops/silverblue:44
# FROM localhost/fedora_reference-bootc:latest

### Intégration de brew dans L'OCI (https://github.com/ublue-os/brew)
### On provisionne les fichiers d'installation de brew dans le rootfs de l'image bootc
# COPY --from=ghcr.io/ublue-os/brew:latest /system_files /

### NB : /var/cache, /var/log et /tmp sont des montages provisoire pendant le build, ils sont donc hors de l'image qui reste donc sans résidus. Vidange finale de /ust/etc.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && rm -rf /usr/etc

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
