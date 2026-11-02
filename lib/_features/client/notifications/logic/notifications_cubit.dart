import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/notification_model.dart';
import '../data/repos/notifications_repo.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo repo;

  NotificationsCubit(this.repo) : super(const NotificationsState());

  Future<void> getNotifications({bool refresh = false}) async {
    if (!refresh && state.status == NotificationsStatus.loading) return;

    if (!refresh && state.notifications.isEmpty) {
      emit(state.copyWith(status: NotificationsStatus.loading));
    }

    final result = await repo.getNotifications();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: data.notifications,
            unreadCount: data.unreadCount,
            errorMessage: '',
          ),
        );
      },
    );
  }

  Future<void> deleteNotification(String id) async {
    final previousList = List<NotificationItemModel>.from(state.notifications);
    final updatedList = state.notifications.where((n) => n.id != id).toList();

    emit(
      state.copyWith(
        notifications: updatedList,
        isDeleting: true,
      ),
    );

    final result = await repo.deleteNotification(id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            notifications: previousList,
            isDeleting: false,
            errorMessage: failure.message,
          ),
        );
      },
      (msg) {
        emit(
          state.copyWith(
            isDeleting: false,
            successMessage: msg,
          ),
        );
      },
    );
  }

  Future<void> clearAllNotifications() async {
    final previousList = List<NotificationItemModel>.from(state.notifications);

    emit(
      state.copyWith(
        notifications: const [],
        isDeleting: true,
      ),
    );

    final result = await repo.clearAllNotifications();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            notifications: previousList,
            isDeleting: false,
            errorMessage: failure.message,
          ),
        );
      },
      (msg) {
        emit(
          state.copyWith(
            isDeleting: false,
            successMessage: msg,
          ),
        );
      },
    );
  }
}

