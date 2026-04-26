import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/providers/cars_filter_provider.dart';
import 'package:sayarti/home/screens/showroom_cars_screen.dart';
import 'package:sayarti/home/widgets/showroom_car_card.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class ShowroomCarsSection extends StatelessWidget {
  final int showroomId;
  final String showroomName;
  final String totalCars;

  const ShowroomCarsSection({
    super.key,
    required this.showroomId,
    required this.showroomName,
    required this.totalCars
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarsFilterProvider>();

    /// ================= LOADING (FIRST LOAD) =================
    if (provider.loading && provider.cars.isEmpty) {
      return Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          height: 230,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, __) => Container(
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: 3,
          ),
        ),
      );
    }

    /// ================= EMPTY =================
    if (provider.cars.isEmpty) {
      return const SizedBox();
    }

    /// ================= CONTENT =================
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= HEADER =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '$totalCars ${AppLocalizations.of(context)!.carListings}',
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShowroomCarsScreen(
                          showroomId: showroomId,
                          showroomName: showroomName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: Color(0xFF868686),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ================= HORIZONTAL LIST =================
          SizedBox(
            height: 243,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.cars.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final car = provider.cars[index];
                return ShowroomCarCard(car: car);
              },
            ),
          ),
        ],
      ),
    );
  }
}
