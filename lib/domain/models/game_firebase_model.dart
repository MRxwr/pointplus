

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:point/domain/models/quiz_question_model.dart';

class GameFireBaseModel {
final  String roomId;
final String createdBy;
final String currentCategoryId;
final bool readyToPlay;
final  int totalQuestions;
final List<UserModel> users;
final String currentUserId;
final String id;

GameFireBaseModel({required this.roomId,required this.createdBy,required this.currentCategoryId,required this.readyToPlay,required this.totalQuestions,required this.currentUserId,required this.users,required this.id});

factory GameFireBaseModel.fromMap(Map<String, dynamic> map) {
  var usersJson = map['users'] as List;
  return GameFireBaseModel(

    roomId: map['roomId'],
    createdBy: map['createdBy'],
    currentCategoryId: map['currentCategoryId'],
    readyToPlay: map['readyToPlay'],
    totalQuestions: map['totalQuestions'],
    currentUserId: map['currentUserId'],
    users: usersJson.map((userJson) => UserModel.fromMap(userJson)).toList(),
    id: map["room"]



  );
}
Map<String, dynamic> toMap() {
  return {
    'roomId': roomId,
    'createdBy': createdBy,
    'currentCategoryId': currentCategoryId,
    'readyToPlay': readyToPlay,
    'totalQuestions': totalQuestions,
    'currentUserId':currentUserId,
    'users': users.map((user) => user.toMap()).toList(),
 'room':id

  };
}

}
class UserModel{
   List<QuestionModel> questions;
   List<String> correctAnswers;
   List<Result> answers;
   List<int> times;
   int questionsPerUser;

   int totalCurrentQuestions;
   bool isSelectCategroy;
   String userName;
    String userImage;
    String userId;
   bool isCreator;
   bool isQuestionsLoaded;
  UserModel({required this.questions,required this.correctAnswers,required this.answers,required this.times,required this.questionsPerUser,required this.totalCurrentQuestions,
    required this.isSelectCategroy,required this.userName,required this.userImage,required this.userId,required this.isCreator,required this.isQuestionsLoaded});
  factory UserModel.fromMap(Map<String, dynamic> map) {
    var usersJson = map['questions'] as List;
    var resultJson = map['answers'] as List;
    return UserModel(
      questions:usersJson.map((userJson) => QuestionModel.fromMap(userJson)).toList(),
      correctAnswers: List<String>.from(map['correctAnswers']),

      answers: resultJson.map((resultJson) => Result.fromMap(resultJson)).toList(),
      times:  List<int>.from(map['times']),
      questionsPerUser: map['questionsPerUser'],
      totalCurrentQuestions: map['totalCurrentQuestions'],
      isSelectCategroy: map['isSelectCategroy'],
      userName: map['userName'],
      userImage: map['userImage'],
      userId: map['userId'],
      isCreator: map['isCreator'],
        isQuestionsLoaded:map['isQuestionsLoaded']


    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questions': questions.map((question) => question.toMap()).toList(),
      'correctAnswers': correctAnswers,
      'answers': answers.map((answers) => answers.toMap()).toList(),
      'times': times,
      'questionsPerUser': questionsPerUser,
      'totalCurrentQuestions': totalCurrentQuestions,
      'isSelectCategroy': isSelectCategroy,
      'userName': userName,
      'userImage': userImage,
      'userId': userId,
      'isCreator':isCreator,
      'isQuestionsLoaded':isQuestionsLoaded
    };
  }


}
class QuestionModel{
  String questionId;
 final String questionText;
 final List<String> answers;
 final int correctAnswerIndex;
 final bool isCorrectAnswer;
 final int timeInSeconds;
 final int points;
 final String image;
 final bool isAnswerQuestion;
 QuestionModel({required this.questionId,required this.questionText,required this.answers,required this.correctAnswerIndex,required this.isCorrectAnswer,required this.timeInSeconds,required this.points,required this.image,required this.isAnswerQuestion});
 factory QuestionModel.fromMap(Map<String, dynamic> map) {

   return QuestionModel(

       questionId: map['questionId'],
       questionText: map['questionText'],
     answers:List<String>.from(map['answers']),
     correctAnswerIndex: map['correctAnswerIndex'],
     isCorrectAnswer:map['isCorrectAnswer'],
       timeInSeconds: map['timeInSeconds'],
       points:map['points'],

     image:map['image'],
     isAnswerQuestion:map['isAnswerQuestion'],

   );
 }
 Map<String, dynamic> toMap() {
   return {
     'questionId': questionId,
     'questionText': questionText,
     'answers': answers,
     'correctAnswerIndex':correctAnswerIndex,
     'isCorrectAnswer':isCorrectAnswer,
     'timeInSeconds':timeInSeconds,
     'points':points,
     'image':image,
     'isAnswerQuestion':isAnswerQuestion
   };
 }


}
class Result {
  final String questionId;
  final bool isCorrect;
  final int timeTaken;
  final String userId;
  final String roomId;
  final String currentCategory;
  final String userSelectCategoryId;
  final String points;

  Result({required this.questionId, required this.isCorrect, required this.timeTaken,required this.userId,required this.roomId,required this.currentCategory,required this.userSelectCategoryId,required this.points});
  factory Result.fromMap(Map<String, dynamic> map) {

    return Result(

      questionId: map['questionId'],
      isCorrect: map['isCorrect'],
      timeTaken:map['timeTaken'],
      userId:map['userId'],
      roomId:map['roomId'],
        currentCategory:map['currentCategory'],
      userSelectCategoryId: map['userSelectCategoryId'],
      points: map['points']


    );
  }
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'isCorrect': isCorrect,
      'timeTaken': timeTaken,
      'userId':userId,
      'roomId':roomId,
      'currentCategory':currentCategory,
      'userSelectCategoryId':userSelectCategoryId,
      'points':points

    };
  }

}
class UserResult{
 final String userId;
 final String  userName;
 final String userImage;
 final String points;
 UserResult({required this.userId,required this.userName,required this.userImage,required this.points});
}
