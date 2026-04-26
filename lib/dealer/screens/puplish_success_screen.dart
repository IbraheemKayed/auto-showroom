import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/dealer/services and providers/create_car_provider.dart';
import 'package:sayarti/dealer/models/upload_image_model.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class PublishSuccessScreen extends StatelessWidget {
  const PublishSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final create = context.watch<CreateCarProvider>();
    final auth = context.watch<AuthProvider>();

    final UploadingCarImage? cover = create.images.isEmpty
        ? null
        : create.images.firstWhere(
            (e) => e.isCover,
            orElse: () => create.images.first,
          );

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ===== SUCCESS ICON =====
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Sparkle top-left
                  Positioned(
                    top: 6,
                    left: 10,
                    child: Icon(Icons.auto_awesome,
                        size: 16, color: Colors.amber.shade400),
                  ),
                  // Sparkle top-right
                  Positioned(
                    top: 4,
                    right: 8,
                    child: Icon(Icons.auto_awesome,
                        size: 12, color: Colors.amber.shade300),
                  ),
                  // Sparkle bottom-right
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Icon(Icons.auto_awesome,
                        size: 14, color: Colors.amber.shade400),
                  ),
                  // Sparkle bottom-left
                  Positioned(
                    bottom: 10,
                    left: 8,
                    child: Icon(Icons.auto_awesome,
                        size: 10, color: Colors.amber.shade300),
                  ),
                  // Badge circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0066EE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              l.successfullyApplied,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l.reviewMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ),

            const SizedBox(height: 24),

            // ===== PREVIEW CARD =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _previewCard(context, create, cover, auth, l),
            ),

            const Spacer(),

            // ===== GO HOME =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const MainLayout()),
                      (_) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    l.goToHome,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PREVIEW CARD =================

  Widget _previewCard(
    BuildContext context,
    CreateCarProvider create,
    UploadingCarImage? cover,
    AuthProvider auth,
    AppLocalizations l,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== IMAGE =====
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: cover != null
                    ? Image.file(
                        cover.file,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image, size: 40),
                        ),
                      ),
              ),

              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.preview,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          // ===== INFO =====
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  create.carTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.localeName == 'ar'
                            ? (auth.user?.nameAr ?? auth.user?.name ?? '')
                            : (auth.user?.name ?? ''),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(
                      _formatPrice(create.price),
                      style: const TextStyle(
                        color: Color(0xFF0066EE),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  '${_formatKm(create.mileage)} ${l.kmUnit}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  String _formatPrice(double value) {
    final formatter = NumberFormat('#,###');
    return '₪${formatter.format(value)}';
  }

  String _formatKm(int? km) {
    if (km == null) return '0';
    final formatter = NumberFormat('#,###');
    return formatter.format(km);
  }
}
