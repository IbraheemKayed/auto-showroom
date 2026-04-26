import 'package:flutter/material.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class PriceRatingWidget extends StatelessWidget {
  final int rating; // من 1 إلى 5
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final String? labelFontFamily;

  const PriceRatingWidget({
    super.key,
    required this.rating,
    this.labelFontSize,
    this.labelFontWeight,
    this.labelFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    final clampedRating = rating.clamp(1, 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Bars =====
        Row(
          children: List.generate(5, (index) {
            final isActive = index < clampedRating;

            return Container(
              width: 12,
              height: 3,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF358658)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),

        const SizedBox(height: 2),

        // ===== Label =====
        Text(
          priceRatingLabel(clampedRating),
          style: AppTextStyles.semiBold.copyWith(
            fontFamily: labelFontFamily,
            fontSize: labelFontSize ?? 10.08,
            fontWeight: labelFontWeight,
            height: 1.0,
            color: const Color(0xFF1B1B1B),
          ),
        ),
      ],
    );
  }
}


String priceRatingLabel(int rating) {
  switch (rating) {
    case 5:
      return 'Excellent Deal';
    case 4:
      return 'Good Deal';
    case 3:
      return 'Fair Deal';
    case 2:
      return 'High Price';
    case 1:
    default:
      return 'No Rating';
  }
}
