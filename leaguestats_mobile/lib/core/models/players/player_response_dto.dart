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

  static List<PlayerResponseDto> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }
    return jsonList
        .map((json) => PlayerResponseDto.fromJson(json as Map<String, dynamic>))
        .toList();
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
