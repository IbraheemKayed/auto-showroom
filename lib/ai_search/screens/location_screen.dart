import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/models/city.dart';
import 'package:sayarti/ai_search/screens/searching_screen.dart';
import 'package:sayarti/ai_search/widgets/preference_widgets.dart.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import '../providers/preferences_provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferencesProvider>().loadCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PreferencesProvider>();
    final l = AppLocalizations.of(context)!;

    // Filter out unwanted cities
    const blockedEn = {
      'gaza', 'rafah', 'khan yunis', 'khan younis', 'deir al-balah',
      'deir el-balah', 'deir al balah', 'jabalia', 'jabaliya',
      'beit lahia', 'beit lahiya', 'beit hanoun',
      'haifa', 'acre', 'akka', 'jaffa', 'yafo', 'nazareth', 'safad',
      'tzfat', 'safed',
    };
    const blockedAr = {
      'غزة', 'رفح', 'خان يونس', 'دير البلح', 'جباليا', 'بيت لاهيا', 'بيت حانون',
      'حيفا', 'عكا', 'يافا', 'الناصرة', 'صفد',
    };
    final cities = provider.cities.where((c) {
      final en = c.nameEn.toLowerCase();
      final ar = c.nameAr.trim();
      final blockedByEn = blockedEn.any((b) => en.contains(b));
      final blockedByAr = blockedAr.any((b) => ar.contains(b));
      return !blockedByEn && !blockedByAr;
    }).toList();

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
          style: TextStyle(
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
            child: PreferenceProgressBar(currentStep: 4),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFFF1F3F2)),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l.locationDescription,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
                height: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF3FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 60,
                    color: Color(0xFF0066EE),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  l.locationHelpText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black45),
                ),

                const SizedBox(height: 32),

                // ── Dropdown ──
                if (provider.isLoadingCities)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SkeletonShimmer(
                      child: SkeletonBox(
                        height: 52,
                        width: double.infinity,
                        borderRadius: 12,
                      ),
                    ),
                  )
                else if (provider.citiesError != null)
                  Text(
                    provider.citiesError!,
                    style: const TextStyle(color: Colors.red),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _CityDropdown(
                      cities: cities,
                      selectedCityId: provider.selectedCityId,
                      onSelected: (id) => provider.selectCity(id),
                    ),
                  ),
              ],
            ),
          ),

          BottomNavButtons(
            onBack: () => Navigator.pop(context),
            onNext: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchingScreen()),
              );
            },
            nextEnabled: provider.selectedCityId != null,
            //nextLabel: l.next,
          ),
        ],
      ),
    );
  }
}

// ─── Custom dropdown anchored below its container ─────────────────────────────

class _CityDropdown extends StatefulWidget {
  final List<CityModel> cities;
  final int? selectedCityId;
  final void Function(int) onSelected;

  const _CityDropdown({
    required this.cities,
    required this.selectedCityId,
    required this.onSelected,
  });

  @override
  State<_CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<_CityDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _open() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Transparent barrier to close on outside tap
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 240),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE6E6E6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.cities.length,
                      itemBuilder: (_, index) {
                        final city = widget.cities[index];
                        final isSelected = city.id == widget.selectedCityId;
                        return InkWell(
                          onTap: () {
                            widget.onSelected(city.id);
                            _close();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 13),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEEF3FF)
                                  : Colors.transparent,
                              border: index < widget.cities.length - 1
                                  ? const Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFF1F3F2), width: 1),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    city.nameEn,
                                    style: TextStyle(
                                      fontFamily: 'FunnelDisplay',
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      fontSize: 14,
                                      color: isSelected
                                          ? const Color(0xFF0066EE)
                                          : const Color(0xFF1F1F1F),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check,
                                      color: Color(0xFF0066EE), size: 18),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedCityId != null
        ? widget.cities.where((c) => c.id == widget.selectedCityId).firstOrNull
        : null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _isOpen ? _close : _open,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(22.67),
            border: Border.all(
              color: _isOpen
                  ? const Color(0xFF0066EE)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 18, color: Color(0xFF868686)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  selected?.nameEn ?? AppLocalizations.of(context)!.chooseYourCity,
                  style: TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: selected != null
                        ? const Color(0xFF1F1F1F)
                        : const Color(0xFF868686),
                  ),
                ),
              ),
              Icon(
                _isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF868686),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
