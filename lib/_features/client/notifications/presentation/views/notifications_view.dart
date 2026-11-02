import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../logic/notifications_cubit.dart';
import '../../logic/notifications_state.dart';
import '../components/notification_item_card.dart';
import '../components/notifications_empty_view.dart';
import '../components/notifications_shimmer.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..getNotifications(),
      child: const _NotificationsViewBody(),
    );
  }
}

class _NotificationsViewBody extends StatelessWidget {
  const _NotificationsViewBody();

  void _showClearAllConfirmDialog(BuildContext context, NotificationsCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'مسح الإشعارات',
            style: AppStyles.font16BoldDark,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في مسح جميع الإشعارات؟',
            style: AppStyles.font14RegularDark,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'تراجع',
                style: AppStyles.font14RegularGray,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                cubit.clearAllNotifications();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'مسح الكل',
                style: AppStyles.font14BoldWhite,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإشعارات',
          style: AppStyles.font18BoldPrimary,
        ),
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            buildWhen: (prev, curr) => prev.notifications.length != curr.notifications.length,
            builder: (context, state) {
              if (state.notifications.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                tooltip: 'مسح الكل',
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  color: AppColors.red,
                  size: 24.r,
                ),
                onPressed: () => _showClearAllConfirmDialog(context, cubit),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationsCubit, NotificationsState>(
        listenWhen: (prev, curr) =>
            curr.errorMessage.isNotEmpty ||
            (curr.successMessage != null && curr.successMessage!.isNotEmpty),
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            showToast(
              context: context,
              message: state.errorMessage,
              isError: true,
            );
          } else if (state.successMessage != null && state.successMessage!.isNotEmpty) {
            showToast(
              context: context,
              message: state.successMessage!,
              isError: false,
            );
          }
        },
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading && state.notifications.isEmpty) {
            return const NotificationsShimmer();
          }

          if (state.status == NotificationsStatus.error && state.notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.r,
                      color: AppColors.red,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      state.errorMessage.isNotEmpty
                          ? state.errorMessage
                          : 'حدث خطأ في تحميل الإشعارات',
                      style: AppStyles.font14RegularDark,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => cubit.getNotifications(refresh: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'إعادة المحاولة',
                        style: AppStyles.font14BoldWhite,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return NotificationsEmptyView(
              onRefresh: () => cubit.getNotifications(refresh: true),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => cubit.getNotifications(refresh: true),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final item = state.notifications[index];
                return NotificationItemCard(
                  notification: item,
                  onDelete: () => cubit.deleteNotification(item.id),
                  onTap: () {
                    if (item.orderId != null) {
                      context.push(
                        AppRouterName.orderDetails,
                        extra: item.orderId,
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
