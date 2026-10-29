class ProductRateModel {
  final num value;
  final String comment;
  final String clientName;
  final String clientImage;

  const ProductRateModel({
    required this.value,
    required this.comment,
    required this.clientName,
    required this.clientImage,
  });

  factory ProductRateModel.fromJson(Map<String, dynamic> json) {
    return ProductRateModel(
      value: (json['value'] as num?) ?? 0,
      comment: json['comment']?.toString() ?? '',
      clientName: json['client_name']?.toString() ?? '',
      clientImage: json['client_image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'comment': comment,
      'client_name': clientName,
      'client_image': clientImage,
    };
  }
}

class ProductRatesResponseModel {
  final List<ProductRateModel> data;
  final String status;
  final String message;

  const ProductRatesResponseModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ProductRatesResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return ProductRatesResponseModel(
      data: list
          .map((item) => ProductRateModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

