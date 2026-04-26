import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/providers/preferences_provider.dart';
import 'package:sayarti/ai_search/screens/find_car_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class ChooseCityScreen extends StatefulWidget {
  const ChooseCityScreen({super.key, required this.firstName});

  final String firstName;

  @override
  State<ChooseCityScreen> createState() => _ChooseCityScreenState();
}

class _ChooseCityScreenState extends State<ChooseCityScreen> {

  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();
    final prefs = context.read<PreferencesProvider>();

    final temp = auth.tempToken;
    if (temp != null && temp.isNotEmpty) {
      prefs.setAuthToken(temp);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs =
          Provider.of<PreferencesProvider>(context, listen: false);
      prefs.loadCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prefs = context.watch<PreferencesProvider>();
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.localeName == 'ar';

    final isLoadingAuth = auth.state == AuthState.loading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back button
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              /// Title
              Text(
                l10n.chooseCityTitle,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 32,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                l10n.personalizeSubtitle,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 16,
                  height: 1.2,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),

              const SizedBox(height: 35),

              /// CITY DROPDOWN
              if (prefs.isLoadingCities)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0066EE)),
                )
              else if (prefs.citiesError != null)
                Center(
                  child: Text(
                    prefs.citiesError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: prefs.selectedCityId,
                      isExpanded: true,
                      hint: Text(
                        l10n.selectCityHint,
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 25,
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                      ),
                      items: prefs.cities.map((city) {
                        return DropdownMenuItem(
                          value: city.id,
                          child: Text(
                            isAr ? city.nameAr : city.nameEn,
                            style: AppTextStyles.regular.copyWith(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) prefs.selectCity(v);
                      },
                    ),
                  ),
                ),

              const Spacer(),

              /// CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (prefs.selectedCityId == null || isLoadingAuth)
                      ? null
                      : () async {
                          await auth.completeProfile(
                            widget.firstName,
                            prefs.selectedCityId!,
                          );

                          if (!context.mounted) return;

                          if (auth.state == AuthState.loggedIn ||
                              auth.tempToken != null ||
                              auth.accessToken != null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FindCarScreen(),
                              ),
                              (_) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  auth.errorMessage ?? l10n.somethingWentWrong,
                                ),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066EE),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: const StadiumBorder(),
                  ),
                  child: isLoadingAuth
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
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
