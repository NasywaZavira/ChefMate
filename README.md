# ChefMate

Aplikasi mobile resep & rencana makan — Tugas Akhir Mata Kuliah Pemrograman
Mobile (ILK3105). Dibangun dengan Flutter, state di memori (tanpa backend),
lewat lapisan repository simulasi untuk alur loading/gagal.

## Fitur utama

- **Beranda** — jelajah & cari resep (judul/bahan), filter kategori.
- **Kalender** — rencana makan per tanggal, modul CRUD dengan relasi ke resep.
- **Daftar Belanja** — modul CRUD kedua, tandai dibeli, bagikan lewat clipboard.
- **Detail Resep** — bahan, alat, langkah, bookmark resep favorit.
- **Chatbot** — asisten tanya-jawab seputar bahan/resep (rule-based).
- **Profil & Pengaturan** — preferensi diet, anggaran, notifikasi.

## Cara menjalankan

1. Pastikan Flutter SDK sudah terpasang (`flutter --version`).
2. Clone repo ini, lalu masuk ke foldernya:
   ```bash
   git clone https://github.com/NasywaZavira/ChefMate.git
   cd ChefMate
   ```
3. Ambil dependency:
   ```bash
   flutter pub get
   ```
4. Jalankan di emulator/device yang sudah terhubung:
   ```bash
   flutter run
   ```
5. (Opsional) jalankan test:
   ```bash
   flutter test
   ```

## Struktur folder

```
lib/
  data/            data resep/kategori dummy + repository simulasi
  models/          model data (Recipe, MealPlanEntry, ShoppingItem, Category)
  screens/         semua layar UI
  state/           AppState (penyimpanan di memori, ChangeNotifier)
  theme/           warna, tipografi, style komponen bersama
```

## Catatan data simulasi

Tidak ada backend/API sungguhan. Semua data (`AppState`) hidup di memori dan
reset setiap aplikasi dijalankan ulang. Operasi simpan/hapus di modul
Kalender dan Daftar Belanja lewat `AppRepository`
(`lib/data/app_repository.dart`), yang menambahkan jeda ~700ms dan opsi
`simulateError` untuk menguji skenario loading/gagal/coba-lagi — ada toggle
"Simulasikan gagal (untuk demo/uji)" di masing-masing form untuk memicunya.