class TopModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  TopModel({this.ok, this.error, this.status, this.data});

  TopModel.fromJson(Map<String, dynamic> json) {
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
  List<Month>? list;
  Top? top;

  Data({this.banners, this.list, this.top});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['list'] != null) {
      list = <Month>[];
      json['list'].forEach((v) {
        list!.add(new Month.fromJson(v));
      });
    }
    top = json['top'] != null ? Top.fromJson(json['top']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.top != null) {
      data['top'] = this.top!.toJson();
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

class Month {
  String? id;
  String? enTitle;
  String? arTitle;

  Month({this.id, this.enTitle, this.arTitle});

  Month.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enTitle = json['enTitle'];
    arTitle = json['arTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['enTitle'] = this.enTitle;
    data['arTitle'] = this.arTitle;
    return data;
  }
}

class Top {
  String? id;
  String? enTitle;
  String? arTitle;
  List<User>? list;

  Top({this.id, this.enTitle, this.arTitle, this.list});

  Top.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enTitle = json['enTitle'];
    arTitle = json['arTitle'];
    if (json['list'] != null) {
      list = <User>[];
      json['list'].forEach((v) {
        list!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['enTitle'] = this.enTitle;
    data['arTitle'] = this.arTitle;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? userId;
  String? username;
  String? totalPoints;

  User({this.userId, this.username, this.totalPoints});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    totalPoints = json['total_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['total_points'] = this.totalPoints;
    return data;
  }
}
