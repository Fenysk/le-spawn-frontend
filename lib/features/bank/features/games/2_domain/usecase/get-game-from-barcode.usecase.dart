import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class GetGameFromBarcodeUsecase implements Usecase<Either, String?> {
  @override
  Future<Either> execute({
    String? request,
  }) async {
    return serviceLocator<GamesRepository>().getGameFromBarcode(request);
  }
}
