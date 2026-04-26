import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class TransmissionScreen extends StatelessWidget {
  const TransmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final search = context.watch<SearchProvider>();

    final options = [
      ('AUTOMATIC', l.automatic),
      ('MANUAL', l.manual),
    ];

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
              l.transmissionLabel,
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
      body: ListView.separated(
        itemCount: options.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          thickness: 0.8,
          color: Color(0xFFE8E8E8),
          indent: 15,
          endIndent: 15,
        ),
        itemBuilder: (_, i) {
          final value = options[i].$1;
          final label = options[i].$2;
          final selected = search.selectedGearTypes.contains(value);
          return ListTile(
            title: Text(
              label,
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
            onTap: () => search.toggleGearType(value),
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
                onPressed: search.selectedGearTypes.isNotEmpty
                    ? search.clearGearTypes
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
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
