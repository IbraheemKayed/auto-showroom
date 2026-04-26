import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class EnterPhoneScreen extends StatelessWidget {
  const EnterPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final isLoading = auth.state == AuthState.loading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) SystemNavigator.pop();
      },
      child: Scaffold(
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
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              Text(
                l10n.enterPhoneTitle,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 32,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                l10n.phoneVerifySubtitle,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 16,
                  height: 1.2,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),

              const SizedBox(height: 30),

              // PHONE INPUT
              Container(
                height: 52,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFF9F9F9),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: auth.countryCode,
                        isDense: true,
                        icon: const Icon(
                          CupertinoIcons.chevron_down,
                          size: 10,
                          color: Colors.black,
                        ),
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                        items: [
                          DropdownMenuItem(value: '+970', child: Text('+970')),
                          DropdownMenuItem(value: '+972', child: Text('+972')),
                        ],
                        onChanged: (val) {
                          if (val != null) auth.setCountryCode(val);
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(
                      width: 170,
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          counterText: '',
                          hintText: '59x-xxx-xxx',
                          hintStyle: AppTextStyles.regular.copyWith(
                            fontSize: 25,
                            color: Colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                        onChanged: auth.setPhoneNumber,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),

              const Spacer(),

              // TOS text
              Center(
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.medium.copyWith(
                      fontSize: 13,
                      height: 1.2,
                      color: const Color(0xFF0066EE),
                    ),
                    children: [
                      TextSpan(text: l10n.tosAgreement),
                      TextSpan(
                        text: l10n.tos,
                        style: AppTextStyles.medium.copyWith(
                          fontSize: 13,
                          height: 1.2,
                          color: const Color(0xFF0066EE),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF0066EE),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // SEND OTP
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
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (auth.phoneNumber.length < 9) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.invalidPhone),
                                ),
                              );
                              return;
                            }

                            await auth.requestOtp();

                            if (!context.mounted) return;
                            if (auth.state == AuthState.loggedOut &&
                                auth.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(auth.errorMessage!)),
                              );
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
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
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

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
  }
}


