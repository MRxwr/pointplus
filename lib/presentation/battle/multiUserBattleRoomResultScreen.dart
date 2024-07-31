import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/api/point_services.dart';
import 'package:point/domain/SumbitRoomModel.dart';
import 'package:point/presentation/game_categories/bloc/multiUserBattleRoomCubit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../app/constant.dart';
import '../../providers/model_hud.dart';
import '../../views/customAppbar.dart';
import '../../views/custom_image.dart';
import '../../views/fonts.dart';
import '../../views/ui_utils.dart';
import '../game_categories/models/userBattleRoomDetails.dart';
import '../game_categories/widgets/customRoundedButton.dart';
import '../main/UserDetailsCubit.dart';
import '../main/main.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import 'models/resultModel.dart';

class MultiUserBattleRoomResultScreen extends StatefulWidget {
  const MultiUserBattleRoomResultScreen({
    required this.users,

    required this.totalQuestions,
    required this.creatorId,
    super.key,
  });

  final List<UserBattleRoomDetails?> users;

  final int totalQuestions;
  final String creatorId ;

  @override
  State<MultiUserBattleRoomResultScreen> createState() =>
      _MultiUserBattleRoomResultScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;
    return CupertinoPageRoute(
      builder: (_) =>
          MultiUserBattleRoomResultScreen(
            users: args!['user'] as List<UserBattleRoomDetails?>,

            totalQuestions: args['totalQuestions'] as int,
            creatorId: args['creatorId'] as String,
          ),
    );
  }
}

class _MultiUserBattleRoomResultScreenState
    extends State<MultiUserBattleRoomResultScreen> {
  List<Map<String, dynamic>> usersWithRank = [];

  @override
  void initState() {

    getResultAndUpdateCoins();
    super.initState();
  }
  List<Map<String,dynamic>> finalResult = [];
List<ResultModel> resultListModel = [];
  void getResultAndUpdateCoins() {
    //create new array of map that creates user and rank
    for (final element in widget.users) {
      usersWithRank.add({'user': element});
    }
    final points = usersWithRank
        .map((d) => (d['user'] as UserBattleRoomDetails).correctAnswers)
        .toSet()
        .toList()
      ..sort((first, second) => second.compareTo(first));

    for (final userDetails in usersWithRank) {
      final rank = points.indexOf(
            (userDetails['user'] as UserBattleRoomDetails).correctAnswers,
          ) +
          1;
      userDetails.addAll({'rank': rank});
    }
    usersWithRank.sort(
      (first, second) => int.parse(first['rank'].toString())
          .compareTo(int.parse(second['rank'].toString())),
    );
    //
    Future.delayed(Duration.zero, () {
      final currentUser = usersWithRank
          .where(
            (element) =>
                (element['user'] as UserBattleRoomDetails).uid ==
                context.read<UserDetailsCubit>().userId(),
          )
          .toList()
          .first;
      final totalWinner = usersWithRank
          .where((element) => element['rank'] == 1)
          .toList()
          .length;

    });
    //check which list is bigger
    List<List<bool>> answersList = [];
    List<List<int>> timesList = [];
    List<List<String>> pointsList = [];
    List<String> users =[];



    for(int i =0;i<widget.users.length;i++){
      answersList.add(widget.users[i]!.answersResult);
      timesList.add(widget.users[i]!.times);
      pointsList.add(widget.users[i]!.points);
      users.add(widget.users[i]!.uid);


    }
//time
    int maxLength = timesList.fold(0, (int max, list) => max > list.length ? max : list.length);

    // Step 2: Extend smaller lists
    timesList = timesList.map((list) {
      return list..addAll(List.filled(maxLength - list.length, 0)); // Using 0 as the initial value to fill
    }).toList();
    // answers

    int maxLengthAnswers = answersList.fold(0, (int max, list) => max > list.length ? max : list.length);

    // Step 2: Extend smaller lists
    answersList = answersList.map((list) {
      return list..addAll(List.filled(maxLengthAnswers - list.length, false)); // Using 0 as the initial value to fill
    }).toList();
    // points

    int maxLengthPoints = pointsList.fold(0, (int max, list) => max > list.length ? max : list.length);

    // Step 2: Extend smaller lists
    pointsList = pointsList.map((list) {
      return list..addAll(List.filled(maxLengthPoints - list.length, "0")); // Using 0 as the initial value to fill
    }).toList();
    print("timesList ---> $timesList");
    print("answersList ---> $answersList");
    print("pointsList ---> $pointsList");
   List<Map<String,dynamic>> resultUsers = [];
    for(int i =0;i<widget.users.length;i++){
      Map<String,dynamic> resultMap = {};
      resultMap['userId']= widget.users[i]!.uid;
      resultMap['points']= pointsList[i];
      resultMap['times'] = timesList[i];
      resultMap['answers']= answersList[i];
      resultUsers.add(resultMap);

    }
    print("resultUsers ---> $resultUsers");
    List<List<Map<String,dynamic>>>  timesUsers = [];
    for(int j=0;j<timesList[0].length;j++) {
      List<Map<String,dynamic>> timesUsersSingleAnswer = [];
      for (int i = 0; i < widget.users.length; i++) {
        Map<String, dynamic> timesMap = {};
        timesMap["userId"] = widget.users[i]!.uid;
        timesMap["time"] = timesList[i][j];
        timesMap["answer"] = answersList[i][j];
        timesMap["point"] = pointsList[i][j];
        timesUsersSingleAnswer.add(timesMap);

      }
      timesUsers.add(timesUsersSingleAnswer);


    }
    print("timesUsers ---> $timesUsers");
    List<List<Map<String,dynamic>>> timesUsersAfterArrange = [];
    for(int i =0;i<timesUsers.length;i++){
      List<Map<String,dynamic>> list = timesUsers[i];
      bool categoryToPrioritize = false;
      list.sort((a, b) {
        // Check if either item belongs to the category to prioritize
        bool isFirstInCategory = a['answer'] == categoryToPrioritize;
        bool isSecondInCategory = b['answer'] == categoryToPrioritize;

        if (isFirstInCategory && !isSecondInCategory) return -1; // a comes first
        if (!isFirstInCategory && isSecondInCategory) return 1;  // b comes first

        if (isFirstInCategory && isSecondInCategory) {
          // If both items are in the category, sort by value
          return a['time'].compareTo(b['time']);
        }

        // If neither item is in the category, their order doesn't change
        return 0;
      });

      timesUsersAfterArrange.add(list);

    }
    print("timesUsersAfterArrange ---> $timesUsersAfterArrange");
    List<List<Map<String,dynamic>>> result = [];

    for(int i=0;i<timesUsersAfterArrange.length;i++){
      List<Map<String,dynamic>> resultQuestion =[];

      for(int j=0;j<timesUsersAfterArrange[i].length;j++) {
        Map<String, dynamic> resultQuestionPerUser = {};
        Map<String, dynamic> userMap = timesUsersAfterArrange[i][j];
        if (userMap['answer'] != false) {
          if (j == 0) {
            resultQuestionPerUser["userId"] = userMap['userId'];
            resultQuestionPerUser['result'] = userMap['point'];
          }else{
            double point = 0.8* double.parse(userMap['point']);
            resultQuestionPerUser["userId"] = userMap['userId'];
            resultQuestionPerUser['result'] = point;

          }
        }else{
          resultQuestionPerUser["userId"] = userMap['userId'];
          resultQuestionPerUser['result'] = 0.0;
        }
        resultQuestion.add(resultQuestionPerUser);
      }
      result.add(resultQuestion);


    }
    print(result);
    List<Map<String,dynamic>> listResult = [];

    for(int  i =0;i<result.length;i++){
      for(int j =0;j<result[i].length;j++){
        Map<String,dynamic> map ={};
        print("result[i][j]['userid'] --> ${result[i][j]['userId']}");
        print("users[j] --> ${users[j]}");

          map['userId']= result[i][j]['userId'];
          map['degrees'] = result[i][j]['result'];
          listResult.add(map);



      }
    }
    print("listResult ---> $listResult");

    Map<String, List<Map<String, dynamic>>> groupedUsers = {};

    for (var user in listResult) {
      String userId = user['userId'] as String; // Cast to ensure type safety
      groupedUsers.putIfAbsent(userId, () => []);
      groupedUsers[userId]!.add(user);
    }


    groupedUsers.forEach((userId, userList) {
      Map<String,dynamic> map = {};
      map['userId'] = userId;
      double resultDouble = 0.0;
      for(int i =0;i<userList.length;i++){
        Map<String,dynamic> hashMap  = userList[i];
        dynamic degreeString = hashMap['degrees'];
        double degree =double.parse(degreeString.toString()) ;


        resultDouble += degree.toDouble();
      }
      map['totalDegree'] = resultDouble;
      UserBattleRoomDetails? user;
      try {
         user = widget.users.firstWhere(
              (user) => user!.uid == userId,
          orElse: () => throw Exception('User not found with userId $userId'),
        );
        print('User found: ${user}');
      } catch (e) {
        print(e); // Handle the case where the user is not found
      }
      map['user']= user;
      finalResult.add(map);

    });
    finalResult.sort((a, b) => b['totalDegree'].compareTo(a['totalDegree']));

setState(() {

});

    print(finalResult);

  }

  // Step 1: Find the length of the largest list

  Widget _buildUserDetailsContainer(
      Map<String,dynamic> userBattleRoomDetails,
    int rank,
    Size size,
    bool showStars,
    AlignmentGeometry alignment,
    EdgeInsetsGeometry edgeInsetsGeometry,
    Color color,
  ) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                QImage.circular(
                  width: 52,
                  height: 52,
                  imageUrl: userBattleRoomDetails['user'].profileUrl,
                ),
                // Center(
                //   child: SvgPicture.asset(
                //     UiUtils.getImagePath('hexagon_frame.svg'),
                //     width: 60,
                //     height: 60,
                //   ),
                // ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                userBattleRoomDetails['user'].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeights.bold,
                  color: ColorManager.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${userBattleRoomDetails['totalDegree']}',
                style: TextStyle(
                  fontWeight: FontWeights.bold,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTopDetailsContainer(
      Map<String,dynamic> userBattleRoomDetails,
    int rank,
    Size size,
    bool showStars,
    AlignmentGeometry alignment,
    EdgeInsetsGeometry edgeInsetsGeometry,
    Color color,
  ) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: edgeInsetsGeometry,
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                QImage.circular(
                  width: 100,
                  height: 100,
                  imageUrl: userBattleRoomDetails['user'].profileUrl,

                ),
                // Center(
                //   child: SvgPicture.asset(
                //     UiUtils.getImagePath('hexagon_frame.svg'),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              userBattleRoomDetails['user'].name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeights.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${userBattleRoomDetails['totalDegree']}',
                style: TextStyle(
                  fontWeight: FontWeights.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ModelHud>(context).isLoading,
      child: Container(
        child: finalResult.isEmpty?
        Container(
          color: Colors.white,

        ):Scaffold(
          appBar: AppBar(
            elevation: 0,

            backgroundColor: ColorManager.primary,
            title: Center(
              child: Center(
                child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
              ),
            ),
            actions: [
              SizedBox(width: AppSize.s30,)
            ],
            leading:
            GestureDetector(
              onTap: ()async {
                String userId = context.read<UserDetailsCubit>().userId();
                if(userId == widget.creatorId){
                  PointServices pointServices = PointServices();
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  String roomId = sharedPreferences.getString("roomId")??"";
                  Map<String,dynamic> userBattleRoomDetails =      finalResult[0] ;
                  String winnerId = userBattleRoomDetails['user'].uid;
                  final modelHud = Provider.of<ModelHud>(context,listen: false);
                  modelHud.changeIsLoading(true);
                  Map<String ,dynamic> map = {};
                  map['roomId'] = roomId;
                  map['winner'] = winnerId;
                  map['points'] = userBattleRoomDetails['totalDegree'];
                  SumbitRoomModel? sumbitRoomModel = await pointServices.sumbitRoom(map);
                  modelHud.changeIsLoading(false);
                  bool isOk = sumbitRoomModel!.ok!;
                  if(isOk){
                    context.read<MultiUserBattleRoomCubit>().clearData();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainView()),
                    );
                  }







                }else{
                  context.read<MultiUserBattleRoomCubit>().clearData();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainView()),
                  );
                }




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
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.height * UiUtils.hzMarginPct,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rank 1
                        _buildUserTopDetailsContainer(
                          finalResult[0],
                          usersWithRank.first['rank'] as int,
                          Size(
                            MediaQuery.of(context).size.width * (0.475),
                            MediaQuery.of(context).size.height * (0.35),
                          ),
                          true,
                          AlignmentDirectional.centerStart,
                          EdgeInsetsDirectional.only(
                            start: 10,
                            top: MediaQuery.of(context).size.height * (0.025),
                          ),
                          Colors.green,
                        ),

                 Expanded(
                   child: Container(
                     color: Colors.white,
                    
                     child: Container(
                       margin: EdgeInsets.all(10.w),
                       child: ListView.separated(itemBuilder: (context,index){
                       
                         return _buildUserDetailsContainer(finalResult[index+1],
                           usersWithRank[index+1]['rank'] as int,
                           Size(
                             MediaQuery.of(context).size.width * (0.38),
                             MediaQuery.of(context).size.height * (0.28),
                           ),
                           false,
                           AlignmentDirectional.center,
                           EdgeInsetsDirectional.only(
                             start: MediaQuery.of(context).size.width * (0.3),
                             bottom: MediaQuery.of(context).size.height * (0.42),
                           ),
                           Colors.redAccent);
                       }, separatorBuilder: (context,index){
                         return Container(height: 1.h,
                         width: AppSize.width,);
                       
                       }, itemCount: finalResult.length-1),
                     ),
                   ),
                 )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: usersWithRank.length == 6 ? 20 : 50.0,
                    ),
                    //if total 4 user than padding will be 20 else 50
                    child: CustomRoundedButton(
                      widthPercentage: 0.85,
                      backgroundColor:ColorManager.secondary,
                      buttonTitle: context.tr('homeBtn'),
                      radius: 5,
                      showBorder: false,
                      fontWeight: FontWeight.bold,
                      height: 40,
                      elevation: 5,
                      titleColor: ColorManager.primary,
                      onTap: () async{
                        String userId = context.read<UserDetailsCubit>().userId();
                        if(userId == widget.creatorId){
                          PointServices pointServices = PointServices();
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          String roomId = sharedPreferences.getString("roomId")??"";
                          Map<String,dynamic> userBattleRoomDetails =      finalResult[0] ;
                          String winnerId = userBattleRoomDetails['user'].uid;
                          final modelHud = Provider.of<ModelHud>(context,listen: false);
                          modelHud.changeIsLoading(true);
                          Map<String ,dynamic> map = {};
                          map['roomId'] = roomId;
                          map['winner'] = winnerId;
                          map['points'] = userBattleRoomDetails['totalDegree'];
                          SumbitRoomModel? sumbitRoomModel = await pointServices.sumbitRoom(map);
                          modelHud.changeIsLoading(false);
                          bool isOk = sumbitRoomModel!.ok!;
                          if(isOk){
                            context.read<MultiUserBattleRoomCubit>().clearData();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainView()),
                            );
                          }







                        }else{
                          context.read<MultiUserBattleRoomCubit>().clearData();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainView()),
                          );
                        }
                      },
                      textSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
