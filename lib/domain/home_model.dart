class HomeModel {
  bool? ok;
  String? error;
  String? status;
  Data? data;

  HomeModel({this.ok, this.error, this.status, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
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
  User? user;
  List<Leaderboard>? leaderboard;
  List<Winners>? winners;
  List<Rounds>? rounds;
  List<Matches>? matches;

  Data(
      {this.banners,
        this.user,
        this.leaderboard,
        this.winners,
        this.rounds,
        this.matches});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['leaderboard'] != null) {
      leaderboard = <Leaderboard>[];
      json['leaderboard'].forEach((v) {
        leaderboard!.add(new Leaderboard.fromJson(v));
      });
    }
    if (json['winners'] != null) {
      winners = <Winners>[];
      json['winners'].forEach((v) {
        winners!.add(new Winners.fromJson(v));
      });
    }
    if (json['rounds'] != null) {
      rounds = <Rounds>[];
      json['rounds'].forEach((v) {
        rounds!.add(new Rounds.fromJson(v));
      });
    }
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        matches!.add(new Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.leaderboard != null) {
      data['leaderboard'] = this.leaderboard!.map((v) => v.toJson()).toList();
    }
    if (this.winners != null) {
      data['winners'] = this.winners!.map((v) => v.toJson()).toList();
    }
    if (this.rounds != null) {
      data['rounds'] = this.rounds!.map((v) => v.toJson()).toList();
    }
    if (this.matches != null) {
      data['matches'] = this.matches!.map((v) => v.toJson()).toList();
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

class User {
  String? notifications;
  String? points;
  String? rank;
  String? pRank;
  List<Stats>? stats;

  User({this.notifications, this.points, this.rank, this.pRank, this.stats});

  User.fromJson(Map<String, dynamic> json) {
    notifications = json['notifications'];
    points = json['points'];
    rank = json['rank'];
    pRank = json['pRank'];
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((v) {
        stats!.add(new Stats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notifications'] = this.notifications;
    data['points'] = this.points;
    data['rank'] = this.rank;
    data['pRank'] = this.pRank;
    if (this.stats != null) {
      data['stats'] = this.stats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stats {
  String? round;
  String? totalPoints;

  Stats({this.round, this.totalPoints});

  Stats.fromJson(Map<String, dynamic> json) {
    round = json['round'];
    totalPoints = json['totalPoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['round'] = this.round;
    data['totalPoints'] = this.totalPoints;
    return data;
  }
}

class Leaderboard {
  String? username;
  String? name;
  String? points;
  String? id;


  Leaderboard({this.username, this.name, this.points,this.id});

  Leaderboard.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    points = json['points'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['name'] = this.name;
    data['points'] = this.points;
    data['id']= this.id;
    return data;
  }
}

class Winners {
  String? username;
  String? name;
  String? team;
  String? winner;

  Winners({this.username, this.name, this.team, this.winner});

  Winners.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    team = json['team'];
    winner = json['winner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['name'] = this.name;
    data['team'] = this.team;
    data['winner'] = this.winner;
    return data;
  }
}

class Rounds {
  String? round;

  Rounds({this.round});

  Rounds.fromJson(Map<String, dynamic> json) {
    round = json['round'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['round'] = this.round;
    return data;
  }
}

class Matches {
  String? id;
  String? status;
  String? isActive;
  String? stadium;
  String? matchDate;

  String? matchTime;

  List<Team1>? team1;
  List<Team1>? team2;
  Result? result;
  Predictions? predictions;

  Matches(
      {this.id,
        this.status,
        this.team1,
        this.team2,
        this.result,
        this.predictions,this.isActive,this.matchDate,this.matchTime,this.stadium});

  Matches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    isActive = json['isActive'];
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];

    stadium = json['staduim'];
    if (json['team1'] != null) {
      team1 = <Team1>[];
      json['team1'].forEach((v) {
        team1!.add(new Team1.fromJson(v));
      });
    }
    if (json['team2'] != null) {
      team2 = <Team1>[];
      json['team2'].forEach((v) {
        team2!.add(new Team1.fromJson(v));
      });
    }
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    predictions = json['predictions'] != null
        ? new Predictions.fromJson(json['predictions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['isActive'] = this.isActive;
    data['matchDate'] = this.matchDate;
    data['matchTime'] = this.matchTime;
    data['stadium'] = this.stadium;
    if (this.team1 != null) {
      data['team1'] = this.team1!.map((v) => v.toJson()).toList();
    }
    if (this.team2 != null) {
      data['team2'] = this.team2!.map((v) => v.toJson()).toList();
    }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    if (this.predictions != null) {
      data['predictions'] = this.predictions!.toJson();
    }
    return data;
  }
}

class Team1 {
  String? arTitle;
  String? enTitle;
  String? logo;

  Team1({this.arTitle, this.enTitle, this.logo});

  Team1.fromJson(Map<String, dynamic> json) {
    arTitle = json['arTitle'];
    enTitle = json['enTitle'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['arTitle'] = this.arTitle;
    data['enTitle'] = this.enTitle;
    data['logo'] = this.logo;
    return data;
  }
}

class Result {
  String? goals1;
  String? goals2;

  Result({this.goals1, this.goals2});

  Result.fromJson(Map<String, dynamic> json) {
    goals1 = json['goals1'];
    goals2 = json['goals2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goals1'] = this.goals1;
    data['goals2'] = this.goals2;
    return data;
  }
}

class Predictions {
  String? goals1;
  String? goals2;
  String? points;

  Predictions({this.goals1, this.goals2, this.points});

  Predictions.fromJson(Map<String, dynamic> json) {
    goals1 = json['goals1'];
    goals2 = json['goals2'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goals1'] = this.goals1;
    data['goals2'] = this.goals2;
    data['points'] = this.points;
    return data;
  }
}
