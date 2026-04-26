import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/l10n/car_translations.dart';
import 'package:sayarti/ai_search/models/drive_train_type.dart';
import 'package:sayarti/ai_search/models/fuel_type.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/dealer/services%20and%20providers/create_car_provider.dart';

class AddPostFuelType extends StatefulWidget {
  const AddPostFuelType({super.key});

  @override
  State<AddPostFuelType> createState() => _AddPostFuelTypeState();
}

class _AddPostFuelTypeState extends State<AddPostFuelType> {
  List<FuelType> fuelTypes = [];
  List<DriveTrainType> driveTrains = [];
  bool loading = true;

  final engineController = TextEditingController();
  final powerController = TextEditingController();
  final ownersController = TextEditingController();

  static const transmissionTypes = ['Automatic', 'Manual'];

  @override
  void initState() {
    super.initState();
    _loadFuelTypes();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final create = context.read<CreateCarProvider>();
      if (create.draft.engineSize != null) {
        engineController.text = create.draft.engineSize!;
      }
      if (create.draft.power != null) {
        powerController.text = create.draft.power!;
      }
      if (create.draft.previousOwners != null) {
        ownersController.text = create.draft.previousOwners.toString();
      }
    });
  }

  @override
  void dispose() {
    engineController.dispose();
    powerController.dispose();
    ownersController.dispose();
    super.dispose();
  }

  Future<void> _loadFuelTypes() async {
    try {
      final api = context.read<CarApiService>();
      final fuelFuture = api.getFuelTypes();
      final driveTrainFuture = api.getDriveTrains();
      fuelTypes = await fuelFuture;
      driveTrains = await driveTrainFuture;
    } catch (e) {
      debugPrint(e.toString());
    }
    if (mounted) setState(() => loading = false);
  }

  bool get _canContinue {
    final create = context.read<CreateCarProvider>();
    return engineController.text.trim().isNotEmpty &&
        powerController.text.trim().isNotEmpty &&
        create.draft.carFuelTypeId != null &&
        create.draft.gearType != null &&
        create.draft.carDriveTrainId != null &&
        ownersController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final create = context.watch<CreateCarProvider>();

    final selectedFuel = fuelTypes
        .where((f) => f.id == create.draft.carFuelTypeId)
        .cast<FuelType?>()
        .firstWhere((_) => true, orElse: () => null);

    final gear = create.draft.gearType;
    final selectedTransmission = gear != null
        ? (gear.substring(0, 1).toUpperCase() +
            gear.substring(1).toLowerCase())
        : null;

    final selectedDriveTrain = driveTrains
        .where((d) => d.id == create.draft.carDriveTrainId)
        .cast<DriveTrainType?>()
        .firstWhere((_) => true, orElse: () => null);

    if (loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(84),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _circleButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        l.question3of5,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                      widthFactor: 3 / 5,
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
              Container(
                height: 13,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 13,
                        width: 180,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                      l.question3of5,
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
                    widthFactor: 3 / 5,
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

      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            const SizedBox(height: 12),

            // ===== ENGINE SIZE =====
            _questionTitle(l.whatsYourEngineSize),
            _textInput(
              controller: engineController,
              hint: l.pleaseChooseEngineSize,
              keyboard: TextInputType.number,
              suffix: 'cc',
              maxLength: 4,
              onChanged: create.setEngine,
            ),

            // ===== POWER =====
            _questionTitle(l.whatsYourPower),
            _textInput(
              controller: powerController,
              hint: l.enterPowerExample,
              keyboard: TextInputType.number,
              suffix: 'hp',
              maxLength: 3,
              onChanged: create.setPower,
            ),

            // ===== FUEL TYPE =====
            _questionTitle(l.whatsYourFuelType),
            _dropdown(
              label: selectedFuel?.name ?? l.pleaseChooseFuelType,
              onTap: fuelTypes.isEmpty
                  ? null
                  : () => _showCupertinoPicker(
                        title: l.fuelType,
                        items: fuelTypes.map((f) => f.name).toList(),
                        initialIndex: selectedFuel != null
                            ? fuelTypes.indexOf(selectedFuel)
                            : 0,
                        onSelected: (i) => create.setFuel(fuelTypes[i].id),
                      ),
            ),

            // ===== TRANSMISSION =====
            _questionTitle(l.whatsYourTransmission),
            _dropdown(
              label: selectedTransmission != null
                  ? CarTranslations.translateValue(selectedTransmission, l)
                  : l.pleaseChooseTransmission,
              onTap: () => _showCupertinoPicker(
                title: l.transmission,
                items: transmissionTypes.map((t) => CarTranslations.translateValue(t, l)).toList(),
                initialIndex: selectedTransmission != null
                    ? transmissionTypes.indexOf(selectedTransmission)
                    : 0,
                onSelected: (i) =>
                    create.setGear(transmissionTypes[i].toUpperCase()),
              ),
            ),

            // ===== DRIVE TRAIN =====
            _questionTitle(l.whatsYourDriveTrain),
            _dropdown(
              label: selectedDriveTrain?.name ?? l.pleaseChooseDriveTrain,
              onTap: driveTrains.isEmpty
                  ? null
                  : () => _showCupertinoPicker(
                        title: l.driveTrain,
                        items: driveTrains.map((d) => d.name).toList(),
                        initialIndex: selectedDriveTrain != null
                            ? driveTrains.indexOf(selectedDriveTrain)
                            : 0,
                        onSelected: (i) =>
                            create.setDriveTrain(driveTrains[i].id),
                      ),
            ),

            // ===== PREVIOUS OWNERS =====
            _questionTitle(
                l.whatsYourPreviousOwners),
            _textInput(
              controller: ownersController,
              hint: l.pleaseInputPreviousOwners,
              keyboard: TextInputType.number,
              maxLength: 2,
              onChanged: (v) {
                final n = int.tryParse(v);
                if (n != null) create.setPreviousOwners(n);
              },
            ),

            const SizedBox(height: 32),

            // ===== CONTINUE =====
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _canContinue
                    ? () => Navigator.pushNamed(context, '/images')
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _questionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    String? suffix,
    int? maxLength,
    required void Function(String) onChanged,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLength: maxLength,
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
          suffixText: suffix,
          suffixStyle: const TextStyle(color: Colors.black54, fontSize: 15),
        ),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _dropdown({required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _showCupertinoPicker({
    required String title,
    required List<String> items,
    required int initialIndex,
    required void Function(int) onSelected,
  }) {
    int tempIndex = initialIndex.clamp(0, items.length - 1);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      builder: (_) => SizedBox(
        height: 300,
        child: Column(
          children: [
            _pickerHeader(title, () {
              onSelected(tempIndex);
              Navigator.pop(context);
              setState(() {});
            }),
            const Divider(height: 1),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController:
                    FixedExtentScrollController(initialItem: tempIndex),
                onSelectedItemChanged: (i) => tempIndex = i,
                children: items
                    .map((e) => Center(child: Text(e, style: const TextStyle(fontSize: 18))))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
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

}
