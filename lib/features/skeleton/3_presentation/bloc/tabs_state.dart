
import 'package:equatable/equatable.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/bloc/tabs_cubit.dart';

class TabsState extends Equatable {
  final TabType currentTab;

  const TabsState({required this.currentTab});

  @override
  List<Object?> get props => [currentTab];
}