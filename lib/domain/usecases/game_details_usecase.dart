import 'package:dartz/dartz.dart';


import '../../data/network/failure.dart';

import '../models/game_firebase_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class GameDetailsUsecase implements BaseUseCase<GameDetailsUsecaseInput,List<GameFireBaseModel>>{
  final Repository _repository;
  GameDetailsUsecase(this._repository);

  Stream<Either<Failure, List<GameFireBaseModel>>> call(GameDetailsUsecaseInput input) {

    return  _repository.gameDetails(input.roomId);

    // TODO: implement execute

  }

  @override
  Future<Either<Failure, List<GameFireBaseModel>>> execute(GameDetailsUsecaseInput input) {
    // TODO: implement execute
    throw UnimplementedError();
  }



}
class GameDetailsUsecaseInput {
  String roomId;




  GameDetailsUsecaseInput(
      this.roomId);
}