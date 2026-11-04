#!/usr/bin/env bash
# menu.sh — menu utama mining VRSC di Termux, tema baru.
# PENTING: file ini HANYA pemanggil. Semua fungsi tetap di file terpisah
# (mine-vrsc.sh, cek-saldo.sh, payout.sh, dan lain-lain), tidak digabung ke sini.
# Menu ini sengaja ringan: tidak ada pkg update, tidak ada download, tidak
# ada cek jaringan saat tampil, jadi menu muncul langsung, bukan loading lama.
# Jalankan: bash menu.sh
# Keluar menu: pilih 0. Keluar menu TIDAK sama dengan stop mining background,
# tapi kalau mining dijalankan dari menu ini (foreground), mining berhenti
# saat kamu tekan CTRL+C, lalu menu tampil lagi.

DIR="$(cd "$(dirname "$0")" && pwd)"
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
DIM='\033[2m'
RESET='\033[0m'

jalankan() {
  local file="$DIR/$1"
  shift
  if [ -f "$file" ]; then
    bash "$file" "$@"
  else
    printf "%bFile %s belum ada di folder ini.%b\n" "$RED" "$file" "$RESET"
    echo "Pastikan semua file repo sudah di-download."
  fi
}

tampil_menu() {
  # Bersihkan layar supaya menu selalu rapi di atas, seperti aplikasi.
  clear 2>/dev/null || printf '\033[2J\033[H'
  printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
  printf "%b║  ⛏  MINING VRSC  •  TERMUX           ║%b\n" "$CYAN" "$RESET"
  printf "%b║  Pool: LuckPool Asia                 ║%b\n" "$CYAN" "$RESET"
  printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
  if pgrep ccminer >/dev/null 2>&1; then
    printf "Status : %b● MINER JALAN%b\n" "$GREEN" "$RESET"
  else
    printf "Status : %b○ MINER BERHENTI%b\n" "$DIM" "$RESET"
  fi
  if [ -f "$HOME/.vrsc_wallet" ]; then
    printf "Wallet : %s\n" "$(cat "$HOME/.vrsc_wallet")"
  else
    printf "Wallet : %bbelum ada — pilih 1 dulu%b\n" "$YELLOW" "$RESET"
  fi
  printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
  printf " %b1%b  Mulai mining\n" "$CYAN" "$RESET"
  printf " %b2%b  Cek saldo pool\n" "$CYAN" "$RESET"
  printf " %b3%b  Cek worker\n" "$CYAN" "$RESET"
  printf " %b4%b  Riwayat pembayaran\n" "$CYAN" "$RESET"
  printf " %b5%b  Cek payout / withdraw\n" "$CYAN" "$RESET"
  printf " %b6%b  Cek miner jalan / tidak\n" "$CYAN" "$RESET"
  printf " %b7%b  Stop mining\n" "$CYAN" "$RESET"
  printf " %b8%b  Install / update ccminer\n" "$CYAN" "$RESET"
  printf " %b0%b  Keluar menu\n" "$CYAN" "$RESET"
  printf "%b────────────────────────────────────────%b\n" "$DIM" "$RESET"
}

while true; do
  tampil_menu
  read -r -p "Pilih [0-8]: " PILIH
  echo ""
  case "$PILIH" in
    1)
      printf "%bMulai mining... tekan CTRL+C untuk berhenti dan kembali ke menu.%b\n" "$GREEN" "$RESET"
      jalankan mine-vrsc.sh
      echo "Kembali ke menu."
      ;;
    2) jalankan cek-saldo.sh ;;
    3)
      read -r -p "Nama worker [hp1]: " WORKER
      WORKER="${WORKER:-hp1}"
      jalankan cek-worker.sh "$WORKER"
      ;;
    4) jalankan riwayat-pembayaran.sh ;;
    5) jalankan payout.sh ;;
    6) jalankan cek-miner.sh ;;
    7) jalankan stop.sh ;;
    8) jalankan install.sh ;;
    0)
      echo "Keluar menu. Sampai jumpa."
      echo "Catatan: kalau mining tadi jalan di foreground, mining sudah berhenti saat CTRL+C."
      echo "Kalau mining jalan di background, gunakan pilihan 7 (Stop mining) untuk menghentikannya."
      break
      ;;
    *)
      printf "%bPilihan tidak ada. Pilih angka 0 sampai 8.%b\n" "$YELLOW" "$RESET"
      ;;
  esac
  if [ "$PILIH" != "0" ]; then
    echo ""
    read -r -p "Tekan Enter untuk kembali ke menu... " _
  fi
done
