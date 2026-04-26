import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/providers/add_showroom_review_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final int showroomId;
  final String? showroomImage;

  const AddReviewBottomSheet({
    super.key,
    required this.showroomId,
    this.showroomImage,
  });

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;

  bool get _canSubmit => _rating > 0 && _reviewController.text.isNotEmpty;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddShowroomReviewProvider>();
    final l = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              // ─── HEADER (black) ───────────────────────────────────────
              Container(
                width: double.infinity,
                color: const Color(0xFFF0F2F1),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // X button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(Icons.close, color: Colors.black, size: 20),
                          ),
                        ),

                        const Spacer(),

                        // Dealer image
                        if (widget.showroomImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: widget.showroomImage!,
                              width: 59,
                              height: 52,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                width: 59,
                                height: 52,
                                color: const Color(0xFF333333),
                                child: const Icon(Icons.store, color: Colors.white54, size: 24),
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 59,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.store, color: Colors.white54, size: 24),
                          ),

                        const Spacer(),

                        // Check button
                        if (_canSubmit)
                          GestureDetector(
                            onTap: provider.loading
                                ? null
                                : () async {
                                    final ok = await provider.submitReview(
                                      showroomId: widget.showroomId,
                                      review: _reviewController.text,
                                      rate: _rating,
                                    );
                                    if (ok && context.mounted) Navigator.pop(context, true);
                                  },
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: provider.loading
                                  ? const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Icon(Icons.check, color: Colors.white, size: 20),
                            ),
                          )
                        else
                          const SizedBox(width: 43),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // "Write a review..." title
                    Text(
                      l.writeAReview,
                      style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── CONTENT (white) ──────────────────────────────────────
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    controller: controller,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                    children: [
                      // Stars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final filled = index < _rating;
                          return GestureDetector(
                            onTap: () => setState(() => _rating = index + 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.star,
                                size: 36,
                                color: filled ? const Color(0xFFFF9900) : const Color(0xFFD1D1D1),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: Text(
                          l.tapToRate,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF868686),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Review input
                      TextField(
                        controller: _reviewController,
                        maxLines: 5,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: l.reviewExperienceHint,
                          hintStyle: const TextStyle(
                            fontSize: 15.81,
                            color: Color(0xFF868686),
                            height: 1.3,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFF0066EE), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),

                      if (provider.error != null) ...[
                        const SizedBox(height: 12),
                        Text(provider.error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
