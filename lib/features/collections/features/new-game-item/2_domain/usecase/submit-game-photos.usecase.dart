import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/dto/submit-game-photos.request.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/2_domain/repository/new-game-item.repository.dart';

class SubmitGamePhotosUsecase implements Usecase<Either<String, void>, SubmitGamePhotosRequest> {
  @override
  Future<Either<String, void>> execute({
    SubmitGamePhotosRequest? request,
  }) async {
    return serviceLocator<NewGameItemRepository>().submitGamePhotos(request!);
  }
}
