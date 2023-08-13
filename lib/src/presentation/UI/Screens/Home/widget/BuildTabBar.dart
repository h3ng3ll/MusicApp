// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/widget/TabViewWidget.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// ignore: must_be_immutable
class BuildTabBar extends StatefulWidget {
  BuildTabBar({
    Key? key,
    required this.callBack,
    required this.activeIndex,
    this.isVisible = true
  }) : super(key: key);

  final Function (int ) callBack  ;
  int activeIndex;
  final bool isVisible;

  @override
  State<BuildTabBar> createState() => _BuildTabBarState();
}

class _BuildTabBarState extends State<BuildTabBar> {

  @override
  Widget build(BuildContext context) {

    if(!widget.isVisible)  return Container();


    return TabViewWidget(
      items:  items.map((e) => buildItem(e , items.indexOf(e))).toList(),
    );
  }

  List<PersistentBottomNavBarItem> items = [
    PersistentBottomNavBarItem(
        icon: const BuildAssetIcon( iconName: "home2",),
        inactiveIcon:  const BuildAssetIcon( iconName: "home",)
    ),
    PersistentBottomNavBarItem(
      icon: const BuildAssetIcon( iconName: "search2",),
      inactiveIcon: const BuildAssetIcon( iconName: "search",),
    ),
    PersistentBottomNavBarItem(
      icon: const BuildAssetIcon( iconName: "library2",),
      inactiveIcon:  const BuildAssetIcon( iconName: "library",),
    ),
  ];

  Widget buildItem (PersistentBottomNavBarItem item , int index ) {
    return InkWell(
        onTap: () {
          widget.callBack(index);
          widget.activeIndex = index;
          setState(() {        });
        },
        child: index == widget.activeIndex ?  item.icon : item.inactiveIcon
    );
  }

}
