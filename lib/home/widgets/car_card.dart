import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import '../models/car_full.dart';

class CarCard extends StatelessWidget {
  final CarFull car;
  final VoidCallback? onTap;

  const CarCard({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    final coverImage = car.coverImage;
        
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- IMAGE ----------------
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: coverImage != null
                  ? CachedNetworkImage(
                      imageUrl: coverImage,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 140,
                        color: const Color(0xFFEDEDED),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 140,
                        color: const Color(0xFFEDEDED),
                        alignment: Alignment.center,
                        child: const Icon(Icons.directions_car, size: 40, color: Colors.black26),
                      ),
                    )
                  : Container(
                      height: 140,
                      color: const Color(0xFFEDEDED),
                      alignment: Alignment.center,
                      child: const Icon(Icons.directions_car, size: 40, color: Colors.black26),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- TITLE ----------------
                  Text(
                    "${car.year} ${car.brandName} ${car.modelName}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // ---------------- PRICE + RATE ----------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "₪${car.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _PriceRateBadge(rate: car.adminPriceRate),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ---------------- TAGS ----------------
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _SpecChip("${car.mileage}${AppLocalizations.of(context)!.kmUnit}"),
                      _SpecChip(car.gearType),
                      _SpecChip(car.driveTrain),
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



class _SpecChip extends StatelessWidget {
  final String text;

  const _SpecChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PriceRateBadge extends StatelessWidget {
  final int rate;

  const _PriceRateBadge({required this.rate});

  @override
  Widget build(BuildContext context) {
    if (rate <= 0) return const SizedBox();
    final l = AppLocalizations.of(context)!;
    final label = switch (rate) {
      5 => l.veryGoodPrice,
      4 => l.goodPrice,
      3 => l.averagePrice,
      2 => l.highPrice,
      1 => l.veryHighPrice,
      _ => '',
    };

    return Row(
      children: [
        Container(
          width: 26,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF358658),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF358658),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
