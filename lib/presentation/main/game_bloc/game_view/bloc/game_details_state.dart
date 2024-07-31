part of 'game_details_bloc.dart';

sealed class GameDetailsState extends Equatable {
  const GameDetailsState();
}

final class GameDetailsInitial extends GameDetailsState {
  @override
  List<Object> get props => [];
}

class GameDetailsStateLoading extends GameDetailsState {
  const GameDetailsStateLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GameDetailsStateFailure extends GameDetailsState {
  final String message;

  const GameDetailsStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class GameDetailsStateSuccess extends GameDetailsState {
  final List<GameFireBaseModel> gameFireBaseModelList;

  const GameDetailsStateSuccess({required this.gameFireBaseModelList});

  @override
  List<Object> get props => [gameFireBaseModelList];
}