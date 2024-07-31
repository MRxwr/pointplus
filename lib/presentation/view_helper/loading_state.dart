
import 'package:flutter/material.dart';
import 'package:point/presentation/view_helper/view_helper.dart';


import '../resources/assets_manager.dart';


class LoadingStates extends StatelessWidget {
  const LoadingStates({super.key});

  @override
  Widget build(BuildContext context) {
    return  getPopUpDialog(
        context, [getAnimatedImage(JsonAssets.loading)]);;
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return  getPopUpDialog(
          context, [getAnimatedImage(JsonAssets.loading)]);
    },
  );
}

