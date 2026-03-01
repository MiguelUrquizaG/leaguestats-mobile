class UserResponseDto {
  int? id;
  String? username;
  int? ratedMatches;
  int? followers;
  int? countryId;
  int? userId;
  int? banned;
  int? teamId;
  int? leagueId;
  int? isPremium;
  int? balance;
  String? createdAt;
  String? updatedAt;
  User? user;
  Country? country;
  Team? team;

  UserResponseDto({
    this.id,
    this.username,
    this.ratedMatches,
    this.followers,
    this.countryId,
    this.userId,
    this.banned,
    this.teamId,
    this.leagueId,
    this.isPremium,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.country,
    this.team,
  });

  UserResponseDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    ratedMatches = json['rated_matches'];
    followers = json['followers'];
    countryId = json['country_id'];
    userId = json['user_id'];
    banned = json['banned'];
    teamId = json['team_id'];
    leagueId = json['league_id'];
    isPremium = json['isPremium'];
    balance = json['balance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    country = json['country'] != null
        ? new Country.fromJson(json['country'])
        : null;
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['rated_matches'] = this.ratedMatches;
    data['followers'] = this.followers;
    data['country_id'] = this.countryId;
    data['user_id'] = this.userId;
    data['banned'] = this.banned;
    data['team_id'] = this.teamId;
    data['league_id'] = this.leagueId;
    data['isPremium'] = this.isPremium;
    data['balance'] = this.balance;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? role;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['email_verified_at'] = this.emailVerifiedAt;
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

class Team {
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

  Team({
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

  Team.fromJson(Map<String, dynamic> json) {
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
