import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/screens/find_car_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class HomeBottomCTA extends StatelessWidget {
  const HomeBottomCTA({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0066EE), Color(0xFF79B3FF)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Text column ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.cantFindNextCar,
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 18,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
                Text(
                  l.aiHelpsFind,
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Button ──
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FindCarScreen()),
            ),
            child: Container(
              width: 98,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: Text(
                l.startNow,
                style: AppTextStyles.medium.copyWith(
                  fontSize: 14,
                  height: 1.0,
                  color: const Color(0xFF1B1B1B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
