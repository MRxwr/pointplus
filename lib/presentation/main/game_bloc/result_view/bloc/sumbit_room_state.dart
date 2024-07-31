part of 'sumbit_room_bloc.dart';

sealed class SumbitRoomState extends Equatable {
  const SumbitRoomState();
}

final class SumbitRoomInitial extends SumbitRoomState {
  @override
  List<Object> get props => [];
}
final class SumbitRoomReset extends SumbitRoomState {
  @override
  List<Object> get props => [];
}

class SumbitRoomStateLoading extends SumbitRoomState {
  const SumbitRoomStateLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SumbitRoomStateFailure extends SumbitRoomState {
  final String message;

  const SumbitRoomStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class SumbitRoomStateSuccess extends SumbitRoomState {
  final SumbitRoomModel sumbitRoomModel;

  const SumbitRoomStateSuccess({required this.sumbitRoomModel});

  @override
  List<Object> get props => [sumbitRoomModel];
}
