#!/usr/bin/env bash
# perbaiki-git.sh — perbaiki git di Termux yang gagal clone dengan error:
#   git 'remote-https' is not a git command
#   fatal: remote helper 'https' aborted
#   warning: templates not found
# Penyebabnya BUKAN file repo yang rusak, tapi instalasi git di Termux
# yang belum lengkap / terpotong. Script ini instal ulang git, lalu
# cek helper-nya, lalu clone repo mining.
# Jalankan SATU perintah ini saja, tunggu sampai selesai, jangan tempel
# perintah lain selagi pkg install masih jalan:
#   bash perbaiki-git.sh
set -e
CYAN='\033[1;36m'; RESET='\033[0m'
printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  🔧  PERBAIKI GIT                     ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
echo "1. Hapus folder XCreateMine setengah jadi kalau ada..."
rm -rf XCreateMine
echo "2. Update paket Termux..."
pkg update -y
echo "3. Instal ulang git..."
pkg install -y git
echo "4. Cek git dan helper https..."
git --version
ls "$PREFIX/libexec/git-core/git-remote-https" || ls /data/data/com.termux/files/usr/libexec/git-core/git-remote-https || echo "PERINGATAN: git-remote-https masih tidak ditemukan, coba pkg reinstall git"
echo "5. Clone repo mining..."
git clone https://github.com/SANCIAO4456/XCreateMine.git
echo ""
echo "Selesai. Lanjut:"
echo "  cd XCreateMine"
echo "  ls"
echo "  bash menu.sh"
