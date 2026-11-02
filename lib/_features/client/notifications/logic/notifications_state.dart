import 'package:equatable/equatable.dart';
import '../data/models/notification_model.dart';

enum NotificationsStatus { initial, loading, success, error }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationItemModel> notifications;
  final int unreadCount;
  final String errorMessage;
  final String? successMessage;
  final bool isDeleting;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage = '',
    this.successMessage,
    this.isDeleting = false,
  });

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItemModel>? notifications,
    int? unreadCount,
    String? errorMessage,
    String? successMessage,
    bool? isDeleting,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        unreadCount,
        errorMessage,
        successMessage,
        isDeleting,
      ];
}

