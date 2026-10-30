import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/wallet_transaction_model.dart';
import '../../logic/wallet_cubit.dart';
import '../../logic/wallet_state.dart';
import '../components/wallet_balance_card.dart';
import '../components/wallet_charge_dashed_button.dart';
import '../components/wallet_transaction_item.dart';
import '../components/wallet_transactions_header.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<WalletCubit>()..getWallet(),
      child: const _WalletViewBody(),
    );
  }
}

class _WalletViewBody extends StatelessWidget {
  const _WalletViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WalletCubit>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'المحفظة',
          style: AppStyles.font18BoldPrimary,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          final transactions = state.recentTransactions;

          return RefreshIndicator(
            onRefresh: () => cubit.getWallet(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  Skeletonizer(
                    enabled: state.isWalletLoading,
                    child: WalletBalanceCard(
                      balance: state.walletBalance,
                    ),
                  ),
                  18.verticalSpacing,
                  WalletChargeDashedButton(
                    onTap: () async {
                      await context.push(AppRouterName.chargeWallet);
                      if (context.mounted) {
                        cubit.getWallet();
                      }
                    },
                  ),
                  24.verticalSpacing,
                  WalletTransactionsHeader(
                    onSeeAllTap: () {
                      context.push(AppRouterName.transactionsHistory);
                    },
                  ),
                  14.verticalSpacing,
                  if (state.isWalletLoading && transactions.isEmpty)
                    Skeletonizer(
                      enabled: true,
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: const WalletTransactionItem(
                              transaction: WalletTransactionModel.dummy,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (transactions.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      separatorBuilder: (context, index) => 12.verticalSpacing,
                      itemBuilder: (context, index) => WalletTransactionItem(
                        transaction: transactions[index],
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Text(
                          'لا توجد معاملات حالياً',
                          style: AppStyles.font14RegularGray,
                        ),
                      ),
                    ),
                  20.verticalSpacing,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

