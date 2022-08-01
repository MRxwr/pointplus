import 'package:flutter/cupertino.dart';

class ColorManager {
  static Color navColor = HexColor.fromHex("#122436");
  static Color primary = HexColor.fromHex("#0E3151");
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