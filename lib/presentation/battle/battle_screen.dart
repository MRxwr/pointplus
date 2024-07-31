import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/app/di.dart';
import 'package:point/domain/compare_model.dart';
import 'package:point/presentation/battle/bloc/QuizCategoryQuestionsCubit.dart';
import 'package:point/presentation/battle/bloc/QuizCubit.dart';
import 'package:point/presentation/battle/multiUserBattleRoomResultScreen.dart';
import 'package:point/presentation/battle/widgets/messageBoxContainer.dart';
import 'package:point/presentation/battle/widgets/messageContainer.dart';
import 'package:point/presentation/battle/widgets/questionsContainer.dart';
import 'package:point/presentation/battle/widgets/rectangleUserProfileContainer.dart';
import 'package:point/presentation/battle/widgets/waitForOthersContainer.dart';
import 'package:point/presentation/common/freezed_data_class.dart';
import 'package:point/presentation/game_categories/bloc/multiUserBattleRoomCubit.dart';
import 'package:point/presentation/game_categories/bloc/quizCategoryCubit.dart';
import 'package:point/presentation/game_categories/models/questionCategory.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/constant.dart';
import '../../domain/models/models.dart';
import '../../systemConfig/cubits/systemConfigCubit.dart';
import '../../views/customAppbar.dart';
import '../../views/custom_image.dart';
import '../../views/exitGameDialog.dart';
import '../../views/fonts.dart';
import '../../views/internet_connectivity.dart';
import '../../views/ui_utils.dart';
import '../game_categories/bloc/messageCubit.dart';
import '../game_categories/models/battleRoom.dart';
import '../game_categories/models/message.dart';
import '../game_categories/models/userBattleRoomDetails.dart';
import '../main/UserDetailsCubit.dart';
import '../main/game/widgets/categories_widget.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
class BattleScreen extends StatefulWidget {
  String categoryId;
  String userId;
  String noOfQuestions;
  String roomId;
   BattleScreen({super.key,required this.categoryId,required this.userId,required this.noOfQuestions,required this.roomId});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController timerAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 30,
    ),
  )
    ..addStatusListener(currentUserTimerAnimationStatusListener)
    ..forward();

  //to animate the question container
  late AnimationController questionAnimationController;
  late AnimationController questionContentAnimationController;

  //to slide the question container from right to left
  late Animation<double> questionSlideAnimation;

  //to scale up the second question
  late Animation<double> questionScaleUpAnimation;

  //to scale down the second question
  late Animation<double> questionScaleDownAnimation;

  //to slude the question content from right to left
  late Animation<double> questionContentAnimation;
  int currentQuestionIndex = 0;

  late AnimationController messageAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
  );
  late Animation<double> messageAnimation =
  Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: messageAnimationController,
      curve: Curves.easeOutBack,
    ),
  );
  double get scrWidth => MediaQuery.of(context).size.width;

  double get scrHeight => MediaQuery.of(context).size.height;
  late List<AnimationController> opponentMessageAnimationControllers = [];
  late List<Animation<double>> opponentMessageAnimations = [];

  late List<AnimationController> opponentProgressAnimationControllers = [];

  late AnimationController messageBoxAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  late Animation<double> messageBoxAnimation =
  Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: messageBoxAnimationController,
      curve: Curves.easeInOut,
    ),
  );



  //if user has minimized the app
  bool showUserLeftTheGame = false;

  bool showWaitForOthers = false;

  //to track if setting dialog is open
  bool isSettingDialogOpen = false;

  bool isExitDialogOpen = false;

  //current user message timer
  Timer? currentUserMessageDisappearTimer;
  int currentUserMessageDisappearTimeInSeconds = 10;

  List<Timer?> opponentsMessageDisappearTimer = [];
  List<int> opponentsMessageDisappearTimeInSeconds = [];

  late double userDetaislHorizontalPaddingPercentage =
      (1.0 - UiUtils.questionContainerWidthPercentage) * (0.5);

  late List<Message> latestMessagesByUsers = [];
  late int userLength;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();


  }
  void init(){

    WakelockPlus.enable();
    for (var i = 0; i < maxUsersInGroupBattle; i++) {
      latestMessagesByUsers.add(Message.empty());
    }
    Future.delayed(Duration.zero, () {


        context.read<MessageCubit>().subscribeToMessages(
        context.read<MultiUserBattleRoomCubit>().getRoomId(),
      );




    });
    initializeAnimation();
    initOpponentConfig();
    questionContentAnimationController.forward();
    //add observer to track app lifecycle activity
    WidgetsBinding.instance.addObserver(this);
    userLength = context.read<MultiUserBattleRoomCubit>().getUsers().length;

  }

  @override
  void dispose() {
    WakelockPlus.disable();
    timerAnimationController
      ..removeStatusListener(currentUserTimerAnimationStatusListener)
      ..dispose();
    questionAnimationController.dispose();
    questionContentAnimationController.dispose();
    messageAnimationController.dispose();
    for (final element in opponentMessageAnimationControllers) {
      element.dispose();
    }
    for (final element in opponentProgressAnimationControllers) {
      element.dispose();
    }
    for (final element in opponentsMessageDisappearTimer) {
      element?.cancel();
    }
    messageBoxAnimationController.dispose();
    currentUserMessageDisappearTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  bool appWasPaused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //remove user from room
    if (state == AppLifecycleState.paused) {
      appWasPaused = true;
      final multiUserBattleRoomCubit = context.read<MultiUserBattleRoomCubit>();
      //if user has already won the game then do nothing
      if (multiUserBattleRoomCubit.getUsers().length != 1) {
        deleteMessages(multiUserBattleRoomCubit);
        multiUserBattleRoomCubit
            .deleteUserFromRoom(context.read<UserDetailsCubit>().userId());
      }
      //
    } else if (state == AppLifecycleState.resumed && appWasPaused) {
      final multiUserBattleRoomCubit = context.read<MultiUserBattleRoomCubit>();
      //if user has won the game already
      if (multiUserBattleRoomCubit.getUsers().length == 1 &&
          multiUserBattleRoomCubit.getUsers().first!.uid ==
              context.read<UserDetailsCubit>().userId()) {
        setState(() {
          showUserLeftTheGame = false;
        });
      }
      //
      else {
        setState(() {
          showUserLeftTheGame = true;
        });
      }
      stopAnimationAndCalculateTime();

    }
  }
  void stopAnimationAndCalculateTime() {
    timerAnimationController.stop();
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime!);
      differenceMilliSecondes = duration.inMilliseconds;
      // print("Animation ran for ${duration.inMilliseconds} milliseconds before stopping.");
      // Handle the calculated time as needed
    }
  }
  void deleteMessages(MultiUserBattleRoomCubit battleRoomCubit) {
    //to delete messages by given user
    context.read<MessageCubit>().deleteMessages(
      battleRoomCubit.getRoomId(),
      context.read<UserDetailsCubit>().userId(),
    );
  }

  void initOpponentConfig() {
    //
    for (var i = 0; i < (maxUsersInGroupBattle - 1); i++) {
      opponentMessageAnimationControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      );
      opponentProgressAnimationControllers
          .add(AnimationController(vsync: this));
      opponentMessageAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: opponentMessageAnimationControllers[i],
            curve: Curves.easeOutBack,
          ),
        ),
      );
      opponentsMessageDisappearTimer.add(null);
      opponentsMessageDisappearTimeInSeconds.add(4);
    }
  }

  //
  void initializeAnimation() {
    questionAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    questionContentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    questionSlideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: questionAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    questionScaleUpAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(
        parent: questionAnimationController,
        curve: const Interval(0, 0.5, curve: Curves.easeInQuad),
      ),
    );
    questionScaleDownAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(
        parent: questionAnimationController,
        curve: const Interval(0.5, 1, curve: Curves.easeOutQuad),
      ),
    );
    questionContentAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: questionContentAnimationController,
        curve: Curves.easeInQuad,
      ),
    );
  }

  void toggleSettingDialog() {
    isSettingDialogOpen = !isSettingDialogOpen;
  }
  DateTime? startTime;
  DateTime? endTime;
  int? differenceMilliSecondes;
  //listener for current user timer
  void currentUserTimerAnimationStatusListener(AnimationStatus status) {
    print('animation status ---> ${status}');
    if (status == AnimationStatus.forward) {
      // Capture start time
      startTime = DateTime.now();
      print("Animation Started at $startTime");
    }else
    if (status == AnimationStatus.completed) {
      endTime = DateTime.now();
      if (startTime != null) {
        final difference = endTime!.difference(startTime!);
        differenceMilliSecondes = difference.inMilliseconds;
        print("differenceMilliSecondes ----> $differenceMilliSecondes");
         }
      submitAnswer('-1');
    }else    if (status == AnimationStatus.dismissed) {
      endTime = DateTime.now();
      if (startTime != null) {
        final difference = endTime!.difference(startTime!);
        differenceMilliSecondes = difference.inMilliseconds;
        print("differenceMilliSecondes ----> $differenceMilliSecondes");

      }

    }
  }
  DateTime? _animationStopTime;
  //update answer locally and on cloud
  void submitAnswer(String submittedAnswer)async  {
    print("submittedAnswer ---> ${submittedAnswer}");
    stopAnimationAndCalculateTime();



    //

    final battleRoomCubit = context.read<MultiUserBattleRoomCubit>();
    final questions = battleRoomCubit.getQuestions();
    String correctAnswerId = questions[currentQuestionIndex].correctAnswer!.answerId!.toString();
    print("correct answer Id ---> ${questions[currentQuestionIndex].correctAnswer!.answerId}");
    print("userId ----> ${context.read<UserDetailsCubit>().userId()}");

    if (!questions[currentQuestionIndex].attempted!) {
      //updated answer locally
      battleRoomCubit
        .updateQuestionAnswer(
          currentQuestionIndex,
          submittedAnswer,
        );
      print("differenceMilliSecondes ---> ${differenceMilliSecondes}");
      battleRoomCubit.submitAnswer(
          context.read<UserDetailsCubit>().userId(),
          submittedAnswer,
        differenceMilliSecondes!,
          questions[currentQuestionIndex]!.points!,

          isCorrectAnswer: submittedAnswer ==
              correctAnswerId,
        );

      // //change question
      // await Future<void>.delayed(
      //   const Duration(seconds: inBetweenQuestionTimeInSeconds),
      // );
      // if (currentQuestionIndex == (questions.length - 1)) {
      //   setState(() {
      //     showWaitForOthers = true;
      //   });
      // } else {
      //   changeQuestion();
      //   await timerAnimationController.forward(from: 0);
      // }
   }
  }

  //next question
  void changeQuestion(List<UserBattleRoomDetails?> users) {

 if( areAllUsersAnswersEqual(users)) {
   questionAnimationController.forward(from: 0).then((value) {
     //need to dispose the animation controllers
     questionAnimationController.dispose();
     questionContentAnimationController.dispose();
     //initializeAnimation again
     setState(() {
       initializeAnimation();
       currentQuestionIndex++;
     });
     //load content(options, image etc) of question
     questionContentAnimationController.forward();
   });
 }else{
   showLoadingState();
 }
  }

  //if user has submitted the answer for current question
  bool hasSubmittedAnswerForCurrentQuestion() {
    return context
        .read<MultiUserBattleRoomCubit>()
        .getQuestions()[currentQuestionIndex]
        .attempted!;
  }

  void battleRoomListener(
      BuildContext context,
      MultiUserBattleRoomState state,
      MultiUserBattleRoomCubit battleRoomCubit,
      ) async{
    Future.delayed(Duration.zero, () async {
      if (await InternetConnectivity.isUserOffline()) {
        await  showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shadowColor: Colors.transparent,
            actions: [
              TextButton(
                onPressed: () async {
                  if (!await InternetConnectivity.isUserOffline()) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text(
                  context.tr('retryLbl')!,
                  style: TextStyle(
                    color: ColorManager.secondary,
                  ),
                ),
              ),
            ],
            content: Text(
              context.tr('noInternet')!,
            ),
          ),
        );
      }
    });




    if (state is MultiUserBattleRoomSuccess) {
      if (battleRoomCubit.getUsers().length != 1) {
        //if there is more than one user in room
        //navigate to result
        //check if it main User Or Not
        // if it main User Search for new User
        //else wait for show new User Categories then select category then load new question then update question and the problem will solve

        navigateToResultScreen(
            battleRoomCubit.getUsers(),
            state.battleRoom,
            state.questions,
            battleRoomCubit,
            state .battleRoom!.createdBy!.toString(),
          context.read<UserDetailsCubit>().userId(),

        );
      }


    }
  }

  void setCurrentUserMessageDisappearTimer() {
    if (currentUserMessageDisappearTimeInSeconds != 4) {
      currentUserMessageDisappearTimeInSeconds = 4;
    }

    currentUserMessageDisappearTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (currentUserMessageDisappearTimeInSeconds == 0) {
            //
            timer.cancel();
            messageAnimationController.reverse();
          } else {
            currentUserMessageDisappearTimeInSeconds--;
          }
        });
  }

  void setOpponentUserMessageDisappearTimer(int opponentUserIndex) {
    //
    if (opponentsMessageDisappearTimeInSeconds[opponentUserIndex] != 4) {
      opponentsMessageDisappearTimeInSeconds[opponentUserIndex] = 4;
    }

    opponentsMessageDisappearTimer[opponentUserIndex] =
        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (opponentsMessageDisappearTimeInSeconds[opponentUserIndex] == 0) {
            //
            timer.cancel();
            opponentMessageAnimationControllers[opponentUserIndex].reverse();
          } else {
            //
            opponentsMessageDisappearTimeInSeconds[opponentUserIndex] =
                opponentsMessageDisappearTimeInSeconds[opponentUserIndex] - 1;
          }
        });
  }

  Future<void> messagesListener(MessageState state) async {
    if (state is MessageFetchedSuccess) {
      if (state.messages.isNotEmpty) {
        //current user message

        if (context
            .read<MessageCubit>()
            .getUserLatestMessage(
          //fetch user id
          context.read<UserDetailsCubit>().userId(),
          messageId: latestMessagesByUsers[0].messageId,
          //latest user message id
        )
            .messageId
            .isNotEmpty) {
          //Assign latest message
          latestMessagesByUsers[0] =
              context.read<MessageCubit>().getUserLatestMessage(
                context.read<UserDetailsCubit>().userId(),
                messageId: latestMessagesByUsers[0].messageId,
              );

          //Display latest message by current user
          //means timer is running
          if (currentUserMessageDisappearTimeInSeconds > 0 &&
              currentUserMessageDisappearTimeInSeconds < 4) {
            currentUserMessageDisappearTimer?.cancel();
            setCurrentUserMessageDisappearTimer();
          } else {
            await messageAnimationController.forward();
            setCurrentUserMessageDisappearTimer();
          }
        }

        //display opponent user messages

        final opponentUsers = context
            .read<MultiUserBattleRoomCubit>()
            .getOpponentUsers(context.read<UserDetailsCubit>().userId());

        for (var i = 0; i < opponentUsers.length; i++) {
          if (context
              .read<MessageCubit>()
              .getUserLatestMessage(
            //opponent user id
            opponentUsers[i]!.uid,
            messageId: latestMessagesByUsers[i + 1].messageId,
            //latest user message id
          )
              .messageId
              .isNotEmpty) {
            //Assign latest message
            latestMessagesByUsers[i + 1] =
                context.read<MessageCubit>().getUserLatestMessage(
                  context.read<UserDetailsCubit>().userId(),
                  messageId: latestMessagesByUsers[i + 1].messageId,
                );

            //if new message by opponent
            if (opponentsMessageDisappearTimeInSeconds[i] > 0 &&
                opponentsMessageDisappearTimeInSeconds[i] < 4) {
              //
              opponentsMessageDisappearTimer[i]?.cancel();
              setOpponentUserMessageDisappearTimer(i);
            } else {
              await opponentMessageAnimationControllers[i].forward();
              setOpponentUserMessageDisappearTimer(i);
            }
          }
        }
      }
    }
  }

  bool  getUserSelectCategory(List<UserBattleRoomDetails?> users,UserBattleRoomDetails user,String userId){
   bool isCurrentUserSelected= false;





        if(user.uid == userId){
          isCurrentUserSelected = true;


        }







    return isCurrentUserSelected;

  }
  bool waitForOthersLoading( List<UserBattleRoomDetails?> users){
    bool isLoaded = true;
    for (final user in users) {
      //if user uid is not empty means user has not left the game so
      //we will check for it's answer completion
      if (user!.uid.isNotEmpty) {
        if (!user.questionLoaded) {
          isLoaded = false;
        }
      }
    }


    return isLoaded;



  }
  void showLoadingState(){
    showWaitForOthers = true;
    if(mounted){

    }
    setState(() {

    });
  }
  Future<void> loadNextQuestion(List<UserBattleRoomDetails?> users) async{

    showWaitForOthers = false;

    changeQuestion(users);
    await timerAnimationController.forward(from: 0);
  }

  bool isAllUsersAnswers(List<UserBattleRoomDetails?> users){
    bool isAnswered= true;
    for (final user in users) {
      //if user uid is not empty means user has not left the game so
      //we will check for it's answer completion
      if (user!.uid.isNotEmpty) {
        //if every user has submitted the answer then move user to result screen
        if (user.answers.length != user.totalCurrentQuestions) {
          isAnswered = false;
        }
      }
    }
    return isAnswered;
  }
  bool goNextCategory(  UserBattleRoomDetails user,   List<Questions> questions){
    bool goNextCategory = false;

    int remaingQuestion = user.totalQuestionsPerUser-questions.length;
    if(remaingQuestion>0){
      goNextCategory = true;
    }
    return goNextCategory;

  }

  bool checkNewCategorySelect(List<UserBattleRoomDetails?> users,String currentUserId){
    bool selectNewCategory= false;
    for(int i =0;i<users.length;i++){

      if(users[i]!.uid.isNotEmpty){
        if(users[i]!.uid == currentUserId){

          if(users[i]!.isSelecetedCategory && users[i]!.categoryId.isNotEmpty && users[i]!.questionLoaded && (users[i]!.totalQuestionsPerUser - users[i]!.totalCurrentQuestions  > 0) ){

            selectNewCategory = true;
            break;
          }


        }






      }

    }
    return selectNewCategory;

  }

  bool areAllUsersAnswersEqual(List<UserBattleRoomDetails?> users) {
    for (int i = 1; i < users.length; i++) {
      if (users[i]!.answers.length != users[0]!.answers.length) {
        return false; // Found an element that is not equal to the first element
      }
    }
    return true; // All elements are equal
  }
  void navigateToResultScreen(
      List<UserBattleRoomDetails?> users,
      BattleRoom? battleRoom,
      List<Questions>? questions,
      MultiUserBattleRoomCubit battleRoomCubit,
      String creatorId,
      String currentUserId
      ) async{

    print("navigationlsjdlsjd");
    var navigateToResult = true;

    if (users.isEmpty) {
      return;
    }
    bool isFinish = battleRoom!.isLoadedScreen!;

    for (final user in users) {
      //if user uid is not empty means user has not left the game so
      //we will check for it's answer completion
      if (user!.uid.isNotEmpty) {
        print("Questions --> ${questions!.length}");
        //if every user has submitted the answer then move user to result screen
        if (user.answers.length != questions!.length) {
          navigateToResult = false;
        }
      }
    }








    if(navigateToResult){
      bool isCreator = false;
      UserBattleRoomDetails? creatorUser;
      UserBattleRoomDetails? currentUser;
      String userName = "";

      for (int i=0;i<users.length;i++ ) {

        if (users[i]!.uid == creatorId) {
          isCreator = true;
          creatorUser = users[i];
          userName = "user${i+1}";


        }
      }
      for (int i=0;i<users.length;i++ ) {

        if (users[i]!.uid == currentUserId) {

          currentUser = users[i];
          userName = "user${i+1}";


        }
      }
      if(checkNewCategorySelect(users,battleRoom.currentUser!)){
        print("chcek");

        if(isCreator){


          if (creatorUser!.totalQuestionsPerUser> 0) {
            if(isAllUsersAnswers(users)) {
              battleRoomCubit
                  .selectUserForSelectCategoryMultiUserBattleRoom();
            }else{
              if(creatorUser.questionLoaded){
                if(creatorUser.answers.length<battleRoom.questions!.length) {
                  context.read<MultiUserBattleRoomCubit>()
                      .getQuestionsFromFireBase();
                }else{
                  loadingWidget();
                }

              }else{
                loadingWidget();
              }

            }


          }



        }else{
          if(currentUser!.questionLoaded){
            if(currentUser.answers.length<battleRoom.questions!.length) {
              context.read<MultiUserBattleRoomCubit>()
                  .getQuestionsFromFireBase();
            }else{
              loadingWidget();
            }

          }else {
            loadingWidget();
          }
        }



      }else{
        UserBattleRoomDetails? currentUserBattleRoomDetails;
        for(int i =0;i<users.length;i++){
          if(users[i]!.uid == battleRoom.currentUser){
            currentUserBattleRoomDetails = users[i]!;
          }


        }
        int different = currentUser!.totalQuestionsPerUser - currentUser.answers.length;

        if(
        different <= 0
        ){

          // giving delay
          Future.delayed(const Duration(milliseconds: 1000), () {
            try {
              //delete battle room by creator of this room
              if (battleRoom!.user1!.uid ==
                  context.read<UserDetailsCubit>().userId()) {
                context
                    .read<MultiUserBattleRoomCubit>()
                    .deleteMultiUserBattleRoom();
              }
              deleteMessages(context.read<MultiUserBattleRoomCubit>());

              //
              //navigating result screen twice...
              //Find optimize solution of navigating to result screen
              //https://stackoverflow.com/questions/56519093/bloc-listen-callback-called-multiple-times try this solution
              //https: //stackoverflow.com/questions/52249578/how-to-deal-with-unwanted-widget-build
              //tried with mounted is true but not working as expected
              //so executing this code in try catch
              //

              if (isSettingDialogOpen) {
                Navigator.of(context).pop();
              }
              if (isExitDialogOpen) {
                Navigator.of(context).pop();
              }
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return MultiUserBattleRoomResultScreen(users: context.read<MultiUserBattleRoomCubit>().getUsers(),
                        totalQuestions:context
                            .read<MultiUserBattleRoomCubit>()
                            .getQuestions()
                            .length,
                      creatorId: creatorId,

                       );
                  }));

            } catch (e) {
              rethrow;
            }
          });

        }else{
          bool isQuestionLoaded = currentUser!.questionLoaded;


            if (isQuestionLoaded) {
              if(currentUser.answers.length != questions!.length) {

                 loadNextQuestion(users);



              }else{
                context.read<MultiUserBattleRoomCubit>().getQuestionsFromFireBase();

              }
            }

            else {
              if (battleRoom!
                  .currentCategoryId
                  .toString()
                  .isNotEmpty) {
                if (!currentUser.questionLoaded) {
                  if(battleRoom.currentUser == widget.userId){
                    if(currentUser.answers.length == questions!.length) {
                      if(currentUser!.totalQuestionsPerUser - currentUser!.totalCurrentQuestions >0) {
                        battleRoomCubit
                            .getQuizCategoryQuestionWithUserIdAndCategoyrId(
                            battleRoom!.currentUser!,
                            battleRoom.currentCategoryId.toString(),
                            creatorUser!.totalQuestionsPerUser.toString(),
                            battleRoom.roomId.toString()
                        );
                      }
                    }
                  }

                }
              }

              else {
                if (battleRoom.currentUser == currentUserId) {
                  if(isAllUsersAnswers(users)) {
                    _showCustomDialog(
                        battleRoomCubit.getRoomId(), userName, battleRoomCubit
                        .getQuestions()
                        .length, battleRoomCubit.getCategories(), context,
                        battleRoomCubit);
                  }else{
                    showLoadingState();
                  }
                }

                else {
                  showLoadingState();
                }
              }

          }
        }








      }
      ////





      }



    else {

      if(questions!.length>currentQuestionIndex) {
        // bool isAllLoaded = true;
        //
        // for (int i = 0; i < users.length; i++) {
        //   print('user isLoaded New Questions ---> ${users[i]!.questionLoaded}');
        //   if (!users[i]!.questionLoaded) {
        //     isAllLoaded = false;
        //   }
        // }
        //
        // if (isAllLoaded) {
          print("currentQuestionIndex--> ${currentQuestionIndex}");
          print("attempted ---> ${questions[currentQuestionIndex].attempted}");
          if (hasSubmittedAnswerForCurrentQuestion()) {
            print("currentQuestionIndex ---> ${currentQuestionIndex}");
            print("questions.length  ---> ${questions!.length - 1}");
            if (currentQuestionIndex == (questions!.length - 1)) {
              setState(() {
                showWaitForOthers = true;
              });
            } else {
              showWaitForOthers = false;
              changeQuestion(users);
              await timerAnimationController.forward(from: 0);
            }
          }
        }
      // }
    }

  }

  Widget _buildYouWonContainer(MultiUserBattleRoomCubit battleRoomCubit) {
    return BlocBuilder<MultiUserBattleRoomCubit, MultiUserBattleRoomState>(
      bloc: battleRoomCubit,
      builder: (context, state) {
        if (state is MultiUserBattleRoomSuccess) {
          if (battleRoomCubit.getUsers().length == 1 &&
              state.battleRoom.user1!.uid ==
                  context.read<UserDetailsCubit>().userId()) {
            stopAnimationAndCalculateTime();

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).colorScheme.background.withOpacity(0.1),
              alignment: Alignment.center,
              child: AlertDialog(
                shadowColor: Colors.transparent,
                title: Text(
                  context.tr('youWonLbl')!,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                content: Text(
                  context.tr('everyOneLeftLbl')!,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      //delete messages
                      deleteMessages(context.read<MultiUserBattleRoomCubit>());

                      //add coins locally



                      //delete room
                      battleRoomCubit.deleteMultiUserBattleRoom();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      context.tr('okayLbl')!,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildUserLeftTheGame() {
    //cancel timer when user left the game
    if (showUserLeftTheGame) {
      return Container(
        color: Theme.of(context).colorScheme.background.withOpacity(0.1),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AlertDialog(
          shadowColor: Colors.transparent,
          content: Text(
            context.tr('youLeftLbl')!,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                context.tr('okayLbl')!,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildCurrentUserDetails(
      UserBattleRoomDetails userBattleRoomDetails,
      String totalQues,
      ) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: MediaQuery.of(context).size.width *
              userDetaislHorizontalPaddingPercentage,
          bottom: MediaQuery.of(context).size.height *
              RectangleUserProfileContainer.userDetailsHeightPercentage *
              0.25,
        ),

        child: ImageCircularProgressIndicator(
          userBattleRoomDetails: userBattleRoomDetails,
          animationController: timerAnimationController,
          totalQues: totalQues,
          // opponentProgressAnimationControllers[opponentUserIndex],
        ),
        // child: RectangleUserProfileContainer(
        //   userBattleRoomDetails: userBattleRoomDetails,
        //   isLeft: true,
        //   progressColor: Theme.of(context).colorScheme.background,
        // ),
      ),
    );
  }

  Widget _buildOpponentUserDetails({
    required int questionsLength,
    required AlignmentDirectional alignment,
    required List<UserBattleRoomDetails?> opponentUsers,
    required int opponentUserIndex,
  }) {
    final userBattleRoomDetails = opponentUsers[opponentUserIndex]!;
    // double progressPercentage =
    //     (100.0 * userBattleRoomDetails.answers.length) / questionsLength;
    // opponentProgressAnimationControllers[opponentUserIndex].value =
    //     NormalizeNumber.inRange(
    //   currentValue: progressPercentage,
    //   minValue: 0.0,
    //   maxValue: 100.0,
    //   newMaxValue: 1.0,
    //   newMinValue: 0.0,
    // );
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: alignment == AlignmentDirectional.bottomEnd ||
              alignment == AlignmentDirectional.topEnd
              ? 0
              : MediaQuery.of(context).size.width *
              userDetaislHorizontalPaddingPercentage,
          end: alignment == AlignmentDirectional.bottomEnd ||
              alignment == AlignmentDirectional.topEnd
              ? MediaQuery.of(context).size.width *
              userDetaislHorizontalPaddingPercentage
              : 0,
          bottom: MediaQuery.of(context).size.height *
              RectangleUserProfileContainer.userDetailsHeightPercentage *
              (0.25),
          top: alignment == AlignmentDirectional.topStart ||
              alignment == AlignmentDirectional.topEnd
              ? 0
              : 0,
        ),
        child: ImageCircularProgressIndicator(
          userBattleRoomDetails: userBattleRoomDetails,
          animationController:
          opponentProgressAnimationControllers[opponentUserIndex],
          totalQues: questionsLength.toString(),
        ),
        // child: RectangleUserProfileContainer(
        //   userBattleRoomDetails: userBattleRoomDetails,
        //   isLeft: alignment == AlignmentDirectional.bottomStart ||
        //       alignment == AlignmentDirectional.topStart,
        //   animationController:
        //       opponentProgressAnimationControllers[opponentUserIndex],
        //   progressColor: Theme.of(context).colorScheme.background,
        // ),
      ),
    );
  }

  Widget _buildMessageButton() {
    return AnimatedBuilder(
      animation: messageBoxAnimationController,
      builder: (context, child) {
        return InkWell(
          onTap: () {
            if (messageBoxAnimationController.isCompleted) {
              messageBoxAnimationController.reverse();
            } else {
              messageBoxAnimationController.forward();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 4),
            child: Icon(
              CupertinoIcons.ellipses_bubble_fill,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBoxContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: messageBoxAnimation.drive(
          Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero),
        ),
        child: MessageBoxContainer(

          battleRoomId: context.read<MultiUserBattleRoomCubit>().getRoomId(),
          topPadding: MediaQuery.of(context).padding.top,
          closeMessageBox: () {
            messageBoxAnimationController.reverse();
          },
        ),
      ),
    );
  }

  Widget _buildCurrentUserMessageContainer() {
    return PositionedDirectional(
      start: MediaQuery.of(context).size.width *
          userDetaislHorizontalPaddingPercentage,
      bottom: MediaQuery.of(context).size.height *
          RectangleUserProfileContainer.userDetailsHeightPercentage *
          2.9,
      child: ScaleTransition(
        scale: messageAnimation,
        alignment: const Alignment(-0.5, -1),
        child: const MessageContainer(

          isCurrentUser: true,
        ), //-0.5 left side and 0.5 is right side,
      ),
    );
  }

  Widget _buildOpponentUserMessageContainer(int opponentUserIndex) {
    var alignment = const Alignment(-0.5, 1);
    if (opponentUserIndex == 0) {
      alignment = const Alignment(0.5, 1);
    } else if (opponentUserIndex == 1) {
      alignment = const Alignment(-0.5, -1);
    } else {
      alignment = const Alignment(0.5, -1);
    }

    return PositionedDirectional(
      end: opponentUserIndex == 1
          ? null
          : MediaQuery.of(context).size.width *
          userDetaislHorizontalPaddingPercentage,
      start: opponentUserIndex == 1
          ? MediaQuery.of(context).size.width *
          userDetaislHorizontalPaddingPercentage
          : null,
      top: opponentUserIndex == 0
          ? null
          : (MediaQuery.of(context).size.height *
          RectangleUserProfileContainer.userDetailsHeightPercentage *
          3.35) +
          MediaQuery.of(context).padding.top,
      bottom: opponentUserIndex == 0
          ? MediaQuery.of(context).size.height *
          RectangleUserProfileContainer.userDetailsHeightPercentage *
          (2.9)
          : null,
      child: ScaleTransition(
        scale: opponentMessageAnimations[opponentUserIndex],
        alignment: alignment,
        child: MessageContainer(

          isCurrentUser: false,
          opponentUserIndex: opponentUserIndex,
        ), //-0.5 left side and 0.5 is right side,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final battleRoomCubit = context.read<MultiUserBattleRoomCubit>();

    final opponentUsers = battleRoomCubit
        .getOpponentUsers(context.read<UserDetailsCubit>().userId());
    return  PopScope(
      canPop: showUserLeftTheGame,
      onPopInvoked: (didPop) {
        if (didPop) return;

        // Close Message Box Before
        if (messageBoxAnimationController.isCompleted) {
          messageBoxAnimationController.reverse();
          return;
        }

        isExitDialogOpen = true;
        showDialog<void>(
          context: context,
          builder: (_) => ExitGameDialog(
            onTapYes: () {
              if (battleRoomCubit.getUsers().length == 1) {
                battleRoomCubit.deleteMultiUserBattleRoom();
              } else {
                //delete user from game room
                battleRoomCubit.deleteUserFromRoom(
                  context.read<UserDetailsCubit>().userId(),
                );
              }
              deleteMessages(battleRoomCubit);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ).then((value) => isExitDialogOpen = true);
      },
      child: Scaffold(
          appBar: QAppBar(
            roundedAppBar: false,
            title: Center(
              child: Center(
                child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
              ),
            ),
            onTapBackButton: () {


              //if user hasleft the game
              if (showUserLeftTheGame) {
                Navigator.of(context).pop();
              }
              //
              if (battleRoomCubit.getUsers().length == 1 &&
                  battleRoomCubit.getUsers().first!.uid ==
                      context.read<UserDetailsCubit>().userId()) {
                return;
              }

              //if user is playing game then show
              //exit game dialog

              isExitDialogOpen = true;
              showDialog<void>(
                context: context,
                builder: (_) => ExitGameDialog(
                  onTapYes: () {
                    if (battleRoomCubit.getUsers().length == 1) {
                      battleRoomCubit.deleteMultiUserBattleRoom();
                    } else {
                      //delete user from game room
                      battleRoomCubit.deleteUserFromRoom(
                        context.read<UserDetailsCubit>().userId(),
                      );
                    }
                    deleteMessages(battleRoomCubit);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ).then((value) => isExitDialogOpen = true);
            },
            actions: [Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMessageButton(),
            )],

          ),
      body: Container(
      width: AppSize.width,
      height: AppSize.height,
      decoration: const BoxDecoration(
      image:  DecorationImage(
      image: AssetImage(ImageAssets.background),
      fit: BoxFit.cover,
      )),
        child: MultiBlocListener(

          listeners: [
            //update ui and do other callback based on changes in MultiUserBattleRoomCubit
            BlocListener<MultiUserBattleRoomCubit, MultiUserBattleRoomState>(
              bloc: battleRoomCubit,

              listener: (context, state) {

                print("MultiUserBattleRoomCubit1");


                  battleRoomListener(context, state, battleRoomCubit);



              },
            ),
            BlocListener<MessageCubit, MessageState>(
              bloc: context.read<MessageCubit>(),
              listener: (context, state) {
                //this listener will be call everytime when new message will add
                messagesListener(state);
              },
            ),

          ],
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                  EdgeInsets.only(top: opponentUsers.length >= 2 ? 70 : 0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: showWaitForOthers
                        ? const WaitForOthersContainer(
                      key: Key('waitForOthers'),
                    )
                        : BlocBuilder<MultiUserBattleRoomCubit,
                        MultiUserBattleRoomState>(

                      bloc: battleRoomCubit,
                      builder: (context, state) {
                        print("MultiUserBattleRoomCubit22");
                        return QuestionsContainer(
                          topPadding: MediaQuery.of(context).size.height *
                              RectangleUserProfileContainer
                                  .userDetailsHeightPercentage *
                              3.5,
                          timerAnimationController:
                          timerAnimationController,

                          showAnswerCorrectness: context
                              .read<SystemConfigCubit>()
                              .showAnswerCorrectness,


                          key: const Key('questions'),

                          hasSubmittedAnswerForCurrentQuestion:
                          hasSubmittedAnswerForCurrentQuestion,
                          questions: battleRoomCubit.getQuestions(),
                          submitAnswer: submitAnswer,
                          questionContentAnimation:
                          questionContentAnimation,
                          questionScaleDownAnimation:
                          questionScaleDownAnimation,
                          questionScaleUpAnimation:
                          questionScaleUpAnimation,
                          questionSlideAnimation: questionSlideAnimation,
                          currentQuestionIndex: currentQuestionIndex,
                          questionAnimationController:
                          questionAnimationController,
                          questionContentAnimationController:
                          questionContentAnimationController, guessTheWordQuestionContainerKeys:const [],
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildMessageBoxContainer(),
              ...showUserLeftTheGame
                  ? []
                  : [
                _buildCurrentUserDetails(
                  battleRoomCubit.getUser(
                    context.read<UserDetailsCubit>().userId(),
                  )!,
                  battleRoomCubit.getQuestions().length.toString(),
                ),
                _buildCurrentUserMessageContainer(),

                //Optimize for more user code
                //use for loop not add manual user like this
                BlocBuilder<MultiUserBattleRoomCubit,
                    MultiUserBattleRoomState>(
                  bloc: battleRoomCubit,
                  builder: (context, state) {
                    if (state is MultiUserBattleRoomSuccess) {
                      final opponentUsers =
                      battleRoomCubit.getOpponentUsers(
                        context.read<UserDetailsCubit>().userId(),
                      );
                      return opponentUsers.isNotEmpty
                          ? _buildOpponentUserDetails(
                        questionsLength: state.questions!.length,
                        alignment: AlignmentDirectional.bottomEnd,
                        opponentUsers: opponentUsers,
                        opponentUserIndex: 0,
                      )
                          : const SizedBox();
                    }
                    return const SizedBox();
                  },
                ),
                _buildOpponentUserMessageContainer(0),
                BlocBuilder<MultiUserBattleRoomCubit,
                    MultiUserBattleRoomState>(
                  bloc: battleRoomCubit,
                  builder: (context, state) {
                    if (state is MultiUserBattleRoomSuccess) {
                      final opponentUsers =
                      battleRoomCubit.getOpponentUsers(
                        context.read<UserDetailsCubit>().userId(),
                      );
                      return opponentUsers.length >= 2
                          ? _buildOpponentUserDetails(
                        questionsLength: state.questions!.length,
                        alignment: AlignmentDirectional.topStart,
                        opponentUsers: opponentUsers,
                        opponentUserIndex: 1,
                      )
                          : const SizedBox();
                    }
                    return const SizedBox();
                  },
                ),
                BlocBuilder<MultiUserBattleRoomCubit,
                    MultiUserBattleRoomState>(
                  bloc: battleRoomCubit,
                  builder: (context, state) {
                    if (state is MultiUserBattleRoomSuccess) {
                      final opponentUsers =
                      battleRoomCubit.getOpponentUsers(
                        context.read<UserDetailsCubit>().userId(),
                      );
                      return opponentUsers.length >= 2
                          ? _buildOpponentUserMessageContainer(1)
                          : const SizedBox();
                    }
                    return const SizedBox();
                  },
                ),
                BlocBuilder<MultiUserBattleRoomCubit,
                    MultiUserBattleRoomState>(
                  bloc: battleRoomCubit,
                  builder: (context, state) {
                    if (state is MultiUserBattleRoomSuccess) {
                      final opponentUsers =
                      battleRoomCubit.getOpponentUsers(
                        context.read<UserDetailsCubit>().userId(),
                      );
                      return opponentUsers.length >= 3
                          ? _buildOpponentUserDetails(
                        questionsLength: state.questions!.length,
                        alignment: AlignmentDirectional.topEnd,
                        opponentUsers: opponentUsers,
                        opponentUserIndex: 2,
                      )
                          : const SizedBox();
                    }
                    return const SizedBox();
                  },
                ),
                BlocBuilder<MultiUserBattleRoomCubit,
                    MultiUserBattleRoomState>(
                  bloc: battleRoomCubit,
                  builder: (context, state) {
                    if (state is MultiUserBattleRoomSuccess) {
                      final opponentUsers =
                      battleRoomCubit.getOpponentUsers(
                        context.read<UserDetailsCubit>().userId(),
                      );
                      return opponentUsers.length >= 3
                          ? _buildOpponentUserMessageContainer(2)
                          : Container();
                    }
                    return Container();
                  },
                ),
              ],
              // _buildMessageButton(),
              _buildYouWonContainer(battleRoomCubit),
              _buildUserLeftTheGame(),
              // _buildTopMenu(),
            ],
          ),
        ),
      )
      ),
    );
  }
  Widget loadingWidget( ){
    return  Container(
      child: const CircularProgressIndicator(


      ),
      alignment: AlignmentDirectional.center,
    );
  }
  void showCategoryBottomSheet(String battleRoom,String user,int questionLength,List<CategoryDataModel> categories,BuildContext context,MultiUserBattleRoomCubit cubit)async{


    final String? result = await  showModalBottomSheet<String>(
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
      print("dismissed ---> CategoryId ${result} ");
      cubit.startGame(battleRoom,user, result,questionLength);



    }

  }
  Future<void> _showCustomDialog(String battleRoom,String user,int questionLength,List<CategoryDataModel> categories,BuildContext context,MultiUserBattleRoomCubit cubit) async {
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
    //   cubit.startGame(battleRoom,user, result,questionLength);
    //   print('Dialog result: $result');
    // }
  }



}


class ImageCircularProgressIndicator extends StatelessWidget {
  const ImageCircularProgressIndicator({
    required this.userBattleRoomDetails,
    required this.animationController,
    required this.totalQues,
    super.key,
  });

  final UserBattleRoomDetails userBattleRoomDetails;
  final AnimationController animationController;
  final String totalQues;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50,
              height: 55,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: QImage.circular(
                      imageUrl: userBattleRoomDetails.profileUrl,
                      height: 48,
                      width: 48,
                    ),
                  ),

                  /// Circle
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CustomPaint(
                        painter: _CircleCustomPainter(
                          color: Theme.of(context).colorScheme.background,
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                  ),

                  /// Arc
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (_, __) {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomPaint(
                            painter: _ArcCustomPainter(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 4,
                              sweepDegree: 360 * animationController.value,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  ///
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 15,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${userBattleRoomDetails.correctAnswers}/$totalQues',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 10,
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 8),
            Text(
              userBattleRoomDetails.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeights.bold,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleCustomPainter extends CustomPainter {
  const _CircleCustomPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, size.width * 0.5, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArcCustomPainter extends CustomPainter {
  const _ArcCustomPainter({
    required this.color,
    required this.strokeWidth,
    required this.sweepDegree,
  });

  final Color color;
  final double strokeWidth;
  final double sweepDegree;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final p = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    /// The PI constant.
    const pi = 3.1415926535897932;

    const startAngle = 3 * (pi / 2);
    final sweepAngle = (sweepDegree * pi) / 180.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.5),
      startAngle,
      sweepAngle,
      false,
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

