// brand_origin_preference_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:svg_flutter/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/screens/fuel_type_preference_screen.dart';
import 'package:sayarti/ai_search/widgets/preference_widgets.dart.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import '../providers/preferences_provider.dart';


class CarBrandOriginScreen extends StatefulWidget {
  const CarBrandOriginScreen({super.key});

  @override
  State<CarBrandOriginScreen> createState() => _CarBrandOriginScreenState();
}

class _CarBrandOriginScreenState extends State<CarBrandOriginScreen> {
  bool _imagesReady = false;
  bool _precacheStarted = false;

  static const Map<String, String> _arCountryNames = {
    'DE': 'المانيا',
    'KR': 'كوريا',
    'US': 'اميركا',
    'JP': 'اليابان',
    'FR': 'فرنسا',
  };

  static const Map<String, String> _enCountryNames = {
    'DE': 'Germany',
    'KR': 'South Korea',
    'US': 'USA',
    'JP': 'Japan',
    'FR': 'France',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferencesProvider>().loadBrandCountries();
    });
  }

  void _precacheImages(List countries) async {
    await Future.wait(
      countries.map((c) => precacheImage(
        CachedNetworkImageProvider(c.imagePath),
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
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainLayout()), (route) => false),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: PreferenceProgressBar(currentStep: 2),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFFF1F3F2)),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.whichBrandOrigin,
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

          Expanded(
            child: () {
              if (provider.isLoadingCountries) return const PreferenceListSkeleton();
              if (provider.countriesError != null) return Center(child: Text(provider.countriesError!));
              // Trigger image precaching once data arrives
              if (!_precacheStarted && provider.countries.isNotEmpty) {
                _precacheStarted = true;
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _precacheImages(provider.countries),
                );
              }
              if (!_imagesReady) return const PreferenceListSkeleton();
              final visibleCountries = provider.countries
                  .where((c) => c.code != 'IT' && c.code != 'UK')
                  .toList();
              return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: visibleCountries.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final isSelected = provider.noCountryPreference;
                            return PreferenceOptionCard(
                              leading: SvgPicture.asset(
                                'assets/images/icon.svg',
                                width: 40,
                                height: 40,
                              ),
                              title: l.noPreference,
                              isSelected: isSelected,
                              onTap: () => provider.selectNoCountryPreference(),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Colors.blue)
                                  : null,
                            );
                          }

                          final country = visibleCountries[index - 1];
                          final isSelected = provider.selectedCountryIds
                              .contains(country.id);
                          final isAr = l.localeName == 'ar';
                          final countryName = isAr
                              ? (_arCountryNames[country.code] ?? country.name)
                              : (_enCountryNames[country.code] ?? country.name);

                          return PreferenceOptionCard(
                            leading: SizedBox(
                              width: 48,
                              height: 34,
                              child: CachedNetworkImage(
                                imageUrl: country.imagePath,
                                fit: BoxFit.contain,
                                errorWidget: (_, __, ___) => const Icon(
                                  Icons.flag_outlined,
                                  size: 28,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            title: countryName,
                            isSelected: isSelected,
                            onTap: () =>
                                provider.toggleCountry(country.id),
                            trailing: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.blue)
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
                  builder: (_) => const FuelTypePreferenceScreen(),
                ),
              );
            },
            nextEnabled: provider.selectedCountryIds.isNotEmpty ||
                provider.noCountryPreference,
          ),
        ],
      ),
    );
  }
}
