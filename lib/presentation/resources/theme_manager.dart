import 'package:flutter/material.dart';
import 'package:point/presentation/resources/values_manager.dart';


import 'color_manager.dart';

import 'font_manager.dart';
import 'styles_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors of the app
      primaryColor: ColorManager.primary,
      primaryColorLight: ColorManager.primaryOpacity70,
      primaryColorDark: ColorManager.darkPrimary,
      disabledColor: ColorManager
          .grey1, // will be used incase of disabled button for example

    // card view theme
      cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4),

    // App bar theme
      appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.primary,
      elevation: AppSize.s4,
      shadowColor: ColorManager.primaryOpacity70,
      titleTextStyle: getRegularStyle(
          color: ColorManager.white, fontSize: FontSize.s16)),

    // Button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor:ColorManager.grey1,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.primaryOpacity70

  ),
      //elevated buttonTheme 
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: ColorManager.white,fontSize: FontSize.s12),
        primary: ColorManager.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s12))
      )
  ),

    // Text theme
      textTheme: TextTheme(
  headline1: getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s16),
  subtitle1: getMediumStyle(color: ColorManager.lightGrey,fontSize: FontSize.s14),
          subtitle2: getMediumStyle(color: ColorManager.primary,fontSize: FontSize.s14),
  caption: getRegularStyle(color: ColorManager.grey1,fontSize: FontSize.s12),
  bodyText1: getRegularStyle(color: ColorManager.grey,fontSize: FontSize.s12)
  ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(AppPadding.p8),
        // hint style
        hintStyle: getRegularStyle(color: ColorManager.grey1,fontSize: FontSize.s12),

        // label style
        labelStyle: getMediumStyle(color: ColorManager.darkGrey,fontSize: FontSize.s12),
        // error style
        errorStyle: getRegularStyle(color: ColorManager.error,fontSize: FontSize.s12),

        // enabled border
        enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

        // focused border
        focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

        // error border
        errorBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
        // focused error border
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
      )
    // input decoration theme (text form field)

  );
}