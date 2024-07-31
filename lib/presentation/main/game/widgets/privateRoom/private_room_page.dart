
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/app/constant.dart';
import 'package:point/presentation/main/game/widgets/privateRoom/bloc/private_room_page_events.dart';
import 'package:point/presentation/main/game/widgets/privateRoom/bloc/private_room_page_states.dart';
import 'package:point/views/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../api/point_services.dart';
import '../../../../../app/app_prefrences.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/join_game_model.dart';
import '../../../../../providers/model_hud.dart';
import '../../../../../views/flutter_toast.dart';
import '../../../../game_categories/game_categories_screen.dart';
import '../../../../resources/color_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/values_manager.dart';
import '../common_widgets.dart';
import 'bloc/private_room_page_blocs.dart';

class PrivateRoom extends StatelessWidget {
  String userId;

   PrivateRoom({super.key,required this.userId});

  void show(BuildContext context,{Key? key}) {




    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => PrivateRoom(key: key,userId: userId,),
    );}

  void hide(BuildContext context) {

    Navigator.of(context).pop();


  }
  String codeForTest="";
  String gameCode ="";

  @override
  Widget build(BuildContext context) {
    return bodyWidget(context);
  }

  Widget bodyWidget(BuildContext context){
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ModelHud>(context).isLoading,

      child: Container(
        margin: EdgeInsets.all(20.w),
        alignment: AlignmentDirectional.center,
        child: Card(
          child: Container(


            width: AppSize.width,
            height: AppSize.s150,
            color: ColorManager.white,
            child: Container(

              child: Stack(
                children: [
                  Positioned.directional(textDirection: Directionality.of(context), child:
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(AppSize.s4),
                      child: Icon(Icons.close,size: AppSize.s20,
                        color: ColorManager.primary,),
                    ),
                  ),top: 0, start: 0,
                  ),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    start: 0,
                    end: 0,
                    top: 0,
                    bottom: 0,

                    child: Container(


                      child: Column(
                        children: [

                          Expanded(flex:2,child: Container(
                            margin: EdgeInsets.all(10.w),
                            child: buildTextField(
                                    (value) {

                                      gameCode = value;
                                }),
                          )),

                          Expanded(flex:1,child: Container(

                              alignment: AlignmentDirectional.center,
                              child: addressButton("start_game".tr(),context,1)
                          )),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  TextButton addressButton(String text,BuildContext context,int type){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(



      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s0)),
      ),
      backgroundColor: ColorManager.secondary,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () async{
        int user = await instance<AppPreferences>().getUserId();

      String  userId = user.toString();

      if(gameCode!.trim() != ""){
        Map<String,dynamic> map ={};
        map['create'] = "0";
        map['join'] = "2";
        map['userId'] = userId;
        map['roomId'] = "1";
        map['roomCode'] = gameCode;
        map['exit'] ="0";

        print('map----> ${map}');
        final modelHud = Provider.of<ModelHud>(context,listen: false);
        modelHud.changeIsLoading(true);
        PointServices pointServices = PointServices();
        JoinGameModel? joinGameModel = await pointServices.joinGame(map);
        modelHud.changeIsLoading(false);


        Navigator.of(context).pop();
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
          return  GameCategoriesScreen(gameCode: gameCode,title: "start_game".tr(),userId: userId,type: 2, isPublicRoom: false,);

        }));

      }else{
        toastInfo(msg: "Please Enter Code");
      }









      },
      child:
      Center(
        child: Text(text,style: TextStyle(
            color: ColorManager.white,
            fontSize: FontSize.s14,
            fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
