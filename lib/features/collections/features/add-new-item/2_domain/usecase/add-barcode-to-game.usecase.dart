import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-barcode-to-game.request.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/repository/new-item.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AddBarcodeToGameUsecase implements Usecase<Either<String, GameEntity>, AddBarcodeToGameRequest> {
  @override
  Future<Either<String, GameEntity>> execute({
    AddBarcodeToGameRequest? request,
  }) async {
    return serviceLocator<NewItemRepository>().addBarcodeToGame(request!);
  }
}
