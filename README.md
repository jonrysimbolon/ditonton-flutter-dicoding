# Ditonton

Aplikasi katalog film dan serial TV yang dibangun dengan Flutter. Proyek ini merupakan submission kelas **Flutter Expert** Dicoding Indonesia.

![Flutter](https://img.shields.io/badge/Flutter-3.47.5-blue)
![Dart](https://img.shields.io/badge/Dart-3.13.4-blue)
![Coverage](https://img.shields.io/badge/coverage-97.12%25-brightgreen)
![Tests](https://img.shields.io/badge/tests-371%20passed-success)

## Fitur

- Daftar film: Now Playing, Popular, dan Top Rated.
- Daftar serial TV: Airing Today, On The Air, Popular, dan Top Rated.
- Detail film dan serial TV, termasuk daftar season dan episode untuk serial TV.
- Pencarian film dan serial TV.
- Watchlist film dan serial TV yang disimpan secara lokal menggunakan SQLite.
- Halaman About.

## Arsitektur & Teknologi

- **Modularisasi** — aplikasi dibagi menjadi modul `ditonton_core`, `ditonton_movie`, dan `ditonton_tv`.
- **Clean Architecture** dengan pemisahan lapisan `data`, `domain`, dan `presentation` di setiap modul.
- **BLoC** untuk state management.
- **Dartz** (`Either`) untuk penanganan error tanpa exception.
- **Get It** untuk dependency injection.
- **HTTP** untuk konsumsi API [The Movie Database (TMDB)](https://www.themoviedb.org/).
- **SQFLite** untuk penyimpanan watchlist secara lokal.
- **SSL Pinning** sebagai lapisan keamanan tambahan saat mengakses API.
- **Firebase Analytics & Crashlytics** untuk memantau stabilitas dan laporan eror dari pengguna.
- **Mockito** untuk pembuatan mock pada pengujian.

## Struktur Proyek

```
a199-flutter-expert-project/
├── lib/              # Entry point aplikasi (package utama: ditonton)
├── ditonton_core/    # Modul core: entity, model, database, konfigurasi, SSL pinning
├── ditonton_movie/   # Modul fitur film
├── ditonton_tv/      # Modul fitur serial TV
├── integration_test/ # Pengujian integrasi
└── codemagic.yaml    # Konfigurasi CI (Codemagic)
```

Struktur internal tiap modul mengikuti Clean Architecture:

```
modul/
├── lib/
│   ├── data/         # Model, datasource, implementasi repository
│   ├── domain/       # Entity, repository abstract, use case
│   └── presentation/ # Halaman, widget, dan bloc
└── test/
```

## Menjalankan Aplikasi

```
flutter pub get
flutter run
```

## Pengujian

Proyek ini memiliki 371 pengujian unit dan widget dengan cakupan kode 97.12%.

```
flutter test
```

Untuk menghasilkan laporan coverage:

```
flutter test --coverage
```

Pengujian integrasi dijalankan secara lokal (memerlukan perangkat/emulator dan koneksi internet karena mengakses API TMDB):

```
flutter test integration_test
```

## Continuous Integration

Proyek ini menggunakan [Codemagic](https://codemagic.io/) dengan workflow `Ditonton CI` (`codemagic.yaml`). Pada setiap push, keempat paket (`ditonton` root, `ditonton_core`, `ditonton_movie`, dan `ditonton_tv`) dijalankan `flutter analyze` dan `flutter test` secara otomatis. Build akan dihentikan jika terdapat pengujian yang gagal.

Build status terakhir: **passed** — dijalankan otomatis oleh Codemagic pada setiap push.

## Author

**Jonry Simbolon**
