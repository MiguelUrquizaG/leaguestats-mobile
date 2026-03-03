class NewsCommentResponseDto {
  int? id;
  int? newsId;
  int? userId;
  int? likes;
  bool? likedByMe;
  String? comment;
  String? createdAt;
  String? updatedAt;
  News? news;
  UserProfile? userProfile;

  NewsCommentResponseDto({
    this.id,
    this.newsId,
    this.userId,
    this.likes,
    this.likedByMe,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.news,
    this.userProfile,
  });

  NewsCommentResponseDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    newsId = json['news_id'];
    userId = json['user_id'];
    likes = json['likes'];
    likedByMe =
      (json['liked_by_me'] ??
          json['is_liked'] ??
          json['likedByMe'] ??
          json['has_liked'])
        as bool?;
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    news = json['news'] != null ? new News.fromJson(json['news']) : null;
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
  }

  static List<NewsCommentResponseDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NewsCommentResponseDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['news_id'] = this.newsId;
    data['user_id'] = this.userId;
    data['likes'] = this.likes;
    data['liked_by_me'] = this.likedByMe;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.news != null) {
      data['news'] = this.news!.toJson();
    }
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.toJson();
    }
    return data;
  }
}

class News {
  int? id;
  String? title;
  String? description;
  String? photo;
  String? type;
  String? createdAt;
  String? updatedAt;

  News({
    this.id,
    this.title,
    this.description,
    this.photo,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    photo = json['photo'];
    type = json['type'];

       List<News> fromJsonList(List<dynamic> jsonList) {
        return jsonList.map((json) => News.fromJson(json)).toList();
      }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['photo'] = this.photo;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class UserProfile {
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

  UserProfile({
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
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
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

     List<UserProfile> fromJsonList(List<dynamic> jsonList) {
      return jsonList.map((json) => UserProfile.fromJson(json)).toList();
    }
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

       List<User> fromJsonList(List<dynamic> jsonList) {
        return jsonList.map((json) => User.fromJson(json)).toList();
      }
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
