class SumbitRoomModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  SumbitRoomModel({this.ok, this.error, this.status, this.data});

  SumbitRoomModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    data['error'] = this.error;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Room>? room;
  String? msg;

  Data({this.room, this.msg});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['room'] != null) {
      room = <Room>[];
      json['room'].forEach((v) {
        room!.add(new Room.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.room != null) {
      data['room'] = this.room!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Room {
  String? id;
  String? date;
  String? type;
  String? code;
  String? listOfUsers;
  String? listOfCategories;
  String? listOfQuestions;
  String? winner;
  String? total;
  String? hidden;
  String? status;

  Room(
      {this.id,
        this.date,
        this.type,
        this.code,
        this.listOfUsers,
        this.listOfCategories,
        this.listOfQuestions,
        this.winner,
        this.total,
        this.hidden,
        this.status});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    type = json['type'];
    code = json['code'];
    listOfUsers = json['listOfUsers'];
    listOfCategories = json['listOfCategories'];
    listOfQuestions = json['listOfQuestions'];
    winner = json['winner'];
    total = json['total'];
    hidden = json['hidden'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['type'] = this.type;
    data['code'] = this.code;
    data['listOfUsers'] = this.listOfUsers;
    data['listOfCategories'] = this.listOfCategories;
    data['listOfQuestions'] = this.listOfQuestions;
    data['winner'] = this.winner;
    data['total'] = this.total;
    data['hidden'] = this.hidden;
    data['status'] = this.status;
    return data;
  }
}
