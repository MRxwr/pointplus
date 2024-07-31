import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/app/di.dart';
import 'package:point/presentation/main/game_bloc/result_view/bloc/sumbit_room_bloc.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/game_users_bloc.dart';

import '../../../../../domain/models/game_firebase_model.dart';
import '../../../../../views/custom_image.dart';
import '../../../../../views/fonts.dart';
import '../../../../resources/assets_manager.dart';
import '../../../../resources/assets_utils.dart';
import '../../../../resources/color_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../../../view_helper/loading_state.dart';
import '../../../main.dart';

class ResultView extends StatefulWidget {
  String gameCode;
  String title;
  String userId;
  int type;
  bool isPublicRoom;
  GameFireBaseModel gameFireBaseModel;

  ResultView(
      {super.key, required this.gameCode, required this.title, required this.userId, required this.type,
        required this.isPublicRoom, required this.gameFireBaseModel});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  List<UserModel> users = [];
  List<Result> totalResults = [];
  List<UserResult> usersResults = [];
  bool isCreator = false;
  SumbitRoomBloc sumbitRoomBloc = instance<SumbitRoomBloc>();
  GameUsersBloc gameUsersBloc = instance<GameUsersBloc>();

  @override
  void dispose() {
    sumbitRoomBloc.close();
    gameUsersBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = widget.gameFireBaseModel.users;
    for (int i = 0; i < widget.gameFireBaseModel.users.length; i++) {
      UserModel user = widget.gameFireBaseModel.users[i];
      if (user.userId == widget.userId) {
        isCreator = user.isCreator;
      }
    }
    for (int i = 0; i < widget.gameFireBaseModel.users.length; i++) {
      UserModel user = widget.gameFireBaseModel.users[i];
      List<Result> results = user.answers;
      for (int j = 0; j < results.length; j++) {
        totalResults.add(results[j]);
      }
    }
    Map<String, double> totalPoints = calculatePoints(totalResults);

    var sortedUsers = totalPoints.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Print the sorted list of users with their points
    // Convert sortedUsers to a list of maps
    List<Map<String, dynamic>> rankedUsers = sortedUsers.map((entry) {
      return {
        'userId': entry.key,
        'points': entry.value,
      };
    }).toList();

    // Print the sorted list of users with their points

    for (int i = 0; i < rankedUsers.length; i++) {
      String rankedUserId = rankedUsers[i]['userId'];
      for (int j = 0; j < users.length; j++) {
        String currentUserId = users[j].userId;
        if (rankedUserId == currentUserId) {
          UserResult userResult = UserResult(userId: currentUserId,
              userName: users[j].userName,
              userImage: users[j].userImage,
              points: '${rankedUsers[i]['points']}');
          usersResults.add(userResult);
        }
      }
    }
    gameUsersBloc!.add(FetchGameDetail(roomId: widget.gameCode));
  }

  Map<String, double> calculatePoints(List<Result> results) {
    // Create a map to store total points for each user
    Map<String, double> userPoints = {};

    // Group results by questionId to find the lowest timeTaken for each question
    Map<String, int> lowestTimePerQuestion = {};

    for (var result in results) {
      if (!lowestTimePerQuestion.containsKey(result.questionId) ||
          result.timeTaken < lowestTimePerQuestion[result.questionId]!) {
        lowestTimePerQuestion[result.questionId] = result.timeTaken;
      }
    }

    // Calculate points based on the provided conditions
    for (var result in results) {
      double points = double.parse(result.points);

      if (!result.isCorrect) {
        points = 0;
      } else {
        if (result.timeTaken > lowestTimePerQuestion[result.questionId]!) {
          points *= 0.8;
        }
      }

      if (result.userId == result.userSelectCategoryId) {
        points *= 2;
      }

      if (userPoints.containsKey(result.userId)) {
        userPoints[result.userId] = userPoints[result.userId]! + points;
      } else {
        userPoints[result.userId] = points;
      }
    }

    return userPoints;
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
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const MainView(
                  );
                }));
          },
          child: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,
            size: AppSize.s20,),
        ),


      ),
      body: SingleChildScrollView(
        child: BlocListener<GameUsersBloc, GameUsersState>(
          bloc: gameUsersBloc,
          listener: (context, state) {
            if(state is GameUsersStateSuccess){
              if(state.gameFireBaseModelList.isEmpty){
                Navigator.of(context) .push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const MainView(
                        );
                    }));

              }
            }
          },
          child: Container(
            margin: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    alignment: Alignment.center,
                    child: inviteRoomUserCard(
                        usersResults[0].userName, usersResults[0].userImage,
                        usersResults[0].points.toString())),
                Container(height: 20.w,),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(width: ScreenUtil().screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        height: 90.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            QImage.circular(
                              imageUrl:
                              usersResults[index].userImage,
                              width: 80.w,
                              height: 80.w,
                            ),
                            Text(
                              usersResults[index].userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeights.regular,
                                color: ColorManager.primary,
                              ),
                            ),
                            Text(
                              '${usersResults[index].points} Pts',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeights.regular,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            )

                          ],
                        ),);
                    },
                    separatorBuilder: (context, index) {
                      return Container(height: 10.w,);
                    },
                    itemCount: usersResults.length),
                Container(height: 20.w,),
                Container(child: isCreator ?
                BlocListener<SumbitRoomBloc, SumbitRoomState>(
                  bloc: sumbitRoomBloc,
                  listener: (context, state) {
                    if (state is SumbitRoomStateLoading) {
                      showLoadingDialog(context);
                    } else if (state is SumbitRoomStateFailure) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is SumbitRoomStateSuccess) {
                      Navigator.pop(context);
                      gameUsersBloc.add(DeleteRoom(roomId: widget.gameCode));
                    }
                    // TODO: implement listener
                  },
                  child: previewButton("home".tr(), context),
                ) : Container())


              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton previewButton(String category, BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(

      minimumSize: Size(50.w, 35.h),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0.w)),
      ),
      backgroundColor: ColorManager.secondary,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        String winner = usersResults[0].userId;
        String point = usersResults[0].points;
        sumbitRoomBloc.add(FetchSumbitRoom(roomId: widget.gameFireBaseModel.id,winner: winner,points: point));


      },
      child: Text(category, style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.w500
      ),),
    );
  }

  Widget inviteRoomUserCard(String userName,
      String img, String points) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return Container(
      width: 200.w,
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


          Text(
            '${points} Pts',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeights.regular,
              color: Colors.black.withOpacity(0.8),
            ),
          )

        ],
      ),
    );
  }
}
