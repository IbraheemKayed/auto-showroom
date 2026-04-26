// ignore_for_file: camel_case_types

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/dealer/screens/edit_price_screen.dart';
import 'package:sayarti/home/providers/cars_filter_provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/home/providers/showroom_provider.dart';
import 'package:sayarti/home/screens/car_photos_screen.dart';
import 'package:sayarti/home/screens/showroom_details_screen.dart';
import 'package:sayarti/theme/app_text_styles.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/widgets/car_horizontal_item.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/l10n/car_translations.dart';
import 'package:intl/intl.dart';

class CarDetailsScreen extends StatefulWidget {
  final int carId;
  final bool isOwner;

  const CarDetailsScreen({
    super.key,
    required this.carId,
    this.isOwner = false,
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  bool _showAllFeatures = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarDetailsProvider>().loadCar(widget.carId);
    });
    _scrollController.addListener(() {
      const threshold = 280.0 - kToolbarHeight;
      final shouldShow = _scrollController.offset > threshold;
      if (shouldShow != _showTitle) {
        setState(() => _showTitle = shouldShow);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<CarDetailsProvider>();

    if (provider.loading) {
      return _CarDetailSkeleton(carId: widget.carId);
    }

    if (provider.error != null) {
      return Scaffold(body: Center(child: Text(provider.error!)));
    }

    if (provider.car == null) {
      return Scaffold(body: Center(child: Text(l.noCarData)));
    }

    final car = provider.car!;
    final base = car.base;
    final showroom = car.showroom;
    final isAr = l.localeName == 'ar';
    final authUser = context.read<AuthProvider>().user;
    final isOwner = widget.isOwner ||
        (authUser?.isDealer == true &&
            showroom != null &&
            authUser?.showroomId == showroom.id);

    final features = car.feature == null
        ? <String>[]
        : car.feature!
              .toMap()
              .entries
              .where((e) => e.value == true)
              .map((e) => e.key)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      body: RefreshIndicator(
        color: const Color(0xFF0066EE),
        onRefresh: () => context.read<CarDetailsProvider>().loadCar(widget.carId),
        child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ===== APP BAR =====
          SliverAppBar(
            expandedHeight: 336,
            pinned: true,
            backgroundColor: _showTitle ? Colors.white : Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 56,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _circleButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              if (isOwner)
                _circleButton(icon: Icons.more_vert, onPressed: () {})
              else
                _circleButton(icon: Icons.share, onPressed: () {}),
              const SizedBox(width: 16),
            ],
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${base.brandName} ${base.modelName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₪${_formatPrice(base.price)} • ${_formatNumber(base.mileage)}${l.kmUnit}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageCarousel(base),
            ),
          ),

          // ===== OVERVIEW =====
          ...[
            // TITLE + PRICE
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.fromLTRB(17, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${base.year} ${base.brandName} ${base.modelName}',
                            style: const TextStyle(
                              fontFamily: 'FunnelDisplay',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                        ),
                        if (!isOwner && !(context.read<AuthProvider>().user?.isDealer ?? false))
                          GestureDetector(
                            onTap: () => context
                                .read<CarDetailsProvider>()
                                .toggleFavorite(),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: SvgPicture.asset(
                                provider.isFavorite
                                    ? 'assets/images/heart_on.svg'
                                    : 'assets/images/heart.svg',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (!isOwner) ...[
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '₪${_formatPrice(base.price)}',
                            style: const TextStyle(
                              fontFamily: 'FunnelDisplay',
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              color: Color(0xFF101010),
                            ),
                          ),
                          if (base.adminPriceRate > 1) ...[
                            const SizedBox(width: 10),
                            Container(
                              height: 37,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              alignment: Alignment.center,
                              child: CarRatingRow(
                                rating: base.adminPriceRate,
                                isAr: isAr,
                                iconSize: 15.53,
                                fontSize: 15.53,
                                textColor: Colors.black,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            _fullDivider,

            // CAR DETAILS
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(17, 24, 16, 24),
                child: _specGrid(base, l),
              ),
            ),

            _fullDivider,

            // ABOUT THIS CAR (owner only)
            if (isOwner)
              _sectionPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.aboutThisCar,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (base.description.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        base.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.55,
                        ),
                      ),
                    ],
                    if (base.listedAt != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _listingDateItem(
                              label: l.listingDate,
                              value: _formatDate(base.listedAt!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _listingDateItem(
                              label: l.listingTime,
                              value: _formatTime(base.listedAt!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

            // FEATURES (non-owner only)
            if (!isOwner)
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(17, 16, 11, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.featuresTitle,
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (features.isEmpty)
                        Text(
                          l.noFeaturesAvailable,
                          style: const TextStyle(color: Colors.black54),
                        )
                      else
                        Builder(
                          builder: (context) {
                            final displayed = (_showAllFeatures ? features : features.take(3)).toList();
                            return Column(
                              children: [
                                for (int i = 0; i < displayed.length; i++) ...[
                                  _featureRow(displayed[i], l),
                                  if (i < displayed.length - 1)
                                    const Divider(
                                      height: 24,
                                      thickness: 0.8,
                                      color: Color(0xFFE8E8E8),
                                    ),
                                ],
                              ],
                            );
                          },
                        ),
                      if (features.length > 3) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => setState(() => _showAllFeatures = !_showAllFeatures),
                          child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: const Color(0xFFD1D1D1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 11.91,
                                  offset: const Offset(0, 5.95),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _showAllFeatures ? l.showLess : l.viewAllFeatures,
                                style: const TextStyle(
                                  fontFamily: 'FunnelDisplay',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                  color: Color(0xFF1B1B1B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // DESCRIPTION (non-owner)
            if (!isOwner) ...() {
              final desc = (isAr && (base.descriptionAr?.trim().isNotEmpty ?? false))
                  ? base.descriptionAr!.trim()
                  : base.description.trim();
              if (desc.isEmpty) return <Widget>[];
              return [
                _fullDivider,
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(17, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.descriptionLabel,
                          style: const TextStyle(
                            fontFamily: 'FunnelDisplay',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            height: 1.0,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          style: const TextStyle(
                            fontFamily: 'FunnelDisplay',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.4,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            }(),

            if (showroom != null) ...[
            _fullDivider,

            // DEALER INFO + LOCATION
            _sectionPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.dealerInformation,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => ShowroomProvider(
                                  context.read<CarApiService>(),
                                )..loadShowroom(showroom.id),
                              ),
                              ChangeNotifierProvider(
                                create: (_) {
                                  final p = CarsFilterProvider(
                                    context.read<CarApiService>(),
                                  );
                                  p.params.carShowroomId = showroom.id;
                                  p.params.carStatuses = ['APPROVED'];
                                  p.load();
                                  return p;
                                },
                              ),
                            ],
                            child: ShowroomDetailsScreen(showroomId: showroom.id),
                          ),
                        ),
                      );
                    },
                    child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: const Color(0xFFE8EFFD),
                              child: showroom.image != null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: showroom.image!,
                                        width: 52,
                                        height: 52,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) =>
                                            const Icon(
                                          Icons.store_rounded,
                                          size: 26,
                                          color: Color(0xFF0066EE),
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.store_rounded,
                                      size: 26,
                                      color: Color(0xFF0066EE),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          isAr ? (showroom.descriptionAr ?? showroom.description) : showroom.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'FunnelDisplay',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1.0,
                                            color: Color(0xFF1B1B1B),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.verified,
                                        color: Color(0xFF0066EE),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    showroom.addedAt != null
                                        ? '${l.registeredSince} ${showroom.addedAt!.year}'
                                        : '',
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
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Container(
                          height: 67,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFEFEFEF)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _dealerStat(
                                  showroom.stats?.reviewsCount.toString() ??
                                      '0',
                                  l.totalReviews,
                                ),
                              ),
                              const _verticalDivider(),
                              Expanded(
                                child: _dealerStat(
                                  showroom.stats?.avgRate.toString() ?? '0',
                                  l.averageRating,
                                ),
                              ),
                              const _verticalDivider(),
                              Expanded(
                                child: isOwner
                                    ? _dealerStat(
                                        showroom.stats?.responseRate != null
                                            ? '${showroom.stats!.responseRate!.toStringAsFixed(0)}%'
                                            : '—',
                                        l.responseRate,
                                      )
                                    : _dealerStat(
                                        showroom.stats?.carsCount.toString() ??
                                            '0',
                                        l.totalCars,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),

                  const SizedBox(height: 16),

                  if (!isOwner)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (_) => ShowroomProvider(
                                    context.read<CarApiService>(),
                                  )..loadShowroom(showroom.id),
                                ),
                                ChangeNotifierProvider(
                                  create: (_) {
                                    final p = CarsFilterProvider(
                                      context.read<CarApiService>(),
                                    );
                                    p.params.carShowroomId = showroom.id;
                                    p.params.carStatuses = ['APPROVED'];
                                    p.load();
                                    return p;
                                  },
                                ),
                              ],
                              child: ShowroomDetailsScreen(
                                  showroomId: showroom.id),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: const Color(0xFFD1D1D1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 11.91,
                              offset: const Offset(0, 5.95),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Center(
                          child: Text(
                            '${l.moreAbout} ${isAr ? (showroom.descriptionAr ?? showroom.description) : showroom.description}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'FunnelDisplay',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  Text(
                    isOwner ? l.theLocation : l.dealersLocation,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () =>
                        openGoogleMaps(showroom.latitude, showroom.longitude),
                    child: Container(
                      height: 272,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFF2F2F2),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/map.png',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: .08),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        showroom.cityNameEn,
                                        style: const TextStyle(
                                          fontFamily: 'FunnelDisplay',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 1.0,
                                          color: Color(0xFF1B1B1B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        l.viewOnMap,
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
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: const Color(0xFFD1D1D1)),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Center(
                                      child: Text(
                                        l.viewMap,
                                        style: const TextStyle(
                                          fontFamily: 'FunnelDisplay',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          height: 1.0,
                                          color: Color(0xFF1B1B1B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            ], // end if (showroom != null)

            // PRICE SECTION (owner only)
            if (isOwner) ...[
              _fullDivider,
              _sectionPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF868686),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₪${_formatPrice(base.price)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    if (base.priceHistory.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        l.previousPrices,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...List.generate(base.priceHistory.length, (i) {
                        final h = base.priceHistory[i];
                        return Column(
                          children: [
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFE6E6E6),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatHistoryDate(h.date),
                                    style: const TextStyle(
                                      color: Color(0xFF868686),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '₪${_formatPrice(h.price)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFF1B1B1B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE6E6E6),
                      ),
                    ],
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        final newPrice = await Navigator.push<double>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditPriceScreen(
                              carId: base.id,
                              carName:
                                  '${base.brandName} ${base.modelName}',
                              currentPrice: base.price,
                              api: context.read<CarDetailsProvider>().api,
                            ),
                          ),
                        );
                        if (newPrice != null && context.mounted) {
                          context.read<CarDetailsProvider>().refreshCar(base.id);
                        }
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.black,
                      ),
                      label: Text(
                        l.editPrice,
                        style:
                            AppTextStyles.bold.copyWith(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => _showMarkAsSoldSheet(context),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                      label: Text(
                        l.markAsSold,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
        ),
      ),

      // ===== BOTTOM BAR =====
      bottomNavigationBar: isOwner
          ? null
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: GestureDetector(
                  onTap: () => openWhatsApp(showroom?.phone ?? ''),
                  child: Container(
                    width: double.infinity,
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
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l.messageDealer,
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
      ),
    );
  }

  // ===== CIRCLE BUTTON (AppBar) =====

  Widget _circleButton({required IconData icon, required VoidCallback onPressed}) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: _showTitle
            ? Icon(icon, color: const Color(0xFF1B1B1B), size: 20)
            : ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0x66000000),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                ),
              ),
      ),
    );
  }

  // ===== MARK AS SOLD SHEET =====

  void _showMarkAsSoldSheet(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) => Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 24 + MediaQuery.of(sheetCtx).padding.bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l.markAsSoldTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                l.markAsSoldMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Color(0xFFE6E6E6)),
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(l.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await context.read<CarDetailsProvider>().markAsSold();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        l.soldBtn,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }

  // ===== HELPERS =====

  static Widget _listingDateItem({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final locale = AppLocalizations.of(context)!.localeName;
    return DateFormat('d MMMM yyyy', locale).format(dt);
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  static String _formatPrice(double price) {
    final s = price.toStringAsFixed(0);
    return s.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }

  static String _formatHistoryDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Widget _buildImageCarousel(base) {
    final images = base.images as List?;
    if (images == null || images.isEmpty) {
      return Container(color: Colors.grey[300]);
    }


    final imageUrls = images
        .map((e) => e.imagePath as String?)
        .where((s) => s != null && s.isNotEmpty)
        .cast<String>()
        .toList();

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _currentImageIndex = i),
          itemBuilder: (ctx, i) {
            final img = images[i].imagePath as String?;
            final urlIndex = imageUrls.indexOf(img ?? '');
            return GestureDetector(
              onTap: imageUrls.isEmpty || _showTitle
                  ? null
                  : () {
                      final provider = ctx.read<CarDetailsProvider>();
                      final showroom = provider.car?.showroom;
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => CarPhotosScreen(
                            images: imageUrls,
                            initialIndex: urlIndex < 0 ? 0 : urlIndex,
                            isFavorite: provider.isFavorite,
                            onToggleFavorite: () => provider.toggleFavorite(),
                            onMessageDealer: () =>
                                openWhatsApp(showroom?.phone ?? ''),
                          ),
                        ),
                      );
                    },
              child: img != null
                  ? CachedNetworkImage(
                      imageUrl: img,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (_, __, ___) =>
                          Container(color: const Color(0xFFEDEDED)),
                    )
                  : Container(color: Colors.grey[300]),
            );
          },
        ),
        if (images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentImageIndex == i ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == i
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  static String _formatNumber(dynamic value) {
    final n = int.tryParse(value.toString()) ?? 0;
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  static SliverToBoxAdapter _sectionPadding({required Widget child, double bottom = 10}) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16, 10, 16, bottom),
        child: child,
      ),
    );
  }

  static const SliverToBoxAdapter _fullDivider = SliverToBoxAdapter(
    child: SizedBox(height: 4),
  );

  Widget _specGrid(base, AppLocalizations l) {
    final left = [
      _specItem('assets/images/mileage.svg', l.mileageLabel, '${_formatNumber(base.mileage)}${l.kmUnit}'),
      _specItem('assets/images/power.svg', l.powerLabel, base.power),
      _specItem('assets/images/fuel.svg', l.fuelLabel, CarTranslations.translateValue(base.fuelTypeName, l)),
      _specItem('assets/images/drivetrain.svg', l.driveTrainLabel, CarTranslations.translateValue(base.driveTrain, l)),
    ];
    final right = [
      _specItem('assets/images/engine.svg', l.engineSizeLabel, base.engineSize),
      _specItem('assets/images/calendar.svg', l.registrationYearLabel, '${base.year}'),
      _specItem('assets/images/transmission.svg', l.transmissionLabel, CarTranslations.translateValue(base.gearType, l)),
      _specItem('assets/images/owners.svg', l.previousOwnersLabel, base.previousOwners != null ? '${base.previousOwners}' : '—'),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < left.length; i++) ...[
              left[i],
              if (i < left.length - 1) const SizedBox(height: 20),
            ],
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < right.length; i++) ...[
              right[i],
              if (i < right.length - 1) const SizedBox(height: 20),
            ],
          ],
        ),
      ],
    );
  }

  Widget _specItem(String svg, String title, String value) {
    return SizedBox(
      height: 40,
      child: Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            svg,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
            colorFilter: const ColorFilter.mode(Color(0xFF0066EE), BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'FunnelDisplay',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.0,
                color: Color(0xFF868686),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'FunnelDisplay',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ],
        ),
      ],
      ),
    );
  }

  Widget _featureRow(String text, AppLocalizations l) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        CarTranslations.getFeatureLabel(text, l),
        style: const TextStyle(
          fontFamily: 'FunnelDisplay',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: Color(0xFF1B1B1B),
        ),
      ),
    );
  }
}

class _dealerStat extends StatelessWidget {
  final String value;
  final String label;

  const _dealerStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _verticalDivider extends StatelessWidget {
  const _verticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 16, color: const Color(0xFF868686));
  }
}

Future<void> openGoogleMaps(double lat, double lng) async {
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
  );

  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('Could not launch Google Maps: $e');
  }
}

Future<void> openWhatsApp(String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
  final uri = Uri.parse('https://wa.me/$cleaned');
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('Could not open WhatsApp: $e');
  }
}

// ─── Car Detail Skeleton ─────────────────────────────────────────────────────

class _CarDetailSkeleton extends StatelessWidget {
  final int carId;
  const _CarDetailSkeleton({required this.carId});

  static const _divider = Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ── Bottom bar ──
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SkeletonShimmer(
            child: const SkeletonBox(height: 50, width: double.infinity, borderRadius: 30),
          ),
        ),
      ),
      body: SkeletonShimmer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image carousel ──
              const SkeletonBox(height: 280, borderRadius: 0, width: double.infinity),

              // ── Title + Price ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Year Brand Model
                    const SkeletonBox(height: 22, width: 220),
                    const SizedBox(height: 10),
                    // Price + rating badge
                    Row(
                      children: const [
                        SkeletonBox(height: 20, width: 110),
                        SizedBox(width: 10),
                        SkeletonBox(height: 20, width: 80, borderRadius: 20),
                      ],
                    ),
                  ],
                ),
              ),

              _divider,

              // ── Car Details (spec grid 2×4) ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(height: 18, width: 100),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                        SizedBox(width: 18),
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                        SizedBox(width: 18),
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                        SizedBox(width: 18),
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                        SizedBox(width: 18),
                        Expanded(child: SkeletonBox(height: 52, borderRadius: 10)),
                      ],
                    ),
                  ],
                ),
              ),

              _divider,

              // ── Features ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(height: 18, width: 80),
                    const SizedBox(height: 14),
                    // Feature row 1
                    Row(
                      children: const [
                        SkeletonBox(height: 20, width: 20, borderRadius: 4),
                        SizedBox(width: 12),
                        Expanded(child: SkeletonBox(height: 14)),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1, color: Color(0xFFEDEDED)),
                    // Feature row 2
                    Row(
                      children: const [
                        SkeletonBox(height: 20, width: 20, borderRadius: 4),
                        SizedBox(width: 12),
                        Expanded(child: SkeletonBox(height: 14)),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1, color: Color(0xFFEDEDED)),
                    // Feature row 3
                    Row(
                      children: const [
                        SkeletonBox(height: 20, width: 20, borderRadius: 4),
                        SizedBox(width: 12),
                        Expanded(child: SkeletonBox(height: 14)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // "View All Features" button
                    const SkeletonBox(height: 48, width: double.infinity, borderRadius: 30),
                  ],
                ),
              ),

              _divider,

              // ── Dealer information ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(height: 18, width: 160),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Avatar + name
                          Row(
                            children: const [
                              SkeletonBox(height: 48, width: 48, borderRadius: 24),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonBox(height: 16, width: 140),
                                  SizedBox(height: 6),
                                  SkeletonBox(height: 12, width: 110),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Stats row
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: const [
                                      SkeletonBox(height: 18, width: 40),
                                      SizedBox(height: 4),
                                      SkeletonBox(height: 11, width: 70),
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 36, color: const Color(0xFFE6E6E6)),
                                Expanded(
                                  child: Column(
                                    children: const [
                                      SkeletonBox(height: 18, width: 40),
                                      SizedBox(height: 4),
                                      SkeletonBox(height: 11, width: 70),
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 36, color: const Color(0xFFE6E6E6)),
                                Expanded(
                                  child: Column(
                                    children: const [
                                      SkeletonBox(height: 18, width: 40),
                                      SizedBox(height: 4),
                                      SkeletonBox(height: 11, width: 70),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
