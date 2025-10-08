import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  static QuestionService? _instance;
  List<Question>? _allQuestions;

  QuestionService._();

  static QuestionService getInstance() {
    _instance ??= QuestionService._();
    return _instance!;
  }

  Future<void> loadQuestions() async {
    if (_allQuestions != null) return;

    try {
      final String jsonString = 
          await rootBundle.loadString('assets/questions/questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _allQuestions = jsonList
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If file doesn't exist, use default questions
      _allQuestions = _getDefaultQuestions();
    }
  }

  Future<List<Question>> getRandomQuestions(int count) async {
    await loadQuestions();
    
    if (_allQuestions == null || _allQuestions!.isEmpty) {
      return [];
    }

    final shuffled = List<Question>.from(_allQuestions!);
    shuffled.shuffle(Random());
    
    return shuffled.take(count).toList();
  }

  List<Question> _getDefaultQuestions() {
    return [
      Question(
        id: '1',
        question: 'Türkiye\'nin başkenti neresi?',
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
      Question(
        id: '3',
        question: 'Güneş sisteminde kaç gezegen var?',
        options: ['7', '8', '9', '10'],
        correctAnswerIndex: 1,
        category: 'Bilim',
        difficulty: 'easy',
      ),
      Question(
        id: '4',
        question: 'Hangisi bir programlama dili değildir?',
        options: ['Python', 'Java', 'HTML', 'Photoshop'],
        correctAnswerIndex: 3,
        category: 'Teknoloji',
        difficulty: 'medium',
      ),
      Question(
        id: '5',
        question: 'Mona Lisa tablosunu kim çizdi?',
        options: ['Picasso', 'Da Vinci', 'Van Gogh', 'Monet'],
        correctAnswerIndex: 1,
        category: 'Sanat',
        difficulty: 'easy',
      ),
      Question(
        id: '6',
        question: 'En büyük okyanus hangisidir?',
        options: ['Atlantik', 'Hint', 'Pasifik', 'Arktik'],
        correctAnswerIndex: 2,
        category: 'Coğrafya',
        difficulty: 'easy',
      ),
      Question(
        id: '7',
        question: 'Hangi yıl Türkiye Cumhuriyeti kuruldu?',
        options: ['1920', '1921', '1922', '1923'],
        correctAnswerIndex: 3,
        category: 'Tarih',
        difficulty: 'easy',
      ),
      Question(
        id: '8',
        question: 'Instagram hangi şirket tarafından satın alındı?',
        options: ['Google', 'Meta', 'Apple', 'Amazon'],
        correctAnswerIndex: 1,
        category: 'Teknoloji',
        difficulty: 'medium',
      ),
      Question(
        id: '9',
        question: 'Hangi element su molekülünde yoktur?',
        options: ['Hidrojen', 'Oksijen', 'Karbon', 'Hepsi var'],
        correctAnswerIndex: 2,
        category: 'Bilim',
        difficulty: 'medium',
      ),
      Question(
        id: '10',
        question: 'En çok Oscar ödülü alan film hangisidir?',
        options: ['Titanic', 'Ben-Hur', 'Lord of the Rings', 'Hepsi eşit'],
        correctAnswerIndex: 3,
        category: 'Sinema',
        difficulty: 'hard',
      ),
      Question(
        id: '11',
        question: 'Hangisi bir Avrupa ülkesi değildir?',
        options: ['Norveç', 'İzlanda', 'Grönland', 'Finlandiya'],
        correctAnswerIndex: 2,
        category: 'Coğrafya',
        difficulty: 'medium',
      ),
      Question(
        id: '12',
        question: 'Bitcoin ilk kez hangi yıl ortaya çıktı?',
        options: ['2007', '2008', '2009', '2010'],
        correctAnswerIndex: 2,
        category: 'Teknoloji',
        difficulty: 'medium',
      ),
      Question(
        id: '13',
        question: 'Hangisi bir Marvel karakteri değildir?',
        options: ['Iron Man', 'Batman', 'Spider-Man', 'Thor'],
        correctAnswerIndex: 1,
        category: 'Pop Kültür',
        difficulty: 'easy',
      ),
      Question(
        id: '14',
        question: 'En hızlı kara hayvanı hangisidir?',
        options: ['Aslan', 'Çita', 'Kaplan', 'Leopar'],
        correctAnswerIndex: 1,
        category: 'Doğa',
        difficulty: 'easy',
      ),
      Question(
        id: '15',
        question: 'Hangisi bir Apple ürünü değildir?',
        options: ['iPhone', 'iPad', 'Galaxy', 'MacBook'],
        correctAnswerIndex: 2,
        category: 'Teknoloji',
        difficulty: 'easy',
      ),
      Question(
        id: '16',
        question: 'Hangisi bir sosyal medya platformu değildir?',
        options: ['TikTok', 'Discord', 'Spotify', 'Snapchat'],
        correctAnswerIndex: 2,
        category: 'Teknoloji',
        difficulty: 'easy',
      ),
      Question(
        id: '17',
        question: 'Dünyanın en kalabalık şehri hangisidir?',
        options: ['Tokyo', 'Delhi', 'Şangay', 'Mumbai'],
        correctAnswerIndex: 0,
        category: 'Coğrafya',
        difficulty: 'medium',
      ),
      Question(
        id: '18',
        question: 'Hangisi bir Netflix dizisi değildir?',
        options: ['Stranger Things', 'Breaking Bad', 'Dark', 'Wednesday'],
        correctAnswerIndex: 1,
        category: 'Dizi',
        difficulty: 'medium',
      ),
      Question(
        id: '19',
        question: 'Işık hızı yaklaşık kaç km/s?',
        options: ['200.000', '300.000', '400.000', '500.000'],
        correctAnswerIndex: 1,
        category: 'Bilim',
        difficulty: 'hard',
      ),
      Question(
        id: '20',
        question: 'Hangisi bir emoji değildir?',
        options: ['😂', '🔥', '💀', '#'],
        correctAnswerIndex: 3,
        category: 'Teknoloji',
        difficulty: 'easy',
      ),
      Question(
        id: '21',
        question: 'YouTube hangi yıl kuruldu?',
        options: ['2003', '2004', '2005', '2006'],
        correctAnswerIndex: 2,
        category: 'Teknoloji',
        difficulty: 'medium',
      ),
      Question(
        id: '22',
        question: 'Hangisi bir yazılım dili değildir?',
        options: ['C++', 'Python', 'HTTP', 'JavaScript'],
        correctAnswerIndex: 2,
        category: 'Teknoloji',
        difficulty: 'medium',
      ),
      Question(
        id: '23',
        question: 'En büyük gezegen hangisidir?',
        options: ['Jüpiter', 'Satürn', 'Uranüs', 'Neptün'],
        correctAnswerIndex: 0,
        category: 'Bilim',
        difficulty: 'easy',
      ),
      Question(
        id: '24',
        question: 'Tesla\'nın CEO\'su kimdir?',
        options: ['Jeff Bezos', 'Elon Musk', 'Bill Gates', 'Mark Zuckerberg'],
        correctAnswerIndex: 1,
        category: 'İş Dünyası',
        difficulty: 'easy',
      ),
      Question(
        id: '25',
        question: 'Hangisi bir Google ürünü değildir?',
        options: ['Gmail', 'YouTube', 'WhatsApp', 'Chrome'],
        correctAnswerIndex: 2,
        category: 'Teknoloji',
        difficulty: 'medium',
      ),
    ];
  }
}

