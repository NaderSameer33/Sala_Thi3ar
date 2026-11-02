class NotificationItemModel {
  final String id;
  final String title;
  final String body;
  final String notifyType;
  final int? orderId;
  final String? orderStatus;
  final String createdAt;
  final String? readAt;
  final String image;

  const NotificationItemModel({
    required this.id,
    this.title = '',
    this.body = '',
    this.notifyType = '',
    this.orderId,
    this.orderStatus,
    this.createdAt = '',
    this.readAt,
    this.image = '',
  });

  bool get isRead => readAt != null && readAt!.isNotEmpty;

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    int? parsedOrderId;
    String? parsedOrderStatus;

    final orderJson = json['order'];
    if (orderJson is Map<String, dynamic>) {
      parsedOrderId = int.tryParse(orderJson['order_id']?.toString() ?? '');
      parsedOrderStatus = orderJson['order_status']?.toString();
    }

    return NotificationItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      notifyType: json['notify_type']?.toString() ?? '',
      orderId: parsedOrderId,
      orderStatus: parsedOrderStatus,
      createdAt: json['created_at']?.toString() ?? '',
      readAt: json['read_at']?.toString(),
      image: json['image']?.toString() ?? '',
    );
  }
}

class NotificationsResponseModel {
  final int unreadCount;
  final List<NotificationItemModel> notifications;

  const NotificationsResponseModel({
    this.unreadCount = 0,
    this.notifications = const [],
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final list = <NotificationItemModel>[];
    final rawNotifications = json['notifications'];
    if (rawNotifications is List) {
      for (final item in rawNotifications) {
        if (item is Map<String, dynamic>) {
          list.add(NotificationItemModel.fromJson(item));
        }
      }
    }

    final count = int.tryParse(
          json['unreadnotifications_count']?.toString() ?? '0',
        ) ??
        0;

    return NotificationsResponseModel(
      unreadCount: count,
      notifications: list,
    );
  }
}

