import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';
import 'package:sala_thimar/_features/client/home/data/repos/home_repo.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  List<SliderModel> sliders = [];

  HomeCubit(this.homeRepo) : super(HomeInitial());

  Future<void> getSliders() async {
    emit(HomeSlidersLoading());

    final result = await homeRepo.getSliders();

    result.fold(
      (failure) => emit(HomeSlidersError(failure.message)),
      (slidersList) {
        sliders = slidersList;
        emit(HomeSlidersSuccess(slidersList));
      },
    );
  }
}
