import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gzx_dropdown_menu_more_custom/gzx_dropdown_menu.dart';
import 'package:styled_widget/styled_widget.dart';

import 'custom_demo_logic.dart';


class CustomDemoPage extends StatelessWidget {
  final logic = Get.put(CustomDemoLogic());
  final state = Get.find<CustomDemoLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomDemoLogic>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text("custom page"),),
          body: buildBody(context),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return DropDrownSelectorComponent(tag: 'xxx',
      headerOnLeftWhenJustOne: false,
      headerBackgroundColor: Colors.lightGreenAccent,
      headerHeight: 50,
      dropdownMenuBuilders: (GZXDropdownMenuController dropdownMenuController,
          dynamic Function(int, String) onHeaderChanged) {

      return [
        GZXDropdownMenuBuilder(dropDownWidget: buildList1(dropdownMenuController,onHeaderChanged,0), dropDownHeight: 200),
        //GZXDropdownMenuBuilder(dropDownWidget: buildList1(dropdownMenuController,onHeaderChanged,1), dropDownHeight: 100),
       // GZXDropdownMenuBuilder(dropDownWidget: buildList1(dropdownMenuController,onHeaderChanged,2), dropDownHeight: 300),
      ];
    }, dropDownHeaders: [
      "浏览器",
       // "ai",
       // "年纪"
      ], body: Center(
          child: Text(state.currentChoosed),
        ),);
  }

  buildList1(GZXDropdownMenuController dropdownMenuController,
      Function(int p1, String p2) onHeaderChanged,int index) {
    List<String> list = ["chrome","edge","360安全浏览器","firefox","傲游","腾讯"];
    return ListView.builder(itemBuilder: (context,i){
      String str = list[i]+"-"+index.toString();
      return Column(
        children: [
          Text(str,).marginSymmetric(vertical: 10),
          Divider(height: 1,thickness: 1,color: Colors.blueAccent,)
        ],
      ).gestures(behavior: HitTestBehavior.opaque,
          onTap: (){
        dropdownMenuController.hide();
        onHeaderChanged.call(index,str);
        state.currentChoosed = str;
        logic.update();
      });
    },itemCount: list.length,);
  }
}
