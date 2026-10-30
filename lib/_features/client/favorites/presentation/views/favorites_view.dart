import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../components/favorites_empty_state.dart';
import '../components/favorites_grid.dart';
import '../components/favorites_header.dart';
import '../../logic/favorites_cubit.dart';
import '../../logic/favorites_state.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesCubit>().getFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<FavoritesCubit>().getFavorites(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FavoritesHeader(),
                12.verticalSpacing,
                BlocBuilder<FavoritesCubit, FavoritesState>(
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.favorites.length != curr.favorites.length,
                  builder: (context, state) {
                    if (state.status == FavoritesStatus.success &&
                        state.favorites.isEmpty) {
                      return const FavoritesEmptyState();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FavoritesGrid(),
                        24.verticalSpacing,
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
