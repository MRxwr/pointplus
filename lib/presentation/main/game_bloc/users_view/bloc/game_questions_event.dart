part of 'game_questions_bloc.dart';

sealed class GameQuestionsEvent extends Equatable {
  const GameQuestionsEvent();
}
class InitializeQuestionEvent extends GameQuestionsEvent {








  @override
  List<Object> get props => [];
}
class FetchQuestionsEvent extends GameQuestionsEvent {

 final List<QuestionRequest> inputs;




  const  FetchQuestionsEvent({required this.inputs});

  @override
  List<Object> get props => [inputs];
}
