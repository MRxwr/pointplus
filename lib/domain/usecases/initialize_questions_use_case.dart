import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class InitializeQuestionsUseCase implements BaseUseCase<InitializeQuestionsUseCaseInput,void>{
  final Repository _repository;
  InitializeQuestionsUseCase(this._repository);
  Future<Either<Failure, void>> execute(InitializeQuestionsUseCaseInput input) async{

    return  _repository.initializeQuestions(input.roomId,input.currentUserId,input.users);

    // TODO: implement execute

  }






}
class InitializeQuestionsUseCaseInput {
  String roomId;String currentUserId;List<UserModel> users;



  InitializeQuestionsUseCaseInput(this.roomId,this.currentUserId,this.users);
}