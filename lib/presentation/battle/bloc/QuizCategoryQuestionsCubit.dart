import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/data/network/failure.dart';
import 'package:point/domain/models/models.dart';
import 'package:point/domain/usecases/categories_usecase.dart';

import '../../../app/battleRoomRepository.dart';
import '../../../domain/usecases/questions_usecase.dart';

@immutable
abstract class QuizCategoryQuestionState {}

class QuizCategoryQuestionInitial extends QuizCategoryQuestionState {}

class QuizCategoryQuestionProgress extends QuizCategoryQuestionState {}

class QuizCategoryQuestionSuccess extends QuizCategoryQuestionState {
  QuizCategoryQuestionSuccess(this.questions);

  final QuestionResponseModel questions;
}
class QuizCategoryQuestionFailure extends QuizCategoryQuestionState {
  QuizCategoryQuestionFailure(this.failure);

  final Failure failure;
}

class QuizCategoryQuestionCubit extends Cubit<QuizCategoryQuestionState> {

  QuizCategoryQuestionCubit(this._questionUseCase) : super(QuizCategoryQuestionInitial());
  final QuestionUseCase _questionUseCase;


  Future<void> getQuizCategoryQuestionWithUserIdAndCategoyrId(String userId,String categoryId,String noOfQuestion) async {
    emit(QuizCategoryQuestionProgress());
    (await _questionUseCase.execute(QuestionCaseInput(userId,categoryId,noOfQuestion))).
    fold((failure)  {



      emit(QuizCategoryQuestionFailure(failure));


    }, (data)  {
      // send questions data to firebase






      // emit(QuizCategoryQuestionSuccess(data));



      //right --> success
      // inputState.add(ContentState());

      //navigate to main Screen

    });

  }



  void updateState(QuizCategoryQuestionState updatedState) {
    emit(updatedState);
  }

  // void unlockPremiumCategory({required String id}) {
  //   if (state is QuizCategorySuccess) {
  //     final categories = (state as QuizCategorySuccess).categories;
  //
  //     final idx = categories.indexWhere((c) => c.id == id);
  //
  //     if (idx != -1) {
  //       emit(QuizCategoryProgress());
  //
  //       categories[idx] = categories[idx].copyWith(hasUnlocked: true);
  //
  //       emit(QuizCategorySuccess(categories));
  //     }
  //   }
  // }

  // bool isPremiumCategoryUnlocked(String categoryId) {
  //   if (state is QuizCategorySuccess) {
  //     final categories = (state as QuizCategorySuccess).categories;
  //
  //     final idx = categories.indexWhere((c) => c.id == categoryId);
  //
  //     if (idx != -1) {
  //       final cate = categories[idx];
  //       return !cate.isPremium || (cate.isPremium && cate.hasUnlocked);
  //     }
  //   }
  //   return false;
  // }

  Object getCat() {
    if (state is QuizCategoryQuestionSuccess) {
      return (state as QuizCategoryQuestionSuccess).questions;
    }
    return '';
  }
}
