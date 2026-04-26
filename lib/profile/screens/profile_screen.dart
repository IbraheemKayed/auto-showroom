import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/app_root.dart';
import 'package:sayarti/dealer/screens/manage_subscription_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/profile/providers/language_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDealer = auth.user?.userType == 'showroom';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: ListView(
          children: [
            // =====================
            // HEADER
            // =====================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFE8EEFF),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF0066EE),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Text(
                        auth.user?.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1B1B1B),
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (auth.user?.isVerified == true)
                        const Icon(Icons.verified,
                            color: Colors.green, size: 16),
                    ],
                  ),
                ],
              ),
            ),


            // =====================
            // SETTINGS + REST
            // =====================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: isDealer
                  ? _dealerSections(context)
                  : _userSections(context),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DEALER SECTIONS
  // =====================================================
  Widget _dealerSections(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l.settings),
        _card(
          child: Column(
            children: [
              _tile(Icons.language, l.language,
                  onTap: () => _showLanguageSheet(context)),
              _divider(),
              _tile(Icons.notifications_none, l.notifications),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _sectionTitle(l.support),
        _card(
          child: Column(
            children: [
              _tile(Icons.headset_mic_outlined, l.contactUs),
              _divider(),
              _tile(Icons.feedback_outlined, l.giveUsFeedback),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _sectionTitle(l.dealer),
        _card(
          child: _tile(
            Icons.credit_card_outlined,
            l.manageSubscription,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ManageSubscriptionScreen(),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        _sectionTitle(l.clutch),
        _card(
          child: Column(
            children: [
              _tile(Icons.shield_outlined, l.termsOfService),
              _divider(),
              _tile(Icons.privacy_tip_outlined, l.privacyPolicy),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _card(
          child: _tile(
            Icons.logout,
            l.logout,
            color: Colors.red,
            trailingColor: Colors.red,
            onTap: () => _showLogoutSheet(context),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // BASIC USER SECTIONS
  // =====================================================
  Widget _userSections(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l.settings),
        _card(
          child: Column(
            children: [
              _tile(Icons.language, l.language,
                  onTap: () => _showLanguageSheet(context)),
              _divider(),
              _tile(Icons.notifications_none, l.notifications),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _sectionTitle(l.support),
        _card(
          child: Column(
            children: [
              _tile(Icons.headset_mic_outlined, l.contactUs),
              _divider(),
              _tile(Icons.feedback_outlined, l.giveUsFeedback),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _sectionTitle(l.clutch),
        _card(
          child: Column(
            children: [
              _tile(Icons.shield_outlined, l.termsOfService),
              _divider(),
              _tile(Icons.privacy_tip_outlined, l.privacyPolicy),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _card(
          child: _tile(
            Icons.logout,
            l.logout,
            color: Colors.red,
            trailingColor: Colors.red,
            onTap: () => _showLogoutSheet(context),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // UI HELPERS
  // =====================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 27, 27, 27),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
      ),
      child: child,
    );
  }

  Widget _tile(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Color color = Colors.black,
    Color trailingColor = const Color(0xFF1B1B1B),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: color,
                  height: 1.0,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: trailingColor),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: Color.fromARGB(255, 230, 230, 230),
    );
  }

  // =====================================================
  // LANGUAGE SHEET
  // =====================================================
  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _LanguageBottomSheet(),
    );
  }

  // =====================================================
  // LOGOUT SHEET
  // =====================================================
  void _showLogoutSheet(BuildContext context) {
    final auth = context.read<AuthProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 32 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.readyToLogout,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.logoutConfirmationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          side: const BorderSide(
                              color: Color(0xFFE6E6E6)),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await auth.logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AppRoot(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.logout,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        );
      },
    );
  }
}

// =====================================================
// LANGUAGE BOTTOM SHEET
// =====================================================
class _LanguageBottomSheet extends StatelessWidget {
  const _LanguageBottomSheet();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 24 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  l.changeLanguage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _languageTile(
              context,
              title: l.english,
              emoji: '🇺🇸',
              selected: lang.isEnglish,
              onTap: () {
                lang.setEnglish();
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 8),

            _languageTile(
              context,
              title: l.arabic,
              emoji: '🇸🇦',
              selected: !lang.isEnglish,
              onTap: () {
                lang.setArabic();
                Navigator.pop(context);
              },
            ),
          ],
        ),
    );
  }

  Widget _languageTile(
    BuildContext context, {
    required String title,
    required String emoji,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF0066EE)
                : const Color(0xFFE6E6E6),
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected
                  ? const Color(0xFF0066EE)
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
