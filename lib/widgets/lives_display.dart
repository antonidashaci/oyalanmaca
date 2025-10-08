import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';

class LivesDisplay extends StatelessWidget {
  final int lives;
  final bool isPremium;

  const LivesDisplay({
    super.key,
    required this.lives,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.neonYellow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: AppTheme.primaryBlack,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              'PREMIUM',
              style: TextStyle(
                color: AppTheme.primaryBlack,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lives <= 1 ? AppTheme.errorRed : AppTheme.mediumGrey,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: lives <= 1 ? AppTheme.errorRed : AppTheme.primaryWhite,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$lives / ${AppConstants.maxLives}',
            style: TextStyle(
              color: lives <= 1 ? AppTheme.errorRed : AppTheme.primaryWhite,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

