import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class UpdateUsersUseCase implements BaseUseCase<UpdateUsersUseCaseInput,void>{
  final Repository _repository;
  UpdateUsersUseCase(this._repository);
  @override
  Future<Either<Failure, void>> execute(UpdateUsersUseCaseInput input) async{

    return  _repository.updateUsers(input.roomId,input.users);

    // TODO: implement execute

  }






}
class UpdateUsersUseCaseInput {
  String roomId;List<UserModel>users;



  UpdateUsersUseCaseInput(this.roomId,this.users);
}