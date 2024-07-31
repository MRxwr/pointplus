import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point/domain/models/sumbit_room_model.dart';
import 'package:point/domain/usecases/sumbit_room_use_case.dart';

part 'sumbit_room_event.dart';
part 'sumbit_room_state.dart';

class SumbitRoomBloc extends Bloc<SumbitRoomEvent, SumbitRoomState> {
  final SumbitRoomUseCase sumbitRoomUseCase;

  SumbitRoomBloc(this.sumbitRoomUseCase) : super(SumbitRoomInitial()) {

    on<FetchSumbitRoom>((event, emit) async {
      emit( const SumbitRoomStateLoading());
      (await sumbitRoomUseCase.execute(SumbitRoomUseCaseInput(event.roomId,event.winner,event.points))).fold(
            (failure) {

          print("failture ---> $failure");
          emit(SumbitRoomStateFailure(message: failure.message)) ;
        },
            (response) async {


          emit(SumbitRoomStateSuccess(sumbitRoomModel: response));



        },
      );

    });
    on<InitializeSumbitRoom>((event, emit)async{
      emit(  SumbitRoomReset());
    });
    add( InitializeSumbitRoom());
  }


}
