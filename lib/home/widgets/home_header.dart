import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/providers/notifications_provider.dart';
import 'package:sayarti/home/screens/notifications_screen.dart';
import 'package:sayarti/home/widgets/home_search_bar.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';
import 'package:svg_flutter/svg.dart';

class HomeHeader extends StatelessWidget {
  final String? cityName;
  final VoidCallback? onSearchTap;
  const HomeHeader({super.key, this.cityName, this.onSearchTap});
  static const double height = 295;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final topPad = MediaQuery.of(context).padding.top;
    final extra = (topPad - 50).clamp(0.0, 80.0);
    return Container(
      height: 245 + extra,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // -------- SVG BACKGROUND --------
          Positioned.fill(
            child: SvgPicture.asset('assets/images/b.svg', fit: BoxFit.cover),
          ),
          Positioned(
            right: Directionality.of(context) == TextDirection.rtl ? null : -16,
            left: Directionality.of(context) == TextDirection.rtl ? -16 : null,
            bottom: -27,
            child: SizedBox(
              width: 214,
              height: 179,
              child: Image.asset(
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'assets/images/home_car_ar.png'
                    : 'assets/images/home_car.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            bottom: -25,
            left: 16,
            right: 16,
            child: HomeSearchBar(onTap: onSearchTap),
          ),
          // -------- CONTENT --------
          Padding(
            padding: EdgeInsets.fromLTRB(20, 50 + extra, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      cityName ?? l.nearby,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Spacer(),
                    Consumer<NotificationsProvider>(
                      builder: (context, notifs, _) => GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Color.fromARGB(255, 27, 27, 27),
                                size: 18,
                              ),
                            ),
                            if (notifs.unreadCount > 0)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF3B30),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  l.findYourNextCar,
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 34,
                    //height: 1.0,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Color(0x26000000),
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  l.browseTrustedDealers,
                  style: AppTextStyles.medium.copyWith(
                    fontSize: 16,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
