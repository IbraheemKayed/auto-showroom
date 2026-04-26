import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/models/car_brand.dart';
import 'package:sayarti/home/models/brand_model.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/ai_search/providers/cities_provider.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/home/widgets/home_header.dart';
import 'package:sayarti/home/widgets/home_categories.dart';
import 'package:sayarti/home/widgets/home_section_horizontal.dart';
import 'package:sayarti/home/widgets/home_bottom_cta.dart';
import 'package:sayarti/ai_search/providers/cars_provider.dart';
import 'package:sayarti/home/widgets/recent_searches_section.dart';
import 'package:sayarti/search/providers/search_provider.dart';
import 'package:sayarti/search/screens/search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  const HomeScreen({super.key, this.onSearchTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _topBarOpacity = 0.0;

  void _onScroll(double offset) {
    const fadeStart = 80.0;
    const fadeEnd = 200.0;
    final opacity = ((offset - fadeStart) / (fadeEnd - fadeStart)).clamp(0.0, 1.0);
    if ((opacity - _topBarOpacity).abs() > 0.005) {
      setState(() => _topBarOpacity = opacity);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarsProvider>().loadHomeSections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cars = context.watch<CarsProvider>();
    final auth = context.watch<AuthProvider>();
    final cities = context.watch<CitiesProvider>();
    final l = AppLocalizations.of(context)!;

    final city = cities.getCityById(auth.user?.cityId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ================= SCROLL CONTENT =================
          RefreshIndicator(
            color: const Color(0xFF0066EE),
            onRefresh: () => cars.loadHomeSections(),
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (n) {
                _onScroll(n.metrics.pixels);
                return false;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  HomeHeader(cityName: city?.nameEn, onSearchTap: widget.onSearchTap),

                  const SizedBox(height: 48),

                  HomeCategories(
                    brands: _filterBrands(cars.brands),
                    loading: cars.loadingBrands,
                    error: cars.brandsError,
                    onBrandTap: (brand) {
                      final searchProvider = context.read<SearchProvider>();
                      searchProvider.reset();
                      searchProvider.selectBrand(
                        CarBrand(
                          id: brand.id,
                          name: brand.name,
                          imagePath: brand.imagePath,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchResultsScreen2(),
                        ),
                      );
                    },
                  ),

                  const RecentSearchesSection(),

                  HomeSectionHorizontal(
                    title: l.exclusiveDeals,
                    cars: cars.adminRate5Cars,
                    loading: cars.loadingAdminRate5,
                    error: cars.adminRate5Error,
                  ),

                  HomeSectionHorizontal(
                    title: l.recentPriceDrops,
                    cars: cars.priceDroppedCars,
                    loading: cars.loadingPriceDropped,
                    error: cars.priceDropError,
                  ),

                  if (cars.loadingNearby || cars.nearbyCars.isNotEmpty)
                    HomeSectionHorizontal(
                      title: city == null ? l.nearbyCars : "In ${city.nameEn}",
                      cars: cars.nearbyCars,
                      loading: cars.loadingNearby,
                      error: cars.nearbyError,
                    ),

                  const SizedBox(height: 20),
                  const HomeBottomCTA(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // ================= STATUS BAR OVERLAY =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: MediaQuery.of(context).padding.top,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: _topBarOpacity),
                  boxShadow: _topBarOpacity > 0.5
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08 * _topBarOpacity),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _allowedBrands = [
    'mercedes', 'mb', 'bmw', 'volkswagen', 'vw',
    'seat', 'skoda', 'škoda', 'hyundai', 'kia', 'toyota',
  ];

  List<BrandModel> _filterBrands(List<BrandModel> brands) {
    return brands.where((b) {
      final n = b.name.toLowerCase();
      return _allowedBrands.any((allowed) => n.contains(allowed));
    }).toList();
  }
}
