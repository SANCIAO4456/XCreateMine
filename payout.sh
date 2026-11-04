#!/usr/bin/env bash
# payout.sh — cek status payout / withdraw di LuckPool.
# PENTING: LuckPool tidak punya tombol withdraw manual.
# Pembayaran otomatis dari pool ke wallet mining kamu, dengan aturan:
#   - fee pool 1%
#   - minimum payout default 0,0001 VRSC (bisa diubah di dashboard pool)
#   - jadwal payout setiap 20 jam
# File ini hanya MENGECEK, bukan menarik dana. Tidak ada private key di sini.
# Pakai: bash payout.sh [ALAMAT_R]
CYAN='\033[1;36m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; DIM='\033[2m'; RESET='\033[0m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  💸  CEK PAYOUT / WITHDRAW            ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
WALLET="${1:-}"
if [ -z "$WALLET" ] && [ -f "$HOME/.vrsc_wallet" ]; then
  WALLET="$(cat "$HOME/.vrsc_wallet")"
fi
if [ -z "$WALLET" ]; then
  echo "Alamat wallet belum ada. Pakai: bash payout.sh ALAMAT_R_KAMU"
  exit 1
fi
echo "Wallet : $WALLET"
echo "Mengambil saldo..."
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
JSON="$(curl -s "https://luckpool.net/verus/miner/$WALLET")"
if [ -z "$JSON" ]; then
  echo "Gagal mengambil data. Cek internet kamu."
  exit 1
fi
BALANCE=""
if command -v jq >/dev/null 2>&1; then
  BALANCE="$(echo "$JSON" | jq -r '.balance // 0')"
  PAID="$(echo "$JSON" | jq -r '.paid // 0')"
elif command -v python3 >/dev/null 2>&1; then
  BALANCE="$(echo "$JSON" | python3 -c "import sys, json; print(json.load(sys.stdin).get('balance', 0))")"
  PAID="$(echo "$JSON" | python3 -c "import sys, json; print(json.load(sys.stdin).get('paid', 0))")"
else
  echo "Data mentah: $JSON"
  exit 0
fi
printf "Saldo di pool : %b%s VRSC%b\n" "$GREEN" "$BALANCE" "$RESET"
printf "Total dibayar : %b%s VRSC%b\n" "$GREEN" "$PAID" "$RESET"
echo "Minimum payout: 0,0001 VRSC (default, bisa diubah di dashboard pool)"
echo ""
if awk "BEGIN { exit !($BALANCE >= 0.0001) }"; then
  printf "%bStatus: saldo sudah melewati minimum payout.%b\n" "$GREEN" "$RESET"
  echo "Tunggu jadwal payout pool berikutnya (setiap 20 jam) supaya dikirim ke wallet kamu."
else
  printf "%bStatus: saldo masih di bawah minimum payout.%b\n" "$YELLOW" "$RESET"
  echo "Terus mining sampai saldo terkumpul, pembayaran akan otomatis saat jadwalnya tiba."
fi
printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
echo "Kalau pembayaran sudah dijadwalkan tapi belum masuk wallet, cek:"
echo "  bash riwayat-pembayaran.sh"
echo "Lalu cek txid-nya di explorer Verus."
echo "Pastikan alamat wallet mining kamu benar dan kamu kuasai — pembayaran tidak bisa dibatalkan."
