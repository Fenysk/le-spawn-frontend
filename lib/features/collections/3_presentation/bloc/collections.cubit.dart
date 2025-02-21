import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/delete-game-item.usecase.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/get-my-collections.usecase.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

part 'collections.state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  CollectionsCubit() : super(CollectionsInitialState());

  Future<void> loadCollections() async {
    emit(CollectionsLoadingState());
    final result = await serviceLocator<GetMyCollectionsUsecase>().execute();
    result.fold(
      (failure) => emit(CollectionsFailureState(errorMessage: failure.toString())),
      (collections) => emit(CollectionsSuccessState(collections: collections)),
    );
  }

  Future<void> deleteGameItem(GameItemEntity gameItem) async {
    // TODO : export this in own cubit to games item
    final result = await serviceLocator<DeleteGameItemUsecase>().execute(request: gameItem);
    result.fold(
      (failure) => {},
      (_) async {
        await loadCollections();
      },
    );
  }
}
