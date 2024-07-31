import '../../battle/models/answerOption.dart';
import '../../battle/models/correctAnswer.dart';

class QuestionsCategory {
  String? categoryId;
  List<Questions>? questions;

  QuestionsCategory({this.categoryId, this.questions});

  QuestionsCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? id;
  String? question;
  String? answer1;
  String? isCorrect1;
  String? answer2;
  String? isCorrect2;
  String? answer3;
  String? isCorrect3;
  String? points;
  String? image;
  String? isCorrectAnswer;
  String?  catId;
   String? marks;

  String? score;
   bool? attempted;
   String? submittedAnswerId;
   List<AnswerOption>? answerOptions;
   CorrectAnswer? correctAnswer;


  Questions(
      {this.id,
        this.question,
        this.answer1,
        this.isCorrect1,
        this.answer2,
        this.isCorrect2,
        this.answer3,
        this.isCorrect3,
        this.points,
        this.image,
      this.isCorrectAnswer,this.score,
      this.attempted,
        this.submittedAnswerId,
      this.answerOptions,
      this.correctAnswer,this.catId,this.marks});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    question = json['question'];
    answer1 = json['answer1'];
    isCorrect1 = json['isCorrect1'];
    answer2 = json['answer2'];
    isCorrect2 = json['isCorrect2'];
    answer3 = json['answer3'];
    isCorrect3 = json['isCorrect3'];
    points = json['points'];
    image = json['image'];
    isCorrectAnswer = json['isCorrectAnswer'];
    score = json['score'];
    attempted = json['attempted'];
    catId = json['catId'];
    submittedAnswerId= json['submittedAnswerId'];
    correctAnswer = json['correctAnswer'] != null ?  CorrectAnswer.fromJson(json['correctAnswer']) : null;
    if (json['answerOptions'] != null) {
      answerOptions = <AnswerOption>[];
      json['answerOptions'].forEach((v) {
        answerOptions!.add(new AnswerOption.fromJson(v));
      });
      marks = json['marks'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer1'] = this.answer1;
    data['isCorrect1'] = this.isCorrect1;
    data['answer2'] = this.answer2;
    data['isCorrect2'] = this.isCorrect2;
    data['answer3'] = this.answer3;
    data['isCorrect3'] = this.isCorrect3;
    data['points'] = this.points;
    data['image'] = this.image;
    data['isCorrectAnswer'] = this.isCorrectAnswer;
    data['score'] = this.score;
    data['attempted']= this.attempted;
    data['submittedAnswerId']= this.submittedAnswerId;
    data['catId']= this.catId;
    if (this.correctAnswer != null) {
      data['correctAnswer'] = this.correctAnswer!.toJson();
    }
    if (this.answerOptions != null) {
      data['answerOptions'] = this.answerOptions!.map((v) => v.toJson()).toList();
    }
    data['marks']= this.marks;

    return data;
  }
  Questions updateQuestionWithAnswer({required String submittedAnswerId}) {
    return Questions(
      question: question,
      answer1: answer1,
      answer2: answer2,
      isCorrect1: isCorrect1,
      isCorrect2: isCorrect2,
      attempted: submittedAnswerId.isNotEmpty,
      answer3: answer3,
      isCorrect3: isCorrect3,
      id: id,
      points: points,
      image: image,
      isCorrectAnswer: submittedAnswerId,
      score: score,
      catId: catId,
      marks: marks,
        answerOptions:answerOptions,
      correctAnswer: correctAnswer,
      submittedAnswerId: submittedAnswerId,



    );
  }
}