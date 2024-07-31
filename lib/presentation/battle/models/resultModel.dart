class ResultModel{
  List<AnswerModel> answerListModel;
  String userId;
  ResultModel(this.answerListModel,this.userId);
}

class AnswerModel{
  String answerId;
  String degree;
  AnswerModel(this.answerId,this.degree);
}