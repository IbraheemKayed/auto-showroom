import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/theme/app_text_styles.dart';
import 'package:sayarti/ai_search/providers/cars_provider.dart';
import 'package:sayarti/ai_search/providers/cities_provider.dart';
import 'package:sayarti/home/models/brand_model.dart';
import 'package:sayarti/home/models/recent_search.dart';
import 'package:sayarti/home/providers/recent_searches_provider.dart';
import 'package:sayarti/search/models/car_color.dart';
import 'package:sayarti/search/providers/color_provider.dart';
import 'package:sayarti/search/providers/search_cars_provider.dart';
import 'package:sayarti/search/screens/search_results_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class RecentSearchesSection extends StatefulWidget {
  const RecentSearchesSection({super.key});

  @override
  State<RecentSearchesSection> createState() => _RecentSearchesSectionState();
}

class _RecentSearchesSectionState extends State<RecentSearchesSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RecentSearchesProvider>().load();
      context.read<CarColorsProvider>().load();
    });
  }

  String _getBrandName(int? brandId, List<BrandModel> brands, AppLocalizations l10n) {
    if (brandId == null) return l10n.allCars;
    try {
      return brands.firstWhere((b) => b.id == brandId).name;
    } catch (_) {
      return l10n.car;
    }
  }

  String _buildSummary(
    RecentSearch item,
    CitiesProvider citiesProvider,
    List<CarColor> outsideColors,
    AppLocalizations l10n,
  ) {
    final parts = <String>[];

    // City
    if (item.cityIds.isNotEmpty) {
      final city = citiesProvider.getCityById(item.cityIds.first);
      if (city != null) {
        parts.add(l10n.localeName == 'ar' ? city.nameAr : city.nameEn);
      }
    }

    // Outside color
    if (item.outsideColorIds.isNotEmpty) {
      try {
        final color = outsideColors.firstWhere(
          (c) => c.id == item.outsideColorIds.first,
        );
        parts.add(color.name);
      } catch (_) {}
    }

    // Price
    if (item.minPrice != null || item.maxPrice != null) {
      final min = item.minPrice?.toInt() ?? 0;
      final max = item.maxPrice?.toInt() ?? 0;
      parts.add('₪$min–₪$max');
    } else {
      parts.add(l10n.anyPrice);
    }

    return parts.join(' · ');
  }

  void _runSearch(BuildContext context, RecentSearch item) {
    context.read<SearchCarsProvider>().searchWithRawParams(item.metaData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SearchResultsScreen2(fromHistory: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<RecentSearchesProvider>();
    final carsProvider = context.watch<CarsProvider>();
    final cities = context.watch<CitiesProvider>();
    final colors = context.watch<CarColorsProvider>();

    if (provider.searches.isEmpty) return const SizedBox.shrink();

    if (provider.loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: SkeletonBox(height: 20, width: 140),
          ),
          SizedBox(
            height: 88,
            child: SkeletonShimmer(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => Container(
                  width: 197,
                  padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E5E5), width: 0.76),
                    borderRadius: BorderRadius.circular(9.08),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(height: 12, width: 80),
                      SizedBox(height: 6),
                      SkeletonBox(height: 10, width: 140),
                      Spacer(),
                      SkeletonBox(height: 20, width: 44, borderRadius: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
          child: Text(
            l10n.recentSearches,
            style: AppTextStyles.medium.copyWith(
              fontSize: 20,
              height: 1.0,
              color: const Color(0xFF1F1F1F),
            ),
          ),
        ),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.searches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final item = provider.searches[i];
              final brandName = _getBrandName(item.carBrandId, carsProvider.brands, l10n);
              final filterSummary = _buildSummary(item, cities, colors.outsideColors, l10n);
              return _SearchCard(
                brandName: brandName,
                filterSummary: filterSummary,
                filterCount: item.activeFilterCount,
                onSearch: () => _runSearch(context, item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  final String brandName;
  final String filterSummary;
  final int filterCount;
  final VoidCallback onSearch;

  const _SearchCard({
    required this.brandName,
    required this.filterSummary,
    required this.filterCount,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 197,
      height: 88,
      padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.76),
        borderRadius: BorderRadius.circular(9.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            brandName,
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 12.33,
              height: 1.0,
              color: const Color(0xFF121212),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 7),
          Text(
            filterSummary,
            style: AppTextStyles.regular.copyWith(
              fontSize: 9.64,
              height: 11.69 / 9.64,
              color: const Color(0xFF2B2B2B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (filterCount > 0) ...[
            const SizedBox(height: 1),
            Text(
              '$filterCount ${filterCount > 1 ? AppLocalizations.of(context)!.filtersSelected : AppLocalizations.of(context)!.filterSelected}',
              style: AppTextStyles.regular.copyWith(
                fontSize: 9.64,
                height: 11.69 / 9.64,
                color: const Color(0xFF2B2B2B),
              ),
            ),
          ],
          const Spacer(),
          GestureDetector(
            onTap: onSearch,
            child: Container(
              width: 44,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFFEFFFE),
                border: Border.all(color: const Color(0xFF272727), width: 1.01),
                borderRadius: BorderRadius.circular(9.58),
              ),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.search,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 9.41,
                  height: 1.0,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
