import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../logic/cart_cubit.dart';
import '../../logic/cart_state.dart';
import '../components/cart_checkout_button.dart';
import '../components/cart_coupon_section.dart';
import '../components/cart_empty_state.dart';
import '../components/cart_header.dart';
import '../components/cart_items_list_section.dart';
import '../components/cart_summary_section.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
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
    return const _CartViewBody();
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
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: AppColors.textLightGray,
                                ),
                              ),
                              12.verticalSpacing,
                              InkWell(
                                onTap: () =>
                                    context.read<CartCubit>().getCart(),
                                child: const Text(
                                  'إعادة المحاولة',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          onPressed: () {},
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
