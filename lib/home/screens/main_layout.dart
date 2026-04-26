import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/dealer/screens/dealer_listings_screen.dart';
import 'package:sayarti/home/providers/favorites_provider.dart';
import 'package:sayarti/home/screens/home_screen.dart';
import 'package:sayarti/home/screens/saved_cars_screen.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/profile/screens/profile_screen.dart';
import 'package:sayarti/search/screens/search_screen.dart';
import 'package:svg_flutter/svg.dart';
// import باقي الصفحات لاحقاً

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDealer = auth.user?.userType == 'showroom';
    final l = AppLocalizations.of(context)!;

    final pages = [
      HomeScreen(onSearchTap: () => setState(() => _currentIndex = 1)),
      const SearchScreen(),
      isDealer && auth.user != null ? DealerListingsScreen(showroomId: auth.user!.showroomId ?? auth.user!.id) : const FavoriteCarsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: pages.asMap().entries.map((entry) {
          final isActive = entry.key == _currentIndex;
          return AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: AnimatedScale(
              scale: isActive ? 1.0 : 0.97,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: IgnorePointer(
                ignoring: !isActive,
                child: entry.value,
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF0066EE),
          unselectedItemColor: const Color(0xFF868686),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'FunnelDisplay',
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 1.0,
            color: Color(0xFF1B1B1B),
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'FunnelDisplay',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            height: 1.0,
            color: Color(0xFF868686),
          ),
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 2 && !isDealer) {
              context.read<FavoritesProvider>().loadFavorites(reset: true);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SvgPicture.asset('assets/images/home.svg', fit: BoxFit.contain),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SvgPicture.asset('assets/images/active_home.svg', fit: BoxFit.contain),
              ),
              label: l.home,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SvgPicture.asset('assets/images/search.svg', fit: BoxFit.contain, width: 20, height: 20),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SvgPicture.asset('assets/images/active_search.svg', fit: BoxFit.contain, width: 20, height: 20),
              ),
              label: l.search,
            ),
            isDealer
                ? BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SvgPicture.asset(
                        'assets/images/posts.svg',
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(Color(0xFF868686), BlendMode.srcIn),
                      ),
                    ),
                    activeIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SvgPicture.asset('assets/images/posts.svg', fit: BoxFit.contain),
                    ),
                    label: l.yourPosts,
                  )
                : BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SvgPicture.asset('assets/images/saved.svg', fit: BoxFit.contain),
                    ),
                    activeIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SvgPicture.asset('assets/images/active_saved.svg', fit: BoxFit.contain),
                    ),
                    label: l.saved,
                  ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SvgPicture.asset('assets/images/profile.svg', fit: BoxFit.contain),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SvgPicture.asset('assets/images/active_profile.svg', fit: BoxFit.contain),
              ),
              label: l.profile,
            ),
          ],
        ),
        ),
      ),
    );
  }
}
