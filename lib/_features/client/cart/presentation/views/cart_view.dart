import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../logic/cart_cubit.dart';
import '../../logic/cart_state.dart';
import '../components/cart_checkout_button.dart';
import '../components/cart_coupon_section.dart';
import '../components/cart_empty_state.dart';
import '../components/cart_header.dart';
import '../components/cart_items_list_section.dart';
import '../components/cart_summary_section.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: const _CartViewContent(),
    );
  }
}

class _CartViewContent extends StatefulWidget {
  const _CartViewContent();

  @override
  State<_CartViewContent> createState() => _CartViewContentState();
}

class _CartViewContentState extends State<_CartViewContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<CartCubit>();
        cubit.resetCouponStatus();
        cubit.getCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listenWhen: (prev, curr) =>
          curr.mutationMessage.isNotEmpty &&
          prev.mutationMessage != curr.mutationMessage,
      listener: (context, state) {
        if (state.mutationMessage.isNotEmpty) {
          toastification.show(
            context: context,
            title: Text(
              state.mutationMessage,
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      },
      child: const _CartViewBody(),
    );
  }
}

class _CartViewBody extends StatelessWidget {
  const _CartViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<CartCubit>().getCart(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CartHeader(),
                16.verticalSpacing,
                BlocBuilder<CartCubit, CartState>(
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.isEmpty != curr.isEmpty,
                  builder: (context, state) {
                    if (state.status == CartStatus.error &&
                        state.cartData == null) {
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                state.errorMessage.isNotEmpty
                                    ? state.errorMessage
                                    : 'فشل تحميل السلة',
                                style: AppStyles.font14RegularGray,
                              ),
                              12.verticalSpacing,
                              InkWell(
                                onTap: () =>
                                    context.read<CartCubit>().getCart(),
                                child: Text(
                                  'إعادة المحاولة',
                                  style: AppStyles.font14BoldPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state.status == CartStatus.success && state.isEmpty) {
                      return const CartEmptyState();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CartItemsListSection(),
                        20.verticalSpacing,
                        const CartCouponSection(),
                        20.verticalSpacing,
                        const CartSummarySection(),
                        24.verticalSpacing,
                        CartCheckoutButton(
                          onPressed: () =>
                              context.push(AppRouterName.completeOrder),
                        ),
                        30.verticalSpacing,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
