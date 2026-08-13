# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# Base Image
# FROM quay.io/fedora-ostree-desktops/silverblue:44
FROM localhost/fedora_reference-bootc:latest

### On provisionne les fichiers d'installation de brew dans le rootfs de l'image bootc
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /


### NB : /var/cache, /var/log et /tmp sont des montages provisoire pendant le build, ils sont donc hors de l'image qui reste donc sans résidus

### fichiers injectés dans /etc et /usr (configs, scripts, skels, services...)
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/environment.sh

### installation des services de brew (universal blue), binaire de llama, repo flathub, rpm
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/softwares.sh

### améliorations des performances
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/tweaks.sh

### suppression des logiciels et services non souhaités (+ vidange finale de /ust/etc)
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/trimming.sh && rm -rf /usr/etc

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
