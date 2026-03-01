class RegisterRequestDto {
  String? name;
  String? email;
  String? password;
  String? passwordConfirmation;
  int? countryId;
  bool? banned;
  int? teamId;
  int? leagueId;
  int balance;
  bool? isPremium;

  RegisterRequestDto(
      {this.name,
      this.email,
      this.password,
      this.passwordConfirmation,
      this.countryId,
      this.banned,
      this.teamId,
      this.leagueId,
      this.balance = 0,
      this.isPremium});

  RegisterRequestDto.fromJson(Map<String, dynamic> json)
      : balance = json['balance'] ?? 0 {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    countryId = json['country_id'];
    banned = json['banned'];
    teamId = json['team_id'];
    leagueId = json['league_id'];
    isPremium = json['isPremium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    data['country_id'] = this.countryId;
    data['banned'] = this.banned;
    data['team_id'] = this.teamId;
    data['league_id'] = this.leagueId;
    data['balance'] = this.balance;
    data['isPremium'] = this.isPremium;
    return data;
  }
}
