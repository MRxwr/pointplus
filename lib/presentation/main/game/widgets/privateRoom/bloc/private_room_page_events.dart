abstract class PrivateRoomEvent {
  const PrivateRoomEvent();
}

class CodeEvent extends PrivateRoomEvent{
  final String code;
  const CodeEvent(this.code);

}
class CreateEvent extends PrivateRoomEvent{
  final String createGame;
  const CreateEvent(this.createGame);

}
class InitialEvent extends PrivateRoomEvent{

  const InitialEvent();

}

class JoinEvent extends PrivateRoomEvent{
  final String joinGame;
  const JoinEvent(this.joinGame);

}
class UserIdEvent extends PrivateRoomEvent{
  final String userIdGame;
  const UserIdEvent(this.userIdGame);

}
class RoomIdEvent extends PrivateRoomEvent{
  final String roomIdGame;
  const RoomIdEvent(this.roomIdGame);

}

class RoomCodeEvent extends PrivateRoomEvent{
  final String roomCodeGame;
  const RoomCodeEvent(this.roomCodeGame);

}

class ExitEvent extends PrivateRoomEvent{
  final String exitGame;
  const ExitEvent(this.exitGame);

}
class RoomEvent extends PrivateRoomEvent{
  String create;
  String join;
  String userId;
  String roomId;
  String roomCode;
  String exit;

  RoomEvent(this.create,this.join,this.userId,this.roomId,this.roomCode,this.exit);

}
class Dialogclose extends PrivateRoomEvent{
  String isDismiss;
  Dialogclose(this.isDismiss);

}
class Dialogshow extends PrivateRoomEvent{
  String isShown;
  Dialogshow(this.isShown);
}

