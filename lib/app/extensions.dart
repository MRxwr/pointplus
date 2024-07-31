import 'constant.dart';


extension NonNullString on String? {
  String orEmpty(){
    if(this == null){
      return Constant.empty;

    }else{
      return this!;
    }
  }


}
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension CivilIdValidator on String{
  bool isValidCivilId(){
    return VerifyCivilId(this);
  }

}
  bool VerifyCivilId(String civilId)
{
  if (civilId.trim().isEmpty){
    return false;
  }else {
    bool output = false;
   int  outLongValue = int.parse(civilId);
    if (civilId.length == 12) {
      int c1 = int.parse(civilId.substring(0, 1));
      int c2 = int.parse(civilId.substring(1, 2));
      int c3 = int.parse(civilId.substring(2, 3));
      int c4 = int.parse(civilId.substring(3, 4));
      int c5 = int.parse(civilId.substring(4, 5));
      int c6 = int.parse(civilId.substring(5, 6));
      int c7 = int.parse(civilId.substring(6, 7));
      int c8 = int.parse(civilId.substring(7, 8));
      int c9 = int.parse(civilId.substring(8, 9));
      int c10 = int.parse(civilId.substring(9, 10));
      int c11 = int.parse(civilId.substring(10, 11));
      int total = 11 - (((c1 * 2) + (c2 * 1) + (c3 * 6) + (c4 * 3) + (c5 * 7) +
          (c6 * 9) + (c7 * 10) + (c8 * 5) + (c9 * 8) + (c10 * 4) + (c11 * 2)) % 11);
      int c12 = int.parse(civilId.substring(11, 12));
      if (c12 == total) {
        output = true;
      } else {
        output = false;
      }

    }

    return output;
  }
}
extension PhoneValidator on String {
  bool isValidPhone() {
    return    RegExp(r'^[0-9]{8}$').hasMatch(this);
  }
}
extension NonNullInteger on int? {
  int orZero(){
    if(this == null){
      return Constant.zero;

    }else{
      return this!;
    }
  }




}

extension NonNullDouble on double? {
  double orDoubleZero(){
    if(this == null){
      return Constant.zeroDouble;

    }else{
      return this!;
    }
  }





}

extension NonNullBool on bool? {
  bool orBoolFalse(){
    if(this == null){
      return Constant.falseBool;

    }else{
      return this!;
    }
  }





}
