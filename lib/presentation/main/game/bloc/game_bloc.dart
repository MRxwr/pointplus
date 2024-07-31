import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/models/models.dart';
import '../../../../domain/usecases/room_usecase.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final RoomUseCase roomUseCase;

  GameBloc(this.roomUseCase) : super(GameInitial()) {
    on<FetchRoom>((event, emit) async {
      emit( GameLoading());
      (await roomUseCase.execute(RoomCaseInput(event.create,event.join,event.userId,
          event.roomId,event.roomCode,event.exit))).fold(
            (failure) {

          print("failture ---> $failure");
          emit(GameStateFailure(message: failure.message)) ;
        },
            (response) async {


          emit(GameStateSuccess(roomModel: response));



        },
      );

    });
on<InitRoom>((event,emit){
  emit(GameReset());
});
add(InitRoom());
  }


}
