# Course Explorer v2 - Architecture Documentation

Project ini menggunakan arsitektur pemisahan tanggung jawab (Separation of Concerns) dengan struktur folder sebagai berikut:

* **`models/`** : Menyimpan representasi struktur data (misal: class `Course`) dan logika *parsing* dari JSON (`Course.fromJson()`).
* **`services/`** : Bertanggung jawab menangani detail teknis pengambilan data mentah, seperti membaca file JSON dari `rootBundle` (atau nantinya melakukan HTTP Request ke API). Tidak boleh berisi kode UI.
* **`repositories/`** : Menjadi lapisan abstraksi (jembatan) pelindung antara sumber data (Service) dan otak aplikasi (Provider).
* **`providers/`** : Sebagai pengelola status (*State Management*) dan logika bisnis. Mengurus data *loading*, *error*, *success*, serta memanggil `notifyListeners()` untuk memperbarui UI. Tidak boleh menyimpan `BuildContext`.
* **`screens/`** : Berisi halaman-halaman utama antarmuka pengguna (UI) seperti HomePage, CoursesPage, dan FavoritesPage. Mengambil data menggunakan `context.watch()` atau `context.read()`.
* **`widgets/`** : Berisi potongan-potongan komponen UI yang dapat digunakan kembali secara berulang (*reusable*), contohnya `CourseCard` dan `StudentHeader`.