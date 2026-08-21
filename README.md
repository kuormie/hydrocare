# HydroCare

Aplikasi mobile Flutter untuk monitoring hidrasi tubuh berbasis analisis warna urin.

## Stack

- **Flutter** 3.44.2 / **Dart** 3.12.2
- **State management:** Provider (ChangeNotifier)
- **Storage:** shared_preferences (seed dari JSON aset, persist antar sesi)
- **Chart:** fl_chart (pie + bar)
- **Font:** Google Fonts — Poppins
- **Platform target:** Android

## Cara menjalankan

```bash
flutter pub get
flutter run        # emulator / device Android
```

## Struktur project

```
lib/
  core/            # theme, routes, widgets reusable, config, network scaffold
  data/            # models, JSON seeds, datasource (local/remote stub), repositories
  providers/       # Auth, Scan, History, Stats, Nav, User
  features/        # splash, onboarding, auth, dashboard, scan, result, history, statistics
assets/
  data/            # user_profile.json, history.json, stats.json, scan_samples.json, recommendations.json
docs/
  prd/             # hydrocare-flutter-frontend.md
```

## Alur unggulan

**Scan Urin:** Capture → animasi loading scanning → alert "Berhasil" → Analysis Result → hasil tersimpan ke History.

**Hydration Statistics** diakses dari app bar halaman History.

## Backend integration

Arsitektur sudah siap untuk integrasi backend — ganti `AppConfig.useRemote = false` menjadi `true` dan isi `RemoteDataSource`. UI/Provider tidak perlu diubah.

## Penulis

Cindy Fitri Utami
