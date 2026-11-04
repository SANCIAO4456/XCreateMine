# Mining VRSC di Termux — Paket Lengkap

Mining VerusCoin (VRSC) dari HP Android 64-bit lewat Termux, ke pool LuckPool Asia.
Setiap fungsi ada di file sendiri, tidak digabung jadi satu file.

> Keamanan dulu: yang dipakai di sini hanya alamat wallet publik VRSC yang
> diawali `R...`. Jangan pernah memasukkan seed phrase, private key, atau
> password ke script mana pun di repo ini, dan jangan upload file
> `.vrsc_wallet` kamu ke GitHub.

## Penggunaan yang sesuai — baca dulu

Repo ini hanya untuk dipakai di perangkat kamu sendiri, untuk belajar.
Script di sini **hanya dijalankan di HP Android kamu lewat Termux**.
Jangan pernah menjalankan mining lewat GitHub Actions, GitHub Codespaces,
GitHub Pages, atau server GitHub lainnya, dan jangan memakai repo ini
untuk aktivitas otomatis massal di GitHub.

Repo ini bukan janji penghasilan, bukan skema cepat kaya, dan tidak
terafiliasi dengan LuckPool atau Verus. Hasil mining kecil dan tidak
bisa dijanjikan. Detail lengkapnya ada di `CATATAN-KEPATUHAN.md`.
Tidak ada jaminan repo ini tidak akan di-flag oleh GitHub — kepatuhan
di atas hanya mengurangi risiko, bukan menghilangkannya.

## Syarat

- HP Android 64-bit (ARM64 / aarch64). Cek dengan `uname -m`, harus `aarch64`.
- Termux dari F-Droid / GitHub, bukan versi Play Store yang lama.
- Alamat wallet VRSC publik kamu sendiri, yang kamu kuasai private key-nya.
  Jangan mining ke alamat exchange.
- HP sambil dicas, tempat sejuk, jangan mining nonstop sampai HP overheat.

## File-file di repo ini

| File | Fungsi |
|---|---|
| `menu.sh` | Menu utama, hanya pemanggil. Pilih 1–8, 0 keluar, 7 stop mining. Fungsi tetap di file terpisah. |
| `mine-vrsc.sh` | Mining utama. Tanya wallet sekali, lalu mining ke LuckPool Asia. |
| `install.sh` | Instalasi awal Termux: update paket, instal `libjansson`, `wget`, `curl`, `jq`, dan download `ccminer` kalau belum ada. |
| `cek-saldo.sh` | Lihat saldo pool, saldo belum matang (immature), total sudah dibayar, hashrate, dan daftar worker. |
| `cek-worker.sh` | Lihat detail satu worker saja, misal `hp1`. |
| `riwayat-pembayaran.sh` | Lihat 10 pembayaran terakhir dari pool: tanggal, txid, dan jumlah VRSC. |
| `payout.sh` | Penjelasan withdraw / payout di LuckPool, plus cek apakah saldo sudah melewati minimum payout. |
| `cek-miner.sh` | Cek apakah `ccminer` sedang jalan di HP, dan lihat log terakhir kalau ada. |
| `stop.sh` | Berhentikan mining (`ccminer`). |
| `pools.md` | Daftar pool alternatif dan cara ganti pool. |
| `troubleshooting.md` | Daftar error yang sudah pernah terjadi dan cara perbaikinya. |
| `perbaiki-git.sh` | Perbaiki instalasi git di Termux yang gagal clone, lalu clone repo ini. |
| `CATATAN-KEPATUHAN.md` | Aturan pakai repo ini supaya tidak melanggar kebijakan GitHub. |
| `LICENSE` | Lisensi MIT untuk kode di repo ini. |
| `.gitignore` | Supaya `ccminer`, log, dan file wallet lokal tidak ikut ter-upload. |

## Sekali salin, sekali jalan (paling mudah)

Salin satu baris ini saja, tempel sekali di Termux, tunggu sampai menu
muncul. Jangan tempel perintah lain selagi perintah ini masih jalan,
karena tiap langkah menunggu langkah sebelumnya selesai.

```bash
cd ~; rm -rf XCreateMine; pkg update -y; pkg install -y git; pkg reinstall -y git; git clone https://github.com/SANCIAO4456/XCreateMine.git && cd XCreateMine && bash menu.sh
```

Setelah menu muncul, pilih `1` untuk mining, lalu masukkan alamat wallet
`R...` kamu. Perintah ini juga memperbaiki git yang sebelumnya error
`remote-https` dengan menginstal ulang git sebelum clone.

## Cara cepat (sudah punya script)

Pakai menu, jadi cukup ingat satu perintah:

```bash
# di folder repo ini, di Termux:
bash menu.sh
# lalu pilih angka:
# 1 = mining, 2 = cek saldo, 3 = cek worker, 4 = riwayat pembayaran,
# 5 = cek payout, 6 = cek miner, 7 = stop mining, 8 = install, 0 = keluar
```

Tanpa menu, tetap bisa langsung per file:

```bash
bash install.sh
bash mine-vrsc.sh
# masukkan alamat wallet R... kamu, lalu enter
```

Jalan berikutnya, wallet sudah tersimpan di `~/.vrsc_wallet`, jadi tinggal:

```bash
bash mine-vrsc.sh
```

Berhenti mining: tekan `CTRL+C`, atau dari terminal lain:

```bash
bash stop.sh
```

## Lihat saldo, worker, dan pembayaran

Semua perintah ini hanya membaca data publik pool dengan alamat wallet kamu.
Tidak ada login, tidak ada seed, tidak ada private key.

```bash
bash cek-saldo.sh
# atau dengan wallet lain, tanpa mengubah yang tersimpan:
bash cek-saldo.sh ALAMAT_R_KAMU

bash cek-worker.sh hp1
bash riwayat-pembayaran.sh
bash payout.sh
```

Artinya dari `cek-saldo.sh`:

- `balance` = saldo di pool yang belum dibayar.
- `immature` = reward yang masih menunggu konfirmasi / matang.
- `paid` = total yang sudah pernah dibayar pool ke wallet kamu.
- `hashrate` = kecepatan mining saat ini, dan `workers` = daftar worker yang
  sedang aktif di pool.

## Withdraw / payout — penting, baca ini

Di LuckPool **tidak ada tombol withdraw manual** seperti di situs cloud mining.
Pembayaran berjalan otomatis dari pool, dengan aturan yang sudah dipublikasi:

- Fee pool: 1%.
- Minimum payout default: 0,0001 VRSC (bisa diubah di dashboard pool).
- Jadwal payout: setiap 20 jam.
- Pembayaran dikirim langsung ke alamat wallet yang kamu pakai untuk mining.
  Pastikan alamat itu benar dan kamu kuasai, karena pembayaran blockchain
  tidak bisa dibatalkan.

Jadi `payout.sh` di repo ini bukan tombol tarik dana, melainkan alat cek:
apakah saldo kamu sudah melewati minimum payout, dan kapan kira-kira
pembayaran berikutnya dijadwalkan. Kalau saldo masih di bawah minimum,
tunggu sampai terkumpul dan jadwal payout berikutnya tiba.

Jangan ganti alamat wallet di tengah jalan kalau tidak perlu, karena saldo
di pool tercatat per alamat wallet.

## Ekspektasi yang jujur

- Hashrate HP umumnya sekitar 3–6 MH/s, tergantung model HP.
- Hasilnya kecil dan tidak bisa dijanjikan. Ini cocok untuk belajar dan
  iseng pakai HP lama, bukan untuk penghasilan utama.
- Mining bikin HP panas dan boros baterai. Mulai dari 4 thread dulu,
  naikkan hanya kalau HP tetap adem.

## Ganti pool

Lihat `pools.md`. Pool utama di script adalah LuckPool Asia
`ap.luckpool.net:3956`. Kalau mau ganti, edit variabel `POOL` di
`mine-vrsc.sh`, atau jalankan dengan pool lain sesuai contoh di `pools.md`.

## Kalau ada error

Buka `troubleshooting.md` dulu. Error yang sudah pernah terjadi di proyek
ini: folder belum kebuat karena tempel semua perintah sekaligus, dan
`bad interpreter` karena shebang lama mengarah ke `com.termux` padahal
terminal yang dipakai paketnya `com.terminalcode`. Keduanya sudah diperbaiki
di script sekarang: shebang pakai `#!/usr/bin/env bash`, dan jalankan
perintah satu per satu, atau pakai `bash namafile.sh`.
