class QuizQuestionModel {
  final String id;
  final String questionText;
  final String image;
  final List<Answer> answers;


  QuizQuestionModel({required this.id, required this.questionText, required this.image,required this.answers});
}

class Answer {
  final String id;
  final String text;
  final bool isCorrect;

  Answer({required this.id, required this.text, required this.isCorrect});
}

class QuestionResult {
  final String questionId;
  final bool isCorrect;
  final Duration timeTaken;

  QuestionResult({required this.questionId, required this.isCorrect, required this.timeTaken});
  factory QuestionResult.fromMap(Map<String, dynamic> map) {

    return QuestionResult(

      questionId: map['questionId'],
      isCorrect: map['isCorrect'],
      timeTaken:map['timeTaken'],


    );
  }
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'isCorrect': isCorrect,
      'timeTaken': timeTaken,

    };
  }
}

