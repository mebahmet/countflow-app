# SAY / CountFlow 📿

> Akıllı sayaç uygulaması — TR: **SAY** · EN: **CountFlow**

Flutter ile yazılmış, Android + iOS için tek koddan derlenen gelişmiş sayaç uygulaması.

## Özellikler / Features

| TR | EN |
|---|---|
| Çoklu sayaç (300'e kadar) | Multiple counters (up to 300) |
| Zikir modu + Arapça metinler | Dhikr mode + Arabic text |
| Her sayıma zaman damgası | Timestamp on every tap |
| Hedef & ilerleme çubuğu | Goal & progress bar |
| 14 günlük grafik istatistik | 14-day bar chart stats |
| Kategori sistemi (7 kategori) | Category system (7 categories) |
| CSV export & paylaşım | CSV export & sharing |
| Geri al (undo) | Undo last action |
| Otomatik sıfırlama | Auto-reset scheduling |
| Widget desteği | Home screen widget |
| Koyu / açık / sistem teması | Dark / light / system theme |
| TR + EN dil desteği | TR + EN language support |
| Titreşim & ses kontrolü | Haptic & sound control |

## Kurulum / Setup

```bash
# Flutter 3.22+ gerekli
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

## GitHub Actions ile Derleme / Build with GitHub Actions

Her `main` branch push'unda otomatik olarak:
- ✅ Android APK + AAB (Ubuntu runner, ücretsiz)
- ✅ iOS IPA unsigned (macOS runner, ücretsiz)

Artifacts → Actions sekmesinden indirilebilir.

### iOS imzalama (App Store için)
1. Apple Developer hesabı ($99/yıl)
2. Xcode'da provisioning profile oluştur
3. GitHub Secrets'e sertifika ekle
4. Workflow'a imzalama adımı ekle

## Proje Yapısı / Project Structure

```
lib/
├── core/
│   ├── constants/     # Sabitler
│   ├── models/        # Hive veri modelleri
│   ├── providers/     # State management
│   └── utils/
├── features/
│   ├── counter/
│   │   ├── screens/   # Ana ekran, detay ekranı
│   │   └── widgets/   # Kart, butonlar, sheet
│   └── settings/      # Ayarlar ekranı
├── l10n/              # TR + EN çeviriler
└── shared/
    └── theme/         # Renk sistemi, tipografi
```

## Renk Paleti / Color Palette

| Rol | Hex |
|---|---|
| Arka plan (koyu) | `#1A0E3D` |
| Marka moru | `#534AB7` |
| Aksan | `#7F77DD` |
| Zikir (teal) | `#1D9E75` |
| Uyarı (kırmızı) | `#E24B4A` |

## Store Yayınlama / Publishing

- **Google Play Store**: $25 tek seferlik, AAB dosyasını yükle
- **Apple App Store**: $99/yıl, Xcode'da imzalayıp yükle

## Lisans / License

MIT
