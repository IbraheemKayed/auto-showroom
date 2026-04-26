// ignore_for_file: camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/providers/add_showroom_review_provider.dart';
import 'package:sayarti/home/providers/cars_filter_provider.dart';
import 'package:sayarti/home/providers/showroom_provider.dart';
import 'package:sayarti/home/providers/showroom_revieas_provider.dart';
import 'package:sayarti/home/widgets/add_review_bottom_sheet.dart';
import 'package:sayarti/home/widgets/showroom_cars_section.dart';
import 'package:sayarti/home/widgets/showroom_reviews_section.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowroomDetailsScreen extends StatefulWidget {
  final int showroomId;

  const ShowroomDetailsScreen({super.key, required this.showroomId});

  @override
  State<ShowroomDetailsScreen> createState() => _ShowroomDetailsScreenState();
}

class _ShowroomDetailsScreenState extends State<ShowroomDetailsScreen> {
  void openAddReviewSheet(BuildContext context, int showroomId, String? image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => AddShowroomReviewProvider(context.read<CarApiService>()),
        child: AddReviewBottomSheet(
          showroomId: showroomId,
          showroomImage: image,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShowroomProvider>().loadShowroom(widget.showroomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShowroomProvider>();
    final l = AppLocalizations.of(context)!;

    if (provider.loading) {
      return _ShowroomDetailSkeleton(showroomId: widget.showroomId);
    }

    if (provider.error != null) {
      return Scaffold(body: Center(child: Text(provider.error!)));
    }

    final showroom = provider.showroom!;
    final isAr = l.localeName == 'ar';
    final showroomName = isAr ? (showroom.descriptionAr ?? showroom.description) : showroom.description;

    /// استخراج سنة التسجيل (بدون ما نكسر التطبيق)
    String? registeredYear;
    try {
      if (showroom.addedAt != null) {
        registeredYear = showroom.addedAt!.year.toString();
      }
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),

      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          showroomName,
          style: const TextStyle(
            fontFamily: 'FunnelDisplay',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ),

      body: RefreshIndicator(
        color: const Color(0xFF0066EE),
        onRefresh: () => context.read<ShowroomProvider>().loadShowroom(widget.showroomId),
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// ================= LOGO + PREMIUM BADGE (overlapping) =================
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8EAE9),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: showroom.imagePath != null
                        ? CachedNetworkImage(
                            imageUrl: showroom.imagePath!,
                            width: 104,
                            height: 104,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.store_rounded,
                              size: 44,
                              color: Color(0xFF0066EE),
                            ),
                          )
                        : const Icon(
                            Icons.store_rounded,
                            size: 44,
                            color: Color(0xFF0066EE),
                          ),
                  ),
                ),
                Positioned(
                  bottom: -16,
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: const Color(0xFFEFEFEF)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🏅', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          l.premiumDealer,
                          style: TextStyle(
                            fontFamily: 'FunnelDisplay',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            /// ================= NAME =================
            Text(
              showroomName,
              style: const TextStyle(
                fontFamily: 'FunnelDisplay',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: Color(0xFF1B1B1B),
              ),
            ),

            const SizedBox(height: 4),

            /// ================= REGISTERED =================
            if (registeredYear != null)
              Text(
                '${l.registeredSince} $registeredYear',
                style: const TextStyle(
                  fontFamily: 'FunnelDisplay',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  color: Color(0xFF868686),
                ),
              ),

            const SizedBox(height: 16),

            /// ================= STATS =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 76,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFEFEFEF)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statItem(
                      showroom.stats?.reviewsCount.toString() ?? '0',
                      l.totalReviews,
                    ),
                    _vDivider(),
                    _statItem(
                      showroom.stats?.avgRate.toStringAsFixed(2) ?? '0.00',
                      l.averageRating,
                    ),
                    _vDivider(),
                    _statItem(
                      showroom.stats?.carsCount.toString() ?? '0',
                      l.totalCars,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ================= ABOUT DEALER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20), // 👈 فوق راوندد فقط
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.aboutDealer,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    showroom.note ?? showroomName,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Color(0xFF868686),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            /// ================= PAYMENT METHODS =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white, // ❌ بدون أي rounding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.acceptedPaymentMethods,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    showroom.paymentMethods.map((e) => e.name).join(', '),
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Color(0xFF868686),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            ChangeNotifierProvider(
              create: (_) {
                final p = CarsFilterProvider(context.read<CarApiService>());
                p.params.carShowroomId = showroom.id;
                p.params.carStatuses = ['APPROVED'];
                p.params.limit = 10;
                p.load();
                return p;
              },
              child: ShowroomCarsSection(
                showroomId: showroom.id,
                showroomName: showroomName,
                totalCars: showroom.stats!.carsCount.toString(),
              ),
            ),

            const SizedBox(height: 4),

            ChangeNotifierProvider(
              create: (_) {
                final p = ShowroomReviewsProvider(
                  api: context.read<CarApiService>(),
                  showroomId: showroom.id,
                );
                print('loading ***********************');
                p.load();
                print('done loading &&&&&&&&&&&&&&');
                return p;
              },
              child: const ShowroomReviewsSection(),
            ),
          ],
        ),
        ),
      ),

      /// ================= CTA =================
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                /// ===== Add Review =====
                Expanded(
                  child: GestureDetector(
                    onTap: () => openAddReviewSheet(context, showroom.id, showroom.imagePath),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 11.91,
                            offset: const Offset(0, 5.95),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_outline_rounded, size: 18, color: Color(0xFF3A3A3A)),
                          const SizedBox(width: 8),
                          Text(
                            l.addReview,
                            style: const TextStyle(
                              fontFamily: 'FunnelDisplay',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              color: Color(0xFF3A3A3A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// ===== Contact Dealer =====
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final phone = showroom.user.phone.replaceAll(RegExp(r'[^\d]'), '');
                      final uri = Uri.parse('https://wa.me/$phone');
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066EE),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 11.91,
                            offset: const Offset(0, 5.95),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/chat.svg',
                            width: 18,
                            height: 18,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.contactDealer,
                            style: const TextStyle(
                              fontFamily: 'FunnelDisplay',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= HELPERS =================

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'FunnelDisplay',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
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
    );
  }

  Widget _vDivider() {
    return Container(width: 1, height: 16, color: const Color(0xFF868686));
  }
}

// ─── Showroom Detail Skeleton ────────────────────────────────────────────────

class _ShowroomDetailSkeleton extends StatelessWidget {
  final int showroomId;
  const _ShowroomDetailSkeleton({required this.showroomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SkeletonShimmer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Avatar
              const Center(child: SkeletonBox(height: 96, width: 96, borderRadius: 48)),
              const SizedBox(height: 12),
              // Name
              const Center(child: SkeletonBox(height: 20, width: 160)),
              const SizedBox(height: 6),
              const Center(child: SkeletonBox(height: 14, width: 100)),
              const SizedBox(height: 20),
              // Stats row
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SkeletonBox(height: 40, width: 70, borderRadius: 8),
                    SkeletonBox(height: 40, width: 70, borderRadius: 8),
                    SkeletonBox(height: 40, width: 70, borderRadius: 8),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Cars section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(height: 18, width: 80),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        SkeletonBox(height: 130, width: 200, borderRadius: 12),
                        SizedBox(width: 12),
                        SkeletonBox(height: 130, width: 200, borderRadius: 12),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Info rows
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: SkeletonBox(height: 16, width: double.infinity),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
