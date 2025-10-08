import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';
import '../models/game_state.dart';
import '../models/question.dart';
import '../models/user_stats.dart';
import '../services/question_service.dart';
import '../services/storage_service.dart';
import '../services/ad_service.dart';
import '../core/constants/app_constants.dart';

class GameProvider with ChangeNotifier {
  GameState _gameState = GameState(questions: []);
  UserStats _userStats = UserStats();
  
  final QuestionService _questionService = QuestionService.getInstance();
  late final StorageService _storageService;
  final AdService _adService = AdService.getInstance();

  DateTime? _questionStartTime;
  
  GameState get gameState => _gameState;
  UserStats get userStats => _userStats;
  bool get canPlay => _userStats.hasLives;

  GameProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _storageService = await StorageService.getInstance();
    await _loadUserStats();
    await _questionService.loadQuestions();
    await _adService.initialize();
    notifyListeners();
  }

  Future<void> _loadUserStats() async {
    _userStats = await _storageService.getUserStats();
  }

  Future<void> startNewGame() async {
    // Check if user has lives
    if (!_userStats.isPremium && _userStats.lives <= 0) {
      return;
    }

    // Decrease life if not premium
    if (!_userStats.isPremium) {
      _userStats = _userStats.copyWith(lives: _userStats.lives - 1);
      await _storageService.saveUserStats(_userStats);
    }

    // Load questions
    final questions = await _questionService.getRandomQuestions(
      AppConstants.maxQuestions,
    );

    _gameState = GameState(
      questions: questions,
      status: GameStatus.playing,
      startTime: DateTime.now(),
    );

    _questionStartTime = DateTime.now();
    
    notifyListeners();
  }

  Future<void> answerQuestion(int selectedIndex) async {
    if (_gameState.status != GameStatus.playing) return;
    if (_gameState.currentQuestion == null) return;

    // Haptic feedback
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }

    final question = _gameState.currentQuestion!;
    final isCorrect = selectedIndex == question.correctAnswerIndex;

    // Calculate response time
    final responseTime = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 0;

    // Update game state
    final newAnswers = List<bool>.from(_gameState.answers)..add(isCorrect);
    final newResponseTimes = List<int>.from(_gameState.responseTimes)
      ..add(responseTime);
    final newScore = isCorrect ? _gameState.score + 1 : _gameState.score;

    if (_gameState.isLastQuestion) {
      // Game finished
      _gameState = _gameState.copyWith(
        answers: newAnswers,
        score: newScore,
        responseTimes: newResponseTimes,
        status: GameStatus.finished,
        endTime: DateTime.now(),
      );
      
      await _updateUserStatsAfterGame();
      await _checkAndShowAd();
    } else {
      // Move to next question
      _gameState = _gameState.copyWith(
        currentQuestionIndex: _gameState.currentQuestionIndex + 1,
        answers: newAnswers,
        score: newScore,
        responseTimes: newResponseTimes,
      );
      
      _questionStartTime = DateTime.now();
    }

    notifyListeners();
  }

  Future<void> _updateUserStatsAfterGame() async {
    final newTotalGames = _userStats.totalGames + 1;
    final newTotalCorrect = _userStats.totalCorrect + _gameState.score;
    final newHighScore = _gameState.score > _userStats.highScore
        ? _gameState.score
        : _userStats.highScore;

    // Streak logic
    final now = DateTime.now();
    final lastPlay = _userStats.lastPlayDate;
    int newStreak = _userStats.currentStreak;

    if (lastPlay == null) {
      newStreak = 1;
    } else {
      final daysDifference = now.difference(lastPlay).inDays;
      if (daysDifference == 1) {
        newStreak++;
      } else if (daysDifference > 1) {
        newStreak = 1;
      }
    }

    final newBestStreak = newStreak > _userStats.bestStreak
        ? newStreak
        : _userStats.bestStreak;

    _userStats = _userStats.copyWith(
      totalGames: newTotalGames,
      totalCorrect: newTotalCorrect,
      highScore: newHighScore,
      currentStreak: newStreak,
      bestStreak: newBestStreak,
      lastPlayDate: now,
    );

    await _storageService.saveUserStats(_userStats);
  }

  Future<void> _checkAndShowAd() async {
    final gameCount = await _storageService.getGameCount();
    await _storageService.incrementGameCount();

    if (gameCount > 0 && gameCount % AppConstants.adsPerGame == 0) {
      if (_adService.isInterstitialAdReady) {
        await _adService.showInterstitialAd();
      }
    }
  }

  Future<bool> watchAdForLife() async {
    bool success = false;
    
    await _adService.showRewardedAd(() {
      _userStats = _userStats.copyWith(lives: _userStats.lives + 1);
      _storageService.saveUserStats(_userStats);
      success = true;
    });

    notifyListeners();
    return success;
  }

  Future<void> purchasePremium() async {
    // In-app purchase logic will be here
    _userStats = _userStats.copyWith(
      isPremium: true,
      lives: AppConstants.maxLives,
    );
    await _storageService.setPremium(true);
    await _storageService.saveUserStats(_userStats);
    notifyListeners();
  }

  void resetGame() {
    _gameState = GameState(questions: []);
    notifyListeners();
  }

  Future<void> refreshStats() async {
    await _loadUserStats();
    notifyListeners();
  }
}

