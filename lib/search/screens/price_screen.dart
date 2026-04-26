import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class PriceScreen extends StatelessWidget {
  const PriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: const BackButton(color: Colors.black),
        title: Text(
          l10n.priceFilter,
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

      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                values: RangeValues(
                  search.minPrice,
                  search.maxPrice,
                ),
                min: search.priceMinLimit,
                max: search.priceMaxLimit,
                divisions: 45,
                onChanged: (values) {
                  search.updatePrice(values);
                },
              ),
            ),

            const SizedBox(height: 8),

            // ===== TOP LABELS =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₪${search.minPrice.toInt()}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  search.maxPrice >= search.priceMaxLimit
                      ? l10n.maxPricePlus
                      : '₪${search.maxPrice.toInt()}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== MIN / MAX INPUTS =====
            Row(
              children: [
                Expanded(
                  child: _priceField(
                    label: l10n.minLabel,
                    value: search.minPrice.toInt().toString(),
                    onChanged: (v) {
                      final value = double.tryParse(v) ?? search.minPrice;
                      search.updatePrice(
                        RangeValues(
                          value.clamp(
                            search.priceMinLimit,
                            search.maxPrice,
                          ),
                          search.maxPrice,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _priceField(
                    label: l10n.maxLabel,
                    value: search.maxPrice.toInt().toString(),
                    onChanged: (v) {
                      final value = double.tryParse(v) ?? search.maxPrice;
                      search.updatePrice(
                        RangeValues(
                          search.minPrice,
                          value.clamp(
                            search.minPrice,
                            search.priceMaxLimit,
                          ),
                        ),
                      );
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
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  search.clearPrice();
                },
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
                onPressed: () {
                  Navigator.pop(context);
                },
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

  // ================= HELPERS =================

  static Widget _priceField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: value,
            suffixText: '₪',
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
              borderSide: const BorderSide(color: Color(0xFF0066EE), width: 2),
            ),
          ),
        ),
      ],
    );
  }

}
