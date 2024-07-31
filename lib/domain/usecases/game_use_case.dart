import 'package:dartz/dartz.dart';


import '../../data/network/failure.dart';

import '../models/game_firebase_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class GameUseCase implements BaseUseCase<GameUseCaseInput,List<GameFireBaseModel>>{
  final Repository _repository;
  GameUseCase(this._repository);

  Stream<Either<Failure, List<GameFireBaseModel>>> call(GameUseCaseInput input) {

      return  _repository.game(input.roomId,input.createdBy,input.currentCategoryId,input.readyToPlay,
          input.totalQuestions,input.userModel,input.currentUserId,input.room);

    // TODO: implement execute

  }

  @override
  Future<Either<Failure, List<GameFireBaseModel>>> execute(GameUseCaseInput input) {
    // TODO: implement execute
    throw UnimplementedError();
  }



}
class GameUseCaseInput {
   String roomId;
   String createdBy;
   String currentCategoryId;
   bool readyToPlay;
   int totalQuestions;
   UserModel userModel;
   String currentUserId;
   String room;



   GameUseCaseInput(
      this.roomId, this.createdBy, this.currentCategoryId,
      this.readyToPlay, this.totalQuestions, this.userModel,this.currentUserId,this.room);
}