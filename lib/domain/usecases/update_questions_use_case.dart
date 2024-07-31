import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class UpdateQuestionsUseCase implements BaseUseCase<UpdateQuestionsUseCaseInput,void>{
  final Repository _repository;
  UpdateQuestionsUseCase(this._repository);
  Future<Either<Failure, void>> execute(UpdateQuestionsUseCaseInput input) async{

    return  _repository.updateQuestion(input.roomId,input.users);

    // TODO: implement execute

  }






}
class UpdateQuestionsUseCaseInput {
  String roomId;List<UserModel>users;



  UpdateQuestionsUseCaseInput(this.roomId,this.users);
}