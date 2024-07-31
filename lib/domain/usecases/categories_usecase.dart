import 'package:dartz/dartz.dart';
import 'package:point/domain/models/models.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class CategoriesUseCase implements BaseUseCase<CategoriesCaseInput,CategoryResponseModel>{
  final Repository _repository;
  CategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryResponseModel>> execute(CategoriesCaseInput input) async{
    // TODO: implement execute
    return await _repository.categories();
  }


}

class CategoriesCaseInput {


  CategoriesCaseInput();
}