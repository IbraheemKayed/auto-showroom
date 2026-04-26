import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/search/providers/search_cars_provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/home/widgets/car_vertical_item.dart';

class SearchResultsScreen2 extends StatefulWidget {
  final bool fromHistory;

  const SearchResultsScreen2({super.key, this.fromHistory = false});

  @override
  State<SearchResultsScreen2> createState() => _SearchResultsScreen2State();
}

class _SearchResultsScreen2State extends State<SearchResultsScreen2> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.fromHistory) {
        context.read<SearchCarsProvider>().searchCars(reset: true);
      }
    });

    _scrollController.addListener(() {
      final provider = context.read<SearchCarsProvider>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.loading &&
          provider.hasNext) {
        provider.searchCars();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilterSheet(BuildContext context) {
    final provider = context.read<SearchCarsProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SearchSortSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<SearchCarsProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l.results,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.5,
            color: Color(0xFF151E1B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () => _showFilterSheet(context),
              icon: const Icon(Icons.tune, color: Colors.black),
            ),
          ),
        ],
      ),
      body: provider.cars.isEmpty && provider.loading
          ? const _SearchResultsSkeleton()
          : RefreshIndicator(
              color: const Color(0xFF0066EE),
              onRefresh: () => provider.searchCars(reset: true),
              child: provider.cars.isEmpty
                  ? CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.car_rental, size: 56, color: Colors.black26),
                                const SizedBox(height: 16),
                                Text(l.noCarsFound, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Text(l.tryAdjustingFilters, style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.zero,
                      itemCount: provider.cars.length + (provider.hasNext ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.cars.length) {
                          return provider.loading
                              ? SkeletonShimmer(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    color: const Color(0xFFFEFEFE),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SkeletonBox(height: 200, width: double.infinity, borderRadius: 0),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SkeletonBox(height: 20, width: 140),
                                              SizedBox(height: 8),
                                              SkeletonBox(height: 16, width: 200),
                                              SizedBox(height: 6),
                                              SkeletonBox(height: 13, width: 160),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                        final car = provider.cars[index];
                        return _CarCard(car: car);
                      },
                    ),
            ),
    );
  }
}

class _CarCard extends StatelessWidget {
  final CarFull car;

  const _CarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    return CarVerticalItem(
      car: car,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CarDetailsProvider(
              context.read<CarApiService>(),
            )..preload(car),
            child: CarDetailsScreen(carId: car.id),
          ),
        ),
      ),
      onFavoriteTap: () =>
          context.read<SearchCarsProvider>().toggleFavorite(car),
    );
  }
}

// ─── Search Results Skeleton ──────────────────────────────────────────────────

class _SearchResultsSkeleton extends StatelessWidget {
  const _SearchResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          color: const Color(0xFFFEFEFE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBox(height: 200, width: double.infinity, borderRadius: 0),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 20, width: 140),
                    SizedBox(height: 8),
                    SkeletonBox(height: 16, width: 200),
                    SizedBox(height: 6),
                    SkeletonBox(height: 13, width: 160),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sort / Filter Sheet ──────────────────────────────────────────────────────

class _SearchSortSheet extends StatefulWidget {
  final SearchCarsProvider provider;
  const _SearchSortSheet({required this.provider});

  @override
  State<_SearchSortSheet> createState() => _SearchSortSheetState();
}

class _SearchSortSheetState extends State<_SearchSortSheet> {
  late String _sort;
  late String _dateFilter;
  late TextEditingController _minCtrl;
  late TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _sort = widget.provider.resultSortKey;
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
    String sortBy = 'id', sortOrder = 'desc';
    switch (_sort) {
      case 'datePosted':   sortBy = 'created'; sortOrder = 'desc'; break;
      case 'priceHighLow': sortBy = 'price';   sortOrder = 'desc'; break;
      case 'priceLowHigh': sortBy = 'price';   sortOrder = 'asc';  break;
    }
    widget.provider.resultSortBy = sortBy;
    widget.provider.resultSortOrder = sortOrder;
    widget.provider.resultDateFilter = _dateFilter;
    widget.provider.resultMinPrice = double.tryParse(_minCtrl.text);
    widget.provider.resultMaxPrice = double.tryParse(_maxCtrl.text);
    widget.provider.searchCars(reset: true);
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
      ('relevance',   l.relevance),
      ('datePosted',  l.datePosted),
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
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
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
                  // ── Sort By ──
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

                  // ── By date ──
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

                  // ── By amount ──
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
