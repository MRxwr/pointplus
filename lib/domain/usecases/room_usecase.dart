import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/models.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RoomUseCase implements BaseUseCase<RoomCaseInput,RoomModel>{
  final Repository _repository;
  RoomUseCase(this._repository);

  @override
  Future<Either<Failure, RoomModel>> execute(RoomCaseInput input) async{
    // TODO: implement execute
    return await _repository.room(RoomRequest(input.create,input.join,input.userId,input.roomId,input.roomCode,
    input.exit));
  }


}
class RoomCaseInput {
  String create;
  String join;
  String userId;
  String roomId;
  String roomCode;
  String exit;

  RoomCaseInput(this.create,this.join,this.userId,this.roomId,this.roomCode,this.exit);
}