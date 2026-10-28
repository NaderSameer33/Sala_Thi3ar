class CategoryModel {
  final int id;
  final String name;
  final String description;
  final String media;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.media,
  });

  /// Alias for backward compatibility
  String get image => media;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      media: json['media']?.toString() ?? json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'media': media,
    };
  }
}

class CategoryResponseModel {
  final List<CategoryModel> data;
  final String status;
  final String message;

  const CategoryResponseModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return CategoryResponseModel(
      data: list
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
