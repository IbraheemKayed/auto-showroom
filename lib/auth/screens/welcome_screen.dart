import 'package:flutter/material.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onContinue;
  const WelcomeScreen({super.key, this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              const Spacer(),

              // Hand image
              Image.asset(
                'assets/images/hand.png',
                width: 64,
                height: 64,
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                l10n.welcomeTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 32,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 16,
                  height: 1.2,
                  color: const Color(0x66000000),
                ),
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.01),
                        blurRadius: 80,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (onContinue != null) {
                        onContinue!();
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainLayout()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066EE),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      l10n.continueBtn,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 16,
                        height: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

            ],
          ),
        ),
      ),
    );
  }
}
