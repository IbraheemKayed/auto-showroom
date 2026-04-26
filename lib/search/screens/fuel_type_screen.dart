import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/models/fuel_type.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class FuelTypeScreen extends StatefulWidget {
  const FuelTypeScreen({super.key});

  @override
  State<FuelTypeScreen> createState() => _FuelTypeScreenState();
}

class _FuelTypeScreenState extends State<FuelTypeScreen> {
  List<FuelType> _fuelTypes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _fuelTypes = await context.read<CarApiService>().getFuelTypes();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
              l.fuelLabel,
              style: const TextStyle(
                fontSize: 18.43,
                fontWeight: FontWeight.w500,
                color: Color(0xFF131313),
                height: 1.0,
              ),
            ),
            Text(
              l.multiSelect,
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
      body: _loading
          ? SkeletonShimmer(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFE5E5EA)),
                itemBuilder: (_, __) => const ListTile(
                  title: SkeletonBox(height: 14, width: double.infinity, borderRadius: 4),
                ),
              ),
            )
          : ListView.separated(
              itemCount: _fuelTypes.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 0.8,
                color: Color(0xFFE8E8E8),
                indent: 15,
                endIndent: 15,
              ),
              itemBuilder: (_, i) {
                final ft = _fuelTypes[i];
                final selected = search.selectedFuelTypeId == ft.id;
                return ListTile(
                  title: Text(
                    ft.name,
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
                  onTap: () => search.setFuelTypeId(selected ? null : ft.id),
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
                onPressed: search.selectedFuelTypeId != null
                    ? search.clearFuelType
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
                child: Text(l.clearFilter),
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
                  l.update,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
