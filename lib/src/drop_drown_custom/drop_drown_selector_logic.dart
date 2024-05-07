import 'dart:ui';

import 'package:get/get.dart';

import '../../gzx_dropdown_menu.dart';
import 'drop_drown_selector_state.dart';

class DropDrownSelectorLogic extends GetxController {
  final DropDrownSelectorState state = DropDrownSelectorState();
  GZXDropdownMenuController dropdownMenuController =
      GZXDropdownMenuController();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    dropdownMenuController.dispose();
  }

/*  void onRoleClicked(int i) {
    if(i == state.selectRole) {
      return;
    }
    state.selectRole = i;
    state.dropDownHeaderItemStrings[0] = state.roleStrs[i];
    update();
    dropdownMenuController.hide();
    onRoleChanged?.call(i);
  }*/

/*  void onDateClear() {
    state.dropDownHeaderItemStrings[1] = SaTaskStr.creationTime.tr;
    state.selectedDateTime = DateTime.now();
    onDateChanged2?.call(null);
    update();
    dropdownMenuController.hide();

  }*/

  void onheaderChanged(int index, String value) {
    state.dropDownHeaderItemStrings[index] = value;
    update();
  }
}
