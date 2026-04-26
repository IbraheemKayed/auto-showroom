import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/providers/cars_filter_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/home/widgets/car_vertical_item.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class ShowroomCarsScreen extends StatelessWidget {
  final int showroomId;
  final String showroomName;

  const ShowroomCarsScreen({
    super.key,
    required this.showroomId,
    required this.showroomName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final p = CarsFilterProvider(context.read<CarApiService>());
        p.params.carShowroomId = showroomId;
        p.params.carStatuses = ['APPROVED'];
        p.load();
        return p;
      },
      // Builder gives a context that has the local CarsFilterProvider
      child: Builder(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              showroomName,
              style: const TextStyle(
                fontSize: 18.43,
                fontWeight: FontWeight.w500,
                color: Color(0xFF151E1B),
                height: 1.0,
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => _FilterSheet(
                    provider: ctx.read<CarsFilterProvider>(),
                  ),
                ),
              ),
            ],
          ),
          body: const _CarsList(),
        ),
      ),
    );
  }
}

// ─── Car list ──────────────────────────────────────────────────────────────────

class _CarsList extends StatelessWidget {
  const _CarsList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarsFilterProvider>();

    if (provider.loading && provider.cars.isEmpty) {
      return const _ShowroomCarsSkeleton();
    }

    if (provider.cars.isEmpty) {
      final l = AppLocalizations.of(context)!;
      return RefreshIndicator(
        color: const Color(0xFF0066EE),
        onRefresh: () => provider.load(reset: true),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.directions_car_outlined, size: 56, color: Colors.black26),
                    const SizedBox(height: 12),
                    Text(l.noCarsFound, style: const TextStyle(fontSize: 16, color: Colors.black45)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF0066EE),
      onRefresh: () => provider.load(reset: true),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.zero,
        itemCount: provider.cars.length,
        itemBuilder: (context, index) => _CarItem(car: provider.cars[index]),
      ),
    );
  }
}

// ─── Single car item ────────────────────────────────────────────────────────────

class _CarItem extends StatefulWidget {
  final CarFull car;
  const _CarItem({required this.car});

  @override
  State<_CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<_CarItem> {
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
            create: (_) => CarDetailsProvider(context.read<CarApiService>())
              ..preload(widget.car),
            child: CarDetailsScreen(carId: widget.car.id),
          ),
        ),
      ),
      onFavoriteTap: _toggleFavorite,
    );
  }
}

// ─── Filter bottom sheet ───────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final CarsFilterProvider provider;
  const _FilterSheet({required this.provider});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _sortBy;
  late String _sortOrder;
  String _dateFilter = 'anytime';
  late TextEditingController _minCtrl;
  late TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _sortBy = widget.provider.params.sortBy;
    _sortOrder = widget.provider.params.sortOrder;
    _minCtrl = TextEditingController(
      text: widget.provider.params.minPrice?.toInt().toString() ?? '',
    );
    _maxCtrl = TextEditingController(
      text: widget.provider.params.maxPrice?.toInt().toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    widget.provider.params.sortBy = _sortBy;
    widget.provider.params.sortOrder = _sortOrder;
    widget.provider.params.minPrice = double.tryParse(_minCtrl.text);
    widget.provider.params.maxPrice = double.tryParse(_maxCtrl.text);
    widget.provider.load(reset: true);
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      _sortBy = 'id';
      _sortOrder = 'desc';
      _dateFilter = 'anytime';
      _minCtrl.clear();
      _maxCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
                  Text(
                    l.filterTitle,
                    style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontSize: 17.88,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
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
                  _sortTile(l.relevance, 'id', 'desc'),
                  _sortTile(l.datePosted, 'created', 'desc'),
                  _sortTile(l.priceHighToLow, 'price', 'desc'),
                  _sortTile(l.priceLowToHigh, 'price', 'asc'),

                  const SizedBox(height: 24),
                  Text(l.sortByDate,
                      style: const TextStyle(
                          fontFamily: 'FunnelDisplay',
                          fontSize: 18.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212A35))),
                  const SizedBox(height: 12),
                  _dateTile(l.anytime, 'anytime'),
                  _dateTile(l.thisWeek, 'week'),
                  _dateTile(l.past30Days, '30d'),
                  _dateTile(l.past90Days, '90d'),
                  _dateTile(l.past6Months, '6m'),
                  _dateTile(l.pastYear, 'year'),
                  _dateTile(l.byDateRange, 'range'),

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
                        widget.provider.totalCount > 0
                            ? '${l.apply} (${widget.provider.totalCount})'
                            : l.apply,
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

  Widget _sortTile(String label, String sortBy, String sortOrder) {
    final selected = _sortBy == sortBy && _sortOrder == sortOrder;
    return GestureDetector(
      onTap: () => setState(() {
        _sortBy = sortBy;
        _sortOrder = sortOrder;
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFEFEFE) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF0066EE) : Colors.transparent,
            width: 1.45,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'FunnelDisplay',
            fontSize: 15.24,
            color: selected ? const Color(0xFF353535) : const Color(0xFF7F8184),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _dateTile(String label, String key) {
    final selected = _dateFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _dateFilter = key),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFEFEFE) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF0066EE) : Colors.transparent,
            width: 1.45,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'FunnelDisplay',
            fontSize: 15.24,
            color: selected ? const Color(0xFF353535) : const Color(0xFF7F8184),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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

// ─── Showroom Cars Skeleton ───────────────────────────────────────────────────

class _ShowroomCarsSkeleton extends StatelessWidget {
  const _ShowroomCarsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonBox(height: 180, width: double.infinity, borderRadius: 16),
            SizedBox(height: 10),
            SkeletonBox(height: 18, width: 160),
            SizedBox(height: 6),
            SkeletonBox(height: 14, width: 220),
            SizedBox(height: 6),
            SkeletonBox(height: 12, width: 130),
          ],
        ),
      ),
    );
  }
}
