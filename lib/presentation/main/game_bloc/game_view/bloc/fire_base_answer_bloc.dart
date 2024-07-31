import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point/domain/models/quiz_question_model.dart';

import '../../../../../domain/models/game_firebase_model.dart';
import '../../../../../domain/usecases/update_answers_use_case.dart';

part 'fire_base_answer_event.dart';
part 'fire_base_answer_state.dart';

class FireBaseAnswerBloc extends Bloc<FireBaseAnswerEvent, FireBaseAnswerState> {
  final UpdateAnswersUseCase updateAnswersUseCase;
  FireBaseAnswerBloc(this.updateAnswersUseCase) : super(FireBaseAnswerInitial()) {
    on<InsertFireBaseAnswer>((event, emit) async {
      emit(const FireBaseAnswerLoading()) ;
      (await updateAnswersUseCase.execute(UpdateAnswersUseCaseInput(event.roomId,event.answers))).fold(
            (failure) {

          print("failture ---> $failure");
          emit(FireBaseAnswerFailure(message: failure.message)) ;
        },
            (response) async {


          emit(FireBaseAnswerSuccess());



        },
      );

    });
  }
}
