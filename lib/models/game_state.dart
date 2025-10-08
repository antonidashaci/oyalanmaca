import 'question.dart';

enum GameStatus {
  notStarted,
  playing,
  paused,
  finished,
}

class GameState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final List<bool> answers; // true = correct, false = wrong
  final int score;
  final GameStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<int> responseTimes; // in milliseconds

  GameState({
    required this.questions,
    this.currentQuestionIndex = 0,
    List<bool>? answers,
    this.score = 0,
    this.status = GameStatus.notStarted,
    this.startTime,
    this.endTime,
    List<int>? responseTimes,
  })  : answers = answers ?? [],
        responseTimes = responseTimes ?? [];

  GameState copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    List<bool>? answers,
    int? score,
    GameStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    List<int>? responseTimes,
  }) {
    return GameState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      responseTimes: responseTimes ?? this.responseTimes,
    );
  }

  Question? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  bool get isFinished => status == GameStatus.finished;

  int get totalQuestions => questions.length;

  double get accuracy => 
      answers.isEmpty ? 0.0 : (score / answers.length) * 100;

  double get averageResponseTime {
    if (responseTimes.isEmpty) return 0.0;
    return responseTimes.reduce((a, b) => a + b) / responseTimes.length;
  }

  Duration? get totalTime {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }
}

