part of 'answer_bloc.dart';

sealed class AnswerEvent extends Equatable {
  const AnswerEvent();
}

class LoadItems extends AnswerEvent {
 final QuestionModel questionModel;
 const LoadItems(this.questionModel);
  @override
  // TODO: implement props
  List<Object?> get props => [questionModel];
}

class ToggleItemStatus extends AnswerEvent {
  final String id;
  final List<AnswerModel> answersList;
  const ToggleItemStatus(this.id,this.answersList);

  @override
  // TODO: implement props
  List<Object?> get props => [id,answersList];
}
class DisplayCorrectAnswer extends AnswerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}