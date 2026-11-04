# Troubleshooting Mining VRSC di Termux

## `No such file or directory` saat `cd ~/vrsc` atau `./mine-vrsc.sh`

Penyebab: folder / file belum kebuat, biasanya karena semua perintah
ditempel sekaligus waktu `pkg install` masih jalan, jadi perintah
berikutnya ketelan dan tidak dieksekusi.

Perbaiki, satu per satu, tunggu prompt `$` balik tiap perintah:

```bash
mkdir -p ~/vrsc
cd ~/vrsc
ls -l
```

Kalau `ls` belum menampilkan file, download ulang file itu, jangan
langsung loncat ke `chmod` atau `./mine-vrsc.sh`.

## `bad interpreter: /data/data/com.termux/files/usr/bin/bash: No such file`

Penyebab: shebang lama hardcoded ke paket `com.termux`, padahal terminal
yang dipakai paketnya `com.terminalcode`, jadi jalur bash itu tidak ada.

Perbaiki tanpa download ulang:

```bash
bash mine-vrsc.sh
```

Script di repo ini sudah pakai `#!/usr/bin/env bash`, jadi `./mine-vrsc.sh`
juga jalan di kedua paket terminal itu.

## `ccminer: No such file` / miner tidak jalan

- Pastikan kamu di folder yang benar: `cd ~/vrsc`, lalu `ls -l`.
- Jalankan `bash install.sh` untuk download `ccminer` ARM64.
- Pastikan HP 64-bit: `uname -m` harus `aarch64`. HP 32-bit tidak cocok.

## Layar mining jalan, tapi pool tidak menampilkan worker

- Tunggu beberapa menit, pool butuh waktu untuk menampilkan worker baru.
- Cek wallet: `bash cek-saldo.sh` — pastikan alamatnya sama dengan yang
  dipakai mining, diawali `R...`, tanpa spasi.
- Cek internet HP, dan pastikan pool yang dipakai masih aktif (lihat
  `pools.md`).

## Saldo di pool ada, tapi belum masuk wallet

Itu normal di LuckPool: pembayaran otomatis setiap 20 jam, dan hanya
kalau saldo sudah melewati minimum payout (default 0,0001 VRSC).
Cek dengan:

```bash
bash payout.sh
bash riwayat-pembayaran.sh
```

Jangan ganti wallet di tengah jalan, dan jangan mengira saldo pool =
saldo wallet. Saldo pool baru jadi uang di wallet setelah payout.

## HP panas / baterai cepat habis

- Turunkan thread: `bash mine-vrsc.sh ALAMAT_R hp1 2` (2 thread, contoh).
- Mining sambil dicas, di tempat sejuk, jangan ditutup rapat.
- Jangan mining nonstop berhari-hari di HP utama. Pakai HP lama kalau ada.

## Miner berhenti sendiri

- Termux bisa dimatikan sistem kalau HP kehabisan RAM / baterai, atau
  layar terkunci lama tanpa wake lock.
- Jalankan lagi `bash mine-vrsc.sh`. Untuk jalan di background, pakai
  `termux-wake-lock` dulu (sudah ada di `mine-vrsc.sh`), atau:
  `nohup bash mine-vrsc.sh > mining.log 2>&1 &`
- Cek dengan `bash cek-miner.sh`, berhenti dengan `bash stop.sh`.
