import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/search/providers/color_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class ExteriorColorScreen extends StatelessWidget {
  const ExteriorColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<CarColorsProvider>();
    final search = context.watch<SearchProvider>();

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
              AppLocalizations.of(context)!.exteriorColor,
              style: const TextStyle(
                fontSize: 18.43,
                fontWeight: FontWeight.w500,
                color: Color(0xFF131313),
                height: 1.0,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.multiSelect,
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
      body: colors.loading
          ? SkeletonShimmer(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE5E5EA)),
                itemBuilder: (_, __) => ListTile(
                  leading: const SkeletonBox(height: 28, width: 28, borderRadius: 14),
                  title: const SkeletonBox(height: 14, width: double.infinity, borderRadius: 4),
                ),
              ),
            )
          : ListView.separated(
              itemCount: colors.outsideColors.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 0.8,
                color: Color(0xFFE8E8E8),
                endIndent: 15,
                indent: 15,
              ),
              itemBuilder: (_, i) {
                final color = colors.outsideColors[i];
                final selected =
                    search.selectedOutsideColorIds.contains(color.id);

                return ListTile(
                  leading: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _mapColor(color.code),
                      border: Border.all(
                        color: const Color(0xFFE8E8E8),
                        width: 0.8,
                      ),
                    ),
                  ),
                  title: Text(
                    _translateColor(color.name, AppLocalizations.of(context)!.localeName == 'ar'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1B1B1B),
                      height: 1.4,
                    ),
                  ),
                  trailing: selected
                      ? const Icon(Icons.check)
                      : const SizedBox(width: 24),
                  onTap: () => search.toggleOutsideColor(color.id),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: search.selectedOutsideColorIds.isNotEmpty
                    ? search.clearColors
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black54,
                  elevation: 0,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.clearFilter),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  elevation: 0,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.update,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
Widget _bottomBar(BuildContext context, {required VoidCallback onClear}) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onClear,
            child: const Text('Clear'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Update'),
          ),
        ),
      ],
    ),
  );
}
const Map<String, String> _arColorNames = {
  'white': 'أبيض', 'black': 'أسود', 'silver': 'فضي',
  'gray': 'رمادي', 'grey': 'رمادي', 'red': 'أحمر',
  'blue': 'أزرق', 'green': 'أخضر', 'brown': 'بني',
  'beige': 'بيج', 'yellow': 'أصفر', 'orange': 'برتقالي',
  'gold': 'ذهبي', 'purple': 'بنفسجي', 'pink': 'وردي',
  'maroon': 'عنابي', 'navy': 'كحلي', 'cream': 'كريمي',
  'burgundy': 'خمري', 'charcoal': 'فحمي', 'bronze': 'برونزي',
  'champagne': 'شامبانيا', 'titanium': 'تيتانيوم', 'pearl': 'لؤلؤي',
  'dark gray': 'رمادي داكن', 'dark grey': 'رمادي داكن',
  'light gray': 'رمادي فاتح', 'light grey': 'رمادي فاتح',
  'off white': 'أبيض مكسور', 'dark blue': 'أزرق داكن',
  'light blue': 'أزرق فاتح', 'dark green': 'أخضر داكن',
  'dark brown': 'بني غامق', 'white leather': 'جلد أبيض',
  'red leather': 'جلد أحمر', 'black alcantara': 'الكانتارا أسود',
  'grey alcantara': 'الكانتارا رمادي', 'gray alcantara': 'الكانتارا رمادي',
};

String _translateColor(String name, bool isAr) {
  if (!isAr) return name;
  return _arColorNames[name.toLowerCase()] ?? name;
}

Color _mapColor(String code) {
  try {
    final hex = code.trim().replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  } catch (_) {
    return Colors.grey.shade300;
  }
}
