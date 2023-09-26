class CoinModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  CoinModel({this.ok, this.error, this.status, this.data});

  CoinModel.fromJson(Map<String, dynamic> json) {
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
  String? points;
  int? pointsToBeRedeemed;
  String? coins;

  Data({this.points, this.pointsToBeRedeemed, this.coins});

  Data.fromJson(Map<String, dynamic> json) {
    points = json['points'];
    pointsToBeRedeemed = json['pointsToBeRedeemed'];
    coins = json['coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    data['pointsToBeRedeemed'] = this.pointsToBeRedeemed;
    data['coins'] = this.coins;
    return data;
  }
}
