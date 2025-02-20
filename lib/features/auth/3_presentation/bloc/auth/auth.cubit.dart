import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/is-logged-in.usercase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/login-with-google.usecase.dart';
import 'package:le_spawn_fr/features/auth/3_presentation/bloc/auth/auth.state.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoadingState());

  void appStarted() async {
    final isLoggedIn = await serviceLocator<IsLoggedInUsecase>().execute();

    if (isLoggedIn) {
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoadingState());
    final result = await serviceLocator<LoginWithGoogleUsecase>().execute();
    result.fold(
      (errorMessage) => emit(UnauthenticatedState(errorMessage: errorMessage)),
      (data) => emit(AuthenticatedState(user: data.user, isFirstTime: data.isFirstTime)),
    );
  }
}
