import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state.dart';

class LoadingButtonCubit extends Cubit<LoadingButtonState> {
  LoadingButtonCubit() : super(LoadingButtonInitialState());

  Future<void> execute({dynamic params, required Usecase usecase}) async {
    if (isClosed) return;

    emit(LoadingButtonLoadingState());

    try {
      Either result = await usecase.execute(request: params);

      if (isClosed) return;

      result.fold(
        (error) => emit(LoadingButtonFailureState(errorMessage: error.toString())),
        (data) => emit(LoadingButtonSuccessState(data: data)),
      );
    } catch (error) {
      if (isClosed) return;
      emit(LoadingButtonFailureState(errorMessage: error.toString()));
    }
  }
}
