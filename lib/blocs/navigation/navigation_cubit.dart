import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState.initial());

  void setTab(AppTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void goToHome() => setTab(AppTab.home);
  void goToSettings() => setTab(AppTab.settings);
  void goToLogs() => setTab(AppTab.logs);
}
