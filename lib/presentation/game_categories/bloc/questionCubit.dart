import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/presentation/game_categories/models/battleRoom.dart';

import '../../../app/battleRoomRepository.dart';
import '../../../domain/usecases/questions_usecase.dart';
import '../../battle/models/answerOption.dart';
import '../../battle/models/correctAnswer.dart';
import '../models/questionCategory.dart';

@immutable
class QuestionsState {

}
class QuestionsInitial extends QuestionsState {}

class QuestionsInProgress extends QuestionsState {}

class QuestionsSuccess extends QuestionsState {
  QuestionsSuccess({

    required this.questions


  });
 final List<Questions> questions;


}
class QuestionsFailure extends QuestionsState {
  QuestionsFailure(this.errorMessageCode);

  final String errorMessageCode;
}

class QuestionsCubit extends Cubit<QuestionsState> {
  QuestionsCubit(this._questionUseCase,this._battleRoomRepository) : super(QuestionsInitial());
  final QuestionUseCase _questionUseCase;
  final BattleRoomRepository _battleRoomRepository;

  Future<void> getQuizCategoryQuestionWithUserIdAndCategoyrId(String userId,String categoryId,String noOfQuestion) async {

    (await _questionUseCase.execute(QuestionCaseInput(userId,categoryId,noOfQuestion))).
    fold((failure)  {



      emit(QuestionsFailure(failure.message));


    }, (data)  {
      List<Questions> questions = [] ;
      // send questions data to firebase
      // for(int i=0;i<data!.questionResultModel.questionList.length;i++){
      //   Questions question = Questions();
      //
      //   question.answer1= data!.questionResultModel.questionList[i].answer1;
      //   question.answer2= data!.questionResultModel.questionList[i].answer2;
      //
      //   question.answer3= data!.questionResultModel.questionList[i].answer3;
      //   question.question= data!.questionResultModel.questionList[i].question;
      //   question.isCorrect1= data!.questionResultModel.questionList[i].isCorrect1;
      //   question.isCorrect2= data!.questionResultModel.questionList[i].isCorrect2;
      //   question.isCorrect3= data!.questionResultModel.questionList[i].isCorrect3;
      //   question.image= data!.questionResultModel.questionList[i].image;
      //   question.points= data!.questionResultModel.questionList[i].points;
      //   question.score= "";
      //   question.attempted= false;
      //
      //   question.id=data!.questionResultModel.questionList[i].id;
      //   List<AnswerOption> answers = [];
      //   AnswerOption answerOption1= AnswerOption(id: "1",title: data!.questionResultModel.questionList[i].answer1);
      //   answers.add(answerOption1);
      //   AnswerOption answerOption2= AnswerOption(id: "2",title: data!.questionResultModel.questionList[i].answer2);
      //   answers.add(answerOption2);
      //   AnswerOption answerOption3= AnswerOption(id: "3",title: data!.questionResultModel.questionList[i].answer3);
      //   answers.add(answerOption3);
      //   question.answerOptions=answers;
      //   CorrectAnswer? correctAnswer;
      //   if(data!.questionResultModel.questionList[i].isCorrect1 == "1"){
      //     correctAnswer = CorrectAnswer(answer:data!.questionResultModel.questionList[i].answer1.toString(),answerId: "1");
      //
      //   }else if(data!.questionResultModel.questionList[i].isCorrect2 == "1"){
      //     correctAnswer = CorrectAnswer(answer:data!.questionResultModel.questionList[i].answer2.toString(),answerId: "2");
      //
      //   }
      //   else if(data!.questionResultModel.questionList[i].isCorrect3 == "1"){
      //     correctAnswer = CorrectAnswer(answer:data!.questionResultModel.questionList[i].answer3.toString(),answerId: "3");
      //
      //   }
      //   question.correctAnswer = correctAnswer;
      //   question.submittedAnswerId = "";
      //
      //
      //
      //
      //
      //   questions.add(question);
      // }


      emit(
        QuestionsSuccess(

          questions: questions,
        ),
      );










      //right --> success
      // inputState.add(ContentState());

      //navigate to main Screen

    });

  }


  void updateState(QuestionsState updatedState) {
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

  List<Questions> getQuestions() {
    if (state is QuestionsSuccess) {
      return (state as QuestionsSuccess).questions;
    }
    return [];
  }
  void updateQuestionAnswer(String questionId, String submittedAnswerId) {
    if (state is QuestionsSuccess) {
      final updatedQuestions = (state as QuestionsSuccess).questions;

      //fetching index of question that need to update with submittedAnswer
      final questionIndex =
      updatedQuestions!.indexWhere((element) => element.id == questionId);
      //update question at given questionIndex with submittedAnswerId
      updatedQuestions[questionIndex] = updatedQuestions[questionIndex]
          .updateQuestionWithAnswer(submittedAnswerId: submittedAnswerId);
      print("questionUpdatedlength---> ${updatedQuestions.length}");
      // emit(
      //   MultiUserBattleRoomSuccess(
      //     battleRoom: (state as MultiUserBattleRoomSuccess).battleRoom,
      //     isRoomExist: true,
      //
      //
      //     questions: updatedQuestions,
      //   ),
      // );
      emit(QuestionsSuccess(questions: updatedQuestions));
    }
  }
  void submitAnswer(
      String currentUserId,
      String submittedAnswer,
      BattleRoom battleRoom,
      {
        required bool isCorrectAnswer,
      }) {
    if (state is QuestionsSuccess) {
      // final battleRoom = (state as MultiUserBattleRoomSuccess).battleRoom;



      final questions = (state as QuestionsSuccess).questions;

      //need to check submitting answer for user1
      if (currentUserId == battleRoom.user1!.uid) {
        if (battleRoom.user1!.answers.length != questions!.length) {
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
        if (battleRoom.user2!.answers.length != questions!.length) {
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
        if (battleRoom.user3!.answers.length != questions!.length) {
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
      } else  if (battleRoom.user4!.answers.length != questions!.length) {
        //submit answer for user4

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
      else  if (battleRoom.user5!.answers.length != questions.length) {
        //submit answer for user4

        _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
          submittedAnswer: List.from(battleRoom.user5!.answers)
            ..add(submittedAnswer),
          battleRoomDocumentId: battleRoom.roomId,
          correctAnswers: isCorrectAnswer
              ? (battleRoom.user5!.correctAnswers + 1)
              : battleRoom.user5!.correctAnswers,
          userNumber: '5',
        );

      }else  if (battleRoom.user6!.answers.length != questions.length) {
        //submit answer for user4

        _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
          submittedAnswer: List.from(battleRoom.user6!.answers)
            ..add(submittedAnswer),
          battleRoomDocumentId: battleRoom.roomId,
          correctAnswers: isCorrectAnswer
              ? (battleRoom.user6!.correctAnswers + 1)
              : battleRoom.user6!.correctAnswers,
          userNumber: '6',
        );

      }
    }
  }
}