#!/usr/bin/env bash
# Mining VRSC (VerusCoin) di Termux — jalur cepat.
# Pool: LuckPool Asia ap.luckpool.net:3956, algo verus, password x
# Cara pakai:
#   bash mine-vrsc.sh
#   -> nanti ditanya alamat wallet R... sekali saja, lalu langsung mining.
#   -> alamat itu disimpan di ~/.vrsc_wallet (alamat publik saja) supaya
#      jalan berikutnya tidak ditanya lagi, dan langsung mulai.
# Atau langsung: bash mine-vrsc.sh ALAMAT_R_KAMU [nama_worker] [jumlah_thread]
# Berhenti: CTRL + C
# JANGAN pernah masukkan seed phrase / private key ke sini.
#
# Kenapa ini cepat: kalau ccminer sudah ada dan wallet sudah tersimpan,
# script ini TIDAK menjalankan pkg update, TIDAK menjalankan pkg install,
# dan TIDAK mengunduh ulang apa pun. Ia langsung exec ccminer.
# pkg install / download hanya jalan kalau ccminer belum ada, dan itu pun
# tanpa pkg update dulu — pkg update baru dicoba kalau download pertama gagal.

POOL="stratum+tcp://ap.luckpool.net:3956"
WALLET_FILE="$HOME/.vrsc_wallet"
DIR="$(cd "$(dirname "$0")" && pwd)"
CC="$DIR/ccminer"
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

WALLET="${1:-}"
WORKER="${2:-hp1}"
THREADS="${3:-4}"

if [ -z "$WALLET" ] && [ -f "$WALLET_FILE" ]; then
  WALLET="$(cat "$WALLET_FILE")"
fi

if [ -z "$WALLET" ]; then
  echo "Masukkan alamat wallet VRSC kamu (diawali R...):"
  read -r WALLET
fi

# Validasi dasar: harus diawali R dan cukup panjang, bukan seed phrase.
case "$WALLET" in
  R??????????????????????????????*) ;;
  *)
    echo "Alamat tidak valid. Harus alamat publik VRSC diawali R..., bukan seed phrase."
    exit 1
    ;;
esac

# Simpan wallet hanya kalau berubah, supaya tidak ada tulis file sia-sia.
if [ ! -f "$WALLET_FILE" ] || [ "$(cat "$WALLET_FILE")" != "$WALLET" ]; then
  echo "$WALLET" > "$WALLET_FILE"
  chmod 600 "$WALLET_FILE" 2>/dev/null || true
fi

if [ "$(uname -m)" != "aarch64" ]; then
  printf "%bPerhatian: script ini untuk HP Android 64-bit (aarch64). Terdeteksi: %s%b\n" "$YELLOW" "$(uname -m)" "$RESET"
fi

if [ ! -x "$CC" ]; then
  echo "[1/2] ccminer belum ada, instal dependensi sekali saja (tanpa pkg update dulu)..."
  pkg install -y libjansson wget >/dev/null 2>&1 || true
  echo "[2/2] Mengunduh ccminer..."
  if ! wget https://raw.githubusercontent.com/rismzun/ccminer-auto-run/main/ccminer -O "$CC"; then
    echo "Download pertama gagal, coba update paket lalu download lagi..."
    pkg update -y >/dev/null 2>&1 || true
    pkg install -y libjansson wget >/dev/null 2>&1 || true
    wget https://raw.githubusercontent.com/rismzun/ccminer-auto-run/main/ccminer -O "$CC" || {
      echo "ccminer gagal diunduh. Cek internet kamu, lalu jalankan lagi."
      exit 1
    }
  fi
  chmod +x "$CC"
  echo "ccminer siap."
else
  echo "ccminer sudah ada, langsung mulai (tanpa download / instal ulang)."
fi

if [ ! -x "$CC" ]; then
  echo "ccminer tidak ditemukan / tidak bisa dieksekusi."
  exit 1
fi

printf "%b╔══════════════════════════════════════╗%b\n" "$CYAN" "$RESET"
printf "%b║  ⛏  MULAI MINING VRSC                ║%b\n" "$CYAN" "$RESET"
printf "%b╚══════════════════════════════════════╝%b\n" "$CYAN" "$RESET"
echo "Pool   : $POOL"
echo "Wallet : $WALLET.$WORKER"
echo "Threads: $THREADS"
echo "Catatan: hashrate langsung jalan, tapi 'accepted' pertama bisa 1-2 menit"
echo "karena difficulty pool — itu normal, bukan loading macet."
printf "%bTekan CTRL+C untuk berhenti.%b\n" "$GREEN" "$RESET"
cd "$DIR" || exit 1
termux-wake-lock 2>/dev/null || true
# exec: langsung ganti proses shell dengan ccminer, tanpa proses perantara.
exec "$CC" -a verus -o "$POOL" -u "$WALLET.$WORKER" -p x -t "$THREADS"
