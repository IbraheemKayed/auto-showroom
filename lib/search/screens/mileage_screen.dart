import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class MileageScreen extends StatelessWidget {
  const MileageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final search = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: const BackButton(color: Colors.black),
        title: Text(
          l10n.mileageFilter,
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
            /// ===== RANGE SLIDER =====
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
                values: RangeValues(search.minMileage, search.maxMileage),
                min: search.mileageMinLimit,
                max: search.mileageMaxLimit,
                divisions: 20,
                onChanged: (values) => search.updateMileage(values),
              ),
            ),

            const SizedBox(height: 8),

            /// ===== LABELS =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${search.minMileage.toInt()} ${l10n.kmUnit}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  search.maxMileage >= search.mileageMaxLimit
                      ? l10n.maxMileagePlus
                      : '${search.maxMileage.toInt()} ${l10n.kmUnit}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ===== FROM / TO INPUTS =====
            Row(
              children: [
                Expanded(
                  child: _MileageField(
                    label: l10n.fromLabel,
                    unit: l10n.kmUnit,
                    value: search.minMileage,
                    onChanged: (val) {
                      if (val == null) return;
                      search.updateMileage(RangeValues(
                        val.clamp(search.mileageMinLimit, search.maxMileage),
                        search.maxMileage,
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MileageField(
                    label: l10n.toLabel,
                    unit: l10n.kmUnit,
                    value: search.maxMileage,
                    onChanged: (val) {
                      if (val == null) return;
                      search.updateMileage(RangeValues(
                        search.minMileage,
                        val.clamp(search.minMileage, search.mileageMaxLimit),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      /// ===== BOTTOM BAR =====
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
                onPressed: search.clearMileage,
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

}

class _MileageField extends StatefulWidget {
  final String label;
  final double value;
  final String unit;
  final ValueChanged<double?> onChanged;

  const _MileageField({
    required this.label,
    required this.value,
    required this.unit,
    required this.onChanged,
  });

  @override
  State<_MileageField> createState() => _MileageFieldState();
}

class _MileageFieldState extends State<_MileageField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value.toInt().toString());
    _focus = FocusNode();
    _focus.addListener(() {
      if (_focus.hasFocus) {
        _ctrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ctrl.text.length,
        );
      } else {
        widget.onChanged(double.tryParse(_ctrl.text) ?? 0);
      }
    });
  }

  @override
  void didUpdateWidget(_MileageField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && old.value != widget.value) {
      _ctrl.text = widget.value.toInt().toString();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 6),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF0066EE),
              selectionColor: Color(0x330066EE),
              selectionHandleColor: Color(0xFF0066EE),
            ),
          ),
          child: TextField(
          controller: _ctrl,
          focusNode: _focus,
          keyboardType: TextInputType.number,
          cursorColor: const Color(0xFF0066EE),

          onChanged: (text) {
            if (text.isEmpty) {
              _ctrl.value = const TextEditingValue(
                text: '0',
                selection: TextSelection.collapsed(offset: 1),
              );
              widget.onChanged(0);
            }
          },
          onSubmitted: (_) => widget.onChanged(double.tryParse(_ctrl.text) ?? 0),
          decoration: InputDecoration(
            suffixText: widget.unit,
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
        ),
      ],
    );
  }
}
