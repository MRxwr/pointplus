import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point/app/string_labels.dart';
import 'package:point/presentation/battle/battle_screen.dart';
import 'package:point/presentation/game_categories/models/questionCategory.dart';
import 'package:point/presentation/game_categories/models/userBattleRoomDetails.dart';
import 'package:point/presentation/game_categories/widgets/customRoundedButton.dart';
import 'package:point/presentation/game_categories/widgets/top_curve_clipper.dart';
import 'package:point/presentation/main/UserDetailsCubit.dart';
import 'package:point/presentation/main/game/widgets/categories_widget.dart';
import 'package:point/views/context_extensions.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/error_message_keys.dart';
import '../../domain/models/models.dart';
import '../../views/custom_image.dart';
import '../../views/fonts.dart';
import '../../views/ui_utils.dart';
import '../resources/assets_manager.dart';
import '../resources/assets_utils.dart';
import '../resources/color_manager.dart';

import '../resources/values_manager.dart';
import 'bloc/multiUserBattleRoomCubit.dart';
import 'bloc/quizCategoryCubit.dart';
class GameCategoriesScreen extends StatefulWidget {
  String gameCode;
  String title;
 String userId;
 int type;
 bool isPublicRoom;
   GameCategoriesScreen({super.key,required this.gameCode,required this.title,required this.userId,required this.type,required this.isPublicRoom});

  @override
  State<GameCategoriesScreen> createState() => _GameCategoriesScreenState();
}

class _GameCategoriesScreenState extends State<GameCategoriesScreen> {

  /// Screen Dimensions
  double get scrWidth => MediaQuery.of(context).size.width;

  double get scrHeight => MediaQuery.of(context).size.height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("userType --> ${widget.type}");
    print("widget.gameCode--->${widget.gameCode}");
    context.read<MultiUserBattleRoomCubit>().reset();
    Future.delayed(Duration.zero, () {

      if(widget.type == 1){

        context.read<MultiUserBattleRoomCubit>().createRoom(roomCode: widget.gameCode,questions: []);
      }else{
        context.read<MultiUserBattleRoomCubit>().joinRoom(roomCode: widget.gameCode,questions: []);
      }



    });




  }
  BuildContext? mContext;
  @override
  Widget build(BuildContext context) {
    mContext =context;
    final size = MediaQuery.of(context).size;



    return
  //  MultiBlocProvider(
  //      providers:widget.type==1? [
  //        BlocProvider<MultiUserBattleRoomCubit>(
  //          create: (context) => instance<MultiUserBattleRoomCubit>()..updateState(MultiUserBattleRoomInitial(), cancelSubscription: true)),
  //        BlocProvider<MultiUserBattleRoomCubit>(
  //            create: (context) => instance<MultiUserBattleRoomCubit>()..createRoom(roomCode: widget.gameCode)),
  //        BlocProvider<QuizCategoryCubit>(
  //            create: (context) => instance<QuizCategoryCubit>()),
  //
  //      ]:
  //      [
  //        BlocProvider<MultiUserBattleRoomCubit>(
  //            create: (context) => instance<MultiUserBattleRoomCubit>()..updateState(MultiUserBattleRoomInitial(), cancelSubscription: true)),
  //        BlocProvider<MultiUserBattleRoomCubit>(
  //            create: (context) => instance<MultiUserBattleRoomCubit>()..joinRoom(roomCode: widget.gameCode)),
  //        BlocProvider<QuizCategoryCubit>(
  //            create: (context) => instance<QuizCategoryCubit>()),
  //      ],
  //
  //    // Add
  // child:
     Scaffold(

      // appBar: AppBar(
      //   elevation: 0,
      //
      //   backgroundColor: ColorManager.primary,
      //   title: Center(
      //     child: Center(
      //       child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
      //     ),
      //   ),
      //   actions: [
      //     SizedBox(width: AppSize.s30,)
      //   ],
      //   leading:
      //   GestureDetector(
      //     onTap: (){
      //       Navigator.pop(context);
      //
      //     },
      //     child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,size: AppSize.s20,),
      //   ),
      //
      //
      // ),
      body: Container(
        width: AppSize.width,
        height: AppSize.height,
        decoration: const BoxDecoration(
            image:  DecorationImage(
              image: AssetImage(ImageAssets.background),
              fit: BoxFit.cover,
            )),
        child:widget.type==1?
        createrWidget(widget.gameCode,widget.userId):
        playerWidget(widget.gameCode,widget.userId)

      ),
    // ),
);


  }

  Widget createrWidget(String gameCode,String userId){


    return BlocConsumer<MultiUserBattleRoomCubit, MultiUserBattleRoomState>(
      bloc: context.read<MultiUserBattleRoomCubit>(),


    builder: (context, state)
      {
        if (state is MultiUserBattleRoomFailure) {

          return Container();
        }
        else if (state is MultiUserBattleRoomSuccess) {
          //wait for others
          return playersWidget(userId,gameCode);
        } else if (state is MultiUserBattleRoomInProgress) {
          return loadingWidget();
        } else {
          return Container(

          );
        }

    }, listener: (BuildContext context, MultiUserBattleRoomState state) {
      if (state is MultiUserBattleRoomFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          UiUtils.errorMessageDialog(
            context,
            context.tr(
              convertErrorCodeToLanguageKey(
                state.errorMessageCode,
              ),
            ),
          );
        });

      }
    },
    );
  }
  Widget playerWidget(String gameCode,String userId){
    return BlocConsumer<MultiUserBattleRoomCubit, MultiUserBattleRoomState>(
      bloc: context.read<MultiUserBattleRoomCubit>(),
      builder: (context, state)
      {
      if(state is MultiUserBattleRoomFailure){
        return Scaffold(
          appBar: AppBar(
            elevation: 0,

            backgroundColor: ColorManager.primary,
            title: Center(
              child: Center(
                child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
              ),
            ),
            actions: [
              Container(
                child: widget.type == 1?
                    widget.isPublicRoom?
                        Container():
                InkWell(
                  onTap: () => _shareRoomCode(
                    roomCode: context
                        .read<MultiUserBattleRoomCubit>()
                        .getRoomCode(),

                  ),
                  child: Icon(
                    Icons.share,
                    size: 30.w,
                    color:Colors.white,
                  ),
                ):SizedBox(height: 30.w,width: 30.w,)
                ,
              )


            ],
            leading:
            GestureDetector(
              onTap: (){
                if(state is !MultiUserBattleRoomSuccess){
                  Navigator.pop(context);
                }else{
                  showExitOrDeleteRoomDialog(userId,context);
                }


              },
              child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,size: AppSize.s30,),
            ),


          ),
          body: Container(
              width: AppSize.width,
              height: AppSize.height,
              decoration: const BoxDecoration(
                  image:  DecorationImage(
                    image: AssetImage(ImageAssets.background),
                    fit: BoxFit.cover,
                  ))),
        );
      }
         else if (state is MultiUserBattleRoomSuccess) {
          //wait for others
          return playersWidget(userId,gameCode);
        } else if (state is MultiUserBattleRoomInProgress) {
          return loadingWidget();
        } else {
          return Container(

          );
        }

      }, listener: (BuildContext context, MultiUserBattleRoomState state) {
      if (state is MultiUserBattleRoomFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          UiUtils.errorMessageDialog(
            context,
            context.tr(
              convertErrorCodeToLanguageKey(
                state.errorMessageCode,
              ),
            ),
          );
        });

      }
    },
    );
  }
  Widget loadingWidget( ){
  return  Container(
      child: const CircularProgressIndicator(


      ),
      alignment: AlignmentDirectional.center,
    );
  }

  Widget playersWidget(String userId,String roomCode){
    // context.watch<MultiUserBattleRoomCubit>().createRoom(roomCode: widget.gameCode);
    return BlocConsumer<MultiUserBattleRoomCubit, MultiUserBattleRoomState>(
      bloc: context.read<MultiUserBattleRoomCubit>(),

  builder: (context, state) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: ColorManager.primary,
        title: Center(
          child: Center(
            child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
          ),
        ),
        actions: [
          Container(
            child: widget.type == 1?
                widget.isPublicRoom?
                    Container():

            InkWell(
              onTap: () => _shareRoomCode(
                roomCode: context
                    .read<MultiUserBattleRoomCubit>()
                    .getRoomCode(),

              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.share,
                  size: 30.w,
                  color:Colors.white,
                ),
              ),
            ):SizedBox(height: 30.w,width: 30.w,)
            ,
          )

        ],
        leading:
        GestureDetector(
          onTap: (){
            if(state is !MultiUserBattleRoomSuccess){
              Navigator.pop(context);
            }else{
              showExitOrDeleteRoomDialog(userId,context);
            }


          },
          child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,size: AppSize.s30,),
        ),


      ),

      body: Container(

        decoration: const BoxDecoration(
            image:  DecorationImage(
              image: AssetImage(ImageAssets.background),
              fit: BoxFit.cover,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [



            /// Invite Code
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child:
                  widget.type == 1?
                      widget.isPublicRoom?
                          Container():
                  Text(
                    roomCode,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeights.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ):Container(),
                ),
                Container(child:widget.type== 1?
                    widget.isPublicRoom?
                        Container():
                const SizedBox(height: 10):Container()),
                Container(
                  child: widget.type == 1?
                      widget.isPublicRoom?
                          Container():
                  Text(
                    context.tr('shareRoomCodeLbl')!,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeights.regular,
                      fontSize: 16,
                      color:Colors.white

                    ),
                  ):Container(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<MultiUserBattleRoomCubit,
                  MultiUserBattleRoomState>(
                builder: (_, state) {
                  if (state is MultiUserBattleRoomSuccess) {
                    print(state.battleRoom.toString());
                    return Container(
                      margin: EdgeInsets.all(10.w),
                      child: GridView.count(

                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,

                        children: [
                          inviteRoomUserCard(
                            state.battleRoom.user1!.name,
                            state.battleRoom.user1!.profileUrl,
                            isCreator: true,
                          ),
                          inviteRoomUserCard(
                            state.battleRoom.user2!.name.isEmpty
                                ? context.tr('player2')!
                                : state.battleRoom.user2!.name,
                            state.battleRoom.user2!.profileUrl,
                            isCreator: false,
                          ),
                          inviteRoomUserCard(
                            state.battleRoom.user3!.name.isEmpty
                                ? context.tr('player3')!
                                : state.battleRoom.user3!.name,
                            state.battleRoom.user3!.profileUrl,
                            isCreator: false,
                          ),
                          inviteRoomUserCard(
                            state.battleRoom.user4!.name.isEmpty
                                ? context.tr('player4')!
                                : state.battleRoom.user4!.name,
                            state.battleRoom.user4!.profileUrl,
                            isCreator: false,
                          ),
                          inviteRoomUserCard(
                            state.battleRoom.user5!.name.isEmpty
                                ? context.tr('player5')!
                                : state.battleRoom.user5!.name,
                            state.battleRoom.user5!.profileUrl,
                            isCreator: false,
                          ),
                          inviteRoomUserCard(
                            state.battleRoom.user6!.name.isEmpty
                                ? context.tr('player6')!
                                : state.battleRoom.user6!.name,
                            state.battleRoom.user6!.profileUrl,
                            isCreator: false,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                }
              ),
            ),
            const SizedBox(height: 20),

            /// Start
            BlocBuilder<MultiUserBattleRoomCubit,
                MultiUserBattleRoomState>(
              builder: (context, state) {
                if (state is MultiUserBattleRoomSuccess) {
                  if (state.battleRoom.user1!.uid !=
                      userId) {
                    return Container();
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                      scrWidth * UiUtils.hzMarginPct + 10,
                    ),
                    child: TextButton(
                      onPressed: () {
                        print("pressed");
                        //need minimum 2 player to start the game
                        //mark as ready to play in database
                        if (state.battleRoom.user2!.uid.isEmpty) {
                          UiUtils.errorMessageDialog(
                            context,
                            context.tr(
                              convertErrorCodeToLanguageKey(
                                errorCodeCanNotStartGame,
                              ),
                            ),
                          );
                        } else {
                          //start quiz
                          /*    widget.quizType==QuizTypes.battle?context.read<BattleRoomCubit>().startGame():*/
                          final battleRoom = state.battleRoom;
                          print('battleRoomId ---> ${state.battleRoom.roomId}');
                          context.read<MultiUserBattleRoomCubit>().selectUserForSelectCategoryMultiUserBattleRoom();

                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                        ColorManager.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        context.tr('startLbl')!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );;
  }, listener: (BuildContext context, MultiUserBattleRoomState state) async{


      if (state is MultiUserBattleRoomSuccess) {
        //if game is ready to play
        // if (state.battleRoom.readyToPlay!) {
        //   //if user has joined room then navigate to quiz screen
        //   if (state.battleRoom.user1!.uid !=
        //       userId) {
        //     // Navigator.of(context)
        //     //     .pushReplacementNamed(Routes.multiUserBattleRoomQuiz);
        //   }
        // }

          String userId1 = state.battleRoom.user1!.uid;
          String userId2 = state.battleRoom.user2!.uid;
          String userId3 = state.battleRoom.user3!.uid;
          String userId4 = state.battleRoom.user4!.uid;
          String userId5 = state.battleRoom.user5!.uid;
          String userId6 = state.battleRoom.user6!.uid;
          bool isCurrentUserSelected = false;
          UserBattleRoomDetails?  user ;

          bool isReadyToPlay = state.battleRoom.readyToPlay!;
          String currentCategoryId = state.battleRoom.currentCategoryId!;
          String userName="";

          String categoryId = state.battleRoom.currentCategoryId.toString();
          bool isQuestionLoaded = false;
          if (userId == userId1) {
            user = state.battleRoom.user1!;
            print(user.name);
            bool isCatEmpty = user.categoryId.isEmpty;
            bool isSelectCategory = user.isSelecetedCategory;
            print('isSelectCategory${isSelectCategory}');
            isQuestionLoaded =  user.questionLoaded;
            if (isSelectCategory) {
              userName = 'user1';





            }
          } else if (userId == userId2) {
            user = state.battleRoom.user2!;
            bool isCatEmpty = user!.categoryId.isEmpty;
            bool isSelectCategory = user!.isSelecetedCategory;
            isQuestionLoaded =  user.questionLoaded;
            if (isSelectCategory) {
              userName = 'user2';

              print('showCategoryBottomSheet');


            }
          } else if (userId == userId3) {
            user = state.battleRoom.user3!;
            bool isCatEmpty = user!.categoryId.isEmpty;
            bool isSelectCategory = user!.isSelecetedCategory;
            isQuestionLoaded =  user.questionLoaded;
            if (isSelectCategory) {
              userName = 'user3';





            }
          } else if (userId == userId4) {
            user = state.battleRoom.user4!;
            bool isCatEmpty = user!.categoryId.isEmpty;
            bool isSelectCategory = user!.isSelecetedCategory;
            isQuestionLoaded =  user.questionLoaded;
            if (isSelectCategory) {
              userName = 'user4';



              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   showCategoryBottomSheet();
              // });
              print('showCategoryBottomSheet ');
              // showCategoryBottomSheet(context);

            }
          } else if (userId == userId5) {
            user = state.battleRoom.user5!;
            bool isCatEmpty = user!.categoryId.isEmpty;
            bool isSelectCategory = user!.isSelecetedCategory;
            isQuestionLoaded =  user.questionLoaded;
            if (isSelectCategory) {
              userName = 'user5';



              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   showCategoryBottomSheet();
              // });
              print('showCategoryBottomSheet ');
              // showCategoryBottomSheet(context);

            }
          }
          else if (userId == userId6) {
            user = state.battleRoom.user6!;
            bool isCatEmpty = user!.categoryId.isEmpty;
            bool isSelectCategory = user!.isSelecetedCategory;
            isQuestionLoaded =  user.questionLoaded;
            if (isSelectCategory) {
              userName = 'user6';


              print('showCategoryBottomSheet ');
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   showCategoryBottomSheet();
              // });

            }
          }
          String mSelectedCategory = state.battleRoom.currentCategoryId.toString();
          List<Questions> questions= context.read<MultiUserBattleRoomCubit>().getQuestions();
          print("questions Loaded ---> $questions" );
          if(questions.isNotEmpty){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return BattleScreen(categoryId: categoryId,
                      userId: widget.userId,
                      noOfQuestions: user!.totalQuestionsPerUser.toString(),
                      roomId: state.battleRoom.roomId.toString());
                }));
          }else{
          if(mSelectedCategory.trim()!= ""){
            if(isReadyToPlay){
              if(user!.uid.toString() == context.read<UserDetailsCubit>().userId()) {
                context.read<MultiUserBattleRoomCubit>().getQuestionsFromFireBase();

                // context.read<MultiUserBattleRoomCubit>().getQuestionsFromFireBase( state.battleRoom!.questions!);

                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (BuildContext context) {
                //       return BattleScreen(categoryId: categoryId,
                //           userId: widget.userId,
                //           noOfQuestions: user!.totalQuestionsPerUser.toString(),
                //           roomId: state.battleRoom.roomId.toString());
                //     }));
              }

            }else{
               if(!isQuestionLoaded) {
                if(state.battleRoom.currentUser == context.read<UserDetailsCubit>().userId()) {
                  context.read<MultiUserBattleRoomCubit>().getQuizCategoryQuestionWithUserIdAndCategoyrId(
                      state.battleRoom!.currentUser!, categoryId,
                      user!.totalQuestionsPerUser.toString(),
                      state.battleRoom.roomId.toString()
                  );
                }
              }
            }





          }else {
            if (userName != "") {
              // WidgetsBinding.instance.addPostFrameCallback((_) {
_showCustomDialog(context, context.read<MultiUserBattleRoomCubit>().getRoomId(), userName,  context.read<MultiUserBattleRoomCubit>().getCategories());
              // showCategoryBottomSheet(
              //     context.read<MultiUserBattleRoomCubit>().getRoomId(),
              //     userName,
              //     context.read<MultiUserBattleRoomCubit>().getCategories());
              // });
            }
          }
          }


        //if owner deleted the room then show this dialog
        if (!state.isRoomExist) {
          if (userId !=
              state.battleRoom.user1!.uid) {

            //Room destroyed by owner
            // showCategoryBottomSheet();
          showRoomDestroyed(context);
          }
        }
      }

    },
);

  }
  void showRoomDestroyed(BuildContext context) {
    showDialog<void>(

      barrierDismissible: false,
      context: context,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          content: Text(
            context.tr('roomDeletedOwnerLbl')!,
            style: TextStyle(color: Colors.black,
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                context.tr('okayLbl')!,
                style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> showExitOrDeleteRoomDialog(String userId,BuildContext context) {
    void onTapYes() {



        final multiUserCubit = context.read<MultiUserBattleRoomCubit>();

        final isCreator = (multiUserCubit.state as MultiUserBattleRoomSuccess)
            .battleRoom
            .user1!
            .uid ==
            userId;

        if (isCreator) {
          multiUserCubit.deleteMultiUserBattleRoom();
        } else {
          multiUserCubit.deleteUserFromRoom(userId!);
        }

        Navigator.of(context).pop();

      Navigator.of(context).pop();
    }

    final textStyle = const TextStyle(
      color: Colors.black,
    );

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: textStyle,
          contentTextStyle: textStyle,
          content: Text(context.tr('roomDelete')!,
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.normal
            ),
          ),
          actions: [
            CupertinoButton(
              onPressed: onTapYes,
              child: Text(
                context.tr('yesBtn')!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            CupertinoButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                context.tr('noBtn')!,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget inviteRoomUserCard(
      String userName,
      String img, {
        required bool isCreator,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: QImage.circular(
              imageUrl:
              img.isNotEmpty ? img : AssetsUtils.getImagePath('friend.svg'),
              width: 100,
              height: 100,
            ),
          ),

          Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeights.regular,
              color: ColorManager.primary,
            ),
          ),

          if (isCreator)
            Text(
              context.tr('creator')!,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeights.regular,
                color: Colors.black.withOpacity(0.8),
              ),
            )
          else
            Text(
              context.tr('addPlayer')!,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeights.regular,
                color:
                Colors.black.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }
  void _shareRoomCode({
    required String roomCode,

  }) {
    try {
      final msgIntro = context.tr('battleInviteMessageIntro');
      final msgJoin = context.tr('battleInviteMessageJoin');


      final inviteMessage = '$msgIntro $appName, $msgJoin $roomCode \n';


      Share.share(roomCode);
    } catch (e) {
      UiUtils.showSnackBar(context.tr(defaultErrorMessageKey)!, context);
    }
  }
  Future<void> _showCustomDialog(BuildContext context,String battleRoom,String user,List<CategoryDataModel> categories ) async {
    // final result = await Navigator.of(context).push(PageRouteBuilder(
    //   opaque: false,
    //   pageBuilder: (_, __, ___) => CategoriesWidget(battleRoom: battleRoom, user: user, categories: categories),
    //   transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
    //     return FadeTransition(
    //       opacity: animation,
    //       child: child,
    //     );
    //   },
    //   transitionDuration: const Duration(milliseconds: 500),
    // ));
    //
    // if (result != null) {
    //   context.read<MultiUserBattleRoomCubit>().startGame(battleRoom,user, result,0);
    //
    //   print('Dialog result: $result');
    // }
  }

  void showCategoryBottomSheet(String battleRoom,String user,List<CategoryDataModel> categories)async{


  final String? result = await
  showModalBottomSheet<String>(
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: UiUtils.bottomSheetTopRadius,
      ),
      context:context,
      enableDrag: false,
      builder: (_) {
        final colorScheme = Theme.of(context).colorScheme;
        return

   AnimatedContainer(
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: UiUtils.bottomSheetTopRadius,
              ),
              height: scrHeight * 0.7,
              padding: const EdgeInsets.only(top: 20),
              duration: const Duration(milliseconds: 500),
              child:
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.h,horizontal: 10.w),
                child: ListView.separated(itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: ()async{
                      print("user is ${user}");
                      String id = categories[index].id;



                      Navigator.of(context).pop(id);



                    },
                    child: SizedBox(
                      height: 50.h,
                      width: ScreenUtil().screenWidth,
                      child: Text(categories[index].enTitle),
                    ),
                  );
                }, separatorBuilder: (context,index){
                  return Container(height:1.h ,width: ScreenUtil().screenWidth,
                    color: Colors.black,);

                }, itemCount: categories.length),
              )
         );
      },
    );
    if(result != null){
      context.read<MultiUserBattleRoomCubit>().startGame(battleRoom,user, result,0);



    }

  }


}
