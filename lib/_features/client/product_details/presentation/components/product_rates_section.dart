import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/rate_list_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sala_thimar/_features/client/product_details/data/models/product_rate_model.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_cubit.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class ProductRatesSection extends StatelessWidget {
  const ProductRatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (prev, curr) =>
          prev.ratesStatus != curr.ratesStatus || prev.rates != curr.rates,
      builder: (context, state) {
        final cubit = context.read<ProductDetailsCubit>();
        final isLoading =
            state.ratesStatus == ProductDetailsStateStatus.loading;

        if (!isLoading && state.rates.isEmpty) {
          return const SizedBox.shrink();
        }

        final rates = isLoading ? cubit.dummyRates : state.rates;

        return Skeletonizer(
          enabled: isLoading,
          child: RateListView(isLoading: isLoading, rates: rates)
        );
      },
    );
  }

}