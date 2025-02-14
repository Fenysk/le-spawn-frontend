part of 'collections.cubit.dart';

abstract class CollectionsState extends Equatable {
  const CollectionsState();

  @override
  List<Object> get props => [];
}

class CollectionsInitialState extends CollectionsState {}

class CollectionsLoadingState extends CollectionsState {}

class CollectionsLoadedState extends CollectionsState {
  final List<CollectionEntity> collections;

  const CollectionsLoadedState({
    required this.collections,
  });

  @override
  List<Object> get props => [
        collections
      ];
}

class CollectionsFailureState extends CollectionsState {
  final String errorMessage;

  const CollectionsFailureState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [
        errorMessage
      ];
}
