import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            final gameState = gameProvider.gameState;
            final score = gameState.score;
            final total = gameState.totalQuestions;
            final accuracy = gameState.accuracy;
            final avgTime = gameState.averageResponseTime / 1000;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Result Title
                  Text(
                    _getResultTitle(score, total),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.neonYellow,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms).scale(),

                  const SizedBox(height: 16),

                  // Score
                  Text(
                    '$score / $total',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms, duration: 300.ms).scale(),

                  const SizedBox(height: 32),

                  // Emoji Grid
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.darkGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.mediumGrey),
                    ),
                    child: Column(
                      children: [
                        _buildEmojiRow(gameState.answers.take(10).toList()),
                        const SizedBox(height: 8),
                        _buildEmojiRow(gameState.answers.skip(10).toList()),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 300.ms).slideY(begin: 0.2),

                  const SizedBox(height: 32),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        label: 'ACCURACY',
                        value: '${accuracy.toStringAsFixed(0)}%',
                        icon: Icons.target,
                      ),
                      _StatItem(
                        label: 'AVG TIME',
                        value: '${avgTime.toStringAsFixed(1)}s',
                        icon: Icons.timer,
                      ),
                      _StatItem(
                        label: 'PERCENTILE',
                        value: 'Top ${_getPercentile(score)}%',
                        icon: Icons.emoji_events,
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms, duration: 300.ms),

                  const Spacer(),

                  // Share Button
                  SizedBox(
                    height: 64,
                    child: ElevatedButton.icon(
                      onPressed: () => _shareResult(gameState.answers, score, total),
                      icon: const Icon(Icons.share, size: 24),
                      label: const Text(
                        'SHARE RESULT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 300.ms),

                  const SizedBox(height: 16),

                  // Play Again Button
                  SizedBox(
                    height: 64,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        gameProvider.resetGame();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.replay, size: 24),
                      label: const Text(
                        'PLAY AGAIN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 300.ms),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmojiRow(List<bool> answers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: answers.map((correct) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            correct ? '🟩' : '⬜',
            style: const TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }

  String _getResultTitle(int score, int total) {
    final percentage = (score / total) * 100;
    
    if (percentage >= 90) return 'GENIUS! 🔥';
    if (percentage >= 80) return 'AMAZING! ⚡';
    if (percentage >= 70) return 'GREAT! 💪';
    if (percentage >= 60) return 'GOOD! 👍';
    if (percentage >= 50) return 'NICE! 👌';
    return 'KEEP TRYING! 💯';
  }

  String _getPercentile(int score) {
    if (score >= 18) return '1';
    if (score >= 16) return '5';
    if (score >= 14) return '10';
    if (score >= 12) return '25';
    if (score >= 10) return '50';
    return '75';
  }

  void _shareResult(List<bool> answers, int score, int total) {
    final text = AppConstants.getShareText(score, total, answers);
    Share.share(text);
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.neonYellow, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.lightGrey,
          ),
        ),
      ],
    );
  }
}

