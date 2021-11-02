import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/enums/enums.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      : super(const BottomNavBarState(selectedItem: BottomNavItem.classes));

  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}
