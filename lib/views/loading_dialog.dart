import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/app/constant.dart';

class LoadingDialog extends StatelessWidget {
  bool _isDialogShowing = false;

   void show(BuildContext context,   GlobalKey<NavigatorState> page,{Key? key}) {


     _isDialogShowing = true;

     showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  );}

   void hide(BuildContext context,  GlobalKey<NavigatorState> page) {
     // if(_isDialogShowing){
       _isDialogShowing = false;
       page.currentState!.pop();

     // }




  }

   LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.transparent,
        width: 50.w,
        height: 50.w,
        padding: const EdgeInsets.all(12.0),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}