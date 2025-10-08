# 🧠 NoBrainer - Ultra Minimalist Trivia Game

**Think Fast. Play Smart.**

NoBrainer, Twitter/X ve Reddit topluluğu için tasarlanmış, minimalist ve bağımlılık yapıcı bir bilgi yarışması oyunudur. Wordle tarzında viral paylaşım özelliği ile sosyal medyada hızla yayılma potansiyeline sahip.

## ✨ Özellikler

### 🎮 Oyun Mekaniği
- **20 Hızlı Soru** - Her oyun 20 çoktan seçmeli soru
- **5 Saniye Limit** - Düşünmeye vaktiniz yok!
- **Lives Sistemi** - 5 can ile başla, reklam izleyerek yenile
- **Streak Sistemi** - Günlük streak takibi
- **Viral Paylaşım** - Wordle tarzı emoji grid ile Twitter/X'te paylaş

### 🎨 Tasarım
- **Ultra Minimalist** - Siyah-beyaz brutal tasarım
- **Neon Sarı Aksanlar** - Modern ve göz alıcı
- **Smooth Animasyonlar** - Flutter Animate ile akıcı geçişler
- **Haptic Feedback** - Titreşim ile etkileşim

### 💰 Monetization
- **AdMob Entegrasyonu** - Her 5 oyunda 1 reklam
- **Rewarded Ads** - Reklam izleyerek can kazan
- **Premium Subscription** - Sınırsız can + Reklamsız ($2.99/ay)

### 📊 İstatistikler
- High score takibi
- Accuracy yüzdesi
- Toplam oyun sayısı
- Günlük ve en iyi streak
- Ortalama yanıt süresi

## 🚀 Kurulum

### Gereksinimler
- Flutter 3.0+
- Dart SDK
- Android Studio / VS Code
- Android SDK (API 21+)

### Adımlar

1. **Depoyu klonlayın:**
```bash
git clone https://github.com/yourusername/nobrainer.git
cd nobrainer
```

2. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

3. **Uygulamayı çalıştırın:**
```bash
flutter run
```

4. **APK oluşturun:**
```bash
flutter build apk --release
```

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── constants/          # Uygulama sabitleri
│   └── theme/             # Tema ve renkler
├── models/                # Veri modelleri
│   ├── question.dart
│   ├── game_state.dart
│   └── user_stats.dart
├── providers/             # State management
│   └── game_provider.dart
├── screens/               # Ekranlar
│   ├── home_screen.dart
│   ├── game_screen.dart
│   └── result_screen.dart
├── services/              # Servisler
│   ├── storage_service.dart
│   ├── question_service.dart
│   └── ad_service.dart
├── widgets/               # Reusable widgets
│   ├── lives_display.dart
│   └── stats_card.dart
└── main.dart

assets/
├── questions/             # Soru veritabanı (JSON)
└── images/               # Görseller

android/                   # Android native kod
```

## 🛠️ Kullanılan Teknolojiler

### Frontend
- **Flutter** - UI Framework
- **Provider** - State Management
- **Flutter Animate** - Animasyonlar
- **Vibration** - Haptic Feedback

### Backend & Services
- **Shared Preferences** - Local Storage
- **Google Mobile Ads** - Reklamlar
- **In-App Purchase** - Premium abonelik
- **Share Plus** - Sosyal paylaşım

### Design
- **Material Design 3** - UI Components
- **Custom Theme** - Brutal minimalizm

## 💡 Viral Paylaşım Formatı

```
🧠 NoBrainer #42
━━━━━━━━━━━━
⚡ 15/20 doğru
🌍 Top 8% 

⬜⬜⬜🟩⬜ 🟩🟩⬜🟩🟩
🟩🟩🟩🟩⬜ 🟩🟩🟩🟩🟩

nobrainer.app
```

## 🎯 Para Kazanma Stratejisi

1. **Freemium Model**
   - 5 ücretsiz can
   - Reklam izleyerek can kazanma
   - Her 5 oyunda 1 interstitial ad

2. **Premium Abonelik** ($2.99/ay)
   - Sınırsız can
   - Reklamsız deneyim
   - Premium badge
   - Gelecek özellikler için erken erişim

3. **Gelecek Planlar**
   - Sponsorlu sorular
   - Marka entegrasyonları
   - Battle mode (PvP)
   - Tournament sistemi

## 📊 Hedef Kitle

- **Yaş:** 18-35
- **Platform:** Twitter/X, Reddit, TikTok kullanıcıları
- **İlgi Alanları:** Trivia, casual games, viral içerik
- **Davranış:** Hızlı oyun seansları, sosyal paylaşım

## 🔧 Geliştirme

```bash
# Debug modda çalıştır
flutter run

# Release APK oluştur
flutter build apk --release

# App Bundle oluştur (Google Play)
flutter build appbundle --release

# Testleri çalıştır
flutter test

# Kod analizi
flutter analyze
```

## 📝 TODO / Gelecek Özellikler

- [ ] Splash screen ve onboarding
- [ ] Kategori seçimi
- [ ] Zorluk seviyesi seçimi
- [ ] Daily challenge
- [ ] Leaderboard
- [ ] Friend challenges
- [ ] Battle mode (PvP)
- [ ] Achievement sistemi
- [ ] Dark/Light tema toggle
- [ ] Daha fazla soru ekleme

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 📞 İletişim

Sorularınız için: [your-email@example.com]

---

**Made with ❤️ and ☕ for viral success!**
