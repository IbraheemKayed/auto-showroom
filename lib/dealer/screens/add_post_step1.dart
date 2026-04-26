import 'package:flutter/material.dart';
import 'package:sayarti/dealer/services%20and%20providers/add_car_flow.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class AddPostStep1 extends StatelessWidget {
  const AddPostStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE6E6E6)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 16),
                ),
              ),
            ),
          ),
          // ===== IMAGE + TEXT =====
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/step1_car.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    l.step1Title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 20,
                      height: 1.0,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== BUTTON =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCarFlow()),
                  );
                },
                child: Text(
                  l.next,
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
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
