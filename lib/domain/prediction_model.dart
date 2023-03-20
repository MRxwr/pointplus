class PredictionModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  PredictionModel({this.ok, this.error, this.status, this.data});

  PredictionModel.fromJson(Map<String, dynamic> json) {
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
  List<Banners>? banners;
  String? countdown;
  String? starttime;
  List<Teams>? teams;
  User? user;

  Data({this.banners, this.countdown, this.teams, this.user,this.starttime});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    countdown = json['countdown'];
    starttime = json['startTime'];
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams!.add(new Teams.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    data['countdown'] = this.countdown;
    data['startTime'] = this.starttime;
    if (this.teams != null) {
      data['teams'] = this.teams!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Banners {
  String? id;
  String? enTitle;
  String? arTitle;
  String? image;
  String? url;
  String? type;

  Banners(
      {this.id, this.enTitle, this.arTitle, this.image, this.url, this.type});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enTitle = json['enTitle'];
    arTitle = json['arTitle'];
    image = json['image'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['enTitle'] = this.enTitle;
    data['arTitle'] = this.arTitle;
    data['image'] = this.image;
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}

class Teams {
  String? matchId;
  String? type;
  String? enTitleTeam1;
  String? arTitleTeam1;
  String? logoTeam1;
  String? enTitleTeam2;
  String? arTitleTeam2;
  String? logoTeam2;
  String? goals1;
  String? goals2;

  Teams(
      {this.matchId,
        this.type,
        this.enTitleTeam1,
        this.arTitleTeam1,
        this.logoTeam1,
        this.enTitleTeam2,
        this.arTitleTeam2,
        this.logoTeam2,
        this.goals1,
        this.goals2});

  Teams.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'];
    type = json['type'];
    enTitleTeam1 = json['enTitleTeam1'];
    arTitleTeam1 = json['arTitleTeam1'];
    logoTeam1 = json['logoTeam1'];
    enTitleTeam2 = json['enTitleTeam2'];
    arTitleTeam2 = json['arTitleTeam2'];
    logoTeam2 = json['logoTeam2'];
    goals1 = json['goals1'];
    goals2 = json['goals2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchId'] = this.matchId;
    data['type'] = this.type;
    data['enTitleTeam1'] = this.enTitleTeam1;
    data['arTitleTeam1'] = this.arTitleTeam1;
    data['logoTeam1'] = this.logoTeam1;
    data['enTitleTeam2'] = this.enTitleTeam2;
    data['arTitleTeam2'] = this.arTitleTeam2;
    data['logoTeam2'] = this.logoTeam2;
    data['goals1'] = this.goals1;
    data['goals2'] = this.goals2;
    return data;
  }
}

class User {
  String? x2;
  String? x3;

  User({this.x2, this.x3});

  User.fromJson(Map<String, dynamic> json) {
    x2 = json['x2'];
    x3 = json['x3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x2'] = this.x2;
    data['x3'] = this.x3;
    return data;
  }
}
