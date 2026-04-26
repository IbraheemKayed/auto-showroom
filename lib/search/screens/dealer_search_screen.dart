import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/search/providers/dealer_search_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class DealerSearchScreen extends StatelessWidget {
  const DealerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dealer = context.watch<DealerSearchProvider>();

    return Column(
      children: [
        // 🔍 Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: AppLocalizations.of(context)!.searchDealers,
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
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF0066EE)))
              : dealer.showrooms.isEmpty
                  ? _emptyState(context)
                  : _buildList(dealer, context),
        ),
      ],
    );
  }

  Widget _buildList(DealerSearchProvider dealer, BuildContext context) {
    // Deduplicate by description
    final seen = <String>{};
    final unique = dealer.showrooms
        .where((s) => seen.add(s.description.trim().toUpperCase()))
        .toList();

    return ListView.builder(
      itemCount: unique.length + (dealer.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == unique.length) {
          dealer.search();
          return const Padding(
            padding: EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator(color: Color(0xFF0066EE))),
          );
        }

        final showroom = unique[index];
        final l10n = AppLocalizations.of(context)!;
        final cityName = showroom.city == null ? '' : (l10n.localeName == 'ar' ? showroom.city!.nameAr : showroom.city!.nameEn);

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
            l10n.localeName == 'ar' ? (showroom.descriptionAr ?? showroom.description) : showroom.description,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: cityName.isNotEmpty ? Text(cityName) : null,
        );
      },
    );
  }

  Widget _emptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            l10n.noDealersFound,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.tryDifferentSearch,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
