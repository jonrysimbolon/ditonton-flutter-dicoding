# Ditonton

Aplikasi katalog film dan serial TV yang dibangun dengan Flutter. Proyek ini merupakan submission kelas **Flutter Expert** Dicoding Indonesia.

![Flutter](https://img.shields.io/badge/Flutter-3.47.5-blue)
![Dart](https://img.shields.io/badge/Dart-3.13.4-blue)
![Coverage](https://img.shields.io/badge/coverage-98.02%25-brightgreen)
![Tests](https://img.shields.io/badge/tests-324%20passed-success)

## Fitur

- Daftar film: Now Playing, Popular, dan Top Rated.
- Daftar serial TV: Airing Today, On The Air, Popular, dan Top Rated.
- Detail film dan serial TV, termasuk daftar season dan episode untuk serial TV.
- Pencarian film dan serial TV.
- Watchlist film dan serial TV yang disimpan secara lokal menggunakan SQLite.
- Halaman About.

## Arsitektur & Teknologi

- **Clean Architecture** dengan pemisahan lapisan `data`, `domain`, dan `presentation`.
- **Provider** untuk state management.
- **Dartz** (`Either`) untuk penanganan error tanpa exception.
- **Get It** untuk dependency injection.
- **HTTP** untuk konsumsi API [The Movie Database (TMDB)](https://www.themoviedb.org/).
- **SQFLite** untuk penyimpanan watchlist secara lokal.
- **Mockito** untuk pembuatan mock pada pengujian.

## Struktur Proyek

```
lib/
├── common/          # Konstanta, konfigurasi, failure, dan exception
├── data/            # Model, datasource, dan implementasi repository
├── domain/          # Entity, repository abstract, dan use case
├── presentation/    # Halaman, widget, dan provider
└── main.dart        # Entry point aplikasi
```

## Menjalankan Aplikasi

```
flutter pub get
flutter run
```

## Pengujian

Proyek ini memiliki 324 pengujian unit dan widget dengan cakupan kode 98.02%.

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

Proyek ini menggunakan [Codemagic](https://codemagic.io/) untuk menjalankan pengujian unit dan widget secara otomatis pada setiap push ke repository. Build akan dihentikan jika terdapat pengujian yang gagal.

Build status terakhir: **passed** pada commit `3bc94ce` — [Lihat hasil build (Codemagic)](https://github.com/jonrysimbolon/ditonton-flutter-dicoding/runs/106430488334)

## Author

**Jonry Simbolon**
