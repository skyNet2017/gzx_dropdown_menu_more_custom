import 'package:flutter/material.dart';

import 'gzx_dropdown_menu_controller.dart';

/// Signature for when a tap has occurred.
typedef OnItemTap<T> = void Function(T value);

/// Dropdown header widget.
class GZXDropDownHeader extends StatefulWidget {
  final Color color;
  final double borderWidth;
  final Color borderColor;
  final TextStyle style;
  final TextStyle? dropDownStyle;
  final double iconSize;
  final Color iconColor;
  final Color? iconDropDownColor;

//  final List<String> menuStrings;
  final double height;
  final double dividerHeight;
  final Color dividerColor;
  final GZXDropdownMenuController controller;
  final OnItemTap? onItemTap;
  final List<GZXDropDownHeaderItem> items;
  final GlobalKey stackKey;

  bool headerOnLeftWhenJustOne;

  /// Creates a dropdown header widget, Contains more than one header items.
  GZXDropDownHeader({
    Key? key,
    required this.items,
    required this.controller,
    required this.stackKey,
    this.headerOnLeftWhenJustOne = false,
    this.style = const TextStyle(color: Color(0xFF666666), fontSize: 13),
    this.dropDownStyle,
    this.height = 40,
    this.iconColor = const Color(0xFFafada7),
    this.iconDropDownColor,
    this.iconSize = 20,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFeeede6),
    this.dividerHeight = 20,
    this.dividerColor = const Color(0xFFeeede6),
    this.onItemTap,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  _GZXDropDownHeaderState createState() => _GZXDropDownHeaderState();
}

class _GZXDropDownHeaderState extends State<GZXDropDownHeader>
    with SingleTickerProviderStateMixin {
  bool _isShowDropDownItemWidget = false;
  late double _screenWidth;
  late int _menuCount;
  GlobalKey _keyDropDownHeader = GlobalKey();
  TextStyle? _dropDownStyle;
  Color? _iconDropDownColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(_onController);
  }

  _onController() {
    if (mounted) {
      setState(() {});
    }
//    print(widget.controller.menuIndex);
  }

  @override
  Widget build(BuildContext context) {
//    print('_GZXDropDownHeaderState.build');

    _dropDownStyle = widget.dropDownStyle ??
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 13);
    _iconDropDownColor =
        widget.iconDropDownColor ?? Theme.of(context).primaryColor;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _menuCount = widget.items.length;

    var gridView;
    /*if(_menuCount ==1 && widget.headerOnLeftWhenJustOne){
      gridView = _menu(widget.items[0]);
    }else{*/
    gridView = GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: _menuCount,
        childAspectRatio: (_screenWidth / _menuCount) / widget.height,
        children: widget.items.map<Widget>((item) {
          return _menu(item);
        }).toList());
    //}

    return Container(
      key: _keyDropDownHeader,
      height: widget.height,
//      padding: EdgeInsets.only(top: 1, bottom: 1),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
      child: gridView,
    );
  }

  dispose() {
    super.dispose();
  }

  _menu(GZXDropDownHeaderItem item) {
    int index = widget.items.indexOf(item);
    int menuIndex = widget.controller.menuIndex;
    _isShowDropDownItemWidget = index == menuIndex && widget.controller.isShow;
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;
    if (_menuCount == 1 && widget.headerOnLeftWhenJustOne) {
      mainAxisAlignment = MainAxisAlignment.start;
    }

    return GestureDetector(
      onTap: () {
        final RenderBox? overlay =
            widget.stackKey.currentContext!.findRenderObject() as RenderBox?;

        final RenderBox dropDownItemRenderBox =
            _keyDropDownHeader.currentContext!.findRenderObject() as RenderBox;

        var position =
            dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
//        print("POSITION : $position ");
        var size = dropDownItemRenderBox.size;
//        print("SIZE : $size");

        widget.controller.dropDownMenuTop = size.height + position.dy;

        if (index == menuIndex) {
          if (widget.controller.isShow) {
            widget.controller.hide();
          } else {
            widget.controller.show(index);
          }
        } else {
          if (widget.controller.isShow) {
            widget.controller.hide(isShowHideAnimation: false);
          }
          widget.controller.show(index);
        }

        if (widget.onItemTap != null) {
          widget.onItemTap!(index);
        }

        setState(() {});
      },
      child: Container(
        color: widget.color,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: mainAxisAlignment,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _isShowDropDownItemWidget
                          ? _dropDownStyle
                          : widget.style.merge(item.style),
                    ),
                  ),
                  buildIconNew(
                          item,
                          _isShowDropDownItemWidget,
                          item.iconSize ?? widget.iconSize,
                          _isShowDropDownItemWidget
                              ? _iconDropDownColor
                              : item.style?.color ?? widget.iconColor) ??
                      Icon(
                        !_isShowDropDownItemWidget
                            ? item.iconData ?? Icons.arrow_drop_down
                            : item.iconDropDownData ??
                                item.iconData ??
                                Icons.arrow_drop_up,
                        color: _isShowDropDownItemWidget
                            ? _iconDropDownColor
                            : item.style?.color ?? widget.iconColor,
                        size: item.iconSize ?? widget.iconSize,
                      ),
                ],
              ),
            ),
            index == widget.items.length - 1
                ? Container()
                : Container(
                    height: widget.dividerHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: widget.dividerColor, width: 1),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget? buildIconNew(GZXDropDownHeaderItem item,
      bool? isShowDropDownItemWidget, double size, Color? color) {
    if (item.icon == null || item.iconDropDown == null) {
      return null;
    }
    ImageProvider widget = item.icon!;
    if (isShowDropDownItemWidget == true) {
      widget = item.iconDropDown!;
    }
    return ImageIcon(
      widget,
      size: size, // 设置图标的大小
      color: color, // 设置图标的颜色
    );
  }
}

class GZXDropDownHeaderItem {
  final String title;
  @deprecated
  IconData? iconData;
  @deprecated
  IconData? iconDropDownData;

  ImageProvider? icon;
  ImageProvider? iconDropDown;

  final double? iconSize;
  final TextStyle? style;

  GZXDropDownHeaderItem(this.title,
      {this.iconData,
      this.iconDropDownData,
      this.iconSize,
      this.style,
      this.icon = const AssetImage("assets/images/ic_triangle_close.png",
          package: "gzx_dropdown_menu_more_custom"),
      this.iconDropDown = const AssetImage("assets/images/ic_triangle_more.png",
          package: "gzx_dropdown_menu_more_custom")});
}
