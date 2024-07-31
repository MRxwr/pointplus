import '../../../../../domain/models/game_firebase_model.dart';

abstract class QuizEvent {}

class LoadQuestions extends QuizEvent {
  List<QuestionModel> questionsList;
  int startIndex;
  LoadQuestions(this.questionsList,this.startIndex);
}

class SelectAnswer extends QuizEvent {
  final String questionId;
  final String answerId;
  SelectAnswer(this.questionId, this.answerId);
}

class DisplayCorrectAnswer extends QuizEvent {}

class NextQuestion extends QuizEvent {}
