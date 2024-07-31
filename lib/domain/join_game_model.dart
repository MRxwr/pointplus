class JoinGameModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  JoinGameModel({this.ok, this.error, this.status, this.data});

  JoinGameModel.fromJson(Map<String, dynamic> json) {
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
  Room? room;

  Data({this.room});

  Data.fromJson(Map<String, dynamic> json) {
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }
}

class Room {
  String? id;
  String? code;
  List<ListOfUsers>? listOfUsers;
  String? type;
  String? winner;
  String? total;
  String? status;
  String? hidden;

  Room(
      {this.id,
        this.code,
        this.listOfUsers,
        this.type,
        this.winner,
        this.total,
        this.status,
        this.hidden});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    if (json['listOfUsers'] != null) {
      listOfUsers = <ListOfUsers>[];
      json['listOfUsers'].forEach((v) {
        listOfUsers!.add(new ListOfUsers.fromJson(v));
      });
    }
    type = json['type'];
    winner = json['winner'];
    total = json['total'];
    status = json['status'];
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    if (this.listOfUsers != null) {
      data['listOfUsers'] = this.listOfUsers!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['winner'] = this.winner;
    data['total'] = this.total;
    data['status'] = this.status;
    data['hidden'] = this.hidden;
    return data;
  }
}

class ListOfUsers {
  String? id;

  ListOfUsers({this.id});

  ListOfUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
