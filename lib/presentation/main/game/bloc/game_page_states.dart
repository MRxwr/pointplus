import 'package:dio/dio.dart';
import 'package:point/data/network/failure.dart';
import 'package:point/domain/models/models.dart';
import 'package:equatable/equatable.dart';
 class GameStates  {
  final RoomModel? roomModel;
  final String? createGame;
  final String? joinGame;
  final String? userIdGame;
  final String? roomIdGame;
  final String? roomCodeGame;
  final String? exitGame;
  final String? isShown;
  final String ? isDismissed;

  final Failure? error;
  GameStates copyWith(
      {RoomModel? roomModel, String? createGame, String? joinGame, String? userIdGame,
        String? roomIdGame,String? roomCodeGame,String? exitGame,String? isShown,String? isDismissed,Failure? error}) {
    return GameStates(
        roomModel: roomModel ?? this.roomModel,
        createGame: createGame ?? this.createGame,
        joinGame: joinGame ?? this.joinGame,
        userIdGame: userIdGame ?? this.userIdGame,
      roomIdGame: roomIdGame ?? this.roomIdGame,
      roomCodeGame: roomCodeGame ?? this.roomCodeGame,
      exitGame:exitGame ?? this.exitGame,
      isShown: isShown ?? this.isShown,
      isDismissed:isDismissed ?? this.isDismissed,
      error: error ?? this.error,
    );
  }

  const GameStates({this.roomModel,this.createGame,this.joinGame,this.userIdGame,this.roomIdGame,this.roomCodeGame,this.exitGame,this.isShown,this.isDismissed,  this.error});

 }

class GameStateLoading extends GameStates {
  const GameStateLoading();
}

class GameSateInit extends GameStates {
  const GameSateInit();
}

class GameStateDone extends GameStates {
  const GameStateDone({required RoomModel roomModel}) : super(roomModel: roomModel);
}
class GameStateError extends GameStates {
  const GameStateError({required Failure error}) : super(error: error);
}


class DialogVisible extends GameStates {
  const DialogVisible({required String isShown}) : super(isShown: isShown);
}

class DialogHidden extends GameStates {
  const DialogHidden({required String isDismissed}) : super(isDismissed: isDismissed);
}
