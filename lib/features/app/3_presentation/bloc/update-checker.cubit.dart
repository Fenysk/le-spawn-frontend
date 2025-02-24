import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/features/app/2_domain/usecase/check-update.usecase.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'update-checker.state.dart';

class UpdateCheckerCubit extends Cubit<UpdateCheckerState> {
  UpdateCheckerCubit() : super(UpdateCheckerInitialState());

  Future<void> checkForUpdate() async {
    emit(UpdateCheckerLoadingState());

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final result = await serviceLocator<CheckUpdateUseCase>().execute(request: currentVersion);
      result.fold(
        (failure) => emit(UpdateCheckerNeedUpdateState(message: failure.toString())),
        (_) => emit(UpdateCheckerGoodVersionState()),
      );
    } catch (e) {
      emit(UpdateCheckerNeedUpdateState(message: e.toString()));
    }
  }
}
