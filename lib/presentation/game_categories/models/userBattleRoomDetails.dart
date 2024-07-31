import 'package:point/presentation/game_categories/models/questionCategory.dart';

class UserBattleRoomDetails {
  const UserBattleRoomDetails({
    required this.categoryId,
    required this.categoryName,
    required this.isSelecetedCategory,
    required this.name,
    required this.profileUrl,
    required this.uid,
    required this.questionCategoryList,
    required this.totalQuestionsPerUser,
    required this.answers,
    required this.times,
    required this.points,

    required this.correctAnswers,
    required this.questionLoaded,
    required this.totalCurrentQuestions,
    required this.answersResult

  });

  UserBattleRoomDetails.fromJson(Map<String, dynamic> json)
      : categoryId = json['categoryId']as String? ?? "",
        totalQuestionsPerUser = json['totalQuestionsPerUser']as int? ?? 0,
        categoryName = json['categoryName'] as String? ?? "",
        isSelecetedCategory = json['isSelectCategory'] as bool? ?? false,
        name = json['name'] as String? ?? '',
        profileUrl = json['profileUrl'] as String? ?? '',
        uid = json['uid'] as String? ?? '',
  questionCategoryList =(json['questionCategory'] as List? ?? []).cast<QuestionsCategory>(),
        answers = (json['answers'] as List? ?? []).cast<String>(),
        points = (json['points'] as List? ?? []).cast<String>(),
        times = (json['times'] as List? ?? []).cast<int>(),
        answersResult = (json['answersResult'] as List? ?? []).cast<bool>(),
        correctAnswers = json['correctAnswers'] as int? ?? 0,
        totalCurrentQuestions = json['totalCurrentQuestions'] as int? ??0,
  questionLoaded = json['questionLoaded'] as bool? ?? false;


final int totalCurrentQuestions;
  final int correctAnswers;
final int totalQuestionsPerUser;
  final String name;
  final List<String> answers;
  final List<String> points;
  final List<bool> answersResult;
  final List<int> times;
  final String profileUrl;
  final String uid;
  final String categoryId;
  final String categoryName;
  final bool isSelecetedCategory ;
  final List<QuestionsCategory> questionCategoryList;
  final bool questionLoaded;
}



