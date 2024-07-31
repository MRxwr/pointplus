

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:point/presentation/common/state_renderer/state_renderer.dart';


import '../../../app/app_prefrences.dart';

import '../../../app/constant.dart';
import '../../../app/di.dart';
import '../../resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
}
// loading state (POPUP,FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;

  String? message;

  LoadingState(
      {required this.stateRendererType, String message = AppStrings.loading});

  @override
  String getMessage() => message ?? AppStrings.loading.tr();

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// error state (POPUP,FULL SCREEN)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// content state

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => Constant.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

class ContentFullState extends FlowState {
  ContentFullState();

  @override
  String getMessage() => Constant.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentFullScreenState;
}

// EMPTY STATE

class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

// success state
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.popupSuccess;
}

late bool isShowDialog;
extension FlowStateExtension on FlowState {

  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {

    print('runtimeType ---> ${runtimeType.toString()} ');

    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            // show popup loading
            showPopup(context, getStateRendererType(), getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen loading state
            return StateRenderer(
                message: getMessage(),
                stateRendererType: getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          print('ErrorState');


            dismissDialog(context);


          if (getStateRendererType() == StateRendererType.popupErrorState) {


            // show popup error
            showPopup(context, getStateRendererType(), getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen error state
            return StateRenderer(
                message: getMessage(),
                stateRendererType: getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case EmptyState:
        {
          print('EmptyState');
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: () {});
        }
      case ContentState:
        {
          print('ContentState');

          //remove for test

             dismissDialog(context);


          return contentScreenWidget;

        }
      case ContentFullState:
        {


          return contentScreenWidget;
        }
      case SuccessState:
        {
          print('SuccessState');
          // i should check if we are showing loading popup to remove it before showing success popup

            dismissDialog(context);




          // show popup
          showPopup(context, StateRendererType.popupSuccess, getMessage(),
              title: AppStrings.success);
          // return content ui of the screen
          return contentScreenWidget;
        }
      default:
        {
          print('default');

            dismissDialog(context);



          return contentScreenWidget;
        }
    }
  }

  _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context)async  {




    print("_isCurrentDialogShowingaddaadad ${Constant.isDialogShown}");

    if(Constant.isDialogShown){
      Constant.isDialogShown = false;
        Navigator.of(context).pop();
      }
      // Keyboard is not visible.








  }

  static final GlobalKey _alertKey = GlobalKey();


  showPopup (

      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constant.empty}) {


    WidgetsBinding.instance.addPostFrameCallback((_) =>
    showDia(context, stateRendererType, message,title: title));

  }

  void showDia(  BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constant.empty}) {
    // Constants.isDialogShown = true;


    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,




        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {}));

    // if(result == true){
    //   Constants.isDialogShown = false;
    // }

  }

}
