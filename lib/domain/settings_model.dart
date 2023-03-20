class SettingsModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  SettingsModel({this.ok, this.error, this.status, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
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
  String? version;
  String? enTerms;
  String? arTerms;
  String? enPolicy;
  String? arPolicy;
  String? enAbout;
  String? arAbout;
  String? insta;
  String? whatsapp;
  String? twitter;

  Data(
      {this.banners,
        this.version,
        this.enTerms,
        this.arTerms,
        this.enPolicy,
        this.arPolicy,
        this.enAbout,
        this.arAbout,
        this.insta,
        this.whatsapp,
        this.twitter});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    version = json['version'];
    enTerms = json['enTerms'];
    arTerms = json['arTerms'];
    enPolicy = json['enPolicy'];
    arPolicy = json['arPolicy'];
    enAbout = json['enAbout'];
    arAbout = json['arAbout'];
    insta = json['insta'];
    whatsapp = json['whatsapp'];
    twitter = json['twitter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    data['version'] = this.version;
    data['enTerms'] = this.enTerms;
    data['arTerms'] = this.arTerms;
    data['enPolicy'] = this.enPolicy;
    data['arPolicy'] = this.arPolicy;
    data['enAbout'] = this.enAbout;
    data['arAbout'] = this.arAbout;
    data['insta'] = this.insta;
    data['whatsapp'] = this.whatsapp;
    data['twitter'] = this.twitter;
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
