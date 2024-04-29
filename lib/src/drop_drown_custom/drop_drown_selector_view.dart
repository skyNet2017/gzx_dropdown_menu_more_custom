import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../gzx_dropdown_menu.dart';

import 'drop_drown_selector_logic.dart';
import 'drop_drown_selector_state.dart';


class DropDrownSelectorComponent extends StatelessWidget {
  String tag;
  late DropDrownSelectorLogic logic ;
  late DropDrownSelectorState state ;


  Widget body;
  late double headerHeight;
  late List<GZXDropdownMenuBuilder> Function(GZXDropdownMenuController dropdownMenuController,
      Function(int index,String newHeader) onHeaderChanged)  dropdownMenuBuilders;
  late List<String> dropDownHeaders;


  DropDrownSelectorComponent({
    required this.dropdownMenuBuilders,
    required this.dropDownHeaders,
    required this.tag,
    this.headerHeight = 50.0,
  required this.body}){
    logic = Get.put(DropDrownSelectorLogic(),tag: tag);
    state = Get.find<DropDrownSelectorLogic>(tag: tag).state;
    state.dropDownHeaderItemStrings = this.dropDownHeaders;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DropDrownSelectorLogic>(
        tag: tag,
        builder: (controller) {
          return Stack(
            key: state.stackKey,
            children: <Widget>[
              Column(
                children: <Widget>[
//              SizedBox(height: 20,),
                Container(
                  height: 0.5,
                  color: Color(0xFFE8E8E8),
                ),
                  // 下拉菜单头部
                  GZXDropDownHeader(
                    // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                    items: buildHeaders(
                        context)
                    ,
                    // GZXDropDownHeader对应第一父级Stack的key
                    stackKey: state.stackKey,
                    // controller用于控制menu的显示或隐藏
                    controller: logic.dropdownMenuController,
                    // 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
                    onItemTap: (index) {
                      //if (index == 3) {
                      //_dropdownMenuController.hide();
                      //_scaffoldKey.currentState!.openEndDrawer();
                      //}
                    },
//                // 头部的高度
                    height: headerHeight,
//                // 头部背景颜色
                    color: Colors.white,
//                // 头部边框宽度
                    borderWidth: 0,
//                // 头部边框颜色
                    borderColor: Colors.white,
//                // 分割线高度
//                     dividerHeight: 0.5,
                    // dividerHeight: 20,
//                // 分割线颜色

                    dividerColor: Colors.white,
//                // 文字样式
                    style: const TextStyle(color: Color(0xFF666666),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
//                // 下拉时文字样式
                    dropDownStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFF0463C),
                        fontWeight: FontWeight.w500
                    ),
//                // 图标大小
//                iconSize: 20,
//                // 图标颜色
                    iconColor: Color(0xFF333333),
//                // 下拉时图标颜色
                    iconDropDownColor: Color(0xFFF0463C),
                  ).paddingOnly(left: 16,right: 16).backgroundColor(Colors.white),
                  body,
                  /*Expanded(
                child: ListView.separated(
                    itemCount: 100,
                    separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: ListTile(
                          leading: Text('test$index'),
                        ),
                        onTap: () {},
                      );
                    }),
              ),*/
                ],
              ),
              // 下拉菜单，注意GZXDropDownMenu目前只能在Stack内，后续有时间会改进，以及支持CustomScrollView和NestedScrollView
              GZXDropDownMenu(
                // controller用于控制menu的显示或隐藏
                controller: logic.dropdownMenuController,
                // 下拉菜单显示或隐藏动画时长
                animationMilliseconds: 0,
                // 下拉后遮罩颜色
//          maskColor: Theme.of(context).primaryColor.withOpacity(0.5),
//          maskColor: Colors.red.withOpacity(0.5),

                dropdownMenuChanged: (isShow, index) {
                  /*     setState(() {
                _dropdownMenuChange = '(已经${isShow ? '显示' : '隐藏'}$index)';
                print(_dropdownMenuChange);
              });*/
                },
                // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
                menus: dropdownMenuBuilders.call(logic.dropdownMenuController,(index,value){
                  logic.onheaderChanged(index,value);
                })
                ,
              ),
            ],
          ).height(double.infinity);
        },
      ),
    );
  }



  buildHeaders(BuildContext context) {
    List<GZXDropDownHeaderItem> items = [];
    for (String str in state.dropDownHeaderItemStrings) {
      items.add(GZXDropDownHeaderItem(str,
          iconSize: 23));
    }
    return items;
  }

}
