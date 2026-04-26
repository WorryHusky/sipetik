# PETIK - Pemesanan Tiket Travel 🚌

Aplikasi mobile berbasis Flutter untuk pemesanan tiket travel secara real-time. Proyek ini dikembangkan sebagai bagian dari tugas akademik di **Politeknik Elektronika Negeri Surabaya**.

---

## 👤 Identitas Mahasiswa
* **Nama:** Mochamad Ardhito Cakra Arya Pratama
* **NRP:** 3124510116
* **Program Studi:** D3 PJJ Teknik Informatika
* **Institusi:** Politeknik Elektronika Negeri Surabaya (PENS)

---

## 🚀 Deskripsi Proyek
**PETIK** (Pemesanan Tiket Travel) adalah solusi digital untuk mempermudah pengguna dalam mencari jadwal keberangkatan bus travel, melakukan pemesanan kursi secara dinamis, hingga melihat riwayat transaksi. Aplikasi ini menggunakan **Supabase** sebagai backend untuk manajemen database relasional dan autentikasi keamanan.

### ✨ Fitur Utama:
1.  **Sistem Autentikasi Modern:**
    * Registrasi User & Login.
    * Verifikasi Email via **8-Digit OTP Code**.
    * Update Profil (Edit Nama Tampilan).
2.  **Manajemen Pemesanan:**
    * Daftar Jadwal Tiket Real-time dari Database.
    * Input Nama Penumpang Dinamis.
    * **Validasi Sisa Kursi** (Mencegah over-booking).
3.  **Sistem Pembayaran:**
    * Simulasi pembayaran menggunakan **QRIS**.
    * Update otomatis sisa kursi di database setelah transaksi sukses.
4.  **Riwayat & E-Ticket:**
    * Daftar riwayat pesanan user.
    * Detail E-Ticket (Pop-up invoice) yang menampilkan daftar nama penumpang.
5.  **Admin Panel (Role-Based):**
    * Akses khusus untuk akun Admin (`admin@gmail.com`).
    * Fitur CRUD (Create, Read, Update, Delete) jadwal tiket langsung dari aplikasi.

---

## 🛠️ Tech Stack
* **Frontend:** Flutter (Dart)
* **Backend:** Supabase (Auth & PostgreSQL)
* **Database:** PostgreSQL
* **State Management:** StatefulWidget (Native)

---

## ⚙️ Cara Menjalankan Project
1.  **Clone Repository:**
    ```bash
    git clone [https://github.com/username/sipetik.git](https://github.com/username/sipetik.git)
    ```
2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Konfigurasi Supabase:**
    Pastikan URL dan Anon Key sudah terpasang di file `lib/main.dart`.
4.  **Run Application:**
    ```bash
    flutter run
    ```

---

## 📊 Struktur Database (PostgreSQL)
Aplikasi ini menggunakan 3 tabel utama di Supabase:
* `tickets`: Menyimpan data bus, rute, harga, dan sisa kursi.
* `bookings`: Mencatat transaksi user, total harga, dan daftar nama penumpang (format JSONB).
* `auth.users`: Tabel bawaan Supabase untuk manajemen akun.

---
*Proyek ini dikembangkan untuk memenuhi tugas mata kuliah dengan menerapkan metodologi Agile Development.*
