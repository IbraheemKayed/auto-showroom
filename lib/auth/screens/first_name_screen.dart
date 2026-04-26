import 'package:flutter/material.dart';
import 'package:sayarti/auth/screens/location_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class FirstNameScreen extends StatefulWidget {
  const FirstNameScreen({super.key});

  @override
  State<FirstNameScreen> createState() => _FirstNameScreenState();
}

class _FirstNameScreenState extends State<FirstNameScreen> {
  final TextEditingController nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFilled = nameCtrl.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                l10n.enterYourName,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 32,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                l10n.personalizeSubtitle,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 16,
                  height: 1.2,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),

              const SizedBox(height: 35),

              // NAME INPUT
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                child: TextField(
                  controller: nameCtrl,
                  onChanged: (_) => setState(() {}),
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: l10n.nameHint,
                    hintStyle: AppTextStyles.regular.copyWith(
                      fontSize: 25,
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const Spacer(),

              // CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: isFilled
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChooseCityScreen(firstName: nameCtrl.text),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066EE),
                    shape: const StadiumBorder(),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    l10n.continueBtn,
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
