import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:point/domain/join_game_model.dart';
import 'package:point/presentation/base/baseviewmodel.dart';
import 'package:point/presentation/main/game/bloc/game_bloc.dart';
import 'package:point/presentation/main/game/bloc/game_page_blocs.dart';
import 'package:point/presentation/main/game/bloc/game_page_states.dart';
import 'package:point/presentation/main/game/widgets/common_widgets.dart';
import 'package:point/presentation/main/game/widgets/privateRoom/private_room_page.dart';
import 'package:point/presentation/main/game/widgets/share_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/point_services.dart';
import '../../../app/app_prefrences.dart';
import '../../../app/di.dart';
import '../../../providers/model_hud.dart';
import '../../../views/flutter_toast.dart';
import '../../../views/loading_dialog.dart';
import '../../common/freezed_data_class.dart';
import '../../game_categories/bloc/multiUserBattleRoomCubit.dart';
import '../../game_categories/game_categories_screen.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../../view_helper/loading_state.dart';
import '../game_bloc/users_view/view/game_users_view.dart';
import 'bloc/game_page_events.dart';

class GameScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;

  GameScreen({super.key, required this.page});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  String userId = "";
  var roomRequestObject = RoomRequestObject("", "", "", "", "", "");

  late BuildContext mContext;
  ModelHud? modelHud;

  Dialog? dialog;
  GameBloc gameBloc = instance<GameBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();



    userId = sharedPreferences.getString("id")??"";
    // int user = await _appPreferences.getUserId();
    // userId = user.toString();
    print("userId ---> ${userId}");

    // context.read<GamePageBloc>().add(Dialogclose("4"));


  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  bool inAsyncCall = false;
  LoadingDialog loadingDialog = LoadingDialog();
  int type=0;
  bool isPublicRoom = false;



  @override
  Widget build(BuildContext mContext) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ModelHud>(context).isLoading,
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        body:
        initGamegameWidget(context)

      ),
    );
  }


  Widget initGamegameWidget(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      bloc: gameBloc,
  listener: (context, state) {
    print(state);
    if(state is GameLoading){
      showLoadingDialog(context);
    }else if(state is GameStateFailure){
      if(type == 1) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }else if(type == 2){
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );

      }
    }else if(state is GameStateSuccess){



      if(!isPublicRoom) {
        if(type == 2){
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context, rootNavigator: true).pop();
        }else if(type == 1){
          Navigator.of(context,rootNavigator: true).pop();
        }
        if(type == 1) {
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return GameUsersView(
                  gameCode: state.roomModel.roomResultModel.roomData.code,
                  title: "start_game".tr(),
                  userId: userId,
                  type: type,
                  isPublicRoom: isPublicRoom,id: state.roomModel.roomResultModel.roomData.id,);
              }));
        }else if(type == 2){
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return GameUsersView(
                  gameCode: gameCode,
                  title: "start_game".tr(),
                  userId: userId,
                  type: type,
                  isPublicRoom: isPublicRoom,id: state.roomModel.roomResultModel.roomData.id);
              }));
        }
      }else{
        Navigator.of(context,rootNavigator: true).pop();
        if(state.roomModel.roomResultModel.roomData.users.length>1){
          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
            return  GameUsersView(gameCode: state.roomModel.roomResultModel.roomData.code,title: "start_game".tr(),userId: userId,type: 2, isPublicRoom: true,id: state.roomModel.roomResultModel.roomData.id);

          }));
        }else{
          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
            return  GameUsersView(gameCode: state.roomModel.roomResultModel.roomData.code,title: "start_game".tr(),userId: userId,type: 1, isPublicRoom: true,id: state.roomModel.roomResultModel.roomData.id);

          }));
        }
      }

    }else{

    }
    // TODO: implement listener
  },
  child: Container(
      height: AppSize.height,
      width: AppSize.width,
      alignment: AlignmentDirectional.center,
      child: Center(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
                type =1;
                isPublicRoom = false;
                gameBloc.add(
                  FetchRoom(
                    create: "1",
                    join:"2" ,
                    userId: userId,
                    roomId: "0",
                    roomCode:"0",
                    exit: "0"

                  ),
                );

                // Map<String,dynamic> map ={};
                // map['create'] = "1";
                // map['join'] = "2";
                // map['userId'] = userId;
                // map['roomId'] = "0";
                // map['roomCode'] = "0";
                // map['exit'] ="0";
                //
                // print('map----> ${map}');
                // final modelHud = Provider.of<ModelHud>(context,listen: false);
                // modelHud.changeIsLoading(true);
                // PointServices pointServices = PointServices();
                // JoinGameModel? joinGameModel = await pointServices.joinGame(map);
                // modelHud.changeIsLoading(false);
                // String code= joinGameModel!.data!.room!.code!.toString();



              },
              child: Container(
                height: AppSize.s70,
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                decoration: BoxDecoration(
                    color: ColorManager.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(
                        AppSize.s35))
                ),
                child: Text("create_private_room".tr(),
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.w500,

                  ),),
              ),
            ), Container(height: AppSize.s10,),
            GestureDetector(
              onTap: () async{
                type =2;
                isPublicRoom = true;
                gameBloc.add(
                  FetchRoom(
                      create: "0",
                      join:"1" ,
                      userId: userId,
                      roomId: "0",
                      roomCode:"0",
                      exit: "0"

                  ),
                );

                // if(MultiUserBattleRoomState is MultiUserBattleRoomSuccess) {
                //   context.read<MultiUserBattleRoomCubit>().clearData();
                // }
                // Map<String,dynamic> map ={};
                // map['create'] = "0";
                // map['join'] = "1";
                // map['userId'] = userId;
                // map['roomId'] = "0";
                // map['roomCode'] = "0";
                // map['exit'] ="0";
                //
                // print('map----> ${map}');
                // final modelHud = Provider.of<ModelHud>(context,listen: false);
                // modelHud.changeIsLoading(true);
                // PointServices pointServices = PointServices();
                // JoinGameModel? joinGameModel = await pointServices.joinGame(map);
                // modelHud.changeIsLoading(false);
                // List<ListOfUsers>? listOfUsers = joinGameModel!.data!.room!.listOfUsers;
                // if(listOfUsers!.length>1){
                //   Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                //     return  GameCategoriesScreen(gameCode: joinGameModel!.data!.room!.code.toString(),title: "start_game".tr(),userId: userId,type: 2, isPublicRoom: true,);
                //
                //   }));
                // }else{
                //   Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                //     return  GameCategoriesScreen(gameCode: joinGameModel!.data!.room!.code.toString(),title: "start_game".tr(),userId: userId,type: 1, isPublicRoom: true,);
                //
                //   }));
                // }

              },
              child: Container(
                height: AppSize.s70,
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                decoration: BoxDecoration(
                    color: ColorManager.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(
                        AppSize.s35))
                ),
                child: Text("join_public_room".tr(),
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.w500,

                  ),),
              ),
            ),
            Container(height: AppSize.s10,),
            GestureDetector(
              onTap: () {
                type =2;
                _joinPrivateRoom(context,userId);
                // PrivateRoom privateRoom =  PrivateRoom(userId: userId,);
                // privateRoom.show(context);
              },
              child: Container(
                height: AppSize.s70,
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                decoration: BoxDecoration(
                    color: ColorManager.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(
                        AppSize.s35))
                ),
                child: Text("join_private_room".tr(),
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.w500,

                  ),),
              ),
            )
          ],
        ),
      ),

    ),
);
  }
String gameCode="";
  Future<void> _joinPrivateRoom(BuildContext context,String userId){
    

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
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
              );

      },
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
        // int user = userId;
        //
        // String  userId = user.toString();

        if(gameCode!.trim() != ""){

          isPublicRoom = false;
          gameBloc.add(
            FetchRoom(
                create: "0",
                join:"2" ,
                userId: userId,
                roomId: "1",
                roomCode:gameCode,
                exit: "0"

            ),
          );


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
  @override
  void dispose() {
    gameBloc.close();
    super.dispose();
  }
}
