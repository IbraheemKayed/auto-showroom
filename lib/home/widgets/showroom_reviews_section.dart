import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/providers/showroom_revieas_provider.dart';
import 'package:sayarti/home/widgets/review_card.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class ShowroomReviewsSection extends StatelessWidget {
  const ShowroomReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShowroomReviewsProvider>();

    if (provider.loading && provider.reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: const CircularProgressIndicator(color: Color(0xFF0066EE)),
      );
    }

    if (provider.reviews.isEmpty) {
      return const SizedBox(); // لا تعرض القسم إذا ما في ريفيوز
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== Title =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.ratingAndReviews,
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
              ],
            ),
          ),
      
          const SizedBox(height: 12),
      
          /// ===== Horizontal list =====
          SizedBox(
            height: 263,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.reviews.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return ReviewCard(review: provider.reviews[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
