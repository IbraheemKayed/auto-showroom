import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/ai_search/providers/preferences_provider.dart';
import 'package:sayarti/ai_search/screens/search_results_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _orbitCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _dotsCtrl;

  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    // Orbit rotation
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    // Center bubble pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Animated dots "..."
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    Future.microtask(() async {
      final provider = context.read<PreferencesProvider>(); // ignore: use_build_context_synchronously
      await Future.wait([
        provider.searchCars(),
        Future.delayed(const Duration(seconds: 2)),
      ]);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
      );
    });
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _pulseCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF4C99FF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // ── Animation area ──────────────────────────────────────────
            AnimatedBuilder(
              animation: Listenable.merge([_orbitCtrl, _pulseCtrl]),
              builder: (context, _) {
                final angle = _orbitCtrl.value * 2 * pi;
                const orbitR = 105.0;

                return SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Faint orbit ring
                      Container(
                        width: orbitR * 2 + 64,
                        height: orbitR * 2 + 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 1.5,
                          ),
                        ),
                      ),

                      // Outer glow ring
                      Container(
                        width: orbitR * 2 + 30,
                        height: orbitR * 2 + 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),

                      // Orbiting car 1 (large)
                      _orbitBubble(
                        'assets/images/step1_car.png',
                        angle: angle,
                        orbitRadius: orbitR,
                        size: 68,
                        padding: 10,
                      ),

                      // Orbiting car 2 (medium)
                      _orbitBubble(
                        'assets/images/step2_car.png',
                        angle: angle + 2 * pi / 3,
                        orbitRadius: orbitR,
                        size: 60,
                        padding: 9,
                      ),

                      // Orbiting car 3 (small)
                      _orbitBubble(
                        'assets/images/step3_car.png',
                        angle: angle + 4 * pi / 3,
                        orbitRadius: orbitR,
                        size: 54,
                        padding: 8,
                      ),

                      // Center pulse ring
                      Transform.scale(
                        scale: _pulseAnim.value * 1.0,
                        child: Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                      ),

                      // Center bubble
                      Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 20,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          'assets/images/home_car.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 36),

            // ── Text ────────────────────────────────────────────────────
            AnimatedBuilder(
              animation: _dotsCtrl,
              builder: (context, _) {
                final dots = '.' * ((_dotsCtrl.value * 3).floor() + 1);
                return Text(
                  '${l.searching}$dots',
                  style: const TextStyle(
                    fontFamily: 'FunnelDisplay',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            Text(
              l.searchingSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'FunnelDisplay',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                height: 1.5,
              ),
            ),

          ],
        ),
      ),
    ));
  }

  Widget _orbitBubble(
    String asset, {
    required double angle,
    required double orbitRadius,
    required double size,
    required double padding,
  }) {
    final dx = orbitRadius * cos(angle);
    final dy = orbitRadius * sin(angle);
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(padding),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}
