# a199-flutter-expert-project

[![CI](https://github.com/raissaputra/submis-fde/actions/workflows/ci.yml/badge.svg)](https://github.com/raissaputra/submis-fde/actions/workflows/ci.yml)

Repository ini merupakan starter project submission kelas Flutter Expert Dicoding Indonesia.

## Fitur submission akhir

- **Continuous Integration** — GitHub Actions (`.github/workflows/ci.yml`) menjalankan `flutter analyze` dan `flutter test` untuk seluruh module pada setiap push/PR. Lihat badge status build di atas.
- **State management BLoC** — seluruh presentation layer memakai `flutter_bloc` (event-driven).
- **SSL Pinning** — koneksi ke TMDB API hanya mempercayai sertifikat yang di-pin (`modules/core/lib/common/ssl_pinning.dart`).
- **Modularization** — aplikasi dipecah menjadi package terpisah.

### Struktur modularisasi

| Package | Isi |
| --- | --- |
| `modules/core` | Kode bersama: common (constants, exception, failure, ssl_pinning, state_enum, utils), `DatabaseHelper`, entity/model `Genre`, dan `AppRoutes` (nama route lintas-module). |
| `modules/movie` | Fitur Movie (domain, data, presentation) — bergantung pada `core`. |
| `modules/tv_series` | Fitur TV Series (domain, data, presentation) — bergantung pada `core`. |
| root (`ditonton`) | Shell aplikasi: `main.dart`, dependency injection, routing — bergantung pada `core`, `movie`, `tv_series`. |

Menjalankan test seluruh module sekaligus (dengan gabungan coverage) memakai `test.sh` pada root repo.

---

## Tips Submission Awal

Pastikan untuk memeriksa kembali seluruh hasil testing pada submissionmu sebelum dikirimkan. Karena kriteria pada submission ini akan diperiksa setelah seluruh berkas testing berhasil dijalankan.


## Tips Submission Akhir

Jika kamu menerapkan modular pada project, Anda dapat memanfaatkan berkas `test.sh` pada repository ini. Berkas tersebut dapat mempermudah proses testing melalui *terminal* atau *command prompt*. Sebelumnya menjalankan berkas tersebut, ikuti beberapa langkah berikut:
1. Install terlebih dahulu aplikasi sesuai dengan Operating System (OS) yang Anda gunakan.
    - Bagi pengguna **Linux**, jalankan perintah berikut pada terminal.
        ```
        sudo apt-get update -qq -y
        sudo apt-get install lcov -y
        ```
    
    - Bagi pengguna **Mac**, jalankan perintah berikut pada terminal.
        ```
        brew install lcov
        ```
    - Bagi pengguna **Windows**, ikuti langkah berikut.
        - Install [Chocolatey](https://chocolatey.org/install) pada komputermu.
        - Setelah berhasil, install [lcov](https://community.chocolatey.org/packages/lcov) dengan menjalankan perintah berikut.
            ```
            choco install lcov
            ```
        - Kemudian cek **Environtment Variabel** pada kolom **System variabels** terdapat variabel GENTHTML dan LCOV_HOME. Jika tidak tersedia, Anda bisa menambahkan variabel baru dengan nilai seperti berikut.
            | Variable | Value|
            | ----------- | ----------- |
            | GENTHTML | C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml |
            | LCOV_HOME | C:\ProgramData\chocolatey\lib\lcov\tools |
        
2. Untuk mempermudah proses verifikasi testing, jalankan perintah berikut.
    ```
    git init
    ```
3. Kemudian jalankan berkas `test.sh` dengan perintah berikut pada *terminal* atau *powershell*.
    ```
    test.sh
    ```
    atau
    ```
    ./test.sh
    ```
    Proses ini akan men-*generate* berkas `lcov.info` dan folder `coverage` terkait dengan laporan coverage.
4. Tunggu proses testing selesai hingga muncul web terkait laporan coverage.

