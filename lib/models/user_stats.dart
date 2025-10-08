class UserStats {
  final int highScore;
  final int totalGames;
  final int totalCorrect;
  final int currentStreak;
  final int bestStreak;
  final int lives;
  final DateTime? lastPlayDate;
  final bool isPremium;

  UserStats({
    this.highScore = 0,
    this.totalGames = 0,
    this.totalCorrect = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lives = 5,
    this.lastPlayDate,
    this.isPremium = false,
  });

  UserStats copyWith({
    int? highScore,
    int? totalGames,
    int? totalCorrect,
    int? currentStreak,
    int? bestStreak,
    int? lives,
    DateTime? lastPlayDate,
    bool? isPremium,
  }) {
    return UserStats(
      highScore: highScore ?? this.highScore,
      totalGames: totalGames ?? this.totalGames,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lives: lives ?? this.lives,
      lastPlayDate: lastPlayDate ?? this.lastPlayDate,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  double get accuracy {
    if (totalGames == 0) return 0.0;
    return (totalCorrect / (totalGames * 20)) * 100;
  }

  bool get hasLives => lives > 0 || isPremium;

  bool get canPlayToday {
    if (isPremium) return true;
    if (lastPlayDate == null) return true;
    
    final now = DateTime.now();
    final lastPlay = lastPlayDate!;
    
    return now.difference(lastPlay).inHours >= 24;
  }

  Map<String, dynamic> toJson() {
    return {
      'highScore': highScore,
      'totalGames': totalGames,
      'totalCorrect': totalCorrect,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lives': lives,
      'lastPlayDate': lastPlayDate?.toIso8601String(),
      'isPremium': isPremium,
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      highScore: json['highScore'] as int? ?? 0,
      totalGames: json['totalGames'] as int? ?? 0,
      totalCorrect: json['totalCorrect'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      lives: json['lives'] as int? ?? 5,
      lastPlayDate: json['lastPlayDate'] != null
          ? DateTime.parse(json['lastPlayDate'] as String)
          : null,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }
}

