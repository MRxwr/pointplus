import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class UpdateAnswersUseCase implements BaseUseCase<UpdateAnswersUseCaseInput,void>{
  final Repository _repository;
  UpdateAnswersUseCase(this._repository);
  @override
  Future<Either<Failure, void>> execute(UpdateAnswersUseCaseInput input) async{

    return  _repository.updateAnswers(input.roomId,input.users);

    // TODO: implement execute

  }






}
class UpdateAnswersUseCaseInput {
  String roomId;List<UserModel>users;



  UpdateAnswersUseCaseInput(this.roomId,this.users);
}