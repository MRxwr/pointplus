class UserGameModel {


  String id;


  UserGameModel(this.id);

}
class RoomDataModel {

  String id;

  String code;

  List<UserGameModel> users;

  String? type;

  String? winner;

  String? total;

  String? status;

  String? hidden;
  RoomDataModel(this.id,this.code,this.users,this.type,this.winner,this.total,this.status,this.hidden);
}
class RoomResultModel{
  RoomDataModel roomData;
  RoomResultModel(this.roomData);
}

class RoomModel{
  RoomResultModel roomResultModel;

  RoomModel(this.roomResultModel);

}
class CategoryDataModel{
  String id;
  String arTitle;
  String enTitle;
  CategoryDataModel(this.id,this.arTitle,this.enTitle);

}
class CategoryResultModel{
  List<CategoryDataModel> categoryList;
  CategoryResultModel(this.categoryList);
}
class CategoryResponseModel{
  CategoryResultModel categoryResultModel;
  CategoryResponseModel(this.categoryResultModel);
}
class QuestionDataModel{
  String id;
  String question;
  String answer1;
  String answer2;
  String answer3;
  String isCorrect1;
  String isCorrect2;
  String isCorrect3;
  String points;
  String image;

  QuestionDataModel(this.id,this.question,this.answer1,this.answer2,this.answer3,this.isCorrect1,this.isCorrect2,
      this.isCorrect3,this.points,this.image);

}
class QuestionResultModel{
  List<QuestionDataModel> questionList;
  QuestionResultModel(this.questionList);
}
class QuestionResponseModel{
  QuestionResultModel questionResultModel;
  QuestionResponseModel(this.questionResultModel);
}

