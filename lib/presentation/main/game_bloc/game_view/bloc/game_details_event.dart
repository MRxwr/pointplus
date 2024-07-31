part of 'game_details_bloc.dart';

sealed class GameDetailsEvent extends Equatable {
  const GameDetailsEvent();
}
class FetchGameDetails extends GameDetailsEvent {


  String roomId;





  FetchGameDetails({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
class FetchGame extends GameDetailsEvent {


  String roomId;





  FetchGame({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
class UpdateAnswersEvent extends GameDetailsEvent {


  String roomId;
  List<Result> users;






  UpdateAnswersEvent({required this.roomId,required this.users});

  @override
  List<Object> get props => [roomId,users];
}