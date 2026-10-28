class SliderModel {
  final int id;
  final String media;

  const SliderModel({
    required this.id,
    required this.media,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      media: json['media']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media': media,
    };
  }
}

class SliderResponseModel {
  final List<SliderModel> data;
  final String status;
  final String message;

  const SliderResponseModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory SliderResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return SliderResponseModel(
      data: list
          .map((item) => SliderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
