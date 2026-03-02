class UserBetDto {
  final int? id;
  final int? userId;
  final int? betId;
  final num? amount;
  final int? awarded;
  final int? winnerSelected;
  final DateTime? createdAt;
  final BetDetailDto? bet; // Objeto anidado con los detalles del partido

  UserBetDto({
    this.id,
    this.userId,
    this.betId,
    this.amount,
    this.awarded,
    this.winnerSelected,
    this.createdAt,
    this.bet,
  });

  factory UserBetDto.fromJson(Map<String, dynamic> json) {
    return UserBetDto(
      id: json['id'],
      userId: json['user_id'],
      betId: json['bet_id'],
      amount: json['amount'],
      awarded: json['awarded'],
      winnerSelected: json['winner_selected'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      bet: json['bet'] != null ? BetDetailDto.fromJson(json['bet']) : null,
    );
  }
}

class BetDetailDto {
  final int? id;
  final String? date;
  final String? time;
  final int? team1Id;
  final int? team2Id;
  final num? team1Value;
  final num? team2Value;
  final String? instance;
  final String? status;
  final LeagueDto? league;
  final TeamDto? team1;
  final TeamDto? team2;

  BetDetailDto({
    this.id,
    this.date,
    this.time,
    this.team1Id,
    this.team2Id,
    this.team1Value,
    this.team2Value,
    this.instance,
    this.status,
    this.league,
    this.team1,
    this.team2,
  });

  factory BetDetailDto.fromJson(Map<String, dynamic> json) {
    return BetDetailDto(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      team1Id: json['team1_id'],
      team2Id: json['team2_id'],
      team1Value: json['team1_value'],
      team2Value: json['team2_value'],
      instance: json['instance'],
      status: json['status'],
      league: json['league'] != null
          ? LeagueDto.fromJson(json['league'])
          : null,
      team1: json['team1'] != null ? TeamDto.fromJson(json['team1']) : null,
      team2: json['team2'] != null ? TeamDto.fromJson(json['team2']) : null,
    );
  }
}

class LeagueDto {
  final String? name;
  final String? logo;

  LeagueDto({this.name, this.logo});

  factory LeagueDto.fromJson(Map<String, dynamic> json) {
    return LeagueDto(name: json['name'], logo: json['logo']);
  }
}

class TeamDto {
  final int? id;
  final String? name;
  final String? logo;

  TeamDto({this.id, this.name, this.logo});

  factory TeamDto.fromJson(Map<String, dynamic> json) {
    return TeamDto(id: json['id'], name: json['name'], logo: json['logo']);
  }
}
