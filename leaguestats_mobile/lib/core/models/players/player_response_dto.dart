class PlayerResponseDto {
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

  PlayerResponseDto({
    this.id,
    this.name,
    this.photo,
    this.teamId,
    this.kda,
    this.position,
    this.birthDate,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  PlayerResponseDto.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = _toStringValue(json['name']);
    photo = _toStringValue(json['photo']);
    teamId = _toInt(json['team_id']);
    kda = _toStringValue(json['kda']);
    position = _toStringValue(json['position']);
    birthDate = _toStringValue(json['birth_date']);
    countryId = _toInt(json['country_id']);
    createdAt = _toStringValue(json['created_at']);
    updatedAt = _toStringValue(json['updated_at']);
  }

  static List<PlayerResponseDto> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    final players = <PlayerResponseDto>[];

    for (final item in jsonList) {
      if (item is! Map) {
        continue;
      }

      try {
        players.add(
          PlayerResponseDto.fromJson(Map<String, dynamic>.from(item)),
        );
      } catch (_) {
        continue;
      }
    }

    return players;
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    return null;
  }

  static String? _toStringValue(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
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
