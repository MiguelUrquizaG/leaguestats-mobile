class GameResponseDto {
  int? id;
  int? homeTeamId;
  int? awayTeamId;
  int? maxGames;
  int? homeTeamScore;
  int? awayTeamScore;
  int? isActive;
  int? leagueId;
  int? mvpId;
  String? date;
  String? createdAt;
  String? updatedAt;
  HomeTeam? homeTeam;
  HomeTeam? awayTeam;
  List<MatchUps>? matchUps;

  GameResponseDto({
    this.id,
    this.homeTeamId,
    this.awayTeamId,
    this.maxGames,
    this.homeTeamScore,
    this.awayTeamScore,
    this.isActive,
    this.leagueId,
    this.mvpId,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.homeTeam,
    this.awayTeam,
    this.matchUps,
  });

  GameResponseDto.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    homeTeamId = _toInt(json['home_team_id']);
    awayTeamId = _toInt(json['away_team_id']);
    maxGames = _toInt(json['max_games']);
    homeTeamScore = _toInt(json['home_team_score']);
    awayTeamScore = _toInt(json['away_team_score']);
    isActive = _toInt(json['is_active']);
    leagueId = _toInt(json['league_id']);
    mvpId = _toInt(json['mvp_id']);
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    homeTeam = json['home_team'] != null
        ? new HomeTeam.fromJson(json['home_team'])
        : null;
    awayTeam = json['away_team'] != null
        ? new HomeTeam.fromJson(json['away_team'])
        : null;
    if (json['match_ups'] is List) {
      matchUps = <MatchUps>[];
      json['match_ups'].forEach((v) {
        matchUps!.add(new MatchUps.fromJson(v));
      });
    }
  }

  static List<GameResponseDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .whereType<Map>()
        .map((json) => GameResponseDto.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['home_team_id'] = this.homeTeamId;
    data['away_team_id'] = this.awayTeamId;
    data['max_games'] = this.maxGames;
    data['home_team_score'] = this.homeTeamScore;
    data['away_team_score'] = this.awayTeamScore;
    data['is_active'] = this.isActive;
    data['league_id'] = this.leagueId;
    data['mvp_id'] = this.mvpId;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.homeTeam != null) {
      data['home_team'] = this.homeTeam!.toJson();
    }
    if (this.awayTeam != null) {
      data['away_team'] = this.awayTeam!.toJson();
    }
    if (this.matchUps != null) {
      data['match_ups'] = this.matchUps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeTeam {
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

  HomeTeam({
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

  HomeTeam.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
    logo = json['logo'];
    countryId = _toInt(json['country_id']);
    lostMatches = _toInt(json['lost_matches']);
    wonMatches = _toInt(json['won_matches']);
    leagueId = _toInt(json['league_id']);
    teamWallpaper = json['team_wallpaper'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
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

class MatchUps {
  int? id;
  int? gameId;
  int? winnerTeamId;
  int? homeTeamKills;
  double? homeTeamGold;
  int? awayTeamKills;
  double? awayTeamGold;
  String? homeTeamSide;
  String? awayTeamSide;
  int? homeTeamTowers;
  int? awayTeamTowers;
  String? createdAt;
  String? updatedAt;

  MatchUps({
    this.id,
    this.gameId,
    this.winnerTeamId,
    this.homeTeamKills,
    this.homeTeamGold,
    this.awayTeamKills,
    this.awayTeamGold,
    this.homeTeamSide,
    this.awayTeamSide,
    this.homeTeamTowers,
    this.awayTeamTowers,
    this.createdAt,
    this.updatedAt,
  });

  MatchUps.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    gameId = _toInt(json['game_id']);
    winnerTeamId = _toInt(json['winner_team_id']);
    homeTeamKills = _toInt(json['home_team_kills']);
    homeTeamGold = _toDouble(json['home_team_gold']);
    awayTeamKills = _toInt(json['away_team_kills']);
    awayTeamGold = _toDouble(json['away_team_gold']);
    homeTeamSide = json['home_team_side'];
    awayTeamSide = json['away_team_side'];
    homeTeamTowers = _toInt(json['home_team_towers']);
    awayTeamTowers = _toInt(json['away_team_towers']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['game_id'] = this.gameId;
    data['winner_team_id'] = this.winnerTeamId;
    data['home_team_kills'] = this.homeTeamKills;
    data['home_team_gold'] = this.homeTeamGold;
    data['away_team_kills'] = this.awayTeamKills;
    data['away_team_gold'] = this.awayTeamGold;
    data['home_team_side'] = this.homeTeamSide;
    data['away_team_side'] = this.awayTeamSide;
    data['home_team_towers'] = this.homeTeamTowers;
    data['away_team_towers'] = this.awayTeamTowers;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
