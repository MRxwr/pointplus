import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/domain/models/quiz_question_model.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/quiz_event.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/quiz_state.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/timer_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/timer_event.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/timer_state.dart';



class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final TimerBloc timerBloc;
  late final StreamSubscription timerSubscription;
  DateTime? questionStartTime;

  QuizBloc({required this.timerBloc}) : super(QuizInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SelectAnswer>(_onSelectAnswer);
    on<DisplayCorrectAnswer>(_onDisplayCorrectAnswer);
    on<NextQuestion>(_onNextQuestion);


    timerSubscription = timerBloc.stream.listen((timerState) {
      if (timerState is TimerRunComplete) {
        add(DisplayCorrectAnswer());
      }
    });
  }

  void _onLoadQuestions(LoadQuestions event, Emitter<QuizState> emit) {
   List<QuizQuestionModel> questions = [];
   for(int i=0;i<event.questionsList.length;i++){
     List<Answer> answers =[];
     for(int j=0;j<event.questionsList[i].answers.length;j++){
       Answer answer;
       if(j == event.questionsList[i].correctAnswerIndex){
          answer = Answer(id: "${i+1}", text: event.questionsList[i].answers[j], isCorrect: true);
       }else{
         answer = Answer(id: "${i+1}", text: event.questionsList[i].answers[j], isCorrect: false);
       }
       answers.add(answer);

     }
     QuizQuestionModel questionModel = QuizQuestionModel(id: event.questionsList[i].questionId, 
         questionText: event.questionsList[i].questionText, image: event.questionsList[i].image,answers: answers);
     questions.add(questionModel);
   }
    // final questions = [
    //   Question(id: '1', questionText: 'Question 1', answers: [
    //     Answer(id: '1', text: 'Answer 1', isCorrect: true),
    //     Answer(id: '2', text: 'Answer 2', isCorrect: false),
    //     Answer(id: '3', text: 'Answer 3', isCorrect: false),
    //   ]),
    //   Question(id: '2', questionText: 'Question 2', answers: [
    //     Answer(id: '1', text: 'Answer 1', isCorrect: false),
    //     Answer(id: '2', text: 'Answer 2', isCorrect: true),
    //     Answer(id: '3', text: 'Answer 3', isCorrect: false),
    //   ]),
    // ];
    emit(QuizLoadSuccess(questions: questions,currentQuestionIndex: event.startIndex));
    timerBloc.add(StartTimer());
   questionStartTime = DateTime.now();
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<QuizState> emit) {
    final currentState = state;
    if (currentState is QuizLoadSuccess) {
      final question = currentState.questions[currentState.currentQuestionIndex];
      final selectedAnswer = question.answers.firstWhere((answer) => answer.id == event.answerId);
      final isCorrect = selectedAnswer.isCorrect;
      final timeTaken = DateTime.now().difference(questionStartTime!);
      final result = QuestionResult(questionId: question.id, isCorrect: isCorrect, timeTaken: timeTaken);

      emit(QuizLoadSuccess(
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex,
        showCorrectAnswer: true,
        results: [...currentState.results, result],
      ));
      timerBloc.add(StopTimer());
      Future.delayed(Duration(seconds: 2), () {
        add(NextQuestion());
      });
    }
  }

  void _onDisplayCorrectAnswer(DisplayCorrectAnswer event, Emitter<QuizState> emit) {
    final currentState = state;
    if (currentState is QuizLoadSuccess) {
      final question = currentState.questions[currentState.currentQuestionIndex];
      final timeTaken = DateTime.now().difference(questionStartTime!);
      final result = QuestionResult(questionId: question.id, isCorrect: false, timeTaken: timeTaken);

      emit(QuizLoadSuccess(
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex,
        showCorrectAnswer: true,
        results: [...currentState.results, result],
      ));
      Future.delayed(Duration(seconds: 2), () {
        add(NextQuestion());
      });
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    final currentState = state;
    if (currentState is QuizLoadSuccess) {
      final nextIndex = currentState.currentQuestionIndex + 1;
      if (nextIndex < currentState.questions.length) {
        emit(QuizLoadSuccess(
          questions: currentState.questions,
          currentQuestionIndex: nextIndex,
          showCorrectAnswer: false,
          results: currentState.results,
        ));
        timerBloc.add(ResetTimer());
        timerBloc.add(StartTimer());
        questionStartTime = DateTime.now();
      } else {
        emit(QuizComplete(currentState.results));
      }
    }
  }

  @override
  Future<void> close() {
    timerSubscription.cancel();
    return super.close();
  }
}