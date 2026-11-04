#!/usr/bin/env bash
# cek-worker.sh — lihat detail satu worker di LuckPool.
# Pakai: bash cek-worker.sh [nama_worker] [ALAMAT_R]
# Default worker: hp1. Kalau wallet tidak diisi, pakai ~/.vrsc_wallet.
CYAN='\033[1;36m'; RESET='\033[0m'; DIM='\033[2m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  👷  CEK WORKER                       ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
WORKER="${1:-hp1}"
WALLET="${2:-}"
if [ -z "$WALLET" ] && [ -f "$HOME/.vrsc_wallet" ]; then
  WALLET="$(cat "$HOME/.vrsc_wallet")"
fi
if [ -z "$WALLET" ]; then
  echo "Alamat wallet belum ada. Pakai: bash cek-worker.sh hp1 ALAMAT_R_KAMU"
  exit 1
fi
echo "Worker : $WALLET.$WORKER"
echo "Mengambil data..."
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
curl -s "https://luckpool.net/verus/worker/$WALLET.$WORKER"
echo ""
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
echo "Kalau hasilnya kosong, worker itu belum pernah / belum aktif di pool."
