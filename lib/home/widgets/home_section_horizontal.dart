import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/theme/app_text_styles.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/screens/view_all_cars_screen.dart';
import 'package:sayarti/home/widgets/car_horizontal_item.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/ai_search/providers/cars_provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class HomeSectionHorizontal extends StatelessWidget {
  final String title;
  final List<CarFull> cars;
  final bool loading;
  final String? error;

  const HomeSectionHorizontal({
    super.key,
    required this.title,
    required this.cars,
    required this.loading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title Row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.medium.copyWith(
                  fontSize: 20,
                  height: 1.0,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewAllCarsScreen(
          title: title,
          cars: cars,
        ),
      ),
    );
  },
  child: Text(
    AppLocalizations.of(context)!.viewAll,
    style: AppTextStyles.medium.copyWith(
      fontSize: 14,
      height: 1.0,
      color: const Color(0xFF868686),
    ),
  ),
),

            ],
          ),
        ),

        SizedBox(
          height: 292,
          child: loading
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  itemBuilder: (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(18.24),
                    child: Container(width: 236, color: Colors.grey.shade300),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 3,
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  itemBuilder: (_, i) => CarHorizontalItem(
                    car: cars[i],
                    onFavoriteTap: () =>
                        context.read<CarsProvider>().toggleFavorite(cars[i]),
                    onTap: () {
                      final carsProvider = context.read<CarsProvider>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => CarDetailsProvider(
                              context.read<CarApiService>(),
                              onFavoriteChanged: carsProvider.syncFavorite,
                            ),
                            child: CarDetailsScreen(carId: cars[i].id),
                          ),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: cars.length,
                ),
        ),
      ],
    );
  }
}
