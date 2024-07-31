part of 'fire_base_answer_bloc.dart';

sealed class FireBaseAnswerState extends Equatable {
  const FireBaseAnswerState();
}

final class FireBaseAnswerInitial extends FireBaseAnswerState {
  @override
  List<Object> get props => [];
}

class FireBaseAnswerLoading extends FireBaseAnswerState {
  const FireBaseAnswerLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FireBaseAnswerFailure extends FireBaseAnswerState {
  final String message;

  const FireBaseAnswerFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class FireBaseAnswerSuccess extends FireBaseAnswerState {


  const FireBaseAnswerSuccess();

  @override
  List<Object> get props => [];
}
