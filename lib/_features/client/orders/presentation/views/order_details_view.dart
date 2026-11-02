import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../../data/models/order_model.dart';
import '../../logic/order_details_cubit.dart';
import '../../logic/order_details_state.dart';
import '../components/order_details_address_card.dart';
import '../components/order_details_bottom_action.dart';
import '../components/order_details_header.dart';
import '../components/order_details_info_card.dart';
import '../components/order_details_summary_card.dart';

class OrderDetailsView extends StatelessWidget {
  final int orderId;
  final OrderModel? initialOrder;

  const OrderDetailsView({
    super.key,
    required this.orderId,
    this.initialOrder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderDetailsCubit>()..init(orderId, initialOrder),
      child: const _OrderDetailsViewBody(),
    );
  }
}

class _OrderDetailsViewBody extends StatelessWidget {
  const _OrderDetailsViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
          listener: (context, state) {
            if (state.cancelStatus == OrderCancelStatus.success) {
              showToast(
                context: context,
                message: state.cancelMessage.isNotEmpty
                    ? state.cancelMessage
                    : 'تم إلغاء الطلب بنجاح',
              );
              context.read<OrderDetailsCubit>().resetCancelStatus();
            } else if (state.cancelStatus == OrderCancelStatus.error) {
              showToast(
                context: context,
                message: state.errorMessage.isNotEmpty
                    ? state.errorMessage
                    : 'فشل إلغاء الطلب',
                isError: true,
              );
              context.read<OrderDetailsCubit>().resetCancelStatus();
            }
          },
          builder: (context, state) {
            final order = state.orderDetails;

            if (state.status == OrderDetailsStatus.loading && order == null) {
              return Column(
                children: [
                  const OrderDetailsHeader(),
                  const Expanded(
                    child: Center(
                      child: AppLoading(),
                    ),
                  ),
                ],
              );
            }

            if (order == null) {
              return Column(
                children: [
                  const OrderDetailsHeader(),
                  Expanded(
                    child: Center(
                      child: Text(
                        state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : 'فشل تحميل تفاصيل الطلب',
                      ),
                    ),
                  ),
                ],
              );
            }

            final cubit = context.read<OrderDetailsCubit>();
            final isCanceling = state.cancelStatus == OrderCancelStatus.loading;

            return Column(
              children: [
                const OrderDetailsHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OrderDetailsInfoCard(order: order),
                        18.verticalSpacing,
                        OrderDetailsAddressCard(order: order),
                        18.verticalSpacing,
                        OrderDetailsSummaryCard(order: order),
                        20.verticalSpacing,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                  child: OrderDetailsBottomAction(
                    order: order,
                    isLoading: isCanceling,
                    onCancelOrder: () => cubit.cancelOrder(order.id),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

