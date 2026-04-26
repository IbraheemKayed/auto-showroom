import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/auth/screens/enter_phone_screen.dart';
import 'package:sayarti/auth/screens/first_name_screen.dart';
import 'package:sayarti/auth/screens/otp.dart';
import 'package:sayarti/auth/screens/welcome_screen.dart';
import 'package:sayarti/home/screens/main_layout.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Widget _lastScreen = const EnterPhoneScreen();
  bool _welcomeShown = false;
  bool _prefLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadWelcomeFlag();
  }

  Future<void> _loadWelcomeFlag() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _welcomeShown = prefs.getBool('welcome_shown') ?? false;
        _prefLoaded = true;
      });
    }
  }

  Future<void> _onWelcomeContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome_shown', true);
    if (mounted) setState(() => _welcomeShown = true);
  }

  Future<void> _clearWelcomeFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('welcome_shown');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        if (auth.state == AuthState.loading) return _lastScreen;

        Widget screen;
        if (auth.state == AuthState.loggedIn) {
          if (!_prefLoaded) return _lastScreen;
          screen = _welcomeShown
              ? const MainLayout()
              : WelcomeScreen(onContinue: _onWelcomeContinue);
        } else {
          // Reset welcome flag on logout so next login shows it again
          if (_welcomeShown) {
            _welcomeShown = false;
            _clearWelcomeFlag();
          }
          screen = switch (auth.state) {
            AuthState.waitingForOtp => const OtpScreen(),
            AuthState.loggedOut => const EnterPhoneScreen(),
            AuthState.waitingForProfile => const FirstNameScreen(),
            AuthState.waitingForAdminPassword => const Placeholder(),
            _ => _lastScreen,
          };
        }

        _lastScreen = screen;
        return screen;
      },
    );
  }
}
