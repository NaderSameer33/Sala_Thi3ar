import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/wallet_transaction_model.dart';
import '../../logic/wallet_cubit.dart';
import '../../logic/wallet_state.dart';
import '../components/wallet_transaction_item.dart';

class TransactionsHistoryView extends StatelessWidget {
  const TransactionsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<WalletCubit>()..getWalletTransactions(),
      child: const _TransactionsHistoryViewBody(),
    );
  }
}

class _TransactionsHistoryViewBody extends StatelessWidget {
  const _TransactionsHistoryViewBody();

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
          'سجل المعاملات',
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
          final transactions = state.allTransactions;

          return RefreshIndicator(
            onRefresh: () => cubit.getWalletTransactions(),
            color: AppColors.primary,
            child: state.isTransactionsLoading && transactions.isEmpty
                ? Skeletonizer(
                    enabled: true,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      itemCount: 5,
                      separatorBuilder: (context, index) => 12.verticalSpacing,
                      itemBuilder: (context, index) => const WalletTransactionItem(
                        transaction: WalletTransactionModel.dummy,
                      ),
                    ),
                  )
                : transactions.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) => 12.verticalSpacing,
                        itemBuilder: (context, index) => WalletTransactionItem(
                          transaction: transactions[index],
                        ),
                      )
                    : Center(
                        child: Text(
                          'لا توجد معاملات حالياً',
                          style: AppStyles.font14RegularGray,
                        ),
                      ),
          );
        },
      ),
    );
  }
}

