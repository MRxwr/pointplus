import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:point/app/di.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/presentation/main/game/bloc/game_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/view/game_view.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/connection_bloc.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/connection_state.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/game_questions_bloc.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/user_profile_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/constant.dart';
import '../../../../../app/error_message_keys.dart';
import '../../../../../domain/models/game_firebase_model.dart';
import '../../../../../views/custom_image.dart';
import '../../../../../views/fonts.dart';
import '../../../../../views/ui_utils.dart';
import '../../../../resources/assets_manager.dart';
import '../../../../resources/assets_utils.dart';
import '../../../../resources/color_manager.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../../../view_helper/loading_state.dart';
import '../../../game/widgets/categories_widget.dart';
import '../../../main.dart';
import '../bloc/game_users_bloc.dart';


  class GameUsersView extends StatefulWidget {
  String gameCode;
  String title;
  String userId;
  int type;
  bool isPublicRoom;
  String id;
   GameUsersView({super.key,required this.gameCode,required this.title,required this.userId,required this.type,
   required this.isPublicRoom,required this.id});

  @override
  State<GameUsersView> createState() => _GameUsersViewState();
}
UserProfileBloc?   userProfileBloc;
GameUsersBloc? gameUsersBloc;
GameQuestionsBloc? gameQuestionsBloc;
ConnectivityBloc? connectivityBloc;
List<UserModel> userModelsList=[];
bool isDialogShown = false;

class _GameUsersViewState extends State<GameUsersView> {
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

  }

  void init(){

    userProfileBloc = instance<UserProfileBloc>();
    gameUsersBloc = instance<GameUsersBloc>();
    connectivityBloc = instance<ConnectivityBloc>();
    gameQuestionsBloc = instance<GameQuestionsBloc>();
    // userProfileBloc!.add(InitializeUser());
    // gameUsersBloc!.add(InitializeGame());
    // gameQuestionsBloc!.add(InitializeQuestionEvent());
    userProfileBloc!.add(FetchUser(userId: widget.userId));
  }

  bool? isCreator;

  double itemWidth = 0.0;

  double itemHeight = 0.0;
    bool userExists(String userId, List<UserModel> users) {
      return users.any((user) => user.userId == userId);
    }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    itemWidth = width / 2;
    itemHeight = 190.h;
    isCreator =  widget.type == 1?true:false;



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
                roomCode: widget.gameCode,
                context: context

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
            _showCloseDialog(context);

          },
          child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,size: AppSize.s20,),
        ),



      ),
      body: Container(
        width: AppSize.width,
        height: AppSize.height,
        decoration: const BoxDecoration(
            image:  DecorationImage(
              image: AssetImage(ImageAssets.background),
              fit: BoxFit.cover,
            )),
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          bloc: userProfileBloc,
  builder: (context, state) {
    if(state is UserProfileStateLoading){
      return Container(

          alignment: AlignmentDirectional.center,
          child: SizedBox(
              height: AppSize.s100,
              width: AppSize.s100,
              child: Lottie.asset(JsonAssets.loading)

          ));
    }
    else if(state is UserProfileStateFailure){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Text(
          state.message,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500
          ),
        ),
      );
    }else if(state is UserProfileStateSuccess){
      if(isCreator!) {
        gameUsersBloc!.add(FetchGameUsers(roomId: widget.gameCode,
            createdBy: widget.userId,
            currentCategoryId: '',
            readyToPlay: false,
            totalQuestions: 12,
            userModel: UserModel(questions: [],
                correctAnswers: [],
                answers: [],
                times: [],
                questionsPerUser: 0,
                totalCurrentQuestions: 0,
                isSelectCategroy: false,
                userName: state.profileDataModel.profileResultModel!
                    .userDataList![0].username.toString(),
                userId: state.profileDataModel.profileResultModel!
                    .userDataList![0].id.toString(),
                userImage: state.profileDataModel.profileResultModel!
                    .userDataList![0].favTeamModel!.logo.toString(),
                isCreator: isCreator!,
                isQuestionsLoaded:false

            ),currentUserId: '',
          room: widget.id

        ));
      }else{
        gameUsersBloc!.add(JoinGameUsers(roomId: widget.gameCode,
            userModel: UserModel(questions: [],
                correctAnswers: [],
                answers: [],
                times: [],
                questionsPerUser: 0,
                totalCurrentQuestions: 0,
                isSelectCategroy: false,
                userName: state.profileDataModel.profileResultModel!
                    .userDataList![0].username.toString(),
                userId: state.profileDataModel.profileResultModel!
                    .userDataList![0].id.toString(),
                userImage: state.profileDataModel.profileResultModel!
                    .userDataList![0].favTeamModel!.logo.toString(),
                isCreator: isCreator!,
                isQuestionsLoaded:false

            ),
        ));


      }
      return BlocConsumer<GameUsersBloc, GameUsersState>(
        bloc: gameUsersBloc,

      builder: (context, state) {
        if(state is GameUsersStateLoading){
          return Container(

              alignment: AlignmentDirectional.center,
              child: SizedBox(
                  height: AppSize.s100,
                  width: AppSize.s100,
                  child: Lottie.asset(JsonAssets.loading)

              ));
        }
        else if(state is GameUsersStateFailure){

          return Container(
            alignment: AlignmentDirectional.center,
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w500
              ),
            ),
          );

        }
        else if(state is GameUsersStateSuccess){
          List<UserModel> userModels =[];
          List<UserModel> users = [];
          int userModelLength =0;
          if(state.gameFireBaseModelList.isNotEmpty){



           userModels = state.gameFireBaseModelList[0].users;

           userModelLength = userModels.length;
          for(int i=0;i<6;i++){
            if(i<userModelLength){
              users.add(userModels[i]);
            }else{
              users.add(UserModel(questions: [], correctAnswers: [], answers: [], times: [], questionsPerUser: 0, totalCurrentQuestions: 0, isSelectCategroy: false, userName: "", userImage: "", userId: "", isCreator: false, isQuestionsLoaded:false));
            }

          }
          }

          return BlocListener<GameQuestionsBloc, GameQuestionsState>(
            bloc: gameQuestionsBloc,
            listener: (context, states) {
              print("gameQuestionsBloc");
              if(states is GameQuestionsStateLoading){
                showLoadingDialog(context);
              }
              else if(states is GameQuestionsStateFailure){
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(states.message)),
                );
              }
              else if(states is GameQuestionsStateSuccess){
                Navigator.of(context).pop();

                List<UserModel> users=[];
                for(int i =0;i<states.questionResponseModelList.length;i++){

                  UserModel userModel = state.gameFireBaseModelList[0].users[i];
                  List<QuestionModel> questionsList =[];
                  for(int j=0;j<states.questionResponseModelList[i].questionResultModel.questionList.length;j++){
                    List<String> answers =[];
                    String answer1 = states.questionResponseModelList[i].questionResultModel.questionList[j].answer1;
                    if(answer1.isNotEmpty){
                      answers.add(states.questionResponseModelList[i].questionResultModel.questionList[j].answer1);
                    }

                    String answer2 = states.questionResponseModelList[i].questionResultModel.questionList[j].answer2;
                    if(answer2.isNotEmpty){
                      answers.add(states.questionResponseModelList[i].questionResultModel.questionList[j].answer2);
                    }

                    String answer3 = states.questionResponseModelList[i].questionResultModel.questionList[j].answer3;
                    if(answer3.isNotEmpty){
                      answers.add(states.questionResponseModelList[i].questionResultModel.questionList[j].answer3);
                    }

                    int correctAnswerIndex = 0;
                    if(states.questionResponseModelList[i].questionResultModel.questionList![j].isCorrect1=="1"){
                      correctAnswerIndex = 0;
                    }else if(states.questionResponseModelList[i].questionResultModel.questionList![j].isCorrect2=="1"){
                      correctAnswerIndex = 1;
                    }else if(states.questionResponseModelList[i].questionResultModel.questionList![j].isCorrect3=="1"){
                      correctAnswerIndex = 2;
                    }

                    String image = states.questionResponseModelList[i].questionResultModel.questionList[j].image;
                    int points = int.parse(states.questionResponseModelList[i].questionResultModel.questionList[j].points);
                    QuestionModel questionModel  = QuestionModel(questionId: states.questionResponseModelList[i].questionResultModel.questionList[j].id, questionText: states.questionResponseModelList[i].questionResultModel.questionList[j].question, answers: answers, correctAnswerIndex: correctAnswerIndex, isCorrectAnswer: false, timeInSeconds: 30,image: image,points:points ,isAnswerQuestion:false);
                    questionsList.add(questionModel);

                  }
                  List<QuestionModel> questionList =[];
                  for(int i =0;i<questionsList.length;i++){
                    QuestionModel questionModel = questionsList[i];
                    questionModel.questionId = '${i+1}';
                    questionList.add(questionModel);

                  }
                  userModel.questions= questionList;
                  userModel.isQuestionsLoaded = true;
                  userModel.totalCurrentQuestions = questionList.length;
                  users.add(userModel);
                }

                gameUsersBloc!.add(UpdateQuestionsEvent( roomId:widget.gameCode,users: users));

              }


            },
  child: BlocListener<ConnectivityBloc, ConnectivityState>(
    bloc: connectivityBloc,
  listener: (context, state) {
    if (state is ConnectivityFailure) {
      isDialogShown = true;
      _internetConnectionDialog(context);
    } else if (state is ConnectivitySuccess) {
      if(isDialogShown) {
        print('isDialogShown --->  ${isDialogShown}');

        Navigator.of(context).pop();
        isDialogShown = false;
      }
    }



  },
  child: Container(
            margin: EdgeInsets.all(10.w),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                            widget.gameCode,
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
                    GridView.builder(scrollDirection: Axis.vertical,



                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                          childAspectRatio:itemWidth/itemHeight),
                      itemCount: users.length,

                      itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.all(10.w),
                          child: inviteRoomUserCard(users[index].userName,
                              users[index].userImage,isCreator:users[index].isCreator,context: context ),
                        );
                      },
                    ),

                    Container(
                      width: ScreenUtil().screenWidth,
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: isCreator!?previewButton('Start Game',context,gameUsersBloc!):Container()
                      ,
                    ),
                    Container(
                      height:isCreator!? 20.w:0,

                    )




                  ],
                ),
              ),
            ) ,
          ),
),
);

        }else{
          return Container();
        }
      }, listener: (BuildContext context, GameUsersState state) {
        if(state is GameUsersStateSuccess) {
          print("state.gameFireBaseModelList --> ${state.gameFireBaseModelList.length}");
          if (state.gameFireBaseModelList.isEmpty) {

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const MainView(
                  );
                }));
          } else {
            userModelsList = state.gameFireBaseModelList[0].users;
            bool exists = userExists(widget.userId, userModelsList);
            print("is user exists ---> ${exists}");
              if (!exists) {
                print(" user Not exists ---> ${exists}");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const MainView(
                    );
                  }));
            } else {
              bool readyToPlay = state.gameFireBaseModelList[0].readyToPlay;
              print("readyToPlay ---> ${readyToPlay}");
              String currentUserId = state.gameFireBaseModelList[0]
                  .currentUserId;
              print("currentUserId ---> ${currentUserId}");
              String currentCategoryId = state.gameFireBaseModelList[0]
                  .currentCategoryId;
              print("currentCategoryId ---> ${currentCategoryId}");
              List<UserModel> users = state.gameFireBaseModelList[0].users;

              UserModel? creatorUser;
              for (int i = 0; i < users.length; i++) {
                if (users[i].isCreator) {
                  creatorUser = users[i];
                  break;
                }
              }
              bool questionsLoaded = creatorUser!.isQuestionsLoaded;
              print("currentId ---> ${currentUserId}");
              if (readyToPlay && currentUserId.isEmpty &&
                  currentCategoryId.isEmpty) {
                if (isCreator!) {
                  selectUser(state.gameFireBaseModelList[0].totalQuestions,
                      state.gameFireBaseModelList[0].users, gameUsersBloc!);
                }
              } else if (readyToPlay && currentUserId.isNotEmpty &&
                  currentCategoryId.isEmpty) {
                if (widget.userId == currentUserId) {
                  _showCustomDialog(
                      users, currentCategoryId, gameUsersBloc!, context);
                }
              }

              else if (readyToPlay && (currentUserId.trim() != "") &&
                  (currentCategoryId.trim() != "")) {
                if (currentUserId == widget.userId) {
                  if (!questionsLoaded) {
                    int noOfQuestions = 0;
                    bool? loadQuestions;
                    List<QuestionRequest> questionsRequest = [];
                    for (int i = 0; i < users.length; i++) {
                      QuestionRequest questionRequest = QuestionRequest(
                          users[i].userId, currentCategoryId,
                          users[i].questionsPerUser.toString());

                      questionsRequest.add(questionRequest);
                    }

                    gameQuestionsBloc!.add(
                        FetchQuestionsEvent(inputs: questionsRequest));
                  } else {
                    print(
                        "questionsLoaded goToScreen current User ---> ${questionsLoaded}");



                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return GameView(
                            gameCode: widget.gameCode,
                            title: "start_game".tr(),
                            userId: widget.userId,
                            type: widget.type,
                            isPublicRoom: widget.isPublicRoom,
                      );
                        }));
                  }
                } else {
                  if (!questionsLoaded) {
                    print("questionsLoaded ---> ${questionsLoaded}");

                    showLoadingDialog(context);
                  } else if (questionsLoaded) {
                    print(
                        "questionsLoaded goToScreen player---> ${questionsLoaded}");

                    Navigator.pop(context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return GameView(
                            gameCode: widget.gameCode,
                            title: "start_game".tr(),
                            userId: widget.userId,
                            type: widget.type,
                            isPublicRoom: widget.isPublicRoom,
                          );
                        }));
                  }
                }
              }
            }
          }
        }
          },
      );

    }else {
      return Container();
    }
  },
),
      ),
    );
  }

  void _shareRoomCode({
    required String roomCode,
   required BuildContext context

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

  Widget inviteRoomUserCard(
      String userName,
      String img, {
        required bool isCreator,
        required BuildContext context
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

  TextButton previewButton(String category,BuildContext context,GameUsersBloc gameUsersBloc){
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(

      minimumSize: Size(50.w, 35.h),

      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0.w)),
      ),
      backgroundColor:userModelsList.length>=2? ColorManager.secondary:Colors.grey,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        if(userModelsList.length>=2) {
          gameUsersBloc!.add(StartPlayEvent(roomId: widget.gameCode));
        }


      },
      child: Text(category,style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.w500
      ),),
    );
  }

 void selectUser( int noOfQuestions,List<UserModel> users,GameUsersBloc gameUsersBloc) async{
    List<UserModel> gameUsers = [];

    List<UserModel> usersNotSelected =[];

    for(int i =0;i<users.length;i++) {
      if (!users[i].isSelectCategroy) {
        usersNotSelected.add(users[i]);
      }
      gameUsers.add(users[i]);
    }
    print(noOfQuestions);
    print(gameUsers.length);
    int noOfQuestionsPerUser= (double.parse('${noOfQuestions}')/double.parse('${gameUsers.length}')).toInt();
    int reminder = (noOfQuestions%gameUsers.length);



        final random = Random();
        String currentSelectUserId = usersNotSelected[random.nextInt(usersNotSelected.length)].userId;
        for(int i =0;i<gameUsers.length;i++){
          String userId = gameUsers[i].userId;
          if(userId == currentSelectUserId){

            gameUsers[i].isSelectCategroy = true ;
          }
          gameUsers[i].questionsPerUser =noOfQuestionsPerUser;


        }
        gameUsers[random.nextInt(usersNotSelected.length)].questionsPerUser = (noOfQuestionsPerUser+reminder);
gameUsersBloc!.add(InitializeQuestionsEvent(roomId: widget.gameCode, currentUserId: currentSelectUserId, users: gameUsers));
        // send users and currentSelectUserId to fireBase









  }

  Future<void> _showCustomDialog(List<UserModel> users, String currentUserId,GameUsersBloc gameUsersBloc,BuildContext context) async {
    final categoryId = await Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => CategoriesWidget(),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    ));

    if (categoryId != null) {
      for(int i = 0;i<users.length;i++){
        UserModel userModel =users[i];
        if(userModel.userId == currentUserId){
          userModel.isSelectCategroy = true;
         users[i] = userModel;
        }
      }
     gameUsersBloc.add(UpdateCategoryEvent(roomId: widget.gameCode,currentCategoryId: categoryId,users: users));



    }
  }
  @override
  void dispose() {
    userProfileBloc!.close();
    gameUsersBloc!.close();
    gameQuestionsBloc!.close();
    connectivityBloc!.close();
    // TODO: implement dispose
    super.dispose();
  }
    Future<void> _showCloseDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(

            content: Container(
              height: 50.h,
              alignment: AlignmentDirectional.center,
              child: Text("do_you_want_exit".tr(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: ColorManager.white,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w500,

                ),),
            ),
            actions: <Widget>[
              TextButton(
                child:  Text("yes".tr(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Color(0xFF5CB852),
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(18),

                  ),),
                onPressed: () {
                  if(isCreator!){
                    gameUsersBloc!.add(DeleteRoom(roomId: widget.gameCode));
                  }else{
                    for(int i =0;i<userModelsList.length;i++){
                      if(userModelsList[i].userId == widget.userId){
                        userModelsList.removeAt(i);
                        break;
                      }
                    }
                    gameUsersBloc!.add(UpdateUsersEvent(roomId: widget.gameCode,users: userModelsList));
                  }

                },
              ),
              TextButton(
                child:  Text("no".tr(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Color(0xFFDB3562),
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(18),

                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _internetConnectionDialog(BuildContext context) async {

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(

            content: Container(
              height: 50.h,
              alignment: AlignmentDirectional.center,
              child: Text("internet_connection_error".tr(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: ColorManager.white,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w500,

                ),),
            ),
            actions: <Widget>[
              TextButton(
                child:  Text("exit_string".tr(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Color(0xFF5CB852),
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(18),

                  ),),
                onPressed: () {
                  if(isCreator!){
                    gameUsersBloc!.add(DeleteRoom(roomId: widget.gameCode));
                  }else{
                    for(int i =0;i<userModelsList.length;i++){
                      if(userModelsList[i].userId == widget.userId){
                        userModelsList.removeAt(i);
                        break;
                      }
                    }
                    gameUsersBloc!.add(UpdateUsersEvent(roomId: widget.gameCode,users: userModelsList));
                  }

                },
              ),

            ],
          );
        },
      );
    }
    void _dismissDialog(BuildContext context) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }


}
