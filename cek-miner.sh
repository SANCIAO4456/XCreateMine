#!/usr/bin/env bash
# cek-miner.sh — cek apakah ccminer sedang jalan di HP ini.
# File ini hanya cek proses lokal, bukan cek pool.
CYAN='\033[1;36m'; GREEN='\033[1;32m'; RED='\033[1;31m'; DIM='\033[2m'; RESET='\033[0m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  📊  CEK MINER                        ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
if pgrep -a ccminer >/dev/null 2>&1; then
  printf "%b● Miner JALAN:%b\n" "$GREEN" "$RESET"
  pgrep -a ccminer
else
  printf "%b○ Miner TIDAK jalan.%b\n" "$RED" "$RESET"
  echo "Jalankan: bash menu.sh, lalu pilih 1"
fi
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
if [ -f mining.log ]; then
  echo "Log terakhir (mining.log):"
  tail -20 mining.log
fi
