#!/usr/bin/env bash
# /etc/scripts/bootc-welcome.sh

RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
GRAY='\033[0;90m'
RED='\033[0;31m'
BLUE='\033[0;34m'

echo ""
echo -e "${PURPLE}⬡${RESET}  ${BOLD}${BLUE}Bienvenue sur $(source /etc/os-release && echo "$PRETTY_NAME")${RESET}  ${GRAY}— $HOSTNAME${RESET}"
echo ""

echo -e "${YELLOW}▸ MISE À JOUR${RESET}"
echo -e "  ${CYAN}bootc status${RESET}                          ${GRAY}# Image active, staged et rollback${RESET}"
echo -e "  ${CYAN}sudo bootc upgrade${RESET}                    ${GRAY}# Télécharge, applique au prochain reboot${RESET}"
echo -e "  ${CYAN}sudo bootc upgrade --apply${RESET}            ${GRAY}# Télécharge et redémarre immédiatement${RESET}"
echo ""

echo -e "${YELLOW}▸ IMAGE DE BASE${RESET}"
echo -e "  ${CYAN}sudo bootc switch <image>${RESET}             ${GRAY}# Change la référence d'image suivie${RESET}"
echo -e "  ${GRAY}# Toute modification passe par le Containerfile + rebuild, jamais par dnf en local${RESET}"
echo ""

echo -e "${YELLOW}▸ ROLLBACK${RESET}"
echo -e "  ${RED}sudo bootc rollback${RESET}                   ${GRAY}# Revenir au déploiement précédent${RESET}"
echo ""

echo -e "${YELLOW}▸ DIAGNOSTIC${RESET}"
echo -e "  ${CYAN}journalctl -b -p err${RESET}                  ${GRAY}# Erreurs depuis le dernier boot${RESET}"
echo -e "  ${CYAN}systemctl --failed${RESET}                    ${GRAY}# Services en échec${RESET}"
echo ""

echo -e "${YELLOW}▸ UTILES${RESET}"
echo -e "  ${CYAN}alias${RESET}                                 ${GRAY}# Liste les commandes personnalisées${RESET}"
echo ""
