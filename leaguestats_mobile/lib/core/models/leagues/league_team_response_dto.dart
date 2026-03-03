class LeagueTeamResponseDto {
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

  LeagueTeamResponseDto(
      {this.id,
      this.name,
      this.logo,
      this.countryId,
      this.lostMatches,
      this.wonMatches,
      this.leagueId,
      this.teamWallpaper,
      this.createdAt,
      this.updatedAt});

  LeagueTeamResponseDto.fromJson(Map<String, dynamic> json) {
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

  static List<LeagueTeamResponseDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => LeagueTeamResponseDto.fromJson(json))
        .toList();
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
