import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/screens/price_range_screen.dart';
import 'package:sayarti/ai_search/widgets/preference_widgets.dart.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import '../providers/preferences_provider.dart';

class FuelTypePreferenceScreen extends StatefulWidget {
  const FuelTypePreferenceScreen({super.key});

  @override
  State<FuelTypePreferenceScreen> createState() =>
      _FuelTypePreferenceScreenState();
}

class _FuelTypePreferenceScreenState extends State<FuelTypePreferenceScreen> {
  static const Map<String, String> _arNames = {
    'PETROL':        'بنزين',
    'DIESEL':        'ديزل',
    'HYBRID':        'هايبرد',
    'ELECTRIC':      'كهربائي',
    'PLUG_IN_HYBRID': 'هايبرد قابل للشحن',
  };


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferencesProvider>().loadFuelTypes();
    });
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
            child: PreferenceProgressBar(currentStep: 3),
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
                  l.whatFuelType,
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

          // ========== LOADING ==========
          if (provider.isLoadingFuelTypes)
            const Expanded(child: PreferenceListSkeleton()),

          // ========== ERROR ==========
          if (!provider.isLoadingFuelTypes && provider.fuelError != null)
            Expanded(
              child: Center(
                child: Text(
                  provider.fuelError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),

          // ========== CONTENT ==========
          if (!provider.isLoadingFuelTypes && provider.fuelError == null)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: provider.fuelTypes.map((fuel) {
                  final isSelected =
                      provider.selectedFuelIds.contains(fuel.id);
                  final isAr = l.localeName == 'ar';
                  final displayName = isAr
                      ? (_arNames[fuel.code] ?? fuel.name)
                      : fuel.name;
                  return PreferenceOptionCard(
                    title: displayName,
                    isSelected: isSelected,
                    onTap: () => provider.toggleFuel(fuel.id),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                  );
                }).toList(),
              ),
            ),

          BottomNavButtons(
            onBack: () => Navigator.pop(context),
            onNext: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PriceRangeScreen()),
              );
            },
            nextEnabled: provider.selectedFuelIds.isNotEmpty,
          ),
        ],
      ),
    );
  }
}
