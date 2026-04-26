import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sayarti/home/models/showroom_review.dart';
import 'package:sayarti/home/widgets/satrs.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class ReviewCard extends StatelessWidget {
  final ShowroomReview review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 334,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== Review content =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Quote icon
                  const Text(
                    '❝',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF868686),
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Review text
                  Expanded(
                    child: Text(
                      review.review.isNotEmpty
                          ? review.review
                          : AppLocalizations.of(context)!.noWrittenReview,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Rating + date
                  Row(
                    children: [
                      Stars(rate: review.rate),
                      const SizedBox(width: 6),
                      Text(
                        review.rate.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                          color: Color(0xFF868686),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(review.addedAt, AppLocalizations.of(context)!.localeName),
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          color: Color(0xFF868686),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// ===== User info =====
          Container(
            height: 63,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE6E6E6))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      review.user.name,
                      style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.memberSinceYear(review.user.created.year),
                      style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: Color(0xFF868686),
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFE0E0E0),
                  child: Icon(Icons.person, size: 20, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date, String locale) {
  return DateFormat('d MMM, yyyy', locale).format(date);
}
