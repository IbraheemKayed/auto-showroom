import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    // ✅ حمّل المدن أول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().loadCities();
    });

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.locationFilter,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.multiSelect,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: search.isLoadingCities
          ? SkeletonShimmer(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEAEAEA)),
                itemBuilder: (_, __) => const ListTile(
                  title: SkeletonBox(height: 14, width: double.infinity, borderRadius: 4),
                ),
              ),
            )
          : ListView.separated(
              itemCount: search.cities.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color(0xFFEDEDED),
              ),
              itemBuilder: (_, i) {
                final city = search.cities[i];
                final selected =
                    search.selectedCityIds.contains(city.id);

                final isAr = AppLocalizations.of(context)!.localeName == 'ar';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(
                    isAr ? city.nameAr : city.nameEn,
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: selected
                      ? const Icon(Icons.check, color: Colors.black)
                      : const SizedBox(),
                  onTap: () => search.toggleCity(city.id),
                );
              },
            ),

      bottomNavigationBar: _bottomBar(
        context,
        onClear: search.clearCities,
        selectedCount: search.selectedCityIds.length,
      ),
    );
  }
}

Widget _bottomBar(
  BuildContext context, {
  required VoidCallback onClear,
  required int selectedCount,
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onClear,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black54,
              elevation: 0,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.clearFilter),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: selectedCount > 0 ? () => Navigator.pop(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedCount > 0
                  ? const Color(0xFF0066EE)
                  : Colors.grey.shade300,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.update,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selectedCount > 0 ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
