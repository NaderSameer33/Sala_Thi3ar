import 'product_model.dart';

class SearchResponseModel {
  final String status;
  final String message;
  final List<ProductModel> results;

  const SearchResponseModel({
    required this.status,
    required this.message,
    required this.results,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final list = data['search_result'] as List<dynamic>? ?? [];
    return SearchResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      results: list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}