class LeagueListResponseDto {
  int? id;
  String? name;
  String? logo;
  int? countryId;
  String? createdAt;
  String? updatedAt;
  Country? country;

  LeagueListResponseDto(
      {this.id,
      this.name,
      this.logo,
      this.countryId,
      this.createdAt,
      this.updatedAt,
      this.country});

  LeagueListResponseDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
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
