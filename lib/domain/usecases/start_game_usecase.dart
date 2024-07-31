import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class StartGameUsecase implements BaseUseCase<StartGameUseCaseInput,void>{
  final Repository _repository;
  StartGameUsecase(this._repository);
  Future<Either<Failure, void>> execute(StartGameUseCaseInput input) async{

    return  _repository.startPlay(input.roomId);

    // TODO: implement execute

  }






}
class StartGameUseCaseInput {
  String roomId;



  StartGameUseCaseInput(this.roomId);
}