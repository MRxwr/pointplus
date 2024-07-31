import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/presentation/main/game/bloc/game_page_events.dart';
import 'package:point/presentation/main/game/bloc/game_page_states.dart';

import '../../../../app/constant.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../domain/usecases/room_usecase.dart';

class GamePageBloc extends Bloc<GameEvents, GameStates> {
  final RoomUseCase _roomUseCase;
  GamePageBloc(this._roomUseCase) : super(const GameSateInit()) {
    on<CreateEvent>(_createEvent);
    on<JoinEvent>(_joinEvent);
    on<UserIdEvent>(_userIdEvent);
    on<RoomIdEvent>(_roomIdEvent);
    on<ExitEvent>(_exitEvent);
    on<RoomCodeEvent>(_roomCodeEvent);
    on<Dialogshow>(_showDialog);
    on<Dialogclose>(_hideDialog);
   on<RoomEvent>(_onGetGame);
   on<InitialEvent>(_onInitialGame);

  }
  void _onInitialGame(InitialEvent event,Emitter<GameStates> emitter){
    emit(const GameSateInit());
  }

  Future<void> _onGetGame(RoomEvent event, Emitter<GameStates> emit) async {
   emit(const GameStateLoading());


    (await _roomUseCase.execute(RoomCaseInput(event.create,event.join,event.userId,event.roomId,event.roomCode,event.exit))).
    fold((failure)  {

    emit(GameStateError(error: failure));




    }, (data)  {






      emit(GameStateDone(roomModel: data));



      //right --> success
      // inputState.add(ContentState());

      //navigate to main Screen

    });

  }

  void _showDialog(Dialogshow event,Emitter<GameStates> emitter){
    emit(state.copyWith(isShown: event.isShown));
  }
  void _hideDialog(Dialogclose event,Emitter<GameStates> emitter){
    emit(state.copyWith(isDismissed:event.isDismiss));
  }

  void _createEvent(CreateEvent event, Emitter<GameStates> emit){

    emit(state.copyWith(createGame: event.createGame));
  }
  void _joinEvent(JoinEvent event, Emitter<GameStates> emit){

    emit(state.copyWith(joinGame: event.joinGame));
  }
  void _userIdEvent(UserIdEvent event, Emitter<GameStates> emit){

    emit(state.copyWith(userIdGame: event.userIdGame));
  }
  void _roomIdEvent(RoomIdEvent event, Emitter<GameStates> emit){

    emit(state.copyWith(roomIdGame: event.roomIdGame));
  }
  void _roomCodeEvent(RoomCodeEvent event, Emitter<GameStates> emit){

    emit(state.copyWith(roomCodeGame: event.roomCodeGame));
  }
  void _exitEvent(ExitEvent event, Emitter<GameStates> emit){

    emit(state.copyWith(exitGame: event.exitGame));
  }

}