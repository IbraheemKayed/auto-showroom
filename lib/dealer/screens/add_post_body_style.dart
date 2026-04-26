import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';

import 'package:sayarti/ai_search/models/car_category.dart';
import 'package:sayarti/ai_search/providers/preferences_provider.dart';
import 'package:sayarti/dealer/services%20and%20providers/create_car_provider.dart';

class AddPostBodyStyleScreen extends StatefulWidget {
  const AddPostBodyStyleScreen({super.key});

  @override
  State<AddPostBodyStyleScreen> createState() => _AddPostBodyStyleScreenState();
}

class _AddPostBodyStyleScreenState extends State<AddPostBodyStyleScreen> {
  static const Map<String, String> _arNames = {
    'suv':       'جيب',
    'hatchback': 'هاتشباك',
    'coupe':     'كوبيه',
    'sedan':     'سيارة سيدان',
    'cabriolet': 'سيارة كشف',
  };

  @override
  void initState() {
    super.initState();
    context.read<PreferencesProvider>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final prefs = context.watch<PreferencesProvider>();
    final create = context.watch<CreateCarProvider>();

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
                      l.question2of3,
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
                    widthFactor: 2 / 3,
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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.step1,
              style: const TextStyle(
                  color: Color(0xFF0066EE), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              l.whatIsBodyStyle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              l.pleaseSelectBodyStyle,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            if (prefs.isLoadingCategories)
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 173 / 100,
                  ),
                  itemBuilder: (_, __) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  itemCount: prefs.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 173 / 100,
                  ),
                  itemBuilder: (context, i) {
                    final CarCategory cat = prefs.categories[i];
                    final bool isSelected = create.draft.categoryId == cat.id;

                    return GestureDetector(
                      onTap: () => create.setCategory(cat.id),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEAF1FF)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0066EE)
                                : const Color(0xFFD1D1D1),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: cat.imagePath,
                                fit: BoxFit.contain,
                                imageBuilder: (_, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                  color: isSelected
                                      ? const Color(0xFF0066EE)
                                      : Colors.black54,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l.localeName == 'ar'
                                  ? (_arNames[cat.code.toLowerCase()] ?? cat.name)
                                  : cat.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isSelected
                                    ? const Color(0xFF0066EE)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: create.draft.categoryId == null
                    ? null
                    : () => Navigator.pushNamed(context, '/mileage'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
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
