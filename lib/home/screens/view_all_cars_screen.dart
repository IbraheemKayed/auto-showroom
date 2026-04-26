import 'package:cached_network_image/cached_network_image.dart';
import 'package:svg_flutter/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/search/widgets/price_rating.dart';

class ViewAllCarsScreen extends StatelessWidget {
  final String title;
  final List<CarFull> cars;

  const ViewAllCarsScreen({super.key, required this.title, required this.cars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: const BackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];

          return _CarCard(
            car: car,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) =>
                        CarDetailsProvider(context.read<CarApiService>())
                          ..loadCar(car.id),
                    child: CarDetailsScreen(carId: car.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CarCard extends StatefulWidget {
  final CarFull car;
  final VoidCallback onTap;

  const _CarCard({required this.car, required this.onTap});

  @override
  State<_CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<_CarCard> {
  late bool _isFavorite;
  int _currentImageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.car.isFavorite;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    final newValue = !_isFavorite;
    setState(() => _isFavorite = newValue);
    try {
      final api = context.read<CarApiService>();
      if (newValue) {
        await api.addToFavorites(widget.car.id);
      } else {
        await api.removeFromFavorites(widget.car.id);
      }
    } catch (_) {
      setState(() => _isFavorite = !newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final images = car.images;
    final isAr = AppLocalizations.of(context)!.localeName == 'ar';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: images.isEmpty
                        ? Container(color: Colors.grey[300])
                        : PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (i) =>
                                setState(() => _currentImageIndex = i),
                            itemBuilder: (_, i) {
                              final img = images[i].imagePath;
                              return (img != null && img.isNotEmpty)
                                  ? CachedNetworkImage(imageUrl: img, fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => Container(color: const Color(0xFFEDEDED)))
                                  : Container(color: Colors.grey[300]);
                            },
                          ),
                  ),
                ),

                if (images.isNotEmpty)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${images.length}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PRICE + FAVORITE
                  Row(
                    children: [
                      Text(
                        '₪${car.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(height: 20, width: 1.5, color: Colors.black26),
                      const SizedBox(width: 8),
                      PriceRatingWidget(rating: car.adminPriceRate),
                      const Spacer(),
                      if (!(context.read<AuthProvider>().user?.isDealer ?? false))
                        GestureDetector(
                          onTap: _toggleFavorite,
                          child: SvgPicture.asset(
                            _isFavorite
                                ? 'assets/images/heart_on.svg'
                                : 'assets/images/heart.svg',
                            width: 24,
                            height: 24,
                          ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${car.brandName} ${car.modelName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${car.year} • ${car.mileage}km • ${car.gearType}',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),

                  if (car.showroom != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isAr ? (car.showroom!.descriptionAr ?? car.showroom!.description) : car.showroom!.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isAr ? car.showroom!.cityNameAr : car.showroom!.cityNameEn,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
