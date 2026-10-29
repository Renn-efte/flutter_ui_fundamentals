# Course Data Manager

Aplikasi manajemen data mata kuliah (Course) yang dikembangkan menggunakan Flutter. Proyek ini merupakan pengembangan dari aplikasi Course Explorer dengan menambahkan fitur integrasi database sungguhan.

## Fitur Utama
- **CRUD Operations**: Create, Read, Update, dan Delete data mata kuliah.
- **State Management**: Menggunakan `provider` untuk menangani state Loading, Success, Empty, dan Error secara reaktif.
- **Favorites**: Menambahkan atau menghapus mata kuliah dari daftar favorit secara lokal.
- **Responsive UI**: Antarmuka yang menyesuaikan dengan ukuran layar menggunakan `LayoutBuilder`.

## Arsitektur
Aplikasi ini menerapkan **Repository Pattern** dengan pemisahan *layer* yang jelas (Separation of Concerns):
1. **UI Layer (Screens & Widgets)**: Menampilkan antarmuka dan berinteraksi dengan Provider.
2. **State Layer (Provider)**: Mengelola logika bisnis dan state aplikasi.
3. **Repository Layer**: Menjadi perantara/kontrak antara sumber data dan state.
4. **Data Source Layer (Service)**: Menangani operasi HTTP/Database secara langsung.

## Backend
Proyek ini terhubung ke backend dan database PostgreSQL yang disediakan oleh **Supabase**. Modul koneksi menggunakan *package* `supabase_flutter`.

## Cara Menjalankan Aplikasi
1. Pastikan Flutter SDK sudah terpasang.
2. Clone repository ini.
3. Jalankan perintah `flutter pub get` di terminal.
4. Hubungkan ke emulator atau perangkat asli.
5. Jalankan perintah `flutter run`.