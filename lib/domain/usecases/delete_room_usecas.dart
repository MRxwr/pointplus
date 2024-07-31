import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/game_firebase_model.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class DeleteRoomUsecase implements BaseUseCase<DeleteRoomUsecaseInput,void>{
  final Repository _repository;
  DeleteRoomUsecase(this._repository);
  Future<Either<Failure, void>> execute(DeleteRoomUsecaseInput input) async{

    return  _repository.deleteRoom(input.roomId);

    // TODO: implement execute

  }






}
class DeleteRoomUsecaseInput {
  String roomId;



  DeleteRoomUsecaseInput(this.roomId);
}