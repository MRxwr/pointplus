part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();
}

class FetchRoom extends GameEvent {
 final String create;
 final String join;
 final String userId;
 final String roomId;
 final String roomCode;
 final String exit;



 const FetchRoom({required this.create,required this.join,required this.userId,
    required this.roomId,required this.roomCode,required this.exit});

  @override
  List<Object> get props => [create,join,userId,roomId,roomCode,exit];
}
class InitRoom extends GameEvent {

 List<Object> get props => [Random().nextDouble()];
}