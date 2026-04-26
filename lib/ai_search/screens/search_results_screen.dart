import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/providers/preferences_provider.dart';
import 'package:sayarti/ai_search/screens/car_type_preference_screen.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/home/widgets/car_vertical_item.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<PreferencesProvider>();
    final results = provider.displayedResults;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          l.yourResults,
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.tune, color: Colors.black),
          onPressed: () {
            final p = context.read<PreferencesProvider>();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => _AiSortSheet(provider: p),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainLayout()), (route) => false),
          ),
        ],
      ),
      body: results.isEmpty && provider.searchError != null
          ? _ErrorState(
              error: provider.searchError!,
              onChangeAnswers: () => _changeAnswers(context, provider),
            )
          : results.isEmpty
          ? _EmptyState(
              onChangeAnswers: () => _changeAnswers(context, provider),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: results.length,
                    itemBuilder: (context, index) =>
                        _AiCarCard(car: results[index]),
                  ),
                ),
                _ChangeAnswersBar(
                  onTap: () => _changeAnswers(context, provider),
                ),
              ],
            ),
    );
  }

  void _changeAnswers(BuildContext context, PreferencesProvider provider) {
    provider.resetAll();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const CarTypePreferenceScreen()),
      (route) => route.isFirst,
    );
  }
}

// ─── Sticky bottom bar ────────────────────────────────────────────────────────

class _ChangeAnswersBar extends StatelessWidget {
  final VoidCallback onTap;
  const _ChangeAnswersBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066EE),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              l.changeYourAnswers,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onChangeAnswers;
  const _ErrorState({required this.error, required this.onChangeAnswers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 64, color: Colors.black26),
                const SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
              ],
            ),
          ),
        ),
        _ChangeAnswersBar(onTap: onChangeAnswers),
      ],
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onChangeAnswers;
  const _EmptyState({required this.onChangeAnswers});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off_rounded, size: 64, color: Colors.black26),
                const SizedBox(height: 16),
                Text(
                  l.noResultsFound,
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.0,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    l.noResultsFoundDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF868686),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _ChangeAnswersBar(onTap: onChangeAnswers),
      ],
    );
  }
}

// ─── Car card ─────────────────────────────────────────────────────────────────

class _AiCarCard extends StatefulWidget {
  final CarFull car;
  const _AiCarCard({required this.car});

  @override
  State<_AiCarCard> createState() => _AiCarCardState();
}

class _AiCarCardState extends State<_AiCarCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.car.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    final api = context.read<CarApiService>();
    final prev = _isFavorite;
    setState(() => _isFavorite = !_isFavorite);
    try {
      if (prev) {
        await api.removeFromFavorites(widget.car.id);
      } else {
        await api.addToFavorites(widget.car.id);
      }
    } catch (_) {
      if (mounted) setState(() => _isFavorite = prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarVerticalItem(
      car: widget.car,
      isFavoriteOverride: _isFavorite,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CarDetailsProvider(
              context.read<CarApiService>(),
            )..preload(widget.car),
            child: CarDetailsScreen(carId: widget.car.id),
          ),
        ),
      ),
      onFavoriteTap: _toggleFavorite,
    );
  }
}

// ─── AI Sort / Filter Sheet ───────────────────────────────────────────────────

class _AiSortSheet extends StatefulWidget {
  final PreferencesProvider provider;
  const _AiSortSheet({required this.provider});

  @override
  State<_AiSortSheet> createState() => _AiSortSheetState();
}

class _AiSortSheetState extends State<_AiSortSheet> {
  late String _sort;
  late String _dateFilter;
  late TextEditingController _minCtrl;
  late TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _sort = widget.provider.resultSortOption;
    _dateFilter = widget.provider.resultDateFilter;
    _minCtrl = TextEditingController(
      text: widget.provider.resultMinPrice?.toInt().toString() ?? '',
    );
    _maxCtrl = TextEditingController(
      text: widget.provider.resultMaxPrice?.toInt().toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    widget.provider.applyResultFilters(
      sort: _sort,
      date: _dateFilter,
      min: double.tryParse(_minCtrl.text),
      max: double.tryParse(_maxCtrl.text),
    );
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      _sort = 'relevance';
      _dateFilter = 'anytime';
      _minCtrl.clear();
      _maxCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final sortOptions = [
      ('relevance',    l.relevance),
      ('datePosted',   l.datePosted),
      ('priceHighLow', l.priceHighToLow),
      ('priceLowHigh', l.priceLowToHigh),
    ];

    final dateOptions = [
      ('anytime', l.anytime),
      ('week',    l.thisWeek),
      ('30d',     l.past30Days),
      ('90d',     l.past90Days),
      ('6m',      l.past6Months),
      ('year',    l.pastYear),
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
              child: Row(
                children: [
                  Text(l.filterTitle,
                      style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 17.88,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(20),
                children: [
                  Text(l.sortByTitle,
                      style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 18.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212A35))),
                  const SizedBox(height: 12),
                  ...sortOptions.map((o) => _optionTile(o.$2,
                      isSelected: _sort == o.$1,
                      onTap: () => setState(() => _sort = o.$1))),
                  const SizedBox(height: 24),
                  Text(l.sortByDate,
                      style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 18.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212A35))),
                  const SizedBox(height: 12),
                  ...dateOptions.map((o) => _optionTile(o.$2,
                      isSelected: _dateFilter == o.$1,
                      onTap: () => setState(() => _dateFilter = o.$1))),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  Text(l.sortByAmount,
                      style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 18.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212A35))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _amountField(_minCtrl, l.amount)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(l.toConnector,
                            style: const TextStyle(
                                fontFamily: 'FunnelDisplay',
                                fontSize: 16.33,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF242424))),
                      ),
                      Expanded(child: _amountField(_maxCtrl, l.amount)),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clear,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        side: const BorderSide(color: Color(0xFFE8E8E8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(l.clearFilter,
                          style: const TextStyle(
                              color: Color(0xFF142A20),
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066EE),
                        minimumSize: const Size(0, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      child: Text(
                        l.apply,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _optionTile(String label,
      {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEFEFE) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066EE) : Colors.transparent,
            width: 1.45,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'FunnelDisplay',
            fontSize: 15.24,
            color: isSelected ? const Color(0xFF353535) : const Color(0xFF7F8184),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _amountField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'FunnelDisplay',
          fontSize: 14.7,
          fontWeight: FontWeight.w400,
          color: Color(0xFF7F8184),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE6E6E6), width: 1.26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE6E6E6), width: 1.26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0066EE), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
