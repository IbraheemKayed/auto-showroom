// car_type_preference_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/screens/brand_origin_preference_screen.dart';
import 'package:sayarti/ai_search/widgets/preference_widgets.dart.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import '../providers/preferences_provider.dart';

class CarTypePreferenceScreen extends StatefulWidget {
  const CarTypePreferenceScreen({super.key});

  @override
  State<CarTypePreferenceScreen> createState() =>
      _CarTypePreferenceScreenState();
}

class _CarTypePreferenceScreenState extends State<CarTypePreferenceScreen> {
  bool _imagesReady = false;
  bool _precacheStarted = false;

  static const Map<String, String> _arNames = {
    'suv':       'جيب',
    'hatchback': 'هاتشباك',
    'coupe':     'كوبيه',
    'sedan':     'سيدان',
    'cabriolet': 'كشف',
  };


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferencesProvider>().loadCategories();
    });
  }

  void _precacheImages(List categories) async {
    await Future.wait(
      categories.map((cat) => precacheImage(
        CachedNetworkImageProvider(cat.imagePath),
        context,
      )),
    );
    if (mounted) setState(() => _imagesReady = true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<PreferencesProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        titleSpacing: 24,
        title: Text(
          l.preference,
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 17.78,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF999899)),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainLayout()), (route) => false),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: PreferenceProgressBar(currentStep: 1),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFFF1F3F2)),
          const SizedBox(height: 20),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.whichCarType,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.multiSelect,
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: 13.33,
                    height: 1.0,
                    color: Color(0xFF545655),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // List
          Expanded(
            child: () {
              if (provider.isLoadingCategories) return const PreferenceListSkeleton();
              if (provider.categoriesError != null) return Center(child: Text(provider.categoriesError!));
              // Trigger image precaching once data arrives
              if (!_precacheStarted && provider.categories.isNotEmpty) {
                _precacheStarted = true;
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _precacheImages(provider.categories),
                );
              }
              if (!_imagesReady) return const PreferenceListSkeleton();
              return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final cat = provider.categories[index];
                          final selected =
                              provider.selectedCategoryIds.contains(cat.id);

                          final isAr = l.localeName == 'ar';
                          final code = cat.code.toLowerCase();
                          final displayName = isAr
                              ? (_arNames[code] ?? cat.name)
                              : cat.name;

                          return PreferenceOptionCard(
                            leading: SizedBox(
                              height: 40,
                              width: 40,
                              child: CachedNetworkImage(
                                imageUrl: cat.imagePath,
                                fit: BoxFit.contain,
                                errorWidget: (_, __, ___) => const Icon(
                                  Icons.directions_car_outlined,
                                  size: 32,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            title: displayName,
                            isSelected: selected,
                            onTap: () => provider.toggleCategory(cat.id),
                            trailing: selected
                                ? const Icon(Icons.check, color: Colors.blue)
                                : null,
                          );
                        },
                      );
            }(),
          ),

          BottomNavButtons(
            onBack: () => Navigator.pop(context),
            onNext: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CarBrandOriginScreen(),
                ),
              );
            },
            nextEnabled: provider.selectedCategoryIds.isNotEmpty,
          ),
        ],
      ),
    );
  }
}
