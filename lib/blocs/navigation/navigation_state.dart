import 'package:equatable/equatable.dart';

enum AppTab { home, settings, logs }

class NavigationState extends Equatable {
  final AppTab currentTab;

  const NavigationState({required this.currentTab});

  const NavigationState.initial() : currentTab = AppTab.home;

  NavigationState copyWith({AppTab? currentTab}) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
    );
  }

  @override
  List<Object?> get props => [currentTab];
}
