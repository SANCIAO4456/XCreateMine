#!/usr/bin/env bash
# stop.sh — berhentikan mining (ccminer) di HP ini.
# Pakai: bash stop.sh
CYAN='\033[1;36m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  ⏹  STOP MINING                       ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
if pgrep ccminer >/dev/null 2>&1; then
  pkill -f ccminer
  sleep 1
  if pgrep ccminer >/dev/null 2>&1; then
    printf "%bccminer masih jalan, coba pakai: pkill -9 -f ccminer%b\n" "$YELLOW" "$RESET"
  else
    printf "%bMining sudah berhenti.%b\n" "$GREEN" "$RESET"
  fi
else
  echo "Tidak ada ccminer yang jalan."
fi
