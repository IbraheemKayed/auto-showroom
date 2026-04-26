import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/dealer/services%20and%20providers/create_car_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/models/car_color.dart';
import 'package:sayarti/search/providers/color_provider.dart';

class AddPostColorsScreen extends StatefulWidget {
  const AddPostColorsScreen({super.key});

  @override
  State<AddPostColorsScreen> createState() => _AddPostColorsScreenState();
}

class _AddPostColorsScreenState extends State<AddPostColorsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CarColorsProvider>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = context.watch<CarColorsProvider>();
    final create = context.watch<CreateCarProvider>();

    final selectedOutside = colors.outsideColors
        .where((c) => c.id == create.draft.carOutsideColorId)
        .cast<CarColor?>()
        .firstWhere((_) => true, orElse: () => null);

    final selectedInside = colors.insideColors
        .where((c) => c.id == create.draft.carInsideColorId)
        .cast<CarColor?>()
        .firstWhere((_) => true, orElse: () => null);

    final canContinue = create.draft.carInsideColorId != null &&
        create.draft.carOutsideColorId != null;

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== App Bar =====
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    _circleButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    Text(
                      l.question2of5,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 38),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 2 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066EE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.step2,
              style: const TextStyle(
                color: Color(0xFF0066EE),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // ===== EXTERIOR COLOR =====
            Text(
              l.whatsYourColor,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l.selectClosestColor,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: selectedOutside?.name ?? l.pleaseChooseExteriorColor,
              isLoading: colors.loading,
              onTap: (colors.loading || colors.outsideColors.isEmpty)
                  ? null
                  : () => _showColorPicker(
                        title: l.exteriorColor,
                        items: colors.outsideColors,
                        selectedId: create.draft.carOutsideColorId,
                        onSelected: create.setOutsideColor,
                      ),
            ),

            const SizedBox(height: 28),

            // ===== INTERIOR COLOR =====
            Text(
              l.whatsYourInteriorColor,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l.selectClosestInteriorColor,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: selectedInside?.name ?? l.pleaseChooseInteriorColor,
              isLoading: colors.loading,
              onTap: (colors.loading || colors.insideColors.isEmpty)
                  ? null
                  : () => _showColorPicker(
                        title: l.interiorColor,
                        items: colors.insideColors,
                        selectedId: create.draft.carInsideColorId,
                        onSelected: create.setInsideColor,
                      ),
            ),

            const Spacer(),

            // ===== CONTINUE =====
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: canContinue
                      ? () => Navigator.of(context).pushNamed('/fuel')
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066EE),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    l.continueBtn,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showColorPicker({
    required String title,
    required List<CarColor> items,
    required int? selectedId,
    required void Function(int) onSelected,
  }) {
    int tempIndex =
        selectedId != null ? items.indexWhere((c) => c.id == selectedId) : 0;
    if (tempIndex < 0) tempIndex = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              _pickerHeader(title, () {
                onSelected(items[tempIndex].id);
                Navigator.pop(context);
              }),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 44,
                  scrollController: FixedExtentScrollController(
                    initialItem: tempIndex,
                  ),
                  onSelectedItemChanged: (i) => tempIndex = i,
                  children: items
                      .map(
                        (c) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _hexToColor(c.code),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'FunnelDisplay',
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pickerHeader(String title, VoidCallback onDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          InkWell(onTap: onDone, child: const Icon(Icons.check)),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String label,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isLoading ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(14),
          color: isLoading ? Colors.grey.shade50 : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: isLoading
                  ? Container(
                      height: 13,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: onTap == null ? Colors.grey.shade400 : Colors.black87,
                      ),
                    ),
            ),
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey.shade400,
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down,
                color: onTap == null ? Colors.grey.shade400 : Colors.black54,
              ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      final cleaned = hex.replaceAll('#', '');
      final value = int.parse(
        cleaned.length == 6 ? 'FF$cleaned' : cleaned,
        radix: 16,
      );
      return Color(value);
    } catch (_) {
      return Colors.grey;
    }
  }
}
