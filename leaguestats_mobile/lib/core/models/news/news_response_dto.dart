class NewsResponseDto {
  final int id;
  final String title;
  final String description;
  final String photo;
  final String type;
  final String createdAt;
  final String updatedAt;

  NewsResponseDto({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsResponseDto.fromJson(Map<String, dynamic> json) {
    return NewsResponseDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photo': photo,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}