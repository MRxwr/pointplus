class LeaguesDetailsModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  LeaguesDetailsModel({this.ok, this.error, this.status, this.data});

  LeaguesDetailsModel.fromJson(Map<String, dynamic> json) {
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
  List<League>? league;
  List<Users>? users;

  Data({this.banners, this.league, this.users});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['league'] != null) {
      league = <League>[];
      json['league'].forEach((v) {
        league!.add(new League.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.league != null) {
      data['league'] = this.league!.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
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

class League {
  String? code;
  String? title;
  String? total;

  League({this.code, this.title, this.total});

  League.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['title'] = this.title;
    data['total'] = this.total;
    return data;
  }
}

class Users {
  String? name;
  String? username;
  String? points;
  String? rank;
  String? pRank;
  String? id;

  Users({this.name, this.username, this.points, this.rank, this.pRank,this.id});

  Users.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    points = json['points'];
    rank = json['rank'];
    pRank = json['pRank'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['points'] = this.points;
    data['rank'] = this.rank;
    data['pRank'] = this.pRank;
    data['id']= this.id;
    return data;
  }
}
