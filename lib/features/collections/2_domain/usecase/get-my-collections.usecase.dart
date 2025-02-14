import 'package:dartz/dartz.dart';
import 'package:le_spawn_frontend/core/usecase/usecase.dart';
import 'package:le_spawn_frontend/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_frontend/service-locator.dart';

class GetMyCollectionsUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> execute({
    dynamic request,
  }) async {
    return serviceLocator<CollectionsRepository>().getMyCollections();
  }
}
