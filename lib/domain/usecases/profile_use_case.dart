import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class ProfileUseCase implements BaseUseCase<ProfileUseCaseInput,ProfileDataModel>{
  final Repository _repository;
  ProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileDataModel>> execute(ProfileUseCaseInput input) async{
    // TODO: implement execute
    return await _repository.profile(input.userId);
  }


}
class ProfileUseCaseInput {
  String userId;



  ProfileUseCaseInput(this.userId);
}