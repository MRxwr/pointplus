import 'dart:async';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/app/di.dart';
import 'package:point/domain/models/models.dart';
import 'package:point/views/context_extensions.dart';

import '../../../app/battleRoomRepository.dart';
import '../../../app/error_message_keys.dart';
import '../../../domain/usecases/categories_usecase.dart';
import '../../../domain/usecases/questions_usecase.dart';
import '../../battle/models/answerOption.dart';
import '../../battle/models/correctAnswer.dart';
import '../models/battleRoom.dart';
import '../models/questionCategory.dart';
import '../models/userBattleRoomDetails.dart';


@immutable
class MultiUserBattleRoomState {}

class MultiUserBattleRoomInitial extends MultiUserBattleRoomState {}

class MultiUserBattleRoomInProgress extends MultiUserBattleRoomState {}

class MultiUserBattleRoomSuccess extends MultiUserBattleRoomState {
  MultiUserBattleRoomSuccess({
    required this.battleRoom,
    required this.isRoomExist,
    required this.questions,
    required this.categories


  });
   List<Questions> questions;
   List<CategoryDataModel> categories;
  final BattleRoom battleRoom;

  final bool isRoomExist;

}



class MultiUserBattleRoomFailure extends MultiUserBattleRoomState {
  MultiUserBattleRoomFailure(this.errorMessageCode);

  final String errorMessageCode;
}

class MultiUserBattleRoomCubit extends Cubit<MultiUserBattleRoomState> {
  MultiUserBattleRoomCubit(this._battleRoomRepository,this._questionUseCase,this._categoriesUseCase
      )
      : super(MultiUserBattleRoomInitial());
  final BattleRoomRepository _battleRoomRepository;
  final QuestionUseCase _questionUseCase;
  final CategoriesUseCase _categoriesUseCase;
  List<Questions> _questions =[];
  int index =0;
  List<CategoryDataModel> _categories=[];
   BattleRoom? _battleRoom ;

   bool _isRoomExist=false;
  StreamSubscription<DocumentSnapshot>? _battleRoomStreamSubscription;
  late StreamSubscription<void>? subscription;

  final _rnd = Random.secure();

  void updateState(
    MultiUserBattleRoomState newState, {
    bool cancelSubscription = false,
  }) {
    if (cancelSubscription) {
      _battleRoomStreamSubscription?.cancel();
    }
    emit(newState);
  }

  //subscribe battle room
  void subscribeToMultiUserBattleRoom(
    String battleRoomDocumentId,
      List<CategoryDataModel> categories

  ) {

    _battleRoomStreamSubscription = _battleRoomRepository
        .subscribeToBattleRoom(battleRoomDocumentId)
        .listen(
      (event) {
        print("event is exists");
        //to check if room destroyed by owner
        if (event.exists) {

          _battleRoom = BattleRoom.fromDocumentSnapshot(event);
          _isRoomExist =true;
          _categories = categories;
          _emitCurrentState();

        } else {
          _battleRoom = BattleRoom.fromDocumentSnapshot(event);
          _isRoomExist =false;
          _categories = categories;
          _emitCurrentState();

        }
      },
      onError: (e) {
        emit(MultiUserBattleRoomFailure(errorCodeDefaultMessage));
      },
      cancelOnError: true,
    );
  }
  Future<void> getQuizCategory() async {

    (await _categoriesUseCase.execute(CategoriesCaseInput())).
    fold((failure)  {



      emit(MultiUserBattleRoomFailure(failure.message));


    }, (data)  {
_categories = data.categoryResultModel.categoryList;










      //right --> success
      // inputState.add(ContentState());

      //navigate to main Screen

    });
  }
  void _emitCurrentState() {
    emit(MultiUserBattleRoomSuccess(questions: _questions, battleRoom: _battleRoom!, isRoomExist: _isRoomExist,categories: _categories));
  }
  void getQuestionsFromFireBase(){
    int questionsLength = _questions.length;
    int start =0;
    if(questionsLength == 0){
      start = 0;
    }else{
      start =questionsLength;
    }

    int questionsFromFireBaseLenght = (state as MultiUserBattleRoomSuccess).battleRoom.questions!.length;
    for(int i =start;i<questionsFromFireBaseLenght;i++){

        _questions.add(
            (state as MultiUserBattleRoomSuccess).battleRoom.questions![i]);

    }


    print("Questions From FireBase ---> ${_questions}");

    _emitCurrentState();

  }
  //to create room for multiuser
  Future<void> createRoom({
    required String roomCode,
    required  List<Questions> questions

  }) async {
    emit(MultiUserBattleRoomInProgress());
    try {

      final documentSnapshot =
          await _battleRoomRepository.createMultiUserBattleRoom(

        roomCode: roomCode,

      );
      (await _categoriesUseCase.execute(CategoriesCaseInput())).
      fold((failure)  {



        emit(MultiUserBattleRoomFailure(failure.message));


      }, (data)  {
        _categories = data.categoryResultModel.categoryList;

        subscribeToMultiUserBattleRoom(documentSnapshot.id,_categories);








        //right --> success
        // inputState.add(ContentState());

        //navigate to main Screen

      });


    } catch (e) {
      emit(MultiUserBattleRoomFailure(e.toString()));
    }
  }

  //to join multi user battle room
  Future<void> joinRoom({


    String? roomCode,
    required List<Questions> questions


  }) async {
    emit(MultiUserBattleRoomInProgress());
    try {
      final (:roomId) =
          await _battleRoomRepository.joinMultiUserBattleRoom(

        roomCode: roomCode,


      );  (await _categoriesUseCase.execute(CategoriesCaseInput())).
      fold((failure)  {



        emit(MultiUserBattleRoomFailure(failure.message));


      }, (data)  {
        _categories = data.categoryResultModel.categoryList;

        subscribeToMultiUserBattleRoom(roomId,_categories);








        //right --> success
        // inputState.add(ContentState());

        //navigate to main Screen

      });


    } catch (e) {
      emit(MultiUserBattleRoomFailure(e.toString()));
    }
  }
  Future<void> addQuestionsForGame({


    String? battleRoomDocumentId,QuestionResponseModel? questionResponseModel,String? categoryId,required List<Questions> questions
  }) async {
    emit(MultiUserBattleRoomInProgress());
    try {
      final (:roomId) =
      await _battleRoomRepository.insertQuestionsForCategory(

       battleRoomDocumentId,questionResponseModel,categoryId


      );

      subscribeToMultiUserBattleRoom(roomId,_categories);
    } catch (e) {
      emit(MultiUserBattleRoomFailure(e.toString()));
    }
  }


  //this will be call when user submit answer and marked questions attempted
  //if time expired for given question then default "-1" answer will be submitted
  // void updateQuestionAnswer(String questionId, String submittedAnswerId) {
  //   if (state is MultiUserBattleRoomSuccess) {
  //     final updatedQuestions = (state as MultiUserBattleRoomSuccess).questions;
  //     //fetching index of question that need to update with submittedAnswer
  //     final questionIndex =
  //         updatedQuestions.indexWhere((element) => element.id == questionId);
  //     //update question at given questionIndex with submittedAnswerId
  //     updatedQuestions[questionIndex] = updatedQuestions[questionIndex]
  //         .updateQuestionWithAnswer(submittedAnswerId: submittedAnswerId);
  //     emit(
  //       MultiUserBattleRoomSuccess(
  //         isRoomExist: (state as MultiUserBattleRoomSuccess).isRoomExist,
  //         battleRoom: (state as MultiUserBattleRoomSuccess).battleRoom,
  //         questions: updatedQuestions,
  //       ),
  //     );
  //   }
  // }

  //delete room after quiting the game or finishing the game
  void deleteMultiUserBattleRoom() {
    if (state is MultiUserBattleRoomSuccess) {
      _battleRoomRepository.deleteBattleRoom(
        (state as MultiUserBattleRoomSuccess).battleRoom.roomId,
        isGroupBattle: true,
        roomCode: (state as MultiUserBattleRoomSuccess).battleRoom.roomCode,
      );
    }
  }
  void clearUsers(String userId){
    if (state is MultiUserBattleRoomSuccess) {
      _battleRoomRepository.clearUsersBattleRoom(
        (state as MultiUserBattleRoomSuccess).battleRoom.roomId,userId
      );
    }
  }

  void deleteUserFromRoom(String userId) {
    if (state is MultiUserBattleRoomSuccess) {
      final battleRoom = (state as MultiUserBattleRoomSuccess).battleRoom;
      if (userId == battleRoom.user1!.uid) {
        _battleRoomRepository.deleteUserFromMultiUserRoom(1, battleRoom);
      } else if (userId == battleRoom.user2!.uid) {
        _battleRoomRepository.deleteUserFromMultiUserRoom(2, battleRoom);
      } else if (userId == battleRoom.user3!.uid) {
        _battleRoomRepository.deleteUserFromMultiUserRoom(3, battleRoom);
      } else if (userId == battleRoom.user4!.uid) {
        _battleRoomRepository.deleteUserFromMultiUserRoom(4, battleRoom);
      } else if (userId == battleRoom.user5!.uid) {
        _battleRoomRepository.deleteUserFromMultiUserRoom(5, battleRoom);
      }else if (userId == battleRoom.user6!.uid) {
        _battleRoomRepository.deleteUserFromMultiUserRoom(6, battleRoom);
      }
    }
  }
void letsGo(){

}

  Future<void> startGame(String battleRoom,String user,String categoryId,int noOfQuestions)async {







    await  _battleRoomRepository.insertNoOfQuestions(
          battleRoom,user,categoryId,noOfQuestions

      );
      //  _emitCurrentState();
      // subscribeToMultiUserBattleRoom(
      //     (state as MultiUserBattleRoomSuccess).battleRoom.roomId!
      // );

  }

  void selectCategory (){
    if(state is MultiUserBattleRoomSuccess){

  }

}

  // void submitAnswer(
  //   String currentUserId,
  //   String submittedAnswer, {
  //   required bool isCorrectAnswer,
  // }) {
  //   if (state is MultiUserBattleRoomSuccess) {
  //     final battleRoom = (state as MultiUserBattleRoomSuccess).battleRoom;
  //     final questions = (state as MultiUserBattleRoomSuccess).questions;
  //
  //     //need to check submitting answer for user1
  //     if (currentUserId == battleRoom.user1!.uid) {
  //       if (battleRoom.user1!.answers.length != questions.length) {
  //         _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
  //           battleRoomDocumentId: battleRoom.roomId,
  //           correctAnswers: isCorrectAnswer
  //               ? (battleRoom.user1!.correctAnswers + 1)
  //               : battleRoom.user1!.correctAnswers,
  //           userNumber: '1',
  //           submittedAnswer: List.from(battleRoom.user1!.answers)
  //             ..add(submittedAnswer),
  //         );
  //       }
  //     } else if (currentUserId == battleRoom.user2!.uid) {
  //       //submit answer for user2
  //       if (battleRoom.user2!.answers.length != questions.length) {
  //         _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
  //           submittedAnswer: List.from(battleRoom.user2!.answers)
  //             ..add(submittedAnswer),
  //           battleRoomDocumentId: battleRoom.roomId,
  //           correctAnswers: isCorrectAnswer
  //               ? (battleRoom.user2!.correctAnswers + 1)
  //               : battleRoom.user2!.correctAnswers,
  //           userNumber: '2',
  //         );
  //       }
  //     } else if (currentUserId == battleRoom.user3!.uid) {
  //       //submit answer for user3
  //       if (battleRoom.user3!.answers.length != questions.length) {
  //         _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
  //           submittedAnswer: List.from(battleRoom.user3!.answers)
  //             ..add(submittedAnswer),
  //           battleRoomDocumentId: battleRoom.roomId,
  //           correctAnswers: isCorrectAnswer
  //               ? (battleRoom.user3!.correctAnswers + 1)
  //               : battleRoom.user3!.correctAnswers,
  //           userNumber: '3',
  //         );
  //       }
  //     } else {
  //       //submit answer for user4
  //       if (battleRoom.user4!.answers.length != questions.length) {
  //         _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
  //           submittedAnswer: List.from(battleRoom.user4!.answers)
  //             ..add(submittedAnswer),
  //           battleRoomDocumentId: battleRoom.roomId,
  //           correctAnswers: isCorrectAnswer
  //               ? (battleRoom.user4!.correctAnswers + 1)
  //               : battleRoom.user4!.correctAnswers,
  //           userNumber: '4',
  //         );
  //       }
  //     }
  //   }
  // }

  //get questions in quiz battle
  // List<Question> getQuestions() {
  //   if (state is MultiUserBattleRoomSuccess) {
  //     return (state as MultiUserBattleRoomSuccess).questions;
  //   }
  //   return [];
  // }

  // String getRoomCode() {
  //   if (state is MultiUserBattleRoomSuccess) {
  //     return (state as MultiUserBattleRoomSuccess).battleRoom.roomCode!;
  //   }
  //   return '';
  // }

  String getRoomId() {
    if (state is MultiUserBattleRoomSuccess) {
      return (state as MultiUserBattleRoomSuccess).battleRoom.roomId!;
    }
    return '';
  }

  //get questions in quiz battle
  // int getEntryFee() {
  //   if (state is MultiUserBattleRoomSuccess) {
  //     return (state as MultiUserBattleRoomSuccess).battleRoom.entryFee!;
  //   }
  //   return 0;
  // }

  // String get categoryName => state is MultiUserBattleRoomSuccess
  //     ? (state as MultiUserBattleRoomSuccess).battleRoom.categoryName!
  //     : '';

  List<UserBattleRoomDetails?> getUsers() {

      final users = <UserBattleRoomDetails?>[];
      final battleRoom = (state as MultiUserBattleRoomSuccess).battleRoom;
      if (battleRoom.user1!.uid.isNotEmpty) {
        users.add(battleRoom.user1);
      }
      if (battleRoom.user2!.uid.isNotEmpty) {
        users.add(battleRoom.user2);
      }
      if (battleRoom.user3!.uid.isNotEmpty) {
        users.add(battleRoom.user3);
      }
      if (battleRoom.user4!.uid.isNotEmpty) {
        users.add(battleRoom.user4);
      }
      if (battleRoom.user5!.uid.isNotEmpty) {
        users.add(battleRoom.user5);
      }
      if (battleRoom.user6!.uid.isNotEmpty) {
        users.add(battleRoom.user6);
      }

      return users;


  }

  UserBattleRoomDetails? getUser(String userId) {
    final users = getUsers();
    return users[users.indexWhere((element) => element!.uid == userId)];
  }

  List<UserBattleRoomDetails?> getOpponentUsers(String userId) {
    return getUsers()..removeWhere((e) => e!.uid == userId);
  }

  // String generateRoomCode(int length) => String.fromCharCodes(
  //       Iterable.generate(
  //         length,
  //         (_) => roomCodeGenerateCharacters
  //             .codeUnitAt(_rnd.nextInt(roomCodeGenerateCharacters.length)),
  //       ),
  //     );

  //to close the stream subscription

  Future<void> getQuizCategoryQuestionWithUserIdAndCategoyrId(String userId,String categoryId,String noOfQuestion, String battleRoomDocumentId,) async {

    (await _questionUseCase.execute(QuestionCaseInput(userId,categoryId,noOfQuestion))).
    fold((failure)  {



      emit(MultiUserBattleRoomFailure(failure.message));


    }, (data)  {
      List<Questions> questions = [] ;




      // send questions data to firebase
      // for(int i=0;i<data!.questionResultModel.questionList.length;i++){
      //   Questions question = Questions();
      //
      //   question.answer1= data!.questionResultModel.questionList[i].answer1;
      //   question.answer2= data!.questionResultModel.questionList[i].answer2;
      //
      //   question.answer3= data!.questionResultModel.questionList[i].answer3;
      //   question.question= data!.questionResultModel.questionList[i].question;
      //   question.isCorrect1= data!.questionResultModel.questionList[i].isCorrect1;
      //   question.isCorrect2= data!.questionResultModel.questionList[i].isCorrect2;
      //   question.isCorrect3= data!.questionResultModel.questionList[i].isCorrect3;
      //   question.image= data!.questionResultModel.questionList[i].image;
      //  question.points= data!.questionResultModel.questionList[i].points;
      //   question.score= "";
      //   question.attempted= false;
      //
      //   question.id='${index+1}';
      //   List<AnswerOption> answers = [];
      //   AnswerOption answerOption1= AnswerOption(id: "1",title: data!.questionResultModel.questionList[i].answer1);
      //   answers.add(answerOption1);
      //   AnswerOption answerOption2= AnswerOption(id: "2",title: data!.questionResultModel.questionList[i].answer2);
      //   answers.add(answerOption2);
      //   if(data!.questionResultModel.questionList[i].answer3 != "") {
      //     AnswerOption answerOption3 = AnswerOption(id: "3",
      //         title: data!.questionResultModel.questionList[i].answer3);
      //     answers.add(answerOption3);
      //   }
      //   question.answerOptions=answers;
      //   CorrectAnswer? correctAnswer;
      //   if(data!.questionResultModel.questionList[i].isCorrect1 == "1"){
      //     correctAnswer = CorrectAnswer(answer:data!.questionResultModel.questionList[i].answer1.toString(),answerId: "1");
      //
      //   }else if(data!.questionResultModel.questionList[i].isCorrect2 == "1"){
      //     correctAnswer = CorrectAnswer(answer:data!.questionResultModel.questionList[i].answer2.toString(),answerId: "2");
      //
      //   }
      //   else if(data!.questionResultModel.questionList[i].isCorrect3 == "1"){
      //     correctAnswer = CorrectAnswer(answer:data!.questionResultModel.questionList[i].answer3.toString(),answerId: "3");
      //
      //   }
      //   question.correctAnswer = correctAnswer;
      //   question.submittedAnswerId = "";
      //
      //
      //
      //
      //
      //   questions.add(question);
      // }
      List<Questions> questionAdded = [];
      List<Questions> questionsFromFireBase =_battleRoom!.questions!;
      int remainingQuestions = 12-questionsFromFireBase.length;
      for(int i=0;i<questions.length;i++){
        if(remainingQuestions >0){
          questionAdded.add(questions[i]);
          remainingQuestions--;

        }



      }

      // _battleRoomRepository.subscribeToBattleRoomQuestions(battleRoomDocumentId,userId).whenComplete((){
      //   _emitCurrentState();
      // });
addQuestions( questionAdded);
      // submitQuestionloaded(userId);
      // _emitCurrentState();

      // submitQuestionloaded(userId,_questions.length);


      // emit(
      //   MultiUserBattleRoomSuccess(
      //     battleRoom: (state as MultiUserBattleRoomSuccess).battleRoom,
      //     isRoomExist: true,
      //     questions: questions,
      //   ),
      // );











      //right --> success
      // inputState.add(ContentState());

      //navigate to main Screen

    });

  }


  @override
  Future<void> close() async {
    await _battleRoomStreamSubscription?.cancel();
    return super.close();
  }

  void clearData(){
    _isRoomExist = false;
    _questions = [];

    _categories =[];

    _emitCurrentState();
  }

  //delete user from multiple user room
  Future<void> selectUserForSelectCategoryMultiUserBattleRoom(


      ) async {

    if (state is MultiUserBattleRoomSuccess) {
      _battleRoomRepository.selectUserCategory(
        (state as MultiUserBattleRoomSuccess).battleRoom.roomId
      );

    }



  }



  List<Questions> getQuestions() {
    if (state is MultiUserBattleRoomSuccess) {
      print((state as MultiUserBattleRoomSuccess).questions!);
      return(state as MultiUserBattleRoomSuccess).questions! ;
    }
    return [];
  }
  List<CategoryDataModel> getCategories() {
    if (state is MultiUserBattleRoomSuccess) {
      return (state as MultiUserBattleRoomSuccess).categories!;
    }
    return [];
  }

  String getRoomCode() {
    if (state is MultiUserBattleRoomSuccess) {
      return (state as MultiUserBattleRoomSuccess).battleRoom.roomCode!;
    }
    return '';
  }

  void updateQuestionAnswer(int questionIndex, String submittedAnswerId) {
    if (state is MultiUserBattleRoomSuccess) {

      final updatedQuestions = (state as MultiUserBattleRoomSuccess).questions;

      //fetching index of question that need to update with submittedAnswer

      //update question at given questionIndex with submittedAnswerId
      updatedQuestions[questionIndex] = updatedQuestions[questionIndex]
          .updateQuestionWithAnswer(submittedAnswerId: submittedAnswerId);
      print("questionUpdatedlength---> ${updatedQuestions.length}");
      _battleRoom = (state as MultiUserBattleRoomSuccess).battleRoom;
      _isRoomExist = true;
      _questions = updatedQuestions;
      // _emitCurrentState();
      // emit(
      //   MultiUserBattleRoomSuccess(
      //     battleRoom: (state as MultiUserBattleRoomSuccess).battleRoom,
      //     isRoomExist: true,
      //
      //
      //      questions: updatedQuestions,
      //   ),
      // );
    }
  }
  void addQuestions(

      List<Questions> listOfquestions
      ) {
    if (state is MultiUserBattleRoomSuccess) {




      final battleRoom =(state as MultiUserBattleRoomSuccess).battleRoom;
      List<Questions> questions =[];
      for(int i =0;i<_battleRoom!.questions!.length;i++){
        questions.add(_battleRoom!.questions![i]);

      }
      for(int i =0;i<listOfquestions!.length;i++){
        questions.add(listOfquestions![i]);

      }


          _battleRoomRepository.addQuestions(
       questions: questions,
            battleRoomDocumentId: battleRoom.roomId,
          );
        }

  }
 void submitAnswer(
      String currentUserId,
      String submittedAnswer,
  int currentTimeInMilliseconds,
     String point,
     {
        required bool isCorrectAnswer,
      }
      ) {
    if (state is MultiUserBattleRoomSuccess) {
      final battleRoom = (state as MultiUserBattleRoomSuccess).battleRoom;



      final questions = (state as MultiUserBattleRoomSuccess).questions;

      //need to check submitting answer for user1
      if (currentUserId == battleRoom.user1!.uid) {
        if (battleRoom.user1!.answers.length != questions!.length) {
          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            times: List.from(battleRoom.user1!.times)
              ..add(currentTimeInMilliseconds),
            points: List.from(battleRoom.user1!.points)
              ..add(point),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user1!.correctAnswers + 1)
                : battleRoom.user1!.correctAnswers,
            userNumber: '1',
            answersResult: List.from(battleRoom.user1!.answersResult)
              ..add(isCorrectAnswer),
            submittedAnswer: List.from(battleRoom.user1!.answers)
              ..add(submittedAnswer),
          );
        }
      } else if (currentUserId == battleRoom.user2!.uid) {
        //submit answer for user2
        if (battleRoom.user2!.answers.length != questions!.length) {
          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user2!.answers)
              ..add(submittedAnswer),
            times: List.from(battleRoom.user2!.times)
              ..add(currentTimeInMilliseconds),
            points: List.from(battleRoom.user2!.points)
              ..add(point),
            answersResult: List.from(battleRoom.user2!.answersResult)
              ..add(isCorrectAnswer),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user2!.correctAnswers + 1)
                : battleRoom.user2!.correctAnswers,
            userNumber: '2',
          );
        }
      } else if (currentUserId == battleRoom.user3!.uid) {
        //submit answer for user3
        if (battleRoom.user3!.answers.length != questions!.length) {
          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user3!.answers)
              ..add(submittedAnswer),
            times: List.from(battleRoom.user1!.times)
              ..add(currentTimeInMilliseconds),
            points: List.from(battleRoom.user3!.points)
              ..add(point),
            answersResult: List.from(battleRoom.user3!.answersResult)
              ..add(isCorrectAnswer),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user3!.correctAnswers + 1)
                : battleRoom.user3!.correctAnswers,
            userNumber: '3',
          );
        }
      } else  if (currentUserId == battleRoom.user4!.uid) {
        if (battleRoom.user4!.answers.length != questions!.length) {
          //submit answer for user4


          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user4!.answers)
              ..add(submittedAnswer),
            times: List.from(battleRoom.user1!.times)
              ..add(currentTimeInMilliseconds),
            points: List.from(battleRoom.user4!.points)
              ..add(point),
            battleRoomDocumentId: battleRoom.roomId,
            answersResult: List.from(battleRoom.user4!.answersResult)
              ..add(isCorrectAnswer),
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user4!.correctAnswers + 1)
                : battleRoom.user4!.correctAnswers,
            userNumber: '4',
          );
        }

      }
      else    if (currentUserId == battleRoom.user5!.uid) {
        if (battleRoom.user5!.answers.length != questions.length) {
          //submit answer for user4

          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user5!.answers)
              ..add(submittedAnswer),
            times: List.from(battleRoom.user1!.times)
              ..add(currentTimeInMilliseconds),
            points: List.from(battleRoom.user5!.points)
              ..add(point),
            answersResult: List.from(battleRoom.user5!.answersResult)
              ..add(isCorrectAnswer),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user5!.correctAnswers + 1)
                : battleRoom.user5!.correctAnswers,
            userNumber: '5',
          );
        }
      }else   if (currentUserId == battleRoom.user6!.uid) {
        if (battleRoom.user6!.answers.length != questions.length) {
          //submit answer for user4

          _battleRoomRepository.submitAnswerForMultiUserBattleRoom(
            submittedAnswer: List.from(battleRoom.user6!.answers)
              ..add(submittedAnswer),
            times: List.from(battleRoom.user6!.times)
              ..add(currentTimeInMilliseconds),
            answersResult: List.from(battleRoom.user6!.answersResult)
              ..add(isCorrectAnswer),
            points: List.from(battleRoom.user6!.points)
              ..add(point),
            battleRoomDocumentId: battleRoom.roomId,
            correctAnswers: isCorrectAnswer
                ? (battleRoom.user6!.correctAnswers + 1)
                : battleRoom.user6!.correctAnswers,
            userNumber: '6',
          );
        }
      }
    }
  }


  Future<void> submitQuestionloaded(
      String userId)async {
    if (state is MultiUserBattleRoomSuccess) {
      final battleRoom = (state as MultiUserBattleRoomSuccess).battleRoom;



      final questions = (state as MultiUserBattleRoomSuccess).questions;

      //need to check submitting answer for user1
      if (userId == battleRoom.user1!.uid) {
        if (battleRoom.user1!.answers.length != questions!.length) {
          _battleRoomRepository.submitQuestionLoadedeRoom(
            battleRoomDocumentId: battleRoom.roomId,
              questionNo: questions.length,
            noOfRemainingQuestions:battleRoom.user1!.totalQuestionsPerUser-questions.length ,


            userNumber: '1',
            );
        }
      } else if (userId == battleRoom.user2!.uid) {
        //submit answer for user2
        if (battleRoom.user2!.answers.length != questions!.length) {
          _battleRoomRepository.submitQuestionLoadedeRoom(
            battleRoomDocumentId: battleRoom.roomId,
            noOfRemainingQuestions:battleRoom.user2!.totalQuestionsPerUser-questions.length ,
            questionNo: questions.length,


            userNumber: '2',
          );
        }
      } else if (userId == battleRoom.user3!.uid) {
        //submit answer for user3
        if (battleRoom.user3!.answers.length != questions!.length) {
          _battleRoomRepository.submitQuestionLoadedeRoom(
            battleRoomDocumentId: battleRoom.roomId,
            questionNo: questions.length,
            noOfRemainingQuestions:battleRoom.user3!.totalQuestionsPerUser-questions.length ,


            userNumber: '3',
          );
        }
      } else  if (userId == battleRoom.user4!.uid) {
        //submit answer for user4


        _battleRoomRepository.submitQuestionLoadedeRoom(
          battleRoomDocumentId: battleRoom.roomId,
          questionNo: questions.length,

          noOfRemainingQuestions:battleRoom.user4!.totalQuestionsPerUser-questions.length ,

          userNumber: '4',
        );

      }
      else  if (userId == battleRoom.user5!.uid) {
        //submit answer for user4

        _battleRoomRepository.submitQuestionLoadedeRoom(
          battleRoomDocumentId: battleRoom.roomId,
          questionNo: questions.length,
          noOfRemainingQuestions:battleRoom.user5!.totalQuestionsPerUser-questions.length ,


          userNumber: '5',
        );

      }else  if (userId == battleRoom.user6!.uid) {
        //submit answer for user4

        _battleRoomRepository.submitQuestionLoadedeRoom(
          battleRoomDocumentId: battleRoom.roomId,
          questionNo:questions.length,
          noOfRemainingQuestions:battleRoom.user6!.totalQuestionsPerUser-questions.length ,



          userNumber: '6',
        );

      }
    }
  }

  void reset() {

    // ignore: invalid_use_of_visible_for_testing_member
    emit(MultiUserBattleRoomInitial());
  }



}
