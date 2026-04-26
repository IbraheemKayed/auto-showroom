import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class YearScreen extends StatelessWidget {
  const YearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();
    final l10n = AppLocalizations.of(context)!;

    final int divisions = (search.yearMaxLimit - search.yearMinLimit).toInt(); // 62

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: const BackButton(color: Colors.black),
        title: Text(
          l10n.yearFilter,
          style: const TextStyle(
            fontSize: 18.43,
            fontWeight: FontWeight.w500,
            color: Color(0xFF131313),
            height: 1.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== RANGE SLIDER =====
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.white,
                overlayColor: const Color(0xFF0066EE).withValues(alpha: 0.1),
                activeTrackColor: const Color(0xFF0066EE),
                inactiveTrackColor: Colors.grey.shade300,
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 12,
                ),
              ),
              child: RangeSlider(
                values: RangeValues(search.minYear, search.maxYear),
                min: search.yearMinLimit,
                max: search.yearMaxLimit,
                divisions: divisions,
                onChanged: (values) => search.updateYear(values),
              ),
            ),

            const SizedBox(height: 8),

            // ===== LABELS =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${search.minYear.toInt()}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  '${search.maxYear.toInt()}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== FROM / TO INPUTS =====
            Row(
              children: [
                Expanded(
                  child: _yearField(
                    label: l10n.fromLabel,
                    value: search.minYear.toInt().toString(),
                    onChanged: (v) {
                      final val = double.tryParse(v);
                      if (val == null) return;
                      search.updateYear(RangeValues(
                        val.clamp(search.yearMinLimit, search.maxYear),
                        search.maxYear,
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _yearField(
                    label: l10n.toLabel,
                    value: search.maxYear.toInt().toString(),
                    onChanged: (v) {
                      final val = double.tryParse(v);
                      if (val == null) return;
                      search.updateYear(RangeValues(
                        search.minYear,
                        val.clamp(search.minYear, search.yearMaxLimit),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // ===== BOTTOM BAR =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: search.clearYear,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black54,
                  elevation: 0,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(l10n.clearFilter),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  l10n.update,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _yearField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: value,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF0066EE), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
