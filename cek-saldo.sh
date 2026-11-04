#!/usr/bin/env bash
# cek-saldo.sh — lihat saldo pool LuckPool untuk satu alamat wallet.
# Hanya membaca data publik pool. Tidak perlu login, seed, atau private key.
# Pakai: bash cek-saldo.sh [ALAMAT_R]
# Kalau alamat tidak diisi, pakai alamat yang tersimpan di ~/.vrsc_wallet.
CYAN='\033[1;36m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; DIM='\033[2m'; RESET='\033[0m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  💰  CEK SALDO POOL                   ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
WALLET="${1:-}"
if [ -z "$WALLET" ] && [ -f "$HOME/.vrsc_wallet" ]; then
  WALLET="$(cat "$HOME/.vrsc_wallet")"
fi
if [ -z "$WALLET" ]; then
  printf "%bAlamat wallet belum ada.%b\n" "$YELLOW" "$RESET"
  echo "Pakai: bash cek-saldo.sh ALAMAT_R_KAMU"
  echo "Atau jalankan dulu bash mine-vrsc.sh supaya wallet tersimpan."
  exit 1
fi
case "$WALLET" in
  R*) ;;
  *) echo "Alamat harus diawali R..."; exit 1 ;;
esac
echo "Wallet : $WALLET"
printf "%bPool   : LuckPool%b\n" "$DIM" "$RESET"
echo "Mengambil data..."
JSON="$(curl -s "https://luckpool.net/verus/miner/$WALLET")"
if [ -z "$JSON" ]; then
  echo "Gagal mengambil data. Cek internet kamu, lalu coba lagi."
  exit 1
fi
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
if command -v jq >/dev/null 2>&1; then
  printf "Hashrate       : %b%s%b\n" "$GREEN" "$(echo "$JSON" | jq -r '.hashrateString // "-"')" "$RESET"
  printf "Saldo (balance): %b%s VRSC%b\n" "$GREEN" "$(echo "$JSON" | jq -r '.balance // "-"')" "$RESET"
  printf "Belum matang   : %b%s VRSC%b\n" "$YELLOW" "$(echo "$JSON" | jq -r '.immature // "-"')" "$RESET"
  printf "Total dibayar  : %b%s VRSC%b\n" "$GREEN" "$(echo "$JSON" | jq -r '.paid // "-"')" "$RESET"
  echo "Worker aktif   :"
  echo "$JSON" | jq -r '.workers[]? // empty'
elif command -v python3 >/dev/null 2>&1; then
  echo "$JSON" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print('Hashrate       :', d.get('hashrateString', '-'))
print('Saldo (balance):', d.get('balance', '-'), 'VRSC')
print('Belum matang   :', d.get('immature', '-'), 'VRSC')
print('Total dibayar  :', d.get('paid', '-'), 'VRSC')
print('Worker aktif   :')
for w in d.get('workers', []) or []:
    print(' ', w)
"
else
  echo "jq / python3 tidak ada. Data mentah:"
  echo "$JSON"
  echo "Instal salah satu: pkg install jq"
fi
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
echo "Catatan: balance = saldo di pool yang belum dibayar, bukan saldo di wallet kamu."
echo "Pembayaran pool lihat di: bash payout.sh  dan  bash riwayat-pembayaran.sh"
