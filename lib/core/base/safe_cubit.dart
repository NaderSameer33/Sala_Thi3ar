import 'package:flutter_bloc/flutter_bloc.dart';

// abstract class BaseCubit<State> extends Cubit<State> {
//   BaseCubit(super.initialState);

//   @override
//   void emit(State state) {
//     if (!isClosed) {
//       super.emit(state);
//     }
//   }
// }

mixin SafeEmitMixin<State> on Cubit<State> {
  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
