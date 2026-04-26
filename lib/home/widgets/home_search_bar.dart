import 'package:flutter/material.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/search/screens/search_screen.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      borderRadius: BorderRadius.circular(48),
      child: InkWell(
        borderRadius: BorderRadius.circular(48),
        onTap: onTap ??
            () {
              // مثال على التنقل
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  const SearchScreen(),
                ),
              );
            },
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(48),
            border: Border.all(
              color: const Color(0xFFD1D1D1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5.95),
                blurRadius: 11.91,
                spreadRadius: 0,
                color: Color.fromARGB(20, 10, 13, 18)
              )
            ]
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black54),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.whatAreYouLookingFor,
                style: const TextStyle(
                  fontFamily: 'FunnelDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.0,
                  color: Color(0xFF868686),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
