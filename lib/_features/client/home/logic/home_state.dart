import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeSlidersLoading extends HomeState {}

class HomeSlidersSuccess extends HomeState {
  final List<SliderModel> sliders;

  const HomeSlidersSuccess(this.sliders);

  @override
  List<Object?> get props => [sliders];
}

class HomeSlidersError extends HomeState {
  final String message;

  const HomeSlidersError(this.message);

  @override
  List<Object?> get props => [message];
}
