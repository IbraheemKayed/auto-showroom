import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/dealer/providers/dealer_listings_provider.dart';
import 'package:sayarti/dealer/screens/add_post_step1.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/providers/car_details_provider.dart';
import 'package:sayarti/home/screens/car_details_screen.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class DealerListingsScreen extends StatefulWidget {
  final int showroomId;

  const DealerListingsScreen({
    super.key,
    required this.showroomId,
  });

  @override
  State<DealerListingsScreen> createState() => _DealerListingsScreenState();
}

class _DealerListingsScreenState extends State<DealerListingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DealerListingsProvider>().fetch(widget.showroomId);
    });
  }

  @override
  void didUpdateWidget(DealerListingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showroomId != widget.showroomId) {
      final provider = context.read<DealerListingsProvider>();
      final newId = widget.showroomId;
      Future.microtask(() => provider.fetch(newId));
    }
  }

  @override
  void dispose() {
    context.read<DealerListingsProvider>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () async {
          final provider = context.read<DealerListingsProvider>();
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPostStep1()),
          );
          if (mounted) {
            provider.fetch(widget.showroomId);
          }
        },
        backgroundColor: const Color(0xFF0066EE),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l.addPost, style: const TextStyle(color: Colors.white)),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(
                    l.yourListings,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Consumer<DealerListingsProvider>(
                    builder: (_, p, __) {
                      final active = p.sortOption != DealerSortOption.relevance || p.dateFilter != 'anytime' || p.minPrice != null || p.maxPrice != null;
                      final color = active
                          ? const Color(0xFF0066EE)
                          : const Color(0xFF1B1B1B);
                      return GestureDetector(
                        onTap: p.items.isEmpty ? null : () => _showSortSheet(p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFFE8F0FE)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? const Color(0xFF0066EE)
                                  : const Color(0xFFE6E6E6),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sort, size: 16, color: color),
                              const SizedBox(width: 4),
                              Text(
                                l.sortBy,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ================= LIST =================
            Expanded(
              child: Consumer<DealerListingsProvider>(
                builder: (context, provider, _) {
                  // loading
                  if (provider.loading) {
                    return const _DealerListingsSkeleton();
                  }

                  // error
                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            l.failedToLoadListings,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () =>
                                provider.fetch(widget.showroomId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066EE),
                            ),
                            child: Text(l.retry,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }

                  // empty
                  if (provider.items.isEmpty) {
                    return RefreshIndicator(
                      color: const Color(0xFF0066EE),
                      onRefresh: () => provider.fetch(widget.showroomId),
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            child: Center(child: Text(l.noListingsYet)),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: const Color(0xFF0066EE),
                    onRefresh: () => provider.fetch(widget.showroomId),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: provider.items.length,
                      itemBuilder: (_, index) {
                        final item = provider.items[index];
                        return _listingCard(item: item);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // LISTING CARD
  // =====================================================

  Widget _listingCard({required DealerCarItem item}) {
    final car = item.car;

    final image = car.coverImage;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => CarDetailsProvider(context.read<CarApiService>())
                ..preload(car)
                ..loadCar(car.id),
              child: CarDetailsScreen(carId: car.id, isOwner: true),
            ),
          ),
        );
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= IMAGE =================
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: image != null
                    ? CachedNetworkImage(
                        imageUrl: image,
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),

              // STATUS BADGE
              Positioned(
                top: 12,
                left: 12,
                child: _statusBadge(item.status),
              ),

            ],
          ),

          // ================= INFO =================
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${car.year} ${car.brandName} ${car.modelName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '₪${NumberFormat('#,###').format(car.price.toInt())}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0066EE),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _showSortSheet(DealerListingsProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _DealerSortSheet(provider: provider),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 260,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.directions_car, size: 48, color: Colors.grey),
      ),
    );
  }

  // =====================================================
  // STATUS BADGE
  // =====================================================

  Widget _statusBadge(String status) {
    final l = AppLocalizations.of(context)!;
    final isRejected = status == 'REJECTED';
    final isPending  = status == 'PENDING';

    final Color borderColor;
    final Widget icon;
    final String label;

    if (isRejected) {
      borderColor = const Color(0xFFDB3333);
      label = l.rejected;
      icon = const Icon(Icons.cancel_outlined, size: 16, color: Color(0xFFDB3333));
    } else if (isPending) {
      borderColor = Colors.grey.shade300;
      label = l.awaitingApproval;
      icon = SvgPicture.asset('assets/images/awaiting_approval.svg', width: 16, height: 16);
    } else {
      borderColor = Colors.grey.shade300;
      label = l.listed;
      icon = SvgPicture.asset('assets/images/listed.svg', width: 16, height: 16);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isRejected ? const Color(0xFFDB3333) : const Color(0xFF1B1B1B),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dealer Listings Skeleton ─────────────────────────────────────────────────

class _DealerListingsSkeleton extends StatelessWidget {
  const _DealerListingsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBox(height: 180, width: double.infinity, borderRadius: 16),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 18, width: 180),
                    SizedBox(height: 8),
                    SkeletonBox(height: 14, width: 240),
                    SizedBox(height: 6),
                    SkeletonBox(height: 12, width: 120),
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

// ─── Dealer Sort Sheet ────────────────────────────────────────────────────────

class _DealerSortSheet extends StatefulWidget {
  final DealerListingsProvider provider;
  const _DealerSortSheet({required this.provider});

  @override
  State<_DealerSortSheet> createState() => _DealerSortSheetState();
}

class _DealerSortSheetState extends State<_DealerSortSheet> {
  late DealerSortOption _sortBy;
  late String _dateFilter;
  late TextEditingController _minCtrl;
  late TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _sortBy = widget.provider.sortOption;
    _dateFilter = widget.provider.dateFilter;
    _minCtrl = TextEditingController(
      text: widget.provider.minPrice?.toInt().toString() ?? '',
    );
    _maxCtrl = TextEditingController(
      text: widget.provider.maxPrice?.toInt().toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    widget.provider.applyFilters(
      sort: _sortBy,
      date: _dateFilter,
      min: double.tryParse(_minCtrl.text),
      max: double.tryParse(_maxCtrl.text),
    );
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      _sortBy = DealerSortOption.relevance;
      _dateFilter = 'anytime';
      _minCtrl.clear();
      _maxCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final sortOptions = [
      (DealerSortOption.relevance,   l.relevance),
      (DealerSortOption.datePosted,  l.datePosted),
      (DealerSortOption.priceHighLow, l.priceHighToLow),
      (DealerSortOption.priceLowHigh, l.priceLowToHigh),
    ];

    final dateOptions = [
      ('anytime', l.anytime),
      ('week',    l.thisWeek),
      ('30d',     l.past30Days),
      ('90d',     l.past90Days),
      ('6m',      l.past6Months),
      ('year',    l.pastYear),
      ('range',   l.byDateRange),
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
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
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
                  // ── Sort By ──
                  Text(l.sortByTitle,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...sortOptions.map((o) => _optionTile(o.$2, isSelected: _sortBy == o.$1,
                      onTap: () => setState(() => _sortBy = o.$1))),

                  const SizedBox(height: 24),

                  // ── By date ──
                  Text(l.sortByDate,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...dateOptions.map((o) => _optionTile(o.$2, isSelected: _dateFilter == o.$1,
                      onTap: () => setState(() => _dateFilter = o.$1))),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // ── By amount ──
                  Text(l.sortByAmount,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _amountField(_minCtrl, l.amount)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(l.toConnector,
                            style: const TextStyle(color: Colors.black54)),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(l.clearFilter,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600)),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        l.apply,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
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
    );
  }

  Widget _optionTile(String label, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066EE) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? const Color(0xFF0066EE) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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
        hintStyle: const TextStyle(color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0066EE)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
