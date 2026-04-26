import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayarti/home/models/app_notification.dart';
import 'package:sayarti/home/providers/notifications_provider.dart';
import 'package:sayarti/home/widgets/skeleton_box.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:sayarti/theme/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<NotificationsProvider>();
      await provider.load();
      await provider.markAllRead();
    });
  }

  // Groups notifications into date-labelled buckets
  Map<String, List<AppNotification>> _grouped(
      List<AppNotification> list, AppLocalizations l) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final result = <String, List<AppNotification>>{};

    for (final n in list) {
      final d = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      final String key;
      if (d == today) {
        key = l.today;
      } else if (d == yesterday) {
        key = l.yesterday;
      } else {
        key = DateFormat('d MMMM yyyy', l.localeName).format(n.createdAt);
      }
      (result[key] ??= []).add(n);
    }
    return result;
  }

  String _relativeTime(DateTime dt, AppLocalizations l) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return l.justNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${l.minutesAgo}';
    if (diff.inHours < 24) return '${diff.inHours} ${l.hoursAgo}';
    return DateFormat('d MMM', l.localeName).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: const TextStyle(color: Color(0xFF1B1B1B), fontWeight: FontWeight.w500, fontSize: 16, height: 1.0),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const _NotificationsSkeleton()
          : RefreshIndicator(
              color: const Color(0xFF0066EE),
              onRefresh: () => provider.load(),
              child: provider.notifications.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        _buildEmpty(context),
                      ],
                    )
                  : _buildList(context, provider.notifications),
            ),
    );
  }

  // ─── Empty state ───────────────────────────────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/notifications.png',
              width: 180,
              height: 180,
            ),

            const SizedBox(height: 20),

            Text(
              l.noNotifications,
              style: AppTextStyles.medium.copyWith(
                fontSize: 16,
                height: 1.0,
                color: const Color(0xFF1B1B1B),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              l.notificationsPlaceholder,
              style: AppTextStyles.regular.copyWith(
                fontSize: 14,
                height: 1.4,
                color: const Color(0xFF868686),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Grouped list ──────────────────────────────────────────────────────────
  Widget _buildList(BuildContext context, List<AppNotification> notifications) {
    final l = AppLocalizations.of(context)!;
    final grouped = _grouped(notifications, l);
    final sections = grouped.entries.toList();

    // Build a flat item list: [header, item, item, header, item, ...]
    final items = <Object>[];
    for (final s in sections) {
      items.add(s.key); // String = section header
      items.addAll(s.value); // AppNotification = tile
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is String) return _buildDateHeader(item);
        return _buildTile(context, item as AppNotification);
      },
    );
  }

  Widget _buildDateHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1B1B1B),
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, AppNotification n) {
    final l = AppLocalizations.of(context)!;
    return Container(
      color: n.isRead ? Colors.white : const Color(0xFFF5F5F7),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(n),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF1B1B1B),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  n.body,
                  style: const TextStyle(
                    color: Color(0xFF868686),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _relativeTime(n.createdAt, l),
                  style: const TextStyle(color: Color(0xFF6B6C6E), fontSize: 12, fontWeight: FontWeight.w500, height: 1.4),
                ),
              ],
            ),
          ),
          if (!n.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF0066EE),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(AppNotification n) {
    final hasIcon = n.iconImageUrl != null && n.iconImageUrl!.isNotEmpty;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Main circle ──────────────────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF0066EE),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: n.imageUrl != null && n.imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: n.imageUrl!,
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.notifications_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                : const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
          ),

          // ── Icon overlay badge (bottom-right) ────────────────────
          if (hasIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: CachedNetworkImage(
                    imageUrl: n.iconImageUrl!,
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Notifications Skeleton ──────────────────────────────────────────────────

class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Row(
          children: [
            const SkeletonBox(height: 44, width: 44, borderRadius: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(height: 14, width: double.infinity),
                  SizedBox(height: 6),
                  SkeletonBox(height: 12, width: 180),
                  SizedBox(height: 4),
                  SkeletonBox(height: 10, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
