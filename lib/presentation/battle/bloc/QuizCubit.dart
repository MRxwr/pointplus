import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:point/presentation/game_categories/models/battleRoom.dart';
import 'package:point/presentation/game_categories/models/questionCategory.dart';

import '../../../app/battleRoomRepository.dart';
import '../../../data/network/failure.dart';
import '../../game_categories/bloc/multiUserBattleRoomCubit.dart';

@immutable
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizProgress extends QuizState {}

class QuizSuccess extends QuizState {
  QuizSuccess(this.questions);

  final List<Questions> questions;
}
class QuizFailure extends QuizState {
  QuizFailure(this.failure);

  final Failure failure;
}

class QuizCubit extends Cubit<QuizState> {
  final MultiUserBattleRoomCubit multiUserBattleRoomCubit;

  QuizCubit(this._battleRoomRepository,this.multiUserBattleRoomCubit) : super(QuizInitial());
  final BattleRoomRepository _battleRoomRepository;


  Future<void> getQuestions(String battleRoomDocumentId) async {
    emit(QuizProgress());
    try{
      print("battleRoomDocumentId ---> $battleRoomDocumentId");
 List<Questions> questions =await     _battleRoomRepository.getQuestionForCurrentUser(battleRoomDocumentId);
 print("question ---> ${questions[0].question}");
 emit(QuizSuccess(questions));
    }catch(e){
      Failure failure = Failure(204, e.toString());
      emit(QuizFailure(failure));
    }



  }



  void updateState(QuizState updatedState) {
    emit(updatedState);
  }

  void updateQuestionAnswer(String questionId, String submittedAnswerId) {
    if (state is QuizSuccess) {
      final updatedQuestions = (state as QuizSuccess).questions;
      //fetching index of question that need to update with submittedAnswer
      final questionIndex =
      updatedQuestions.indexWhere((element) => element.id == questionId);
      //update question at given questionIndex with submittedAnswerId
      updatedQuestions[questionIndex] = updatedQuestions[questionIndex]
          .updateQuestionWithAnswer(submittedAnswerId: submittedAnswerId);
      emit(
        QuizSuccess(

         updatedQuestions,
        ),
      );
    }
  }
  void submitAnswer(
      String currentUserId,
      String submittedAnswer,
      BattleRoom battleRoom,{
        required bool isCorrectAnswer,
      }) {
    if (state is QuizSuccess) {




      final questions = (state as QuizSuccess).questions;

      //need to check submitting answer for user1
      if (currentUserId == battleRoom.user1!.uid) {
        if (battleRoom.user1!.answers.length != questions.length) {
          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user1!.correctAnswers + 1)
                : battleRoom.user1!.correctAnswers,
            userNumber: '1',
            submittedAnswer: List.from(battleRoom.user1!.answers)
              ..add(submittedAnswer),
          );
        }
      } else if (currentUserId == battleRoom.user2!.uid) {
        //submit answer for user2
        if (battleRoom.user2!.answers.length != questions.length) {
          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user2!.answers)
              ..add(submittedAnswer),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user2!.correctAnswers + 1)
                : battleRoom.user2!.correctAnswers,
            userNumber: '2',
          );
        }
      } else if (currentUserId == battleRoom.user3!.uid) {
        //submit answer for user3
        if (battleRoom.user3!.answers.length != questions.length) {
          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user3!.answers)
              ..add(submittedAnswer),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user3!.correctAnswers + 1)
                : battleRoom.user3!.correctAnswers,
            userNumber: '3',
          );
        }
      } else {
        //submit answer for user4
        if (battleRoom.user4!.answers.length != questions.length) {
          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user4!.answers)
              ..add(submittedAnswer),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user4!.correctAnswers + 1)
                : battleRoom.user4!.correctAnswers,
            userNumber: '4',
          );
        }
      }
    }
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
  List<Questions> getCatQuestions() {
    if (state is QuizSuccess) {
      return (state as QuizSuccess).questions;
    }
    return [];
  }


}