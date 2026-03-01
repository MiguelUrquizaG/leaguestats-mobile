class TeamListResponseDto {
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
  League? league;
  Country? country;
  List<Players>? players;

  TeamListResponseDto(
      {this.id,
      this.name,
      this.logo,
      this.countryId,
      this.lostMatches,
      this.wonMatches,
      this.leagueId,
      this.teamWallpaper,
      this.createdAt,
      this.updatedAt,
      this.league,
      this.country,
      this.players});

  TeamListResponseDto.fromJson(Map<String, dynamic> json) {
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
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(new Players.fromJson(v));
      });
    }
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
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.players != null) {
      data['players'] = this.players!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class League {
  int? id;
  String? name;
  String? logo;
  int? countryId;
  String? createdAt;
  String? updatedAt;

  League(
      {this.id,
      this.name,
      this.logo,
      this.countryId,
      this.createdAt,
      this.updatedAt});

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

class Country {
  int? id;
  String? name;
  String? flag;
  String? createdAt;
  String? updatedAt;

  Country({this.id, this.name, this.flag, this.createdAt, this.updatedAt});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    flag = json['flag'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['flag'] = this.flag;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Players {
  int? id;
  String? name;
  String? photo;
  int? teamId;
  String? kda;
  String? position;
  String? birthDate;
  int? countryId;
  String? createdAt;
  String? updatedAt;

  Players(
      {this.id,
      this.name,
      this.photo,
      this.teamId,
      this.kda,
      this.position,
      this.birthDate,
      this.countryId,
      this.createdAt,
      this.updatedAt});

  Players.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    teamId = json['team_id'];
    kda = json['kda'];
    position = json['position'];
    birthDate = json['birth_date'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['team_id'] = this.teamId;
    data['kda'] = this.kda;
    data['position'] = this.position;
    data['birth_date'] = this.birthDate;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
