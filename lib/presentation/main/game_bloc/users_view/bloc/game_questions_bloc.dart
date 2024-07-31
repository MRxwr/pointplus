import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/network/request.dart';
import '../../../../../domain/models/models.dart';
import '../../../../../domain/usecases/questions_usecase.dart';

part 'game_questions_event.dart';
part 'game_questions_state.dart';

class GameQuestionsBloc extends Bloc<GameQuestionsEvent, GameQuestionsState> {
  final QuestionUseCase questionUseCase;

  GameQuestionsBloc(this.questionUseCase) : super(GameQuestionsInitial()) {

    on<FetchQuestionsEvent>((event, emit) async {
      emit( const GameQuestionsStateLoading());
      (await questionUseCase.call(event.inputs)).fold(
            (failure) {

          print("failture ---> $failure");
          emit(GameQuestionsStateFailure(message: failure.message)) ;
        },
            (response) async {


          emit(GameQuestionsStateSuccess(questionResponseModelList: response));



        },
      );

    });
    on<InitializeQuestionEvent>((event, emit)async{
      emit(  GameQuestionsReset());
    });
    add( InitializeQuestionEvent());
  }
}
