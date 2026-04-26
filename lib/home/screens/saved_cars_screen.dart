import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/providers/favorites_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/home/widgets/car_horizontal_item.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/theme/app_text_styles.dart';
import 'package:svg_flutter/svg.dart';

class FavoriteCarsScreen extends StatefulWidget {
  const FavoriteCarsScreen({super.key});

  @override
  State<FavoriteCarsScreen> createState() => _FavoriteCarsScreenState();
}

class _FavoriteCarsScreenState extends State<FavoriteCarsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites(reset: true);
    });

    _scrollController.addListener(() {
      final provider = context.read<FavoritesProvider>();

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          provider.hasNext &&
          !provider.loading) {
        provider.loadFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context)!.saved,
          style: AppTextStyles.semiBold.copyWith(
            fontSize: 26,
            height: 1.0,
            color: const Color(0xFF1B1B1B),
          ),
        ),
        backgroundColor: const Color(0xFFF0F2F1),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: provider.cars.isEmpty && provider.loading
            ? const _SavedCarsSkeleton()
            : RefreshIndicator(
                color: const Color(0xFF0066EE),
                onRefresh: () => provider.loadFavorites(reset: true),
                child: provider.cars.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        children: [
                          const SizedBox(height: 200),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.favorite_border, size: 64, color: Colors.black26),
                                const SizedBox(height: 16),
                                Text(AppLocalizations.of(context)!.noSavedCarsYet, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Text(AppLocalizations.of(context)!.savedCarsPlaceholder, style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.cars.length + (provider.hasNext ? 1 : 0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 203,
                        ),
                        itemBuilder: (context, index) {
                          if (index == provider.cars.length) {
                            return SkeletonShimmer(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18.24),
                                ),
                              ),
                            );
                          }
                          final car = provider.cars[index];
                          return _SavedCarCard(
                            car: car,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => CarDetailsProvider(
                                      context.read<CarApiService>(),
                                    )..loadCar(car.id),
                                    child: CarDetailsScreen(carId: car.id),
                                  ),
                                ),
                              ).then((_) {
                                if (context.mounted) {
                                  context.read<FavoritesProvider>().loadFavorites(reset: true);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
      ),
    );
  }
}

// ====================== CARD ======================

class _SavedCarCard extends StatelessWidget {
  final CarFull car;
  final VoidCallback? onTap;

  const _SavedCarCard({required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final title = car.driveTrain.isNotEmpty
        ? '${car.year} ${car.brandName} ${car.modelName} ${car.driveTrain}'
        : '${car.year} ${car.brandName} ${car.modelName}';
    final city = isAr ? car.showroom?.cityNameAr : car.showroom?.cityNameEn;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE3E3E3)),
          borderRadius: BorderRadius.circular(18.24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ─── IMAGE ───
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18.24),
                ),
                child: car.coverImage != null
                    ? CachedNetworkImage(
                        imageUrl: car.coverImage!,
                        height: 118,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          height: 118,
                          color: const Color(0xFFEDEDED),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          height: 118,
                          color: const Color(0xFFEDEDED),
                          alignment: Alignment.center,
                          child: const Icon(Icons.directions_car,
                              size: 32, color: Colors.black26),
                        ),
                      )
                    : Container(
                        height: 118,
                        color: const Color(0xFFEDEDED),
                        alignment: Alignment.center,
                        child: const Icon(Icons.directions_car,
                            size: 32, color: Colors.black26),
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () =>
                      context.read<FavoritesProvider>().removeFavorite(car.id),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      car.isFavorite
                          ? 'assets/images/heart_on.svg'
                          : 'assets/images/heart.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ─── INFO ───
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFEFEFE),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(18.24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(12, 9, 12, 11),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontWeight: FontWeight.w500,
                      fontSize: 11.32,
                      height: 1.22,
                      color: Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // PRICE | divider | MILEAGE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₪${NumberFormat('#,###').format(car.price.toInt())}',
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          height: 1.0,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 2,
                        height: 13,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(1.33),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${NumberFormat('#,###').format(car.mileage)} ${AppLocalizations.of(context)!.kmUnit}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'FunnelDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            height: 1.0,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // RATING
                  CarRatingRow(
                    rating: car.adminPriceRate,
                    isAr: isAr,
                    iconSize: 11,
                    fontSize: 11,
                  ),

                  // CITY
                  if (city != null && city.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      city,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: 9,
                        height: 1.0,
                        color: Color(0xFF868686),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// ─── Saved Cars Skeleton ─────────────────────────────────────────────────────

class _SavedCarsSkeleton extends StatelessWidget {
  const _SavedCarsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
          mainAxisExtent: 240,
        ),
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(
                  height: 132,
                  width: double.infinity,
                  borderRadius: 18,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(height: 13, width: double.infinity),
                      SizedBox(height: 6),
                      SkeletonBox(height: 12, width: 100),
                      SizedBox(height: 10),
                      SkeletonBox(height: 20, width: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
