part of 'answer_bloc.dart';

sealed class AnswerState extends Equatable {
   const AnswerState();
}

final class AnswerInitial extends AnswerState {
  @override
  List<Object> get props => [Random().nextDouble()];
}


class AnswerLoadSuccess extends AnswerState {
  final List<AnswerModel> answers;
  final String selectedItemId;
  final bool showCorrectAnswer;
    const AnswerLoadSuccess({required this.answers,this.selectedItemId ="",this.showCorrectAnswer=false});

  @override
  // TODO: implement props
  List<Object?> get props => [answers,selectedItemId,showCorrectAnswer];
}
