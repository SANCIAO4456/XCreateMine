#!/usr/bin/env bash
# riwayat-pembayaran.sh — lihat 10 pembayaran terakhir dari LuckPool.
# Format dari pool: timestamp:txid:jumlah, terbaru dulu.
# Hanya membaca data publik pool. Tidak perlu login atau private key.
# Pakai: bash riwayat-pembayaran.sh [ALAMAT_R]
CYAN='\033[1;36m'; GREEN='\033[1;32m'; DIM='\033[2m'; RESET='\033[0m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  🧾  RIWAYAT PEMBAYARAN               ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
WALLET="${1:-}"
if [ -z "$WALLET" ] && [ -f "$HOME/.vrsc_wallet" ]; then
  WALLET="$(cat "$HOME/.vrsc_wallet")"
fi
if [ -z "$WALLET" ]; then
  echo "Alamat wallet belum ada. Pakai: bash riwayat-pembayaran.sh ALAMAT_R_KAMU"
  exit 1
fi
echo "Wallet : $WALLET"
echo "Mengambil riwayat pembayaran (10 terbaru)..."
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
JSON="$(curl -s "https://luckpool.net/verus/payments/$WALLET")"
if [ -z "$JSON" ] || [ "$JSON" = "[]" ]; then
  echo "Belum ada pembayaran untuk wallet ini, atau wallet belum pernah mining di pool ini."
  exit 0
fi
if command -v python3 >/dev/null 2>&1; then
  echo "$JSON" | python3 -c "
import sys, json, datetime
data = json.load(sys.stdin)
for item in data[:10]:
    try:
        ts, txid, amount = item.split(':', 2)
        dt = datetime.datetime.fromtimestamp(int(ts) / 1000).strftime('%Y-%m-%d %H:%M')
        print(f'{dt}  {amount} VRSC  txid: {txid}')
    except Exception:
        print(item)
"
else
  echo "$JSON" | tr ',' '\n' | head -20
  echo "Instal python3 untuk tampilan yang rapi: pkg install python"
fi
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
echo "Cek txid di explorer Verus kalau mau memastikan pembayaran sudah masuk wallet."
