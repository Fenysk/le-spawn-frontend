import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/dto/submit-game-photos.request.dart';

abstract class NewGameItemRepository {
  Future<Either<String, void>> submitGamePhotos(SubmitGamePhotosRequest dto);
}
