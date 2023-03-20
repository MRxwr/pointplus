class LeaguesModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  LeaguesModel({this.ok, this.error, this.status, this.data});

  LeaguesModel.fromJson(Map<String, dynamic> json) {
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
  List<Leagues>? leagues;
  List<Create>? create;
  List<User>? user;

  Data({this.banners, this.leagues, this.create, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['leagues'] != null) {
      if(json['leagues'].toString().contains('msg')){
        leagues = <Leagues>[];
      }else {
        leagues = <Leagues>[];
        json['leagues'].forEach((v) {
          leagues!.add(new Leagues.fromJson(v));
        });
      }
    }
    if (json['create'] != null) {
      if(json['create'].toString().contains('msg')){
        create = <Create>[];
      }else {
        create = <Create>[];
        json['create'].forEach((v) {
          create!.add(new Create.fromJson(v));
        });
      }
    }
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.leagues != null) {
      data['leagues'] = this.leagues!.map((v) => v.toJson()).toList();
    }
    if (this.create != null) {
      data['create'] = this.create!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
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

class Leagues {
  String? id;
  String? rank;
  String? points;
  String? title;
  String? subLeagRank;
  String? subLeagPRank;

  Leagues(
      {this.id,
        this.rank,
        this.points,
        this.title,
        this.subLeagRank,
        this.subLeagPRank});

  Leagues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rank = json['rank'];
    points = json['points'];
    title = json['title'];
    subLeagRank = json['subLeagRank'];
    subLeagPRank = json['subLeagPRank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rank'] = this.rank;
    data['points'] = this.points;
    data['title'] = this.title;
    data['subLeagRank'] = this.subLeagRank;
    data['subLeagPRank'] = this.subLeagPRank;
    return data;
  }
}

class Create {
  String? id;
  String? code;
  String? title;
  String? userId;

  Create({this.id, this.code, this.title, this.userId});

  Create.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['title'] = this.title;
    data['userId'] = this.userId;
    return data;
  }
}

class User {
  String? id;
  String? rank;
  String? points;

  User({this.id, this.rank, this.points});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rank = json['rank'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rank'] = this.rank;
    data['points'] = this.points;
    return data;
  }
}
