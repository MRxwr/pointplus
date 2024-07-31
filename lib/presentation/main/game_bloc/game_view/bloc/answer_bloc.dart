import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point/domain/models/answer_model.dart';
import 'package:point/domain/models/game_firebase_model.dart';

part 'answer_event.dart';
part 'answer_state.dart';

class AnswerBloc extends Bloc<AnswerEvent, AnswerState> {
  AnswerBloc() : super(AnswerInitial()) {
    on<LoadItems>(_onLoadItems);
    on<ToggleItemStatus>(_onToggleItemStatus);
    on<DisplayCorrectAnswer>(_onDisplayCorrectAnswer);
  }
  void _onLoadItems(LoadItems event, Emitter<AnswerState> emit) {
    List<AnswerModel> answersList =[];
    QuestionModel questionModel = event.questionModel;
    List<String> answers= questionModel.answers;

    for(int i =0;i<answers.length;i++){
      bool isCorrectAnswer= false ;
      if(i == questionModel.correctAnswerIndex){
        isCorrectAnswer = true;
      }
      AnswerModel answerModel = AnswerModel(answer: answers[i], isCorrect: isCorrectAnswer, status: false, id: '${i+1}');
      answersList.add(answerModel);
    }
    emit(AnswerLoadSuccess(answers: answersList));
  }

  void _onToggleItemStatus(ToggleItemStatus event, Emitter<AnswerState> emit) {
    List<AnswerModel> answersList =event.answersList;
    final currentState = state;
    if (currentState is AnswerLoadSuccess) {
      final items = currentState.answers.map((item) {
        if (item.id == event.id) {
          AnswerModel answerModel = item;
          answerModel.status = !answerModel.status;
          return answerModel;
        }
        return item;
      }).toList();
      emit(AnswerLoadSuccess(answers: items,selectedItemId: event.id, showCorrectAnswer: false));
      Future.delayed(const Duration(seconds: 1), () {
        add(DisplayCorrectAnswer());
      });

    }
  }

  void _onDisplayCorrectAnswer(DisplayCorrectAnswer event, Emitter<AnswerState> emit) {
    final currentState = state;
    if (currentState is AnswerLoadSuccess) {
      emit(AnswerLoadSuccess(answers: currentState.answers, selectedItemId: currentState.selectedItemId, showCorrectAnswer: true));
    }
  }
}
