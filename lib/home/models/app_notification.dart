class AppNotification {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;      // avatar_image_path — main circle image
  final String? iconImageUrl;  // icon_image_path   — small overlay badge
  final DateTime createdAt;
  final bool isRead;
  final String type; // notification code

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.iconImageUrl,
    required this.createdAt,
    required this.isRead,
    required this.type,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final nested = json['notification'] as Map<String, dynamic>?;

    String? str(dynamic v) {
      final s = v as String?;
      return (s != null && s.isNotEmpty) ? s : null;
    }

    return AppNotification(
      id: json['id'] as int,
      title: (nested?['title'] as String?) ?? '',
      body: (nested?['body'] as String?) ?? '',
      imageUrl: str(nested?['avatar_image_path']),
      iconImageUrl: str(nested?['icon_image_path']),
      createdAt: DateTime.tryParse(json['added_at'] as String? ?? '') ?? DateTime.now(),
      isRead: (json['status'] as String?) == 'READ',
      type: (nested?['code'] as String?) ?? 'system',
    );
  }

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        imageUrl: imageUrl,
        iconImageUrl: iconImageUrl,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        type: type,
      );
}
