class EditProfileModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  EditProfileModel({this.ok, this.error, this.status, this.data});

  EditProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? msg;
  List<User>? user;

  Data({this.msg, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? date;
  String? username;
  String? password;
  String? cookie;
  String? name;
  String? email;
  String? mobile;
  String? logo;
  String? header;
  String? type;
  String? userId;
  String? country;
  String? team;
  String? favoTeam;
  String? birthday;
  String? points;
  String? rank;
  String? pRank;
  String? coins;
  String? winner;
  String? x2;
  String? x3;
  String? firebase;
  String? status;

  User(
      {this.id,
        this.date,
        this.username,
        this.password,
        this.cookie,
        this.name,
        this.email,
        this.mobile,
        this.logo,
        this.header,
        this.type,
        this.userId,
        this.country,
        this.team,
        this.favoTeam,
        this.birthday,
        this.points,
        this.rank,
        this.pRank,
        this.coins,
        this.winner,
        this.x2,
        this.x3,
        this.firebase,
        this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    username = json['username'];
    password = json['password'];
    cookie = json['cookie'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    logo = json['logo'];
    header = json['header'];
    type = json['type'];
    userId = json['userId'];
    country = json['country'];
    team = json['team'];
    favoTeam = json['favoTeam'];
    birthday = json['birthday'];
    points = json['points'];
    rank = json['rank'];
    pRank = json['pRank'];
    coins = json['coins'];
    winner = json['winner'];
    x2 = json['x2'];
    x3 = json['x3'];
    firebase = json['firebase'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['username'] = this.username;
    data['password'] = this.password;
    data['cookie'] = this.cookie;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['logo'] = this.logo;
    data['header'] = this.header;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['country'] = this.country;
    data['team'] = this.team;
    data['favoTeam'] = this.favoTeam;
    data['birthday'] = this.birthday;
    data['points'] = this.points;
    data['rank'] = this.rank;
    data['pRank'] = this.pRank;
    data['coins'] = this.coins;
    data['winner'] = this.winner;
    data['x2'] = this.x2;
    data['x3'] = this.x3;
    data['firebase'] = this.firebase;
    data['status'] = this.status;
    return data;
  }
}
