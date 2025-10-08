import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_stats.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // User Stats
  Future<UserStats> getUserStats() async {
    final highScore = _prefs?.getInt(AppConstants.keyHighScore) ?? 0;
    final totalGames = _prefs?.getInt(AppConstants.keyTotalGames) ?? 0;
    final totalCorrect = _prefs?.getInt(AppConstants.keyTotalCorrect) ?? 0;
    final currentStreak = _prefs?.getInt(AppConstants.keyCurrentStreak) ?? 0;
    final bestStreak = _prefs?.getInt(AppConstants.keyBestStreak) ?? 0;
    final lives = _prefs?.getInt(AppConstants.keyLives) ?? 5;
    final isPremium = _prefs?.getBool(AppConstants.keyIsPremium) ?? false;
    
    final lastPlayDateStr = _prefs?.getString(AppConstants.keyLastPlayDate);
    DateTime? lastPlayDate;
    if (lastPlayDateStr != null) {
      lastPlayDate = DateTime.parse(lastPlayDateStr);
    }

    return UserStats(
      highScore: highScore,
      totalGames: totalGames,
      totalCorrect: totalCorrect,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lives: lives,
      lastPlayDate: lastPlayDate,
      isPremium: isPremium,
    );
  }

  Future<void> saveUserStats(UserStats stats) async {
    await _prefs?.setInt(AppConstants.keyHighScore, stats.highScore);
    await _prefs?.setInt(AppConstants.keyTotalGames, stats.totalGames);
    await _prefs?.setInt(AppConstants.keyTotalCorrect, stats.totalCorrect);
    await _prefs?.setInt(AppConstants.keyCurrentStreak, stats.currentStreak);
    await _prefs?.setInt(AppConstants.keyBestStreak, stats.bestStreak);
    await _prefs?.setInt(AppConstants.keyLives, stats.lives);
    await _prefs?.setBool(AppConstants.keyIsPremium, stats.isPremium);
    
    if (stats.lastPlayDate != null) {
      await _prefs?.setString(
        AppConstants.keyLastPlayDate,
        stats.lastPlayDate!.toIso8601String(),
      );
    }
  }

  // Lives Management
  Future<int> getLives() async {
    return _prefs?.getInt(AppConstants.keyLives) ?? AppConstants.maxLives;
  }

  Future<void> setLives(int lives) async {
    await _prefs?.setInt(AppConstants.keyLives, lives);
  }

  Future<void> decrementLives() async {
    final current = await getLives();
    await setLives(current - 1);
  }

  Future<void> restoreLives() async {
    await setLives(AppConstants.maxLives);
  }

  // Game Count for Ads
  Future<int> getGameCount() async {
    return _prefs?.getInt(AppConstants.keyGameCount) ?? 0;
  }

  Future<void> incrementGameCount() async {
    final current = await getGameCount();
    await _prefs?.setInt(AppConstants.keyGameCount, current + 1);
  }

  Future<void> resetGameCount() async {
    await _prefs?.setInt(AppConstants.keyGameCount, 0);
  }

  // Premium Status
  Future<bool> isPremium() async {
    return _prefs?.getBool(AppConstants.keyIsPremium) ?? false;
  }

  Future<void> setPremium(bool value) async {
    await _prefs?.setBool(AppConstants.keyIsPremium, value);
  }

  // First Launch
  Future<bool> isFirstLaunch() async {
    return _prefs?.getBool(AppConstants.keyFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    await _prefs?.setBool(AppConstants.keyFirstLaunch, false);
  }

  // Clear All Data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

