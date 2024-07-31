import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/values_manager.dart';

Widget buildTextField(

    void Function(String value)? func) {
  return      Container(
    height: AppSize.s60,
    margin: EdgeInsets.symmetric(vertical: AppSize.s10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("enter_code".tr(),
          textAlign: TextAlign.start,
          style: TextStyle(
              color: ColorManager.black,
              fontSize: FontSize.s12,
              fontWeight: FontWeight.w500
          ),),
        SizedBox(height: AppSize.s4,),
        Expanded(flex:1,child:
        Container(

          decoration: BoxDecoration(
              border: Border.all(
                  color: ColorManager.secondary,
                  width: AppSize.s1
              ),
              color: ColorManager.white,
              borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
          ),
          child: TextField(


            style: TextStyle(color:ColorManager.black,fontSize: FontSize.s12),
            textAlign: TextAlign.start,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name ,

            textInputAction: TextInputAction.done,

            onChanged: (value) => func!(value),
            maxLines: null,
            decoration: const InputDecoration(

              isDense: true,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),

          ),
        )),

      ],
    ),
  );

}