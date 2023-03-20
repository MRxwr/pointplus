import 'package:flutter/cupertino.dart';

class ColorManager {
  static Color blueBlack = HexColor.fromHex("#14283B");
  static Color cyan = HexColor.fromHex("#748D9E");
  static Color navColor = HexColor.fromHex("#122436");
  static Color primary = HexColor.fromHex("#0E3151");
  static Color expire = HexColor.fromHex("#EE0E0E");
  static Color active = HexColor.fromHex("#0B9F01");
  static Color secondary = HexColor.fromHex("#00CAD6");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");
  static Color black = HexColor.fromHex("#000000");
  // new colors
  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color backGroundColor = HexColor.fromHex("#0E3151");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color error = HexColor.fromHex("#e61f34");
  static Color background = HexColor.fromHex("#0E3151");
  static Color rectangle = HexColor.fromHex("#00CAD6");
  static Color selectedRectangle = HexColor.fromHex("#0A243B");
  static Color selectedCircle = HexColor.fromHex("#0E3151");
  static Color expandedColor = HexColor.fromHex("#103B63");
  // red color
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}