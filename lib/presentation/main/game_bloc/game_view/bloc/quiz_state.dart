import 'package:point/domain/models/game_firebase_model.dart';
import 'package:point/domain/models/quiz_question_model.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoadSuccess extends QuizState {
  final List<QuizQuestionModel> questions;
  final int currentQuestionIndex;
  final bool showCorrectAnswer;
  final List<QuestionResult> results;

  QuizLoadSuccess({required this.questions, this.currentQuestionIndex = 0, this.showCorrectAnswer = false,  this.results = const [],});
}

class QuizComplete extends QuizState {
  final List<QuestionResult> results;
  QuizComplete(this.results);

}

