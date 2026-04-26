import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'first_name_screen.dart';
import 'welcome_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool isVerifying = false;
  bool isError = false;
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> submitCode() async {
    final auth = context.read<AuthProvider>();
    final code = _controller.text.trim();

    if (code.length != 6) return;

    setState(() {
      isVerifying = true;
      isError = false;
    });

    await auth.verifyOtp(code);

    if (!mounted) return;

    setState(() => isVerifying = false);

    switch (auth.state) {
      case AuthState.waitingForProfile:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FirstNameScreen()),
        );
        break;

      case AuthState.loggedIn:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
        break;

      default:
        setState(() => isError = true);
    }
  }

  Future<void> _resend() async {
    if (isResending) return;
    setState(() => isResending = true);
    await context.read<AuthProvider>().requestOtp();
    if (!mounted) return;
    _controller.clear();
    setState(() {
      isResending = false;
      isError = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.watch<AuthProvider>().fullNumber;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => context.read<AuthProvider>().backToPhoneEntry(),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                isVerifying ? l10n.verifyingCode : l10n.enterOtpTitle,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 32,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                l10n.otpSentTo(phone),
                style: AppTextStyles.regular.copyWith(
                  fontSize: 16,
                  height: 1.2,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),

              const SizedBox(height: 35),

              // OTP BOX
              GestureDetector(
                onTap: () => _focusNode.requestFocus(),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Visible digits
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int index = 0; index < 6; index++) ...[
                            if (index > 0) const SizedBox(width: 40),
                            Text(
                              index < _controller.text.length
                                  ? _controller.text[index]
                                  : '-',
                              style: AppTextStyles.regular.copyWith(
                                fontSize: 25,
                                color: index < _controller.text.length
                                    ? Colors.black
                                    : Colors.black.withValues(alpha: 0.18),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Hidden textfield
                      Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          onChanged: (value) {
                            setState(() => isError = false);
                            if (value.length == 6) submitCode();
                          },
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            letterSpacing: 38,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isError) ...[
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    l10n.invalidOtp,
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],

              const Spacer(),

              // Resend text
              Center(
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.medium.copyWith(
                      fontSize: 13,
                      height: 1.2,
                      color: const Color(0xFF0066EE),
                    ),
                    children: [
                      TextSpan(text: l10n.didntReceiveCode),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: _resend,
                          child: Text(
                            isResending ? l10n.sending : l10n.resend,
                            style: AppTextStyles.medium.copyWith(
                              fontSize: 13,
                              height: 1.2,
                              color: const Color(0xFF0066EE),
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF0066EE),
                            ),
                          ),
                        ),
                      ),
                    ],
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
