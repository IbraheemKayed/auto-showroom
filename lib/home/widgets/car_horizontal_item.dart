import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/favorites_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:svg_flutter/svg.dart';

class CarHorizontalItem extends StatelessWidget {
  final CarFull car;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const CarHorizontalItem({
    super.key,
    required this.car,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDealer = context.read<AuthProvider>().user?.isDealer ?? false;
    final isFav = context.watch<FavoritesProvider>().wasRemoved(car.id) ? false : car.isFavorite;
    final title = car.driveTrain.isNotEmpty
        ? '${car.year} ${car.brandName} ${car.modelName} ${car.driveTrain}'
        : '${car.year} ${car.brandName} ${car.modelName}';
    final city = isAr
        ? car.showroom?.cityNameAr
        : car.showroom?.cityNameEn;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 239,
        height: 290,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───────── IMAGE ─────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: car.coverImage != null
                      ? CachedNetworkImage(
                          imageUrl: car.coverImage!,
                          height: 133,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 133,
                            color: const Color(0xFFEDEDED),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 133,
                            color: const Color(0xFFEDEDED),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.directions_car,
                              size: 40,
                              color: Colors.black26,
                            ),
                          ),
                        )
                      : Container(
                          height: 133,
                          color: const Color(0xFFEDEDED),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.directions_car,
                            size: 40,
                            color: Colors.black26,
                          ),
                        ),
                ),
                if (car.isSold)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 58,
                      height: 29,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(55),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.sold,
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                if (!isDealer)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          isFav
                              ? 'assets/images/heart_on.svg'
                              : 'assets/images/heart.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ───────── INFO ─────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFEFE),
                  border: Border.all(color: const Color(0xFFE3E3E3), width: 1),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(18.24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TITLE — reserves 2-line height always
                    SizedBox(
                      height: 39,
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontWeight: FontWeight.w500,
                          fontSize: 15.53,
                          height: 1.23,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // PRICE | divider | MILEAGE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₪${NumberFormat('#,###').format(car.price.toInt())}',
                          style: const TextStyle(
                            fontFamily: 'FunnelDisplay',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.0,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 2,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(1.82),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${NumberFormat('#,###').format(car.mileage)} ${AppLocalizations.of(context)!.kmUnit}',
                          style: const TextStyle(
                            fontFamily: 'FunnelDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.0,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // RATING
                    CarRatingRow(rating: car.adminPriceRate, isAr: isAr, fontSize: 15.34),

                    // CITY
                    if (city != null && city.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        city,
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontWeight: FontWeight.w400,
                          fontSize: 10.95,
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

// ─── Shared rating row ────────────────────────────────────────────────────────

class CarRatingRow extends StatelessWidget {
  final int rating;
  final bool isAr;
  final double iconSize;
  final double fontSize;
  final Color textColor;

  const CarRatingRow({
    super.key,
    required this.rating,
    required this.isAr,
    this.iconSize = 15.34,
    this.fontSize = 15.34,
    this.textColor = const Color(0xFF222222),
  });

  String get _svgAsset {
    switch (rating) {
      case 2: return 'assets/images/overpriced.svg';
      case 3: return 'assets/images/fair_deal.svg';
      case 4: return 'assets/images/good_deal.svg';
      case 5: return 'assets/images/great_deal.svg';
      default: return 'assets/images/no_rating.svg';
    }
  }

  String get _labelEn {
    switch (rating) {
      case 2: return 'High Price';
      case 3: return 'Fair Deal';
      case 4: return 'Good Deal';
      case 5: return 'Great Deal';
      default: return 'No Rating';
    }
  }

  String get _labelAr {
    switch (rating) {
      case 2: return 'سعر مرتفع';
      case 3: return 'سعر مناسب';
      case 4: return 'سعر جيد جدا';
      case 5: return 'سعر ممتاز';
      default: return 'بدون تقييم';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(_svgAsset, width: iconSize, height: iconSize),
        const SizedBox(width: 5),
        Text(
          isAr ? _labelAr : _labelEn,
          style: TextStyle(
            fontFamily: 'FunnelDisplay',
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            height: 1.0,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
