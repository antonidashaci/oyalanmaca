class AppConstants {
  // App Info
  static const String appName = 'NoBrainer';
  static const String appTagline = 'Think Fast. Play Smart.';
  
  // Game Settings
  static const int maxQuestions = 20;
  static const int questionTimeLimit = 5; // seconds
  static const int maxLives = 5;
  static const int adsPerGame = 5; // Show ad every 5 games
  
  // Storage Keys
  static const String keyHighScore = 'high_score';
  static const String keyTotalGames = 'total_games';
  static const String keyTotalCorrect = 'total_correct';
  static const String keyCurrentStreak = 'current_streak';
  static const String keyBestStreak = 'best_streak';
  static const String keyLives = 'lives';
  static const String keyLastPlayDate = 'last_play_date';
  static const String keyIsPremium = 'is_premium';
  static const String keyGameCount = 'game_count';
  static const String keyFirstLaunch = 'first_launch';
  
  // AdMob IDs (Test IDs - Replace with real ones)
  static const String androidAdMobAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String androidRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
  static const String androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  
  // In-App Purchase
  static const String premiumProductId = 'nobrainer_premium';
  static const double premiumPrice = 2.99;
  
  // Share Template
  static String getShareText(int score, int total, List<bool> answers) {
    final emoji = answers.map((correct) => correct ? '🟩' : '⬜').toList();
    final firstRow = emoji.take(10).join('');
    final secondRow = emoji.skip(10).take(10).join('');
    
    return '''
🧠 NoBrainer #${DateTime.now().day}
━━━━━━━━━━━━
⚡ $score/$total doğru
🌍 Top ${_calculatePercentile(score)}%

$firstRow
$secondRow

nobrainer.app
''';
  }
  
  static String _calculatePercentile(int score) {
    if (score >= 18) return '1';
    if (score >= 16) return '5';
    if (score >= 14) return '10';
    if (score >= 12) return '25';
    if (score >= 10) return '50';
    return '75';
  }
  
  // Animations
  static const int buttonAnimationDuration = 100; // ms
  static const int questionTransitionDuration = 300; // ms
  static const int resultAnimationDuration = 500; // ms
}

