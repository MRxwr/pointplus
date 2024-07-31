import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/models.dart';
import 'package:point/domain/models/sumbit_room_model.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/profile_data_model.dart';

abstract class Repository {

  Future<Either<Failure, RoomModel>> room(RoomRequest roomRequest);
  Future<Either<Failure, CategoryResponseModel>> categories();
  Future<Either<Failure, QuestionResponseModel>> questions(QuestionRequest questionRequest);
  Future<Either<Failure, List<QuestionResponseModel>>> fetchQuestions(List<QuestionRequest> requests);
  Stream<Either<Failure, List<GameFireBaseModel>>> game(  String roomId,
       String createdBy,
       String currentCategoryId,
       bool readyToPlay,
       int totalQuestions,
       UserModel userModel,
      String currentUserId,
      String room);
  Future<Either<Failure, ProfileDataModel>> profile(String userId);
  Stream<Either<Failure, List<GameFireBaseModel>>> joinGame(String roomId,
      UserModel userModel);
  Future<Either<Failure, bool>> clearGame(String roomId);
  Future<Either<Failure, void>> startPlay
      (String roomId);
  Future<Either<Failure, void>> deleteRoom
      (String roomId);
  Future<Either<Failure, void>> initializeQuestions
      (String roomId,String currentUserId,List<UserModel> users);
  Future<Either<Failure, void>> updateCategoryAndUsers
      (String roomId,String currentCategoryId,List<UserModel> users);
   Future<Either<Failure, void>> updateQuestion
      (String roomId,List<UserModel> users);
  Future<Either<Failure, void>> updateAnswers
      (String roomId,List<UserModel> users);
  Stream<Either<Failure, List<GameFireBaseModel>>> gameDetails(  String roomId,
     );
  Future<Either<Failure, SumbitRoomModel>> sumbitRoom(String roomId,String winner,String points);
  Future<Either<Failure, void>> updateUsers
      (String roomId,List<UserModel> users);
}