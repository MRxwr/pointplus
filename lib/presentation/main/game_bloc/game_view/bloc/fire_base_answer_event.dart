part of 'fire_base_answer_bloc.dart';

sealed class FireBaseAnswerEvent extends Equatable {
  const FireBaseAnswerEvent();
}

class InsertFireBaseAnswer extends FireBaseAnswerEvent {

  final List<UserModel> answers;
  final String roomId;




  const InsertFireBaseAnswer({required this.answers,required this.roomId});

  @override
  List<Object> get props => [answers,roomId];
}
