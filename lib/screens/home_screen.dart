import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/theme/app_theme.dart';
import 'game_screen.dart';
import '../widgets/lives_display.dart';
import '../widgets/stats_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            final stats = gameProvider.userStats;
            
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NOBRAINER',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppTheme.neonYellow,
                              letterSpacing: 4,
                            ),
                          ),
                          Text(
                            'THINK FAST. PLAY SMART.',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                      ),
                      LivesDisplay(
                        lives: stats.lives,
                        isPremium: stats.isPremium,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Stats Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        StatsCard(
                          title: 'HIGH SCORE',
                          value: stats.highScore.toString(),
                          subtitle: '/ 20',
                          icon: Icons.emoji_events,
                        ),
                        StatsCard(
                          title: 'ACCURACY',
                          value: stats.accuracy.toStringAsFixed(0),
                          subtitle: '%',
                          icon: Icons.target,
                        ),
                        StatsCard(
                          title: 'GAMES',
                          value: stats.totalGames.toString(),
                          subtitle: 'played',
                          icon: Icons.gamepad,
                        ),
                        StatsCard(
                          title: 'STREAK',
                          value: stats.currentStreak.toString(),
                          subtitle: 'days',
                          icon: Icons.local_fire_department,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Play Button
                  SizedBox(
                    height: 64,
                    child: ElevatedButton(
                      onPressed: gameProvider.canPlay
                          ? () => _startGame(context, gameProvider)
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, size: 32),
                          const SizedBox(width: 8),
                          Text(
                            gameProvider.canPlay ? 'START GAME' : 'NO LIVES',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Watch Ad Button
                  if (!stats.isPremium && stats.lives < 5)
                    OutlinedButton.icon(
                      onPressed: () => _watchAdForLife(context, gameProvider),
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('WATCH AD FOR +1 LIFE'),
                    ),
                  
                  // Premium Button
                  if (!stats.isPremium)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: () => _showPremiumDialog(context, gameProvider),
                        child: Text(
                          '⚡ GET PREMIUM - UNLIMITED LIVES',
                          style: TextStyle(
                            color: AppTheme.neonYellow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _startGame(BuildContext context, GameProvider gameProvider) async {
    await gameProvider.startNewGame();
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const GameScreen(),
        ),
      );
    }
  }

  void _watchAdForLife(BuildContext context, GameProvider gameProvider) async {
    final success = await gameProvider.watchAdForLife();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '+1 Life earned!' : 'Ad not available'),
          backgroundColor: success ? AppTheme.successGreen : AppTheme.errorRed,
        ),
      );
    }
  }

  void _showPremiumDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGrey,
        title: const Text('⚡ PREMIUM'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✓ Unlimited Lives'),
            Text('✓ No Ads'),
            Text('✓ Premium Badge'),
            Text('✓ Exclusive Themes'),
            SizedBox(height: 16),
            Text(
              '\$2.99 / month',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.neonYellow,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              gameProvider.purchasePremium();
              Navigator.pop(context);
            },
            child: const Text('BUY NOW'),
          ),
        ],
      ),
    );
  }
}

