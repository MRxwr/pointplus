class AnswerOption {
  AnswerOption({this.id, this.title});

  final String? id;
  final String? title;
  AnswerOption.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'].toString();


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;


    return data;
  }
}
