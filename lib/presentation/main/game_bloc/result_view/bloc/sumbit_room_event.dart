part of 'sumbit_room_bloc.dart';

sealed class SumbitRoomEvent extends Equatable {
  const SumbitRoomEvent();
}

class FetchSumbitRoom extends SumbitRoomEvent {

  final String roomId;
  final String winner;
  final String points;




  const FetchSumbitRoom({required this.roomId,required this.winner,required this.points});

  @override
  List<Object> get props => [roomId,winner,points];
}
class InitializeSumbitRoom extends SumbitRoomEvent {








  @override
  List<Object> get props => [];
}