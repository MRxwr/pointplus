import 'package:dartz/dartz.dart';


import '../../data/network/failure.dart';

import '../models/game_firebase_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class JoinGameUseCase implements BaseUseCase<JoinGameUseCaseInput,List<GameFireBaseModel>>{
  final Repository _repository;
  JoinGameUseCase(this._repository);

  Stream<Either<Failure, List<GameFireBaseModel>>> call(JoinGameUseCaseInput input) {

    return  _repository.joinGame(input.roomId,input.userModel);

    // TODO: implement execute

  }

  @override
  Future<Either<Failure, List<GameFireBaseModel>>> execute(JoinGameUseCaseInput input) {
    // TODO: implement execute
    throw UnimplementedError();
  }



}
class JoinGameUseCaseInput {
  String roomId;

  UserModel userModel;



  JoinGameUseCaseInput(
      this.roomId, this.userModel);
}