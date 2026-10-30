import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../logic/cart_cubit.dart';
import '../../logic/cart_state.dart';
import 'cart_item_card.dart';

class CartItemsListSection extends StatelessWidget {
  const CartItemsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final isLoading = state.status == CartStatus.loading && state.cartData == null;
        final items = isLoading
            ? cubit.dummyCartData.items
            : (state.cartData?.items ?? []);

        return Skeletonizer(
          enabled: isLoading,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemCard(
                key: ValueKey(item.id),
                item: item,
                isLoading: isLoading,
              );
            },
          ),
        );
      },
    );
  }
}

