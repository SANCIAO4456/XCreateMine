# Daftar Pool VRSC

Pool utama di `mine-vrsc.sh` adalah LuckPool Asia, karena paling dekat
dari Indonesia dan sudah teruji di proyek ini.

## LuckPool (utama)

- Website: https://luckpool.net/verus/
- Fee: 1%
- Minimum payout default: 0,0001 VRSC, bisa diubah di dashboard pool.
- Jadwal payout: setiap 20 jam.
- Tanpa daftar akun: username mining = alamat wallet, misal `ALAMAT_R.hp1`.
- Server:
  - Asia: `ap.luckpool.net:3956` (CPU, dipakai di script ini)
  - Asia SSL: `ap.luckpool.net:3958`
  - Amerika: `na.luckpool.net:3956`
  - Eropa: `eu.luckpool.net:3956`
- Cek saldo: `https://luckpool.net/verus/miner/ALAMAT_R`
- Cek pembayaran: `https://luckpool.net/verus/payments/ALAMAT_R`

## ZergPool (alternatif)

- Server Asia: `verushash.asia.mine.zergpool.com:3300`
- Contoh perintah (bukan default script ini):
  `ccminer -a verus -o stratum+tcp://verushash.asia.mine.zergpool.com:3300 -u ALAMAT_R.hp1 -p x`
- Cek fee, minimum payout, dan jadwal payout di situs ZergPool sendiri
  sebelum pindah, karena bisa berubah.

## Cara ganti pool

1. Buka `mine-vrsc.sh`, ganti baris `POOL="stratum+tcp://..."`.
2. Simpan, lalu jalankan lagi `bash mine-vrsc.sh`.
3. Cek worker di pool baru dengan `bash cek-saldo.sh` — ingat, saldo di
   pool lama tidak pindah ke pool baru. Saldo tercatat per pool per wallet.

Jangan mining ke alamat exchange, dan jangan pakai alamat yang private
key-nya tidak kamu kuasai.
