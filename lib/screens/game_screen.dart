import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/game_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = AppConstants.questionTimeLimit;
  int? _selectedIndex;
  bool _showingResult = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = AppConstants.questionTimeLimit;
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        // Time's up - treat as wrong answer
        _answerQuestion(context, -1);
      }
    });
  }

  void _answerQuestion(BuildContext context, int selectedIndex) async {
    if (_showingResult) return;
    
    setState(() {
      _selectedIndex = selectedIndex;
      _showingResult = true;
    });
    
    _timer?.cancel();

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final question = gameProvider.gameState.currentQuestion;
    final isCorrect = selectedIndex == question?.correctAnswerIndex;

    // Show feedback for 500ms
    await Future.delayed(const Duration(milliseconds: 500));

    await gameProvider.answerQuestion(selectedIndex);

    if (mounted) {
      if (gameProvider.gameState.isFinished) {
        // Navigate to result screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ResultScreen(),
          ),
        );
      } else {
        // Next question
        setState(() {
          _selectedIndex = null;
          _showingResult = false;
        });
        _animationController.reset();
        _animationController.forward();
        _startTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            final gameState = gameProvider.gameState;
            final question = gameState.currentQuestion;

            if (question == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header: Progress and Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Progress
                      Text(
                        '${gameState.currentQuestionIndex + 1}/${gameState.totalQuestions}',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      // Timer
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _remainingSeconds <= 2
                              ? AppTheme.errorRed
                              : AppTheme.darkGrey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _remainingSeconds <= 2
                                ? AppTheme.errorRed
                                : AppTheme.neonYellow,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '${_remainingSeconds}s',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.primaryWhite,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: (gameState.currentQuestionIndex + 1) / gameState.totalQuestions,
                    backgroundColor: AppTheme.darkGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.neonYellow),
                    minHeight: 8,
                  ),

                  const Spacer(),

                  // Question
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      question.question,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(),

                  // Answer Options
                  ...List.generate(question.options.length, (index) {
                    final isSelected = _selectedIndex == index;
                    final isCorrect = index == question.correctAnswerIndex;
                    final showCorrect = _showingResult && isCorrect;
                    final showWrong = _showingResult && isSelected && !isCorrect;

                    Color? backgroundColor;
                    Color? borderColor;
                    
                    if (showCorrect) {
                      backgroundColor = AppTheme.successGreen;
                      borderColor = AppTheme.successGreen;
                    } else if (showWrong) {
                      backgroundColor = AppTheme.errorRed;
                      borderColor = AppTheme.errorRed;
                    } else if (isSelected) {
                      backgroundColor = AppTheme.neonYellow.withOpacity(0.1);
                      borderColor = AppTheme.neonYellow;
                    } else {
                      backgroundColor = AppTheme.darkGrey;
                      borderColor = AppTheme.mediumGrey;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SizedBox(
                        height: 64,
                        child: OutlinedButton(
                          onPressed: _showingResult
                              ? null
                              : () => _answerQuestion(context, index),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: backgroundColor,
                            side: BorderSide(color: borderColor, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            question.options[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: (showCorrect || showWrong)
                                  ? AppTheme.primaryBlack
                                  : AppTheme.primaryWhite,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

