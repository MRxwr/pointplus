import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontConstants {
  static const String fontFamily = "Montserrat";
}

class FontWeightManager {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class FontSize {
  ScreenUtil screenUtil = ScreenUtil();
  static  double s8 = ScreenUtil().setSp(8);
  static  double s11 = ScreenUtil().setSp(11);
  static  double s15 = ScreenUtil().setSp(15);
  static  double s21 = ScreenUtil().setSp(21);
  static  double s1 = ScreenUtil().setSp(1);
  static  double s6 = ScreenUtil().setSp(6);
  static  double s9 = ScreenUtil().setSp(9);
  static  double s12 = ScreenUtil().setSp(12);
  static  double s14 =ScreenUtil().setSp(14);
  static  double s16 = ScreenUtil().setSp(16);
  static  double s10 = ScreenUtil().setSp(10);
  static  double s17 = ScreenUtil().setSp(17);
  static  double s18 = ScreenUtil().setSp(18);
  static  double s20 = ScreenUtil().setSp(20);
  static  double s22 = ScreenUtil().setSp(22);
}