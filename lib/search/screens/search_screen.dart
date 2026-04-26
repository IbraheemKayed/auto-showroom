import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/color_provider.dart';
import 'package:sayarti/search/providers/dealer_search_provider.dart';
import 'package:sayarti/search/providers/search_cars_provider.dart';
import 'package:sayarti/search/providers/search_provider.dart';
import 'package:sayarti/search/screens/exterior_color_screen.dart';
import 'package:sayarti/search/screens/interior_color_screen.dart';
import 'package:sayarti/search/screens/mileage_screen.dart';
import 'package:sayarti/search/screens/model_screen.dart';
import 'package:sayarti/search/screens/more_filters_screen.dart';
import 'package:sayarti/search/screens/price_screen.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/providers/showroom_provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/home/screens/showroom_details_screen.dart';
import 'package:sayarti/search/screens/search_results_screen.dart';
import 'package:sayarti/search/screens/year_screen.dart';
import 'package:sayarti/theme/app_text_styles.dart';
import 'make_select_screen.dart';
import 'package:sayarti/search/screens/transmission_screen.dart';
import 'package:sayarti/search/screens/fuel_type_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isCarSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchCarsProvider>().fetchCount();
    });
  }

  void _fetchCount() {
    if (mounted) context.read<SearchCarsProvider>().fetchCount();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F1),

      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF0F2F1),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          l.search,
          style: AppTextStyles.semiBold.copyWith(
            fontSize: 26,
            height: 1.0,
            color: const Color(0xFF1B1B1B),
          ),
        ),
      ),

      body: Column(
        children: [
          /// ===== TOGGLE (in gray area) =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  _toggleItem(
                    title: l.car,
                    selected: isCarSelected,
                    onTap: () {
                      setState(() => isCarSelected = true);
                    },
                  ),
                  _toggleItem(
                    title: l.dealer,
                    selected: !isCarSelected,
                    onTap: () {
                      setState(() => isCarSelected = false);
                      final dealer = context.read<DealerSearchProvider>();
                      if (dealer.showrooms.isEmpty && !dealer.isLoading) {
                        dealer.search(reset: true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          /// ===== WHITE CONTAINER =====
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  /// ===== CONTENT =====
                  Expanded(
                    child: isCarSelected
                        ? _carFilters(context)
                        : _dealerSearch(context),
                  ),

                  /// ===== BOTTOM ACTION (ONLY FOR CAR) =====
                  if (isCarSelected) _carBottomBar(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ======================= CAR FILTERS =====================
  // =========================================================

  Widget _carFilters(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final search = context.watch<SearchProvider>();
    final brandCount = search.selectedBrandIds.length;
    final selectedMakeName = brandCount == 0
        ? l.any
        : brandCount == 1
            ? (search.selectedBrand?.name ?? l.any)
            : '$brandCount ${l.selected}';

    return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _filterItem(
            title: l.makeFilter,
            value: selectedMakeName,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MakeScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.modelFilter,
            value: _modelValue(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ModelScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.priceFilter,
            value: _priceValue(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PriceScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.yearFilter,
            value: (search.minYear == search.yearMinLimit && search.maxYear == search.yearMaxLimit)
                ? l.any
                : '${search.minYear.toInt()} - ${search.maxYear.toInt()}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const YearScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.mileageFilter,
            value: _mileageValue(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MileageScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.interiorColor,
            value: search.selectedInsideColorIds.isEmpty
                ? l.any
                : '${search.selectedInsideColorIds.length} ${l.selected}',
            onTap: () {
              context.read<CarColorsProvider>().load();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InteriorColorScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.exteriorColor,
            value: search.selectedOutsideColorIds.isEmpty
                ? l.any
                : '${search.selectedOutsideColorIds.length} ${l.selected}',
            onTap: () {
              context.read<CarColorsProvider>().load();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExteriorColorScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.transmissionLabel,
            value: search.selectedGearTypes.isEmpty
                ? l.any
                : search.selectedGearTypes
                    .map((g) => g == 'AUTOMATIC' ? l.automatic : l.manual)
                    .join(', '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransmissionScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _filterItem(
            title: l.fuelLabel,
            value: search.selectedFuelTypeId == null ? l.any : l.selected,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FuelTypeScreen()),
              ).then((_) => _fetchCount());
            },
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),

          const SizedBox(height: 6),

          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoreFiltersScreen()),
                ).then((_) => _fetchCount());
              },
              icon: const Icon(Icons.tune, size: 18, color: Color(0xFF1B1B1B)),
              label: Text(
                l.showMoreFilters,
                style: const TextStyle(
                  color: Color(0xFF1B1B1B),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.72,
                  height: 1.0,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
    );
  }

  Widget _carBottomBar(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final search = context.watch<SearchProvider>();
    final searchCars = context.watch<SearchCarsProvider>();
    final filtersCount = _selectedFiltersCount(search);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  search.reset();
                  _fetchCount();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(right: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l.clearFilter,
                  style: const TextStyle(
                    color: Color(0xFF0066EE),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.04,
                    height: 1.0,
                  ),
                ),
              ),
              const Icon(Icons.refresh, size: 20, color: Color(0xFF0066EE)),
              const Spacer(),

              // ✅ Badge + "filters selected" مثل الصورة
              if (filtersCount > 0) ...[
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA1C6F6),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    '$filtersCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  filtersCount == 1 ? l.filterSelected : l.filtersSelected,
                  style: const TextStyle(fontSize: 12.75, fontWeight: FontWeight.w400, color: Color(0xFF1B1B1B), height: 1.0),
                ),
              ],
            ],
          ),

          const SizedBox(height: 10),

          // ✅ زر نفس شكل الصورة + عدد سيارات مؤقت
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchResultsScreen2()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066EE),
              minimumSize: const Size(double.infinity, 47),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            ),
            child: Text(
              searchCars.totalCount > 0
                  ? '${l.searchAllCars} (${_formatCount(searchCars.totalCount)})'
                  : l.searchAllCars,
              style: const TextStyle(
                fontSize: 14.88,
                fontWeight: FontWeight.w500,
                color: Color(0xFFEEEEEE),
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ===================== DEALER SEARCH =====================
  // =========================================================

  Widget _dealerSearch(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final dealer = context.watch<DealerSearchProvider>();

    return Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: l.searchDealers,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFF0066EE), width: 2),
                ),
              ),
              onChanged: dealer.updateSearch,
            ),
          ),

          Expanded(
            child: dealer.isLoading && dealer.showrooms.isEmpty
                ? const _DealerSearchSkeleton()
                : dealer.showrooms.isEmpty
                    ? _dealerEmptyState(context)
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemCount: dealer.showrooms.length + (dealer.hasMore ? 1 : 0),
                        separatorBuilder: (_, index) {
                          if (dealer.hasMore && index == dealer.showrooms.length - 1) {
                            return const SizedBox.shrink();
                          }
                          return const Divider(height: 1, color: Color(0xFFEAEAEA));
                        },
                        itemBuilder: (context, index) {
                          if (index == dealer.showrooms.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: TextButton(
                                  onPressed: dealer.isLoading ? null : () => dealer.search(),
                                  child: dealer.isLoading
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black54,
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              l.showMore,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black54,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            );
                          }

                          final showroom = dealer.showrooms[index];
                          final isAr = AppLocalizations.of(context)!.localeName == 'ar';
                          final cityName = isAr ? (showroom.city?.nameAr ?? '') : (showroom.city?.nameEn ?? '');

                          return ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFFE8EFFD),
                              child: showroom.imagePath != null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: showroom.imagePath!,
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => const Icon(
                                          Icons.store_rounded,
                                          size: 20,
                                          color: Color(0xFF0066EE),
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.store_rounded,
                                      size: 20,
                                      color: Color(0xFF0066EE),
                                    ),
                            ),
                            title: Text(
                              isAr ? (showroom.descriptionAr ?? showroom.description) : showroom.description,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: cityName.isNotEmpty ? Text(cityName) : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => ShowroomProvider(
                                      context.read<CarApiService>(),
                                    ),
                                    child: ShowroomDetailsScreen(
                                      showroomId: showroom.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
    );
  }

  // =========================================================
  // ======================= HELPERS =========================
  // =========================================================

  Widget _toggleItem({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: selected
                ? Border.all(color: const Color(0xFFD1D1D1), width: 1)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: const Color(0xFF1B1B1B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterItem({
    required String title,
    required String value,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B), height: 1.0),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(color: Color(0xFF868686), fontSize: 12, fontWeight: FontWeight.w400, height: 1.0),
      ),
      trailing: icon != null
          ? Icon(icon, color: const Color(0xFFB3B2B3))
          : const Icon(Icons.chevron_right, color: Color(0xFFB3B2B3)),
      onTap: onTap,
    );
  }

  String _mileageValue(BuildContext context) {
    final search = context.read<SearchProvider>();

    if (search.minMileage == search.mileageMinLimit &&
        search.maxMileage == search.mileageMaxLimit) {
      return AppLocalizations.of(context)!.any;
    }
    return '${search.minMileage.toInt()} - ${search.maxMileage.toInt()} ${AppLocalizations.of(context)!.kmUnit}';
  }

  String _priceValue(BuildContext context) {
    final search = context.read<SearchProvider>();

    if (search.minPrice == search.priceMinLimit &&
        search.maxPrice == search.priceMaxLimit) {
      return AppLocalizations.of(context)!.any;
    }
    if (search.maxPrice >= search.priceMaxLimit) {
      return '₪${search.minPrice.toInt()} - ₪500,000+';
    }
    return '₪${search.minPrice.toInt()} - ₪${search.maxPrice.toInt()}';
  }

  String _modelValue(BuildContext context) {
    final search = context.read<SearchProvider>();
    final l = AppLocalizations.of(context)!;
    if (search.selectedModelIds.isEmpty) return l.any;
    return '${search.selectedModelIds.length} ${l.selected}';
  }

  int _selectedFiltersCount(SearchProvider search) {
    int count = 0;
    if (search.selectedBrandIds.isNotEmpty) count++;
    if (search.selectedModelIds.isNotEmpty) count++;
    if (search.selectedCityIds.isNotEmpty) count++;
    if (search.minYear != search.yearMinLimit || search.maxYear != search.yearMaxLimit) count++;
    if (search.selectedInsideColorIds.isNotEmpty) count++;
    if (search.selectedOutsideColorIds.isNotEmpty) count++;
    if (search.minMileage != search.mileageMinLimit ||
        search.maxMileage != search.mileageMaxLimit) {
      count++;
    }
    if (search.minPrice != search.priceMinLimit ||
        search.maxPrice != search.priceMaxLimit) {
      count++;
    }
    if (search.selectedGearTypes.isNotEmpty) count++;
    if (search.selectedFuelTypeId != null) count++;
    if (search.selectedFeaturesCount() > 0) count++;
    return count;
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(count % 1000 == 0 ? 0 : 1)}K';
    return '$count';
  }

  Widget _dealerEmptyState(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            l.noDealersFound,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            l.tryDifferentSearch,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

}

// ─── Dealer Search Skeleton ───────────────────────────────────────────────────

class _DealerSearchSkeleton extends StatelessWidget {
  const _DealerSearchSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEAEAEA)),
        itemBuilder: (_, __) => ListTile(
          leading: const SkeletonBox(height: 44, width: 44, borderRadius: 22),
          title: const SkeletonBox(height: 14, width: double.infinity),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: const SkeletonBox(height: 12, width: 100),
          ),
        ),
      ),
    );
  }
}
