abstract class GameEvents {
  const GameEvents();
}

class CreateEvent extends GameEvents{
  final String createGame;
  const CreateEvent(this.createGame);

}
class InitialEvent extends GameEvents{

  const InitialEvent();

}

class JoinEvent extends GameEvents{
  final String joinGame;
  const JoinEvent(this.joinGame);

}
class UserIdEvent extends GameEvents{
  final String userIdGame;
  const UserIdEvent(this.userIdGame);

}
class RoomIdEvent extends GameEvents{
  final String roomIdGame;
  const RoomIdEvent(this.roomIdGame);

}

class RoomCodeEvent extends GameEvents{
  final String roomCodeGame;
  const RoomCodeEvent(this.roomCodeGame);

}

class ExitEvent extends GameEvents{
  final String exitGame;
  const ExitEvent(this.exitGame);

}
class RoomEvent extends GameEvents{
  String create;
  String join;
  String userId;
  String roomId;
  String roomCode;
  String exit;

  RoomEvent(this.create,this.join,this.userId,this.roomId,this.roomCode,this.exit);

}
class Dialogclose extends GameEvents{
  String isDismiss;
  Dialogclose(this.isDismiss);

}
class Dialogshow extends GameEvents{
  String isShown;
   Dialogshow(this.isShown);
}
