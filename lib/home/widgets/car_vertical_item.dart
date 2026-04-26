import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/favorites_provider.dart';
import 'package:sayarti/home/widgets/car_horizontal_item.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:svg_flutter/svg.dart';

class CarVerticalItem extends StatelessWidget {
  final CarFull car;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool? isFavoriteOverride;

  const CarVerticalItem({
    super.key,
    required this.car,
    this.onTap,
    this.onFavoriteTap,
    this.isFavoriteOverride,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDealer = context.read<AuthProvider>().user?.isDealer ?? false;
    final city = isAr ? car.showroom?.cityNameAr : car.showroom?.cityNameEn;
    final removedFav = context.watch<FavoritesProvider>().wasRemoved(car.id);
    final isFav = removedFav ? false : (isFavoriteOverride ?? car.isFavorite);
    final subtitle = car.driveTrain.isNotEmpty
        ? '${car.driveTrain} - ${NumberFormat('#,###').format(car.mileage)} ${AppLocalizations.of(context)!.kmUnit}'
        : '${NumberFormat('#,###').format(car.mileage)} ${AppLocalizations.of(context)!.kmUnit}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E3E3), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── IMAGE ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: AspectRatio(
                    aspectRatio: 363 / 211,
                    child: car.coverImage != null
                        ? CachedNetworkImage(
                            imageUrl: car.coverImage!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: const Color(0xFFEDEDED)),
                            errorWidget: (_, __, ___) => Container(
                              color: const Color(0xFFEDEDED),
                              alignment: Alignment.center,
                              child: const Icon(Icons.directions_car,
                                  size: 40, color: Colors.black26),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFEDEDED),
                            alignment: Alignment.center,
                            child: const Icon(Icons.directions_car,
                                size: 40, color: Colors.black26),
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
                if (!isDealer && onFavoriteTap != null)
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

            // ── CONTENT ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${car.year} ${car.brandName} ${car.modelName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.0,
                      color: Color(0xFF121212),
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.9,
                      height: 1.0,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),

                  if (city != null && city.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.08,
                        height: 1.0,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: CarRatingRow(
                          rating: car.adminPriceRate,
                          isAr: isAr,
                          iconSize: 15,
                          fontSize: 15.53,
                          textColor: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₪${NumberFormat('#,###').format(car.price.toInt())}',
                        style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontWeight: FontWeight.w700,
                          fontSize: 17.17,
                          height: 1.0,
                          color: Color(0xFF060606),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
