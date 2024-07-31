class RoomRequest{
  String create;
  String join;
  String userId;
      String roomId;
      String roomCode;
      String exit;
      RoomRequest(this.create,this.join,this.userId,this.roomId,this.roomCode,this.exit);
}

class QuestionRequest{
  String userId;
  String quizCategory;
  String noOfQuestions;

  QuestionRequest(this.userId,this.quizCategory,this.noOfQuestions);
}