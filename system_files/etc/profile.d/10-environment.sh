#!/usr/bin/env bash
# /etc/profile.d/10-environment.sh

# ── Historique ────────────────────────────────────────────────
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%s "

# ── PATH ──────────────────────────────────────────────────────
export PATH="$HOME/Git/scripts:$PATH"

# ── Alias ─────────────────────────────────────────────────────
alias d='du -h --max-depth=0'
alias ll='ls -l'
alias bkp='$HOME/Git/scripts/backup.sh'
alias bh='$HOME/Git/scripts/bash-history-export.sh'
alias gs='$HOME/Git/scripts/git-sync.sh'

alias gemma='llama-cli --model "/cargo/local_cache/LLM/gemma-3-4b-it-Q8_0.gguf" --conversation --system-prompt "Tu es un assistant compréhensif pour la vie quotidienne : ménage, jardin, travaux, mécanique." --no-mmap --ctx-size 4096'
alias qwen='llama-cli --model "/cargo/local_cache/LLM/Qwen2.5-Coder-3B-Instruct-abliterated-Q4_K_M.gguf" --conversation --system-prompt "Tu es un assistant concis en ingénierie des systèmes linux, scripting, développement." --no-mmap --ctx-size 4096'
alias llama='llama-cli --model "/cargo/local_cache/LLM/Llama-3.2-3B-Instruct-Q4_K_M.gguf" --conversation --system-prompt "Tu es un assistant personnel pour aider à explorer de nouveaux concepts." --no-mmap --ctx-size 4096'

alias sup='/etc/scripts/system-update.sh'     # update système et flatpaks
alias bstat='bootc status'
alias bup='sudo bootc upgrade --apply'     # applique et redémarre immédiatement
alias bstage='sudo bootc upgrade'          # télécharge, applique au prochain reboot
alias brb='sudo bootc rollback'
alias bs='sudo bootc switch'               # ex: bswitch quay.io/moi/mon-image:latest


# ── Prompt, historique immédiat, message de bienvenue ───────────
if [[ $- == *i* ]]; then
    PS1='\[\e[01;32m\][\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[01;32m\]]\$\[\e[00m\] '
    shopt -s histappend
    echo "# SESSION $(date +%s)" >> "$HISTFILE"
    PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
    bash /etc/scripts/bootc-welcome.sh
fi
