import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/ai_search/models/car_brand.dart';
import 'package:sayarti/dealer/screens/add_post_body_style.dart';
import 'package:sayarti/dealer/services%20and%20providers/create_car_provider.dart';
import 'package:sayarti/search/providers/search_provider.dart';
import 'package:sayarti/search/models/car_model.dart';

class AddPostStep2 extends StatefulWidget {
  const AddPostStep2({super.key});

  @override
  State<AddPostStep2> createState() => _AddPostStep2State();
}

class _AddPostStep2State extends State<AddPostStep2> {
  final List<int> years = List.generate(48, (i) => 2027 - i);

  @override
  void initState() {
    super.initState();
    final search = context.read<SearchProvider>();
    search.clearBrands();
    search.loadBrands();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final search = context.watch<SearchProvider>();
    final create = context.watch<CreateCarProvider>();

    final CarBrand? selectedBrand = search.selectedBrand;
    final CarModel? selectedModel = search.models
        .where((m) => m.id == create.draft.carModelId)
        .cast<CarModel?>()
        .firstWhere((m) => m != null, orElse: () => null);

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
                      l.question1of3,
                      style: TextStyle(
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
                  child: Container(
                    width: MediaQuery.of(context).size.width * .33,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066EE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.step1,
              style: TextStyle(
                color: Color(0xFF0066EE),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.chooseMakeModel,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 28),

            // ============ MAKE ============
            _dropdown(
              label: selectedBrand?.name ?? l.pleaseChooseMake,
              isLoading: search.isLoadingBrands,
              onTap: search.isLoadingBrands
                  ? null
                  : () => _showPicker<CarBrand>(
                      title: l.chooseMake,
                      items: search.brands,
                      labelBuilder: (b) => b.name,
                      initialIndex: search.brands
                          .indexWhere((b) => b.id == selectedBrand?.id)
                          .clamp(0, search.brands.isEmpty ? 0 : search.brands.length - 1),
                      onSelected: (brand) {
                        search.selectBrand(brand);
                        create.setMake(brand.id, brand.name);
                      },
                    ),
            ),

            const SizedBox(height: 14),

            // ============ MODEL ============
            _dropdown(
              label: selectedModel?.name ?? l.pleaseChooseModel,
              isLoading: search.isLoadingModels,
              onTap: (search.selectedBrand == null || search.isLoadingModels)
                  ? null
                  : () => _showPicker<CarModel>(
                      title: l.chooseModel,
                      items: search.models,
                      labelBuilder: (m) => m.name,
                      initialIndex: search.models
                          .indexWhere((m) => m.id == create.draft.carModelId)
                          .clamp(0, search.models.isEmpty ? 0 : search.models.length - 1),
                      onSelected: (model) {
                        create.setModel(model.id, model.name);
                      },
                    ),
            ),

            const SizedBox(height: 14),

            // ============ YEAR ============
            _dropdown(
              label: create.draft.year?.toString() ?? l.pleaseChooseYear,
              onTap: () => _showPicker<int>(
                title: l.chooseYear,
                items: years,
                labelBuilder: (y) => y.toString(),
                initialIndex: years
                    .indexOf(create.draft.year ?? years[0])
                    .clamp(0, years.length - 1),
                onSelected: (year) {
                  create.setYear(year);
                },
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: (create.draft.carMakeId != null &&
                        create.draft.carModelId != null &&
                        create.draft.year != null)
                    ? () => Navigator.of(context).pushNamed('/body')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  disabledBackgroundColor: const Color(0xFFE6E6E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  l.continueBtn,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

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
                        color: onTap == null
                            ? Colors.grey.shade400
                            : Colors.black87,
                      ),
                    ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: onTap == null ? Colors.grey.shade400 : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  // ================= Picker =================

  void _showPicker<T>({
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    required Function(T) onSelected,
    int initialIndex = 0,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      builder: (_) {
        int tempIndex = initialIndex;
        final scrollController =
            FixedExtentScrollController(initialItem: initialIndex);
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              _pickerHeader(title, () {
                onSelected(items[tempIndex]);
                Navigator.pop(context);
              }),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  scrollController: scrollController,
                  itemExtent: 44,
                  onSelectedItemChanged: (i) => tempIndex = i,
                  children: items
                      .map(
                        (e) => Center(
                          child: Text(
                            labelBuilder(e),
                            style: const TextStyle(fontSize: 18),
                          ),
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
}
