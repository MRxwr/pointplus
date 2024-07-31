import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:point/presentation/game_categories/models/questionCategory.dart';

import 'package:point/presentation/game_categories/models/userBattleRoomDetails.dart';

class BattleRoom {
  BattleRoom({
    this.roomId,
    this.currentCategoryId,
    this.currentUser,
    this.questions,


    this.user1,
    this.user2,
    this.createdBy,
    this.readyToPlay,
    this.roomCode,
    this.user3,
    this.user4,
    this.user5,
    this.user6,
    this.totalQuestions,
    this.isLoadedScreen,
    this.isSelectNewCategory

  });

  final String? roomId;
  final bool? isSelectNewCategory;
  final String? currentCategoryId;
  final int? totalQuestions;

  final String? createdBy;
  final bool? isLoadedScreen;
  final String? currentUser;


  //it will be in use for multiUserBattleRoom
  //user1 will be the creator of this room
  final UserBattleRoomDetails? user1;
  final UserBattleRoomDetails? user2;
  final UserBattleRoomDetails? user3;
  final UserBattleRoomDetails? user4;
  final UserBattleRoomDetails? user5;
  final UserBattleRoomDetails? user6;
  final List<Questions>? questions;

  final String? roomCode;
  final bool? readyToPlay;

  // TODO(J): issue with making it constructor.
  static BattleRoom fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data()! as Map<String, dynamic>;
    List<Questions> questions =[];
    if (data['questions'] != null) {
      questions = <Questions>[];
      data['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    return BattleRoom(
      questions:questions,

      isSelectNewCategory: data['isSelectNewCategory'] as bool? ?? false,
      createdBy: data['createdBy'] as String? ?? '',
      currentUser: data['currentUser']as String? ??'',
      roomId: documentSnapshot.id,
      currentCategoryId:  data['currentCategoryId'] as String? ?? '',
      readyToPlay: data['readyToPlay'] as bool? ?? false,
      isLoadedScreen: data['questionLoaded'] as bool? ?? false,
      roomCode: data['roomCode'] as String? ?? '',
      totalQuestions: data['totalQuestion'] as int? ?? 0,
      user3: UserBattleRoomDetails.fromJson(
        Map.from(data['user3'] as Map<String, dynamic>? ?? {}),
      ),

      user4: UserBattleRoomDetails.fromJson(
        Map.from(data['user4'] as Map<String, dynamic>? ?? {}),
      ),
      user1: UserBattleRoomDetails.fromJson(
        Map.from(data['user1'] as Map<String, dynamic>),
      ),
      user2: UserBattleRoomDetails.fromJson(
        Map.from(data['user2'] as Map<String, dynamic>),
      ),
      user5: UserBattleRoomDetails.fromJson(
        Map.from(data['user5'] as Map<String, dynamic>? ?? {}),
      ),
      user6: UserBattleRoomDetails.fromJson(
        Map.from(data['user6'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }
}
