part of 'game_bloc.dart';

sealed class GameState extends Equatable {
  const GameState();
}

final class GameInitial extends GameState {
  @override
  List<Object> get props => [];
}
final class GameReset extends GameState {
  @override
  List<Object> get props => [Random().nextDouble()];
}

 class GameLoading extends GameState {
   GameLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [Random().nextDouble()];
}

class GameStateFailure extends GameState {
  final String message;

  GameStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class GameStateSuccess extends GameState {
  final RoomModel roomModel;

  GameStateSuccess({required this.roomModel});

  @override
  List<Object> get props => [roomModel];
}
