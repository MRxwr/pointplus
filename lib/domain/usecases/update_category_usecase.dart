import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class UpdateCategoryUsecase implements BaseUseCase<UpdateCategoryUsecaseInput,void>{
  final Repository _repository;
  UpdateCategoryUsecase(this._repository);
  Future<Either<Failure, void>> execute(UpdateCategoryUsecaseInput input) async{

    return  _repository.updateCategoryAndUsers(input.roomId,input.currentCategoryId,input.users);

    // TODO: implement execute

  }






}
class UpdateCategoryUsecaseInput {
  String roomId;String currentCategoryId;List<UserModel> users;



  UpdateCategoryUsecaseInput(this.roomId,this.currentCategoryId,this.users);
}