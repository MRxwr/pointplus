import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/values_manager.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconPath,  required this.text});
  String iconPath;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  ScreenUtil screenUtil = ScreenUtil();
  FABBottomAppBar({
    required this.items,
    required this.centerItemText,
    this.height = 70,
    this.iconSize = 24.0,
    required this.backgroundColor,
    required  this.color,
    required   this.selectedColor,

    required  this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 5);
  }
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;

  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    // items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(

      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  // Widget _buildMiddleTabItem() {
  //   ScreenUtil screenUtil = ScreenUtil();
  //   return Expanded(
  //     child: SizedBox(
  //       height: 60.h,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           SizedBox(height: 30.h),
  //           Text(
  //             widget.centerItemText ?? '',
  //             style: TextStyle(color: widget.color),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    ScreenUtil screenUtil = ScreenUtil();
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child:
      Container(
        decoration: _selectedIndex == index?BoxDecoration(
          border:Border(
            top: BorderSide(width: AppSize.s1,color: ColorManager.secondary),
            bottom: BorderSide(width: AppSize.s1,color: ColorManager.secondary),
          )
        ):null,
        height: 55.h,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                  Image.asset(item.iconPath
                  ,height: 21.w,width: 21.w,),
               SizedBox(height: 4.w,)


               ,
                Text(
                  item.text,
                  style: TextStyle(color: color,
                  fontSize: screenUtil.setSp(8)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}