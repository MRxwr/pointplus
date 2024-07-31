part of 'game_users_bloc.dart';

sealed class GameUsersState extends Equatable {
  const GameUsersState();
}

final class GameUsersInitial extends GameUsersState {
  @override
  List<Object> get props => [];
}
class GameUsersStateLoading extends GameUsersState {
  const GameUsersStateLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GameUsersStateFailure extends GameUsersState {
  final String message;

  const GameUsersStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class GameUsersStateSuccess extends GameUsersState {
  final List<GameFireBaseModel> gameFireBaseModelList;

  const GameUsersStateSuccess({required this.gameFireBaseModelList});

  @override
  List<Object> get props => [gameFireBaseModelList];
}

final class GameUsersReset extends GameUsersState {
  @override
  List<Object> get props => [];
}