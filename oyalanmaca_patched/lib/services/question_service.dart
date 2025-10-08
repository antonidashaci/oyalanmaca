import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../models/question.dart';

/// A simple service for loading and shuffling questions.
///
/// At startup the service attempts to read `assets/questions/questions.json` from
/// the Flutter asset bundle.  If the file cannot be found or parsed the
/// internal `_getDefaultQuestions` list is used as a fallback.  Questions are
/// loaded once and then cached for subsequent requests.  When fetching
/// questions the service shuffles the list so each game receives a random
/// subset.
class QuestionService {
  static QuestionService? _instance;
  List<Question>? _allQuestions;

  QuestionService._();

  /// Returns the singleton instance of this service.  Lazily
  /// instantiates itself on first access.
  static QuestionService getInstance() {
    _instance ??= QuestionService._();
    return _instance!;
  }

  /// Loads the questions from the bundled JSON file.  If the file cannot be
  /// loaded or parsed the fallback `_getDefaultQuestions` list is used.
  Future<void> loadQuestions() async {
    if (_allQuestions != null) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/questions/questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _allQuestions = jsonList
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // If file doesn't exist or fails to parse, use default questions
      _allQuestions = _getDefaultQuestions();
    }
  }

  /// Returns a list of `count` random questions.  The list of questions is
  /// shuffled on each call to avoid predictable order.
  Future<List<Question>> getRandomQuestions(int count) async {
    await loadQuestions();
    if (_allQuestions == null || _allQuestions!.isEmpty) {
      return [];
    }
    final shuffled = List<Question>.from(_allQuestions!);
    shuffled.shuffle(Random());
    return shuffled.take(count).toList();
  }

  /// Provides a minimal fallback dataset so the game can run even if the
  /// bundled JSON is missing.  These questions mirror the style of the
  /// application and avoid known issues like empty options or broken strings.
  List<Question> _getDefaultQuestions() {
    return [
      Question(
        id: '1',
        question: 'Türkiye’nin başkenti neresidir?',
        options: ['İstanbul', 'Ankara', 'İzmir', 'Bursa'],
        correctAnswerIndex: 1,
        category: 'Genel Kültür',
        difficulty: 'easy',
      ),
      Question(
        id: '2',
        question: '2 + 2 = ?',
        options: ['3', '4', '5', '6'],
        correctAnswerIndex: 1,
        category: 'Matematik',
        difficulty: 'easy',
      ),
      // Corrected version of the emoji question – includes real emojis and a
      // non‑emoji option (#) as the correct answer.
      Question(
        id: '3',
        question: 'Hangisi bir emoji değildir?',
        options: ['😀', '🎉', '🏠', '#'],
        correctAnswerIndex: 3,
        category: 'Teknoloji',
        difficulty: 'easy',
      ),
      // Fixed the broken string for Mark Zuckerberg’s name.
      Question(
        id: '4',
        question: 'Tesla’nın CEO’su kimdir?',
        options: ['Jeff Bezos', 'Elon Musk', 'Bill Gates', 'Mark Zuckerberg'],
        correctAnswerIndex: 1,
        category: 'İş Dünyası',
        difficulty: 'easy',
      ),
    ];
  }
}