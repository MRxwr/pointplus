import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:point/app/di.dart';
import 'package:point/domain/models/game_firebase_model.dart';
import 'package:point/domain/models/quiz_question_model.dart';


import 'package:point/presentation/main/game_bloc/game_view/bloc/game_details_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/quiz_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/quiz_state.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/timer_bloc.dart';
import 'package:point/presentation/main/game_bloc/result_view/view/result_view.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/connection_state.dart';
import 'package:point/presentation/main/game_bloc/users_view/view/game_users_view.dart';
import 'package:point/views/loading_dialog.dart';

import '../../../../../app/constant.dart';
import '../../../../../data/network/request.dart';
import '../../../../resources/assets_manager.dart';
import '../../../../resources/color_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../../../view_helper/loading_state.dart';
import '../../../game/widgets/categories_widget.dart';
import '../../../main.dart';
import '../../users_view/bloc/connection_bloc.dart';
import '../../users_view/bloc/game_questions_bloc.dart';
import '../../users_view/bloc/game_users_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/timer_state.dart';

class GameView extends StatefulWidget {
  String gameCode;
  String title;
  String userId;
  int type;
  bool isPublicRoom;




  GameView(
      {super.key, required this.gameCode, required this.title, required this.userId, required this.type,
        required this.isPublicRoom});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  UserModel? userModel;

  List<QuestionModel> questionsList = [];

  int questionIndex =0;
  GameUsersBloc?   gameDetailsBloc;
  TimerBloc? timerBloc;
  QuizBloc? quizBloc;
  GameQuestionsBloc? gameQuestionsBloc;
  ConnectivityBloc? connectivityBloc;
  List<UserModel> userModelsList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameDetailsBloc  = instance<GameUsersBloc>();
    connectivityBloc = instance<ConnectivityBloc>();
     timerBloc = instance<TimerBloc>();

       quizBloc = instance<QuizBloc>();
    gameQuestionsBloc = instance<GameQuestionsBloc>();

    gameDetailsBloc!.add(FetchGameDetail(roomId: widget.gameCode));
  }
  bool userExists(String userId, List<UserModel> users) {
    return users.any((user) => user.userId == userId);
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: ColorManager.primary,
        title: Center(
          child: Center(
            child: Image.asset(ImageAssets.titleBarImage, height: AppSize.s32,
              width: AppSize.s110,
              fit: BoxFit.fill,),
          ),
        ),
        actions: [
          Container(
            width: 30.w,
            height: 30.w,

          )
        ],
        leading:
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,
            size: AppSize.s20,),
        ),


      ),
      body: Container(
          width: AppSize.width,
          height: AppSize.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageAssets.background),
                fit: BoxFit.cover,
              )),
          child: BlocConsumer<GameUsersBloc, GameUsersState>(
            bloc: gameDetailsBloc,

            listener: (context, gameDetailsState) {
              if (gameDetailsState is GameUsersStateSuccess) {
                List<UserModel> users = gameDetailsState.gameFireBaseModelList[0].users;
                userModelsList = gameDetailsState.gameFireBaseModelList[0].users;
                print("state ---> ${gameDetailsState.gameFireBaseModelList[0].roomId}");
                if (gameDetailsState.gameFireBaseModelList.isEmpty) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const MainView(
                        );
                      }));
                } else {
                  userModelsList =
                      gameDetailsState.gameFireBaseModelList[0].users;
                  bool exists = userExists(widget.userId, userModelsList);
                  print("is user exists ---> ${exists}");
                  if (!exists) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const MainView(
                          );
                        }));
                  } else {
                    bool goToNextCategory = true;
                    bool isExamFinish = true;
                    for (int i = 0; i <
                        gameDetailsState.gameFireBaseModelList[0].users
                            .length; i++) {
                      int totalQuestions = gameDetailsState
                          .gameFireBaseModelList[0].users[i].questionsPerUser;
                      int totalAnswers = gameDetailsState
                          .gameFireBaseModelList[0]
                          .users[i].answers.length;
                      if (totalQuestions != totalAnswers) {
                        isExamFinish = false;
                        break;
                      }
                    }
                    if (!isExamFinish) {
                      for (int i = 0; i <
                          gameDetailsState.gameFireBaseModelList[0].users
                              .length; i++) {
                        int totalQuestions = gameDetailsState
                            .gameFireBaseModelList[0].users[i].questions.length;
                        int totalAnswers = gameDetailsState
                            .gameFireBaseModelList[0]
                            .users[i].answers.length;
                        if (totalQuestions != totalAnswers) {
                          goToNextCategory = false;
                          break;
                        }
                      }
                      if (goToNextCategory) {
                        bool isCreator = false;
                        //search if is currentUser is Creator;
                        String currentUserId = gameDetailsState
                            .gameFireBaseModelList[0].currentUserId;
                        String currentCategoryId = gameDetailsState
                            .gameFireBaseModelList[0].currentCategoryId;
                        for (int i = 0; i <
                            gameDetailsState.gameFireBaseModelList[0].users
                                .length; i++) {
                          UserModel userModel = gameDetailsState
                              .gameFireBaseModelList[0].users[i];
                          if (userModel.isCreator) {
                            if (userModel.userId == widget.userId) {
                              isCreator = true;
                            }
                          }
                        }
                        if (isCreator) {
                          if (currentUserId == "" && currentCategoryId == "") {
                            selectUser(
                                gameDetailsState.gameFireBaseModelList[0]
                                    .users);
                          } else
                          if (currentUserId != "" && currentCategoryId == "") {
                            if (currentUserId == widget.userId) {
                              _showCustomDialog(
                                  gameDetailsState.gameFireBaseModelList[0]
                                      .users,
                                  currentUserId, gameDetailsBloc!, context);
                            }
                          } else
                          if (currentUserId != "" && currentCategoryId != "") {
                            if (currentUserId == widget.userId) {
                              int noOfQuestions = 0;
                              bool? loadQuestions;
                              List<QuestionRequest> questionsRequest = [];
                              for (int i = 0; i < users.length; i++) {
                                int noOfQuestions = users[i].questionsPerUser -
                                    users[i].questions.length;
                                QuestionRequest questionRequest = QuestionRequest(
                                    users[i].userId, currentCategoryId,
                                    noOfQuestions.toString());

                                questionsRequest.add(questionRequest);
                              }

                              gameQuestionsBloc!.add(
                                  FetchQuestionsEvent(
                                      inputs: questionsRequest));
                            }
                          }
                        } else {
                          if (currentUserId == "" && currentCategoryId == "") {


                          } else
                          if (currentUserId != "" && currentCategoryId == "") {
                            if (currentUserId == widget.userId) {
                              _showCustomDialog(
                                  gameDetailsState.gameFireBaseModelList[0]
                                      .users,
                                  currentUserId, gameDetailsBloc!, context);
                            }
                          } else
                          if (currentUserId != "" && currentCategoryId != "") {
                            if (currentUserId == widget.userId) {
                              int noOfQuestions = 0;
                              bool? loadQuestions;
                              List<QuestionRequest> questionsRequest = [];
                              for (int i = 0; i < users.length; i++) {
                                int noOfQuestions = users[i].questionsPerUser -
                                    users[i].questions.length;
                                QuestionRequest questionRequest = QuestionRequest(
                                    users[i].userId, currentCategoryId,
                                    noOfQuestions.toString());

                                questionsRequest.add(questionRequest);
                              }

                              gameQuestionsBloc!.add(
                                  FetchQuestionsEvent(
                                      inputs: questionsRequest));
                            }
                          }
                        }
                      }
                    } else {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return ResultView(gameCode: widget.gameCode,
                                userId: widget.userId,
                                title: widget.title,
                                type: widget.type,
                                isPublicRoom: widget.isPublicRoom,
                                gameFireBaseModel: gameDetailsState
                                    .gameFireBaseModelList[0]

                            );
                          }));
                    }
                  }
                }



              }
            },
            builder: (context, gameDetailsState) {
              if (gameDetailsState is GameUsersStateLoading) {
                return Container(

                    alignment: AlignmentDirectional.center,
                    child: SizedBox(
                        height: AppSize.s100,
                        width: AppSize.s100,
                        child: Lottie.asset(JsonAssets.loading)

                    ));
              }

              else if (gameDetailsState is GameUsersStateFailure) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    gameDetailsState.message,
                    style: Theme
                        .of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                );
              } else if (gameDetailsState is GameUsersStateSuccess) {
                List<UserModel> userModelList = [];

                userModelList = gameDetailsState.gameFireBaseModelList[0].users;
                if(gameDetailsState.gameFireBaseModelList[0].currentCategoryId != "") {
                  for (int i = 0; i < userModelList.length; i++) {
                    if (userModelList[i].userId == widget.userId) {

                      userModel = userModelList[i];
                      int answersLength = userModel!.answers.length;
                      int questionsLength = userModel!.questions.length;
                      if(questionsLength>answersLength){

                      for(int i=answersLength;i<userModel!.questions.length;i++){
                        questionsList.add(userModel!.questions[i]);
                      }
                      if(questionsList.isNotEmpty) {
                        // questionsList = userModel!.questions;
                        quizBloc!.add(LoadQuestions(questionsList,answersLength,));
                      }
                      print(
                          'questionsList.length --- > ${questionsList.length}');
                      break;
                    }
                      }
                  }
                }


                return BlocListener<GameQuestionsBloc, GameQuestionsState>(
                  bloc: gameQuestionsBloc,
  listener: (context, gameQuestionState) {
    if(gameQuestionState is GameQuestionsStateLoading){
      showLoadingDialog(context);
    }
    else if(gameQuestionState is GameQuestionsStateFailure){
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(gameQuestionState.message)),
      );
    }
    else if(gameQuestionState is GameQuestionsStateSuccess){
      Navigator.of(context).pop();

      List<UserModel> users=[];
      for(int i =0;i<gameQuestionState.questionResponseModelList.length;i++){

        UserModel userModel = gameDetailsState.gameFireBaseModelList[0].users[i];
        List<QuestionModel> questionsList =[];
        for(int j=0;j<gameQuestionState.questionResponseModelList[i].questionResultModel.questionList.length;j++){
          List<String> answers =[];
          String answer1 = gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].answer1;
          if(answer1.isNotEmpty){
            answers.add(gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].answer1);
          }

          String answer2 = gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].answer2;
          if(answer2.isNotEmpty){
            answers.add(gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].answer2);
          }

          String answer3 = gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].answer3;
          if(answer3.isNotEmpty){
            answers.add(gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].answer3);
          }

          int correctAnswerIndex = 0;
          if(gameQuestionState.questionResponseModelList[i].questionResultModel.questionList![j].isCorrect1=="1"){
            correctAnswerIndex = 0;
          }else if(gameQuestionState.questionResponseModelList[i].questionResultModel.questionList![j].isCorrect2=="1"){
            correctAnswerIndex = 1;
          }else if(gameQuestionState.questionResponseModelList[i].questionResultModel.questionList![j].isCorrect3=="1"){
            correctAnswerIndex = 2;
          }

          String image = gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].image;
          int points = int.parse(gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].points);
          QuestionModel questionModel  = QuestionModel(questionId: gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].id, questionText: gameQuestionState.questionResponseModelList[i].questionResultModel.questionList[j].question, answers: answers, correctAnswerIndex: correctAnswerIndex, isCorrectAnswer: false, timeInSeconds: 30,image: image,points:points ,isAnswerQuestion:false);
          questionsList.add(questionModel);

        }
        List<QuestionModel> questionsUserList = userModel.questions;
        int remainingQuestions = userModel.questionsPerUser - userModel.answers.length;
        for(int i =0;i<remainingQuestions;i++){
          questionsUserList.add(questionsList[i]);
        }
        List<QuestionModel> questionList =[];
        for(int i =0;i<questionsUserList.length;i++){
          QuestionModel questionModel = questionsUserList[i];
          questionModel.questionId = '${i+1}';
          questionList.add(questionModel);

        }
        userModel.questions=questionList ;
        userModel.isQuestionsLoaded = true;
        userModel.totalCurrentQuestions = questionList.length;
        //error
        users.add(userModel);
      }

      gameDetailsBloc!.add(UpdateQuestionsEvent( roomId:widget.gameCode,users: users));

    }

    // TODO: implement listener
  },
  child: BlocConsumer<QuizBloc, QuizState>(
                                listener: (context,state){

                                  if(state is QuizComplete){
                                    print("QuizComplete ${state.results}");
                                    int totalQuestionsPerUser = userModel!.questionsPerUser;
                                    List<UserModel> users =[];

                                  users = gameDetailsState.gameFireBaseModelList[0].users;
                                  List<UserModel> usersModels =[];
                                  for(int i=0;i<users.length;i++){
                                    UserModel userModel = users[i];
                                    if(userModel.userId == widget.userId){
                                      List<Result>  results =[];
                                      for(int k=0;k<userModel.answers.length;k++){
                                        results.add(userModel.answers[k]);

                                      }
                                      for(int j=0;j<state.results.length;j++){
                                        int points = userModel.questions[j].points;

                                        int milliseconds = state.results[j].timeTaken.inMilliseconds;


                                        Result result = Result(questionId: state.results[j].questionId, isCorrect: state.results[j].isCorrect, timeTaken: milliseconds,userId: widget.userId,roomId: widget.gameCode,currentCategory:  gameDetailsState
                                            .gameFireBaseModelList[0].currentCategoryId,userSelectCategoryId:gameDetailsState.gameFireBaseModelList[0].currentUserId ,points: points.toString());
                                        results.add(result);

                                      }
                                      userModel.answers = results;
                                      usersModels.add(userModel);
                                    }else{
                                      usersModels.add(userModel);
                                    }
                                  }
                                    gameDetailsBloc!.add(InsertFireBaseAnswer(users: usersModels, roomId: widget.gameCode));


                                     // fireBaseAnswerBloc!.add(InsertFireBaseAnswer(roomId: widget.gameCode,answers: results));
                                     //




                                  }
                                },
                                bloc: quizBloc,
                                builder: (context, state) {
                                  if(state is QuizInitial){
                                    return Container(

                                        alignment: AlignmentDirectional.center,
                                        child: SizedBox(
                                            height: AppSize.s100,
                                            width: AppSize.s100,
                                            child: Lottie.asset(JsonAssets.loading)

                                        ));
                                  }else if(state is QuizLoadSuccess){
                                    print("questions ---> ${state.questions.length}");
                                    final question = state.questions[state.currentQuestionIndex];
                                    return BlocListener<ConnectivityBloc, ConnectivityState>(
  listener: (context, state) {
    if (state is ConnectivityFailure) {
      isDialogShown = true;
      _internetConnectionDialog(context);
    } else if (state is ConnectivitySuccess) {
      if(isDialogShown){
        _dismissDialog(context);
        isDialogShown = false;
      }

    }
  },
  child: Container(
                                      margin: EdgeInsets.all(10.w),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 20.w,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('${state.currentQuestionIndex+1}',style:
                                                  TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(16)
                                                  ),),
                                                Text(' / ',style:
                                                TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(16)
                                                ),),
                                                Text('${userModel!.questionsPerUser}',style:
                                                TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(16)
                                                ),)
                                              ],
                                            ),
                                            SizedBox(height: 20.w,),
                                            Text(question.questionText,
                                              textAlign: TextAlign.center,

                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(16),
                                                  fontWeight: FontWeight.bold


                                              ),),
                                            SizedBox(height: 10.w,),
                                            Container(
                                              child: question.image.isEmpty?Container():

                                              Container(
                                                width: ScreenUtil().screenWidth,
                                                height: 90.w,
                                                alignment: AlignmentDirectional.center,
                                                child: Container(
                                                  height: 90.w,
                                                  width: 90.w,
                                                  alignment: AlignmentDirectional.center,
                                                  child:   ClipRRect(
                                                    borderRadius: BorderRadius.circular(AppSize.s8),


                                                    child:
                                                    CachedNetworkImage(
                                                      width: AppSize.width,

                                                      fit: BoxFit.fill,
                                                      imageUrl:'$TAG_IMAGE_URL${question.image}',
                                                      imageBuilder: (context, imageProvider) => Container(
                                                          width: AppSize.width,


                                                          decoration: BoxDecoration(



                                                            image: DecorationImage(


                                                                fit: BoxFit.fill,
                                                                image: imageProvider),
                                                          )
                                                      ),
                                                      placeholder: (context, url) =>
                                                          Column(
                                                            children: [
                                                              Expanded(
                                                                flex: 9,
                                                                child: Container(
                                                                  height: AppSize.height,
                                                                  width:  AppSize.width,


                                                                  alignment: FractionalOffset.center,
                                                                  child: SizedBox(
                                                                      height: AppSize.s50,
                                                                      width: AppSize.s50,
                                                                      child:  const CircularProgressIndicator()),
                                                                ),
                                                              ),
                                                            ],
                                                          ),


                                                      errorWidget: (context, url, error) => Container(
                                                          height: AppSize.height,
                                                          width:  AppSize.width,

                                                          alignment: FractionalOffset.center,
                                                          child: const Icon(Icons.image_not_supported_outlined)),

                                                    ),
                                                    // Image.network(
                                                    //
                                                    //
                                                    // '${kBaseUrl}${mAdsPhoto}${item.photo}'  , fit: BoxFit.fitWidth,
                                                    //   height: 600.h,),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: question!.image.isEmpty?0:10.w,
                                            ),
                                        ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context,index){
                                              Answer answer = question.answers[index];
                                              final isSelected = answer.id == state.questions[state.currentQuestionIndex].id;

                                              print("state.showCorrectAnswer --> ${state.showCorrectAnswer}");
                                              return GestureDetector(
                                                onTap: (){
                                                  if (!state.showCorrectAnswer) {
                                                    quizBloc!.add(SelectAnswer(question.id, answer.id));
                                                  }
                                                  // _timerBloc.add(StopTimer());
                                                  // _answerBloc.add(ToggleItemStatus(state.answers[index].id,state.answers));


                                                },
                                                child: Container(
                                                  height: 50.w,
                                                  width:
                                                  ScreenUtil().screenWidth,
                                                  alignment: AlignmentDirectional.center,
                                                  decoration: BoxDecoration(
                                                    color: state.showCorrectAnswer
                                                        ? (answer.isCorrect ? Colors.green : Colors.red)
                                                        : ColorManager.secondary,

                                                    borderRadius: BorderRadius.circular(5.w),

                                                  ),
                                                  child: Text(
                                                    answer.text,
                                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil().setSp(12),
                                                        fontWeight: FontWeight.normal
                                                    ),

                                                  ),
                                                ),
                                              );
                                            }, separatorBuilder: (context,index){
                                          return Container(height: 10.w,);

                                        }, itemCount: question.answers.length),
                                            BlocBuilder<TimerBloc, TimerState>(
                                              bloc: timerBloc,

                                              builder: (context, timerState) {
                                                if (timerState is TimerRunInProgress) {
                                                  return Text('Time left: ${timerState.duration}');
                                                } else if (timerState is TimerRunComplete) {
                                                  return Text('Time is up!');
                                                }
                                                return Container();
                                              },
                                            ),



                                          ],
                                        ),
                                      ),
                                    ),
);
                                  }else if (state is QuizComplete) {
                                   
                                    return  Center(child: Text('waiting For Other Users',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.w500,
                                      
                                    ),));
                                  } else {
                                    return const Center(child: Text('Failed to load quiz'));
                                  }

                                },
                              ),
);
              } else {
                return Container();
              }
            },
          )
      ),
    );
  }

  void selectUser( List<UserModel> users) async{
    List<UserModel> gameUsers = [];

    List<UserModel> usersNotSelected =[];

    for(int i =0;i<users.length;i++) {
      if (!users[i].isSelectCategroy) {
        usersNotSelected.add(users[i]);
      }
      gameUsers.add(users[i]);
    }

    print(gameUsers.length);





    final random = Random();
    print("user select ---> ${usersNotSelected.length}");
    String currentSelectUserId = usersNotSelected[random.nextInt(usersNotSelected.length)].userId;
    for(int i =0;i<gameUsers.length;i++){
      String userId = gameUsers[i].userId;
      if(userId == currentSelectUserId){

        gameUsers[i].isSelectCategroy = true ;
      }



    }
    List<UserModel> currentUsers =[];
    for(int i =0;i<gameUsers.length;i++){
      int noOfquestions = gameUsers[i].questionsPerUser;
      int noOfAnsweredQuestiosns = gameUsers[i].questions.length;
      int noofCurrentQuestions = noOfquestions - noOfAnsweredQuestiosns;
      UserModel userModel = gameUsers[i];
      // userModel.questionsPerUser = noofCurrentQuestions;
      currentUsers.add(userModel);



    }
    gameDetailsBloc!.add(InitializeQuestionsEvent(roomId: widget.gameCode, currentUserId: currentSelectUserId, users: currentUsers));










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
                if(widget.type == 1){
                  gameDetailsBloc!.add(DeleteRoom(roomId: widget.gameCode));
                }else{
                  for(int i =0;i<userModelsList.length;i++){
                    if(userModelsList[i].userId == widget.userId){
                      userModelsList.removeAt(i);
                      break;
                    }
                  }
                  gameDetailsBloc!.add(UpdateUsersEvent(roomId: widget.gameCode,users: userModelsList));
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
                if(widget.type == 1){
                  gameDetailsBloc!.add(DeleteRoom(roomId: widget.gameCode));
                }else{
                  for(int i =0;i<userModelsList.length;i++){
                    if(userModelsList[i].userId == widget.userId){
                      userModelsList.removeAt(i);
                      break;
                    }
                  }
                  gameDetailsBloc!.add(UpdateUsersEvent(roomId: widget.gameCode,users: userModelsList));
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
}
