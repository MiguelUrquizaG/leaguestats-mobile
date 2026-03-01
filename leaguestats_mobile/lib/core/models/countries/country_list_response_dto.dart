class CountryListResponseDto {
  int? id;
  String? name;
  String? flag;
  String? createdAt;
  String? updatedAt;

  CountryListResponseDto(
      {this.id, this.name, this.flag, this.createdAt, this.updatedAt});

  CountryListResponseDto.fromJson(Map<String, dynamic> json) {
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
