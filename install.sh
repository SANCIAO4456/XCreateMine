#!/usr/bin/env bash
# install.sh — instalasi awal mining VRSC di Termux, dibuat lebih cepat.
# Tidak lagi wajib pkg update dulu: instalasi dicoba langsung, pkg update
# hanya jalan kalau instalasi pertama gagal. Ini yang bikin loading lama
# di versi lama.
# File ini hanya instalasi, bukan mining. Mining ada di mine-vrsc.sh.
set -e
CYAN='\033[1;36m'; RESET='\033[0m'; DIM='\033[2m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  📥  INSTALL MINING                   ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
echo "Instal paket yang dibutuhkan (tanpa pkg update dulu)..."
if ! pkg install -y libjansson wget curl jq unzip; then
  echo "Instal pertama gagal, coba pkg update lalu instal lagi..."
  pkg update -y
  pkg install -y libjansson wget curl jq unzip
fi
echo "Membuat folder kerja ~/vrsc (kalau belum ada)..."
mkdir -p ~/vrsc
cd ~/vrsc || exit 1
if [ ! -f ./ccminer ]; then
  echo "Mengunduh ccminer ARM64..."
  wget https://raw.githubusercontent.com/rismzun/ccminer-auto-run/main/ccminer -O ccminer
  chmod +x ccminer
else
  echo "ccminer sudah ada, dilewati (tidak download ulang)."
fi
echo ""
echo "Selesai. Selanjutnya:"
echo "  bash menu.sh"
echo "  pilih 1 untuk mining"
