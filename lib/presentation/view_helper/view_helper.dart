import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/styles_manager.dart';
import '../resources/values_manager.dart';



Widget getPopUpDialog(BuildContext context, List<Widget> children) {
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14)),
    elevation: AppSize.s1_5,
    backgroundColor: Colors.transparent,
    child: Container(




      decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: const [BoxShadow(color: Colors.black26)]),
      child: _getDialogContent(context, children),
    ),
  );
}

Widget _getDialogContent(BuildContext context, List<Widget> children) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: children,
  );
}

Widget _getItemsColumn(List<Widget> children) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: children,
  );
}

Widget getAnimatedImage(String animationName) {
  return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName));
}

Widget getMessage(String message) {
  return Center(
    child: Padding(
      padding:  EdgeInsets.all(AppPadding.p8),
      child: Text(
        message,
        style: getRegularStyle(
            color: ColorManager.black, fontSize: FontSize.s18),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget getRetryButton(String buttonTitle, BuildContext context) {
  return Center(
    child: Padding(
      padding:  EdgeInsets.all(AppPadding.p18),
      child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                // if (stateRendererType ==
                //     StateRendererType.fullScreenErrorState) {
                //   print("retry");
                //   // call retry function
                //   retryActionFunction.call();
                // } else {
                //
                //   print("pop up");
                //   Navigator.pop(context);
                //   // popup error state
                //   // Navigator.of(context).pop();
                //
                // }
                Navigator.pop(context);

              },
              child: Text(buttonTitle))),
    ),
  );
}