abstract class LoadingButtonState {}

class LoadingButtonInitialState extends LoadingButtonState {}

class LoadingButtonLoadingState extends LoadingButtonState {}

class LoadingButtonSuccessState extends LoadingButtonState {
  final dynamic data;

  LoadingButtonSuccessState({required this.data});
}

class LoadingButtonFailureState extends LoadingButtonState {
  final String errorMessage;

  LoadingButtonFailureState({required this.errorMessage});
}
