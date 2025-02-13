import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/bloc/tabs_state.dart';

enum TabType { home, collections, bank, profile }

class TabsCubit extends Cubit<TabsState> {
  TabsCubit() : super(const TabsState(currentTab: TabType.home));

  void setTabIndex(int index) {
    final tabType = TabType.values[index];
    emit(TabsState(currentTab: tabType));
  }
}
