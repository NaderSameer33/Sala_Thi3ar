import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/order_model.dart';
import '../../logic/orders_cubit.dart';
import '../../logic/orders_state.dart';
import '../components/order_item_card.dart';
import '../components/orders_toggle_tab_bar.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<OrdersCubit>()..getCurrentOrders(),
      child: const _MyOrdersViewBody(),
    );
  }
}

class _MyOrdersViewBody extends StatelessWidget {
  const _MyOrdersViewBody();

  static const _dummyOrders = [
    OrderModel(
      id: 4587,
      status: 'pending',
      statusTranslated: 'بإنتظار الموافقة',
      date: '27 يونيو, 2021',
      totalPrice: 180,
    ),
    OrderModel(
      id: 4586,
      status: 'in_prep',
      statusTranslated: 'جاري التحضير',
      date: '27 يونيو, 2021',
      totalPrice: 180,
    ),
    OrderModel(
      id: 4585,
      status: 'delivering',
      statusTranslated: 'في الطريق',
      date: '27 يونيو, 2021',
      totalPrice: 180,
    ),
    OrderModel(
      id: 4584,
      status: 'finished',
      statusTranslated: 'منتهي',
      date: '27 يونيو, 2021',
      totalPrice: 180,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'طلباتي',
          style: AppStyles.font18BoldPrimary,
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final isLoading = state.isLoading;
          final orders = isLoading ? _dummyOrders : state.displayedOrders;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 12.h),
                OrdersToggleTabBar(
                  activeTab: state.activeTab,
                  onTabChanged: (tab) => cubit.changeTab(tab),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => cubit.refresh(),
                    child: Skeletonizer(
                      enabled: isLoading,
                      child: (!isLoading && orders.isEmpty)
                          ? Center(
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 72.r,
                                      color: AppColors.textLightGray,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      state.activeTab == OrdersTab.current
                                          ? 'لا توجد طلبات حالية'
                                          : 'لا توجد طلبات منتهية',
                                      style: AppStyles.font16BoldDark.copyWith(
                                        color: AppColors.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.only(bottom: 24.h),
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                return OrderItemCard(order: orders[index]);
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
