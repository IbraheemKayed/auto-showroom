import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class ShowroomCarCard extends StatelessWidget {
  final CarFull car;

  const ShowroomCarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => CarDetailsProvider(context.read<CarApiService>()),
              child: CarDetailsScreen(carId: car.id),
            ),
          ),
        );
      },
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    car.coverImage != null
                        ? CachedNetworkImage(
                            imageUrl: car.coverImage!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: const Color(0xFFEDEDED),
                              alignment: Alignment.center,
                              child: const Icon(Icons.directions_car, size: 32, color: Colors.black26),
                            ),
                          )
                        : Container(color: const Color(0xFFEDEDED)),
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// NAME
            Text(
              '${car.brandName} ${car.modelName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'FunnelDisplay',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.0,
                color: Color(0xFF1B1B1B),
              ),
            ),

            const SizedBox(height: 4),

            /// PRICE
            Text(
              '₪${NumberFormat('#,###').format(car.price.toInt())}',
              style: const TextStyle(
                fontFamily: 'FunnelDisplay',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
