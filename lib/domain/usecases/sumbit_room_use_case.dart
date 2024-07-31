import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/models/sumbit_room_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class SumbitRoomUseCase implements BaseUseCase<SumbitRoomUseCaseInput,SumbitRoomModel>{
  final Repository _repository;
  SumbitRoomUseCase(this._repository);

  @override
  Future<Either<Failure, SumbitRoomModel>> execute(SumbitRoomUseCaseInput input) async{
    // TODO: implement execute
    return await _repository.sumbitRoom(input.roomId,input.winner,input.points);
  }


}
class SumbitRoomUseCaseInput {
  String roomId;
  String winner;
  String  points;



  SumbitRoomUseCaseInput(this.roomId,this.winner,this.points);
}