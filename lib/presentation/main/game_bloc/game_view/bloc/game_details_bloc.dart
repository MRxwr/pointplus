import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../domain/models/game_firebase_model.dart';
import '../../../../../domain/usecases/game_details_usecase.dart';
import '../../../../../domain/usecases/update_answers_use_case.dart';

part 'game_details_event.dart';
part 'game_details_state.dart';

class GameDetailsBloc extends Bloc<GameDetailsEvent, GameDetailsState> {
  final GameDetailsUsecase gameDetailsUsecase;
  final UpdateAnswersUseCase updateAnswersUseCase;
  GameDetailsBloc(this.gameDetailsUsecase,this.updateAnswersUseCase) : super(GameDetailsInitial()) {
    on<FetchGameDetails>((input, emit) async {
      emit(const GameDetailsStateLoading());
      await emit.forEach(
        gameDetailsUsecase.call(GameDetailsUsecaseInput(input.roomId,
            )),
        onData: (data) {
          return data.fold(
                (failure) => GameDetailsStateFailure( message: failure.message),
                (users) => GameDetailsStateSuccess(gameFireBaseModelList:  users),
          );
        },
        onError: (_, __) => const GameDetailsStateFailure(message: 'Unexpected error occurred'),
      );


    });

  }
}
