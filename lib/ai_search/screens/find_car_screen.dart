import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/screens/car_type_preference_screen.dart';
import 'package:sayarti/home/screens/main_layout.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class FindCarScreen extends StatelessWidget {
  const FindCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF4C99FF),
      body: SafeArea(
        child: Stack(
          children: [

            // ====================== CAR IMAGE ======================
            Positioned(
              top: 325,
              left: -22,
              child: Image.asset(
                "assets/images/car.png",
                fit: BoxFit.contain,
                width: 630,
                height: 288,
              ),
            ),

            // ====================== CONTENT ======================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE + CLOSE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          l.findingRightCar,
                          style: const TextStyle(
                            fontSize: 34.2,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainLayout()),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 19),

                  // SUBTITLE
                  Text(
                    l.findCarSubtitle,
                    style: const TextStyle(
                      fontSize: 19.7,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFE9E9E9),
                      height: 1.21,
                    ),
                  ),

                  const Spacer(),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CarTypePreferenceScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066EE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.33),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l.findYourPerfectCar,
                        style: const TextStyle(
                          color: Color(0xFFFBEDEA),
                          fontSize: 16.23,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
