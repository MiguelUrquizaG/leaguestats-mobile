class BetResponseDto {
  int? id;
  String? date;
  String? time;
  int? leagueId;
  int? team1Id;
  int? team2Id;
  double? team1Value;
  double? team2Value;
  String? instance;
  int? winnerTeamId;
  String? status;
  String? createdAt;
  String? updatedAt;
  League? league;
  Team1? team1;
  Team1? team2;
  Team1? winnerTeam;

  BetResponseDto({
    this.id,
    this.date,
    this.time,
    this.leagueId,
    this.team1Id,
    this.team2Id,
    this.team1Value,
    this.team2Value,
    this.instance,
    this.winnerTeamId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.league,
    this.team1,
    this.team2,
    this.winnerTeam,
  });

  BetResponseDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    leagueId = json['league_id'];
    team1Id = json['team1_id'];
    team2Id = json['team2_id'];
    team1Value = json['team1_value'];
    team2Value = json['team2_value'];
    instance = json['instance'];
    winnerTeamId = json['winner_team_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    league = json['league'] != null
        ? new League.fromJson(json['league'])
        : null;
    team1 = json['team1'] != null ? new Team1.fromJson(json['team1']) : null;
    team2 = json['team2'] != null ? new Team1.fromJson(json['team2']) : null;
    winnerTeam = json['winner_team'] != null
        ? new Team1.fromJson(json['winner_team'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['league_id'] = this.leagueId;
    data['team1_id'] = this.team1Id;
    data['team2_id'] = this.team2Id;
    data['team1_value'] = this.team1Value;
    data['team2_value'] = this.team2Value;
    data['instance'] = this.instance;
    data['winner_team_id'] = this.winnerTeamId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.team1 != null) {
      data['team1'] = this.team1!.toJson();
    }
    if (this.team2 != null) {
      data['team2'] = this.team2!.toJson();
    }
    if (this.winnerTeam != null) {
      data['winner_team'] = this.winnerTeam!.toJson();
    }
    return data;
  }

  static List<BetResponseDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => BetResponseDto.fromJson(item)).toList();
  }
}

class League {
  int? id;
  String? name;
  String? logo;
  int? countryId;
  String? createdAt;
  String? updatedAt;

  League({
    this.id,
    this.name,
    this.logo,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Team1 {
  int? id;
  String? name;
  String? logo;
  int? countryId;
  int? lostMatches;
  int? wonMatches;
  int? leagueId;
  String? teamWallpaper;
  String? createdAt;
  String? updatedAt;

  Team1({
    this.id,
    this.name,
    this.logo,
    this.countryId,
    this.lostMatches,
    this.wonMatches,
    this.leagueId,
    this.teamWallpaper,
    this.createdAt,
    this.updatedAt,
  });

  Team1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    countryId = json['country_id'];
    lostMatches = json['lost_matches'];
    wonMatches = json['won_matches'];
    leagueId = json['league_id'];
    teamWallpaper = json['team_wallpaper'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['country_id'] = this.countryId;
    data['lost_matches'] = this.lostMatches;
    data['won_matches'] = this.wonMatches;
    data['league_id'] = this.leagueId;
    data['team_wallpaper'] = this.teamWallpaper;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
