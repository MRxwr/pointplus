import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(height: AppSize.s10,),
          Container(height: AppSize.s80,
            margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssets.header),
                  fit: BoxFit.cover,
                ),
              ),
            ),),
          Container(height: AppSize.s50,)
          ,
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
              Container(
                height: AppSize.s100,
                decoration: BoxDecoration(
                  color: ColorManager.expandedColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                ),
                child: ExpandablePanel(


                header: Text("title"),
    collapsed: Text("collapse", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
    expanded: Text("expand", softWrap: true, ),
                  theme: ExpandableThemeData(
                    
                    iconSize: AppSize.s25,
                      iconColor: ColorManager.rectangle,
                      animationDuration: const Duration(milliseconds: 500)
                  ),
                  controller: ExpandedC,

    ),
              ),

                
              ],
            ),
          )
        ],
      ),
    );
  }
}
