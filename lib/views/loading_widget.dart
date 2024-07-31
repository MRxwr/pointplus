import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/app/constant.dart';

class LoadingWidget extends StatelessWidget {


 static void show(BuildContext context, {Key? key}) {




    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => LoadingWidget(key: key),
    );}

 static void hide(BuildContext context) {
    // if(_isDialogShowing){

   Navigator.of(context).pop();

    // }




  }

  LoadingWidget({Key? key}) : super(key: key);

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