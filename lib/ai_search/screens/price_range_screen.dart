// price_range_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/screens/searching_screen.dart';
import 'package:sayarti/ai_search/widgets/preference_widgets.dart.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import '../providers/preferences_provider.dart';

class PriceRangeScreen extends StatelessWidget {
  const PriceRangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PreferencesProvider>();
    final l = AppLocalizations.of(context)!;

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
          l.price,
          style: const TextStyle(
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
              l.chooseYourPriceRange,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Slider ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2.0,
                activeTrackColor: const Color(0xFF0066EE),
                inactiveTrackColor: const Color(0xFFC4C4C4),
                thumbColor: Colors.white,
                overlayColor: const Color(0xFF0066EE).withValues(alpha: 0.12),
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 16.5,
                  elevation: 4,
                ),
              ),
              child: RangeSlider(
                values: RangeValues(
                  provider.selectedMinPrice,
                  provider.selectedMaxPrice,
                ),
                min: provider.minPrice,
                max: provider.maxPrice,
                divisions: ((provider.maxPrice - provider.minPrice) / 10000).round(),
                onChanged: (values) {
                  provider.setPriceRange(values.start, values.end);
                },
              ),
            ),
          ),

          // ── Min / Max labels ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₪${provider.minPrice.toInt()}",
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: 13.33,
                    height: 1.0,
                    color: Color(0xFF545655),
                  ),
                ),
                Text(
                  "₪${provider.maxPrice.toInt()}+",
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: 13.33,
                    height: 1.0,
                    color: Color(0xFF545655),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Input fields ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _PriceField(
                    label: l.minPrice,
                    value: provider.selectedMinPrice,
                    onChanged: (v) => provider.setPriceRange(
                      v ?? provider.minPrice,
                      provider.selectedMaxPrice,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PriceField(
                    label: l.maxPrice,
                    value: provider.selectedMaxPrice,
                    onChanged: (v) => provider.setPriceRange(
                      provider.selectedMinPrice,
                      v ?? provider.maxPrice,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          BottomNavButtons(
            onBack: () => Navigator.pop(context),
            onNext: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchingScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PriceField extends StatefulWidget {
  final String label;
  final double value;
  final void Function(double?) onChanged;

  const _PriceField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<_PriceField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toInt().toString());
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
      if (!_focusNode.hasFocus) {
        final v = double.tryParse(_controller.text);
        widget.onChanged(v);
      }
    });
  }

  @override
  void didUpdateWidget(_PriceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && oldWidget.value != widget.value) {
      _controller.text = widget.value.toInt().toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'FunnelDisplay',
            fontWeight: FontWeight.w400,
            fontSize: 13.33,
            height: 1.0,
            color: Color(0xFF545655),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hasFocus ? const Color(0xFF0066EE) : const Color(0xFFF5F5F5),
              width: 0.99,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.56,
                    height: 1.0,
                    color: Color(0xFF1F1F1F),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (text) {
                    final v = double.tryParse(text);
                    widget.onChanged(v);
                  },
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '₪',
                style: TextStyle(
                  fontFamily: 'FunnelDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.56,
                  height: 1.0,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
