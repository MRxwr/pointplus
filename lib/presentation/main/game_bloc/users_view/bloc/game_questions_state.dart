part of 'game_questions_bloc.dart';

sealed class GameQuestionsState extends Equatable {
  const GameQuestionsState();
}

final class GameQuestionsInitial extends GameQuestionsState {
  @override
  List<Object> get props => [];
}

final class GameQuestionsReset extends GameQuestionsState {
  @override
  List<Object> get props => [];
}
class GameQuestionsStateLoading extends GameQuestionsState {
  const GameQuestionsStateLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GameQuestionsStateFailure extends GameQuestionsState {
  final String message;

  const GameQuestionsStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class GameQuestionsStateSuccess extends GameQuestionsState {
  final List<QuestionResponseModel> questionResponseModelList;

  const GameQuestionsStateSuccess({required this.questionResponseModelList});

  @override
  List<Object> get props => [questionResponseModelList];
}
