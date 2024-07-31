class CorrectAnswer {
  const CorrectAnswer({
     this.answer,
     this.answerId,
  });

  CorrectAnswer.fromJson(Map<String, dynamic> json)
      : answer = json['answer'].toString(),
        answerId = json['answerId'].toString();

  final String? answer;
  final String? answerId;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['answerId'] = this.answerId;


    return data;
  }
}
