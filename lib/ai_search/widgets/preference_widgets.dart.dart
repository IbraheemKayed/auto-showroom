// preference_widgets.dart
import 'package:flutter/material.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';

class PreferenceProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const PreferenceProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final step = index + 1;
        final isActive = step <= currentStep;
        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsetsDirectional.only(
              end: step == totalSteps ? 0 : 6,
            ),
            decoration: BoxDecoration(
              color: isActive ? Colors.blue : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      }),
    );
  }
}

class PreferenceOptionCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing;
  final double minHeight;

  const PreferenceOptionCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.trailing,
    this.minHeight = 73,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(minHeight: minHeight),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF3FF) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(13.33),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'FunnelDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: 15.56,
                      height: 1.0,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontFamily: 'FunnelDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.33,
                        height: 1.152,
                        color: Color(0xFF545655),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class PreferenceListSkeleton extends StatelessWidget {
  final int count;
  const PreferenceListSkeleton({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: count,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(minHeight: 106),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(13.33),
          ),
          child: Row(
            children: [
              const SkeletonBox(width: 40, height: 40, borderRadius: 10),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(height: 14, width: double.infinity),
                    SizedBox(height: 6),
                    SkeletonBox(height: 12, width: 200),
                    SizedBox(height: 4),
                    SkeletonBox(height: 12, width: 150),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onNext;
  final bool nextEnabled;

  const BottomNavButtons({
    super.key,
    required this.onBack,
    required this.onNext,
    this.nextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFC8D2CC), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: onBack,
              child: Text(
                l.back,
                style: const TextStyle(
                  fontFamily: 'FunnelDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.67,
                  height: 1.0,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    nextEnabled ? const Color(0xFF0066EE) : Colors.grey.shade300,
                minimumSize: const Size(0, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: nextEnabled ? onNext : null,
              child: Text(
                l.next,
                style: const TextStyle(
                  fontFamily: 'FunnelDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.2,
                  height: 1.0,
                  color: Color(0xFFFCF1EF),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
