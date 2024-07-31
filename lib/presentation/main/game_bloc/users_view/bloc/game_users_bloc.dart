import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/usecases/update_questions_use_case.dart';


import '../../../../../domain/models/game_firebase_model.dart';
import '../../../../../domain/usecases/delete_room_usecas.dart';
import '../../../../../domain/usecases/game_details_usecase.dart';
import '../../../../../domain/usecases/game_use_case.dart';
import '../../../../../domain/usecases/initialize_questions_use_case.dart';
import '../../../../../domain/usecases/join_game_use_case.dart';
import '../../../../../domain/usecases/start_game_usecase.dart';
import '../../../../../domain/usecases/update_answers_use_case.dart';
import '../../../../../domain/usecases/update_category_usecase.dart';
import '../../../../../domain/usecases/update_users_use_case.dart';

part 'game_users_event.dart';
part 'game_users_state.dart';

class GameUsersBloc extends Bloc<GameUsersEvent, GameUsersState> {
  final GameUseCase gameUseCase;
  final JoinGameUseCase joinGameUseCase;
  final StartGameUsecase startGameUsecase;
  final InitializeQuestionsUseCase initializeQuestionsUseCase;
  final UpdateCategoryUsecase updateCategoryUsecase;
  final UpdateQuestionsUseCase updateQuestionsUseCase;
  final GameDetailsUsecase gameDetailsUsecase;
  final UpdateAnswersUseCase updateAnswersUseCase;
  final DeleteRoomUsecase deleteRoomUsecase;
  final UpdateUsersUseCase updateUsersUseCase;



  GameUsersBloc(this.gameUseCase,this.joinGameUseCase,this.startGameUsecase,this.initializeQuestionsUseCase,this.updateCategoryUsecase,this.updateQuestionsUseCase,this.gameDetailsUsecase,this.updateAnswersUseCase,this.deleteRoomUsecase,this.updateUsersUseCase) : super(GameUsersInitial()) {
    on<FetchGameDetail>((input, emit) async {
      emit(const GameUsersStateLoading());
      await emit.forEach(
        gameDetailsUsecase.call(GameDetailsUsecaseInput(input.roomId,
        )),
        onData: (data) {
          return data.fold(
                (failure) => GameUsersStateFailure( message: failure.message),
                (users) => GameUsersStateSuccess(gameFireBaseModelList:  users),
          );
        },
        onError: (_, __) => const GameUsersStateFailure(message: 'Unexpected error occurred'),
      );


    });
    on<FetchGameUsers>((input, emit) async {
      emit(const GameUsersStateLoading());
      await emit.forEach(
        gameUseCase.call(GameUseCaseInput(input.roomId,
        input.createdBy,input.currentCategoryId,input.readyToPlay,input.totalQuestions,input.userModel,input.currentUserId,input.room)),
        onData: (data) {
          return data.fold(
                (failure) => GameUsersStateFailure( message: failure.message),
                (users) => GameUsersStateSuccess(gameFireBaseModelList:  users),
          );
        },
        onError: (_, __) => const GameUsersStateFailure(message: 'Unexpected error occurred'),
      );


    });
    on<JoinGameUsers>((input, emit) async {
      emit(const GameUsersStateLoading());
      await emit.forEach(
        joinGameUseCase.call(JoinGameUseCaseInput(input.roomId,input.userModel)),
        onData: (data) {
          return data.fold(
                (failure) => GameUsersStateFailure( message: failure.message),
                (users) => GameUsersStateSuccess(gameFireBaseModelList:  users),
          );
        },
        onError: (_, __) => const GameUsersStateFailure(message: 'Unexpected error occurred'),
      );


    });
    on<StartPlayEvent>((event, emit) async {

      (await startGameUsecase.execute(StartGameUseCaseInput(event.roomId)));

    });

    on<UpdateUsersEvent>((event, emit) async {

      (await updateUsersUseCase.execute(UpdateUsersUseCaseInput(event.roomId,event.users)));

    });
    on<DeleteRoom>((event, emit) async {

      (await deleteRoomUsecase.execute(DeleteRoomUsecaseInput(event.roomId)));

    });
    on<InitializeQuestionsEvent>((event, emit) async {

      (await initializeQuestionsUseCase.execute(InitializeQuestionsUseCaseInput(event.roomId,event.currentUserId,event.users)));

    });
    on<UpdateCategoryEvent>((event, emit) async {

      (await updateCategoryUsecase.execute(UpdateCategoryUsecaseInput(event.roomId,event.currentCategoryId,event.users)));

    });
    on<UpdateQuestionsEvent>((event, emit) async {

      (await updateQuestionsUseCase.execute(UpdateQuestionsUseCaseInput(event.roomId,event.users)));

    });
    on<InsertFireBaseAnswer>((event, emit) async {

      (await updateAnswersUseCase.execute(UpdateAnswersUseCaseInput(event.roomId,event.users)));

    });

    // on<InitializeGame>((event, emit)async{
    //   emit(  GameUsersReset());
    // });
    // add( InitializeGame());
  }
  @override
  Future<void> close() {

    return super.close();
  }
}
