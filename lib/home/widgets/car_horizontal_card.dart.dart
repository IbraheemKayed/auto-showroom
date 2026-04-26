import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class CarHorizontalCard extends StatelessWidget {
  final CarFull car;

  const CarHorizontalCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final image = car.images.isNotEmpty ? car.images.first.imagePath : null;

    return GestureDetector(
      onTap: () {
        // TODO: navigate to car details
      },

      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Car Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: image != null
                ? CachedNetworkImage(
                    imageUrl: image,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 130,
                      color: const Color(0xFFEDEDED),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 130,
                      color: const Color(0xFFEDEDED),
                      alignment: Alignment.center,
                      child: const Icon(Icons.directions_car, size: 40, color: Colors.black26),
                    ),
                  )
                : Container(
                    height: 130,
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

                  Text(
                    "${car.brandName} ${car.modelName}",
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${car.year} · ${car.mileage} ${AppLocalizations.of(context)!.kmUnit}",
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${car.price.toStringAsFixed(0)} ₪",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
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
