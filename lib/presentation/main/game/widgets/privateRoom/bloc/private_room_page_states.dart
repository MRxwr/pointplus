import '../../../../../../data/network/failure.dart';
import '../../../../../../domain/models/models.dart';

class PrivateRoomState{
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
  final String? code;
  const PrivateRoomState(
      {
        this.roomModel,this.createGame,this.joinGame,this.userIdGame,this.roomIdGame,this.roomCodeGame,this.exitGame,this.isShown,this.isDismissed,  this.error,this.code

        });

  PrivateRoomState copyWith(
      {String? code,RoomModel? roomModel, String? createGame, String? joinGame, String? userIdGame,
        String? roomIdGame,String? roomCodeGame,String? exitGame,String? isShown,String? isDismissed,Failure? error}) {
    return PrivateRoomState(
        code: code ?? this.code,
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

}
class GameStateLoading extends PrivateRoomState {
  const GameStateLoading();
}

class GameSateInit extends PrivateRoomState {
  const GameSateInit();
}

class GameStateDone extends PrivateRoomState {
  const GameStateDone({required RoomModel roomModel}) : super(roomModel: roomModel);
}
class GameStateError extends PrivateRoomState {
  const GameStateError({required Failure error}) : super(error: error);
}


class DialogVisible extends PrivateRoomState {
  const DialogVisible({required String isShown}) : super(isShown: isShown);
}

class DialogHidden extends PrivateRoomState {
  const DialogHidden({required String isDismissed}) : super(isDismissed: isDismissed);
}