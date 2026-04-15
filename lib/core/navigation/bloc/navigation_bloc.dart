import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_event.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(selectedIndex: 0)) {
    on<NavigationTabChanged>(_onTabChanged);
  }

  void _onTabChanged(
    NavigationTabChanged event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationState(selectedIndex: event.tabIndex));
  }
}
