import 'package:dartz/dartz.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/usecases/base_usecase.dart';

import '../../data/network/failure.dart';
import '../models/models.dart';
import '../repository/repository.dart';

class QuestionUseCase implements BaseUseCase<QuestionCaseInput,List<QuestionResponseModel>>{
  final Repository _repository;
  QuestionUseCase(this._repository);

  @override
  Future<Either<Failure, List<QuestionResponseModel>>> call(List<QuestionRequest> inputs) async{
    // TODO: implement execute
    return await _repository.fetchQuestions(inputs);
  }

  @override
  Future<Either<Failure, List<QuestionResponseModel>>> execute(QuestionCaseInput input) {
    // TODO: implement execute
    throw UnimplementedError();
  }


}
class QuestionCaseInput {
  String userId;
  String quizCategory;
  String noOfQuestions;


  QuestionCaseInput(this.userId,this.quizCategory,this.noOfQuestions);
}