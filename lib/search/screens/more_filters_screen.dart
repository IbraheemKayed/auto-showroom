import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/l10n/car_translations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class MoreFiltersScreen extends StatelessWidget {
  const MoreFiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final search = context.watch<SearchProvider>();
    final entries = search.features.entries.toList();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: const BackButton(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.moreFilters,
              style: const TextStyle(
                fontSize: 18.43,
                fontWeight: FontWeight.w500,
                color: Color(0xFF131313),
                height: 1.0,
              ),
            ),
            Text(
              l.multiSelect,
              style: const TextStyle(
                fontSize: 12.1,
                fontWeight: FontWeight.w400,
                color: Color(0xFF5E5F5F),
                height: 1.0,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(
            height: 1,
            thickness: 0.8,
            color: Color(0xFFE8E8E8),
          ),
        ),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final selected = entry.value;

          return Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                CarTranslations.getFeatureLabel(entry.key, l),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1B1B1B),
                  height: 1.4,
                ),
              ),
              trailing: selected
                  ? const Icon(Icons.check, color: Colors.black)
                  : const SizedBox(width: 24),
              onTap: () => search.toggleFeature(entry.key),
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
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
                onPressed: search.clearFeatures,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black54,
                  elevation: 0,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(l.clearFilter),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '${l.update} (${search.selectedFeaturesCount()})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
