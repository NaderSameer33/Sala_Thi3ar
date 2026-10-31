import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class OrderModel {
  final int id;
  final String status;
  final String statusTranslated;
  final String date;
  final num totalPrice;
  final List<String> productImages;

  const OrderModel({
    required this.id,
    this.status = '',
    this.statusTranslated = '',
    this.date = '',
    this.totalPrice = 0,
    this.productImages = const [],
  });

  bool get isCanceled =>
      status.toLowerCase().contains('cancel') ||
      statusTranslated.contains('ملغي');

  bool get isFinished =>
      status.toLowerCase().contains('finish') ||
      status.toLowerCase().contains('complete') ||
      statusTranslated.contains('منتهي');

  String get statusTitle {
    if (statusTranslated.isNotEmpty) return statusTranslated;
    final s = status.toLowerCase();
    if (s.contains('cancel')) return 'طلب ملغي';
    if (s.contains('finish') || s.contains('complete')) return 'منتهي';
    if (s.contains('prep')) return 'جاري التحضير';
    if (s.contains('way') || s.contains('deliver')) return 'في الطريق';
    if (s.contains('pend') || s.contains('wait')) return 'بإنتظار الموافقة';
    return status.isNotEmpty ? status : 'بإنتظار الموافقة';
  }

  Color get statusTextColor {
    if (isCanceled) return AppColors.red;
    if (isFinished) return AppColors.textSecondary;
    return AppColors.primary;
  }

  Color get statusBackgroundColor {
    if (isCanceled) return AppColors.redLight;
    if (isFinished) return const Color(0xFFF3F3F3);
    return AppColors.primaryTint;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final images = <String>[];
    final rawProducts = json['products'] ?? json['items'] ?? json['order_products'];
    if (rawProducts is List) {
      for (final p in rawProducts) {
        if (p is Map<String, dynamic>) {
          final url = p['url'] ?? p['image'] ?? p['product_image'] ?? p['image_url'];
          if (url != null && url.toString().isNotEmpty) {
            images.add(url.toString());
          }
        } else if (p is String && p.isNotEmpty) {
          images.add(p);
        }
      }
    }

    return OrderModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '',
      statusTranslated: json['status_translated']?.toString() ??
          json['status_text']?.toString() ??
          json['status_ar']?.toString() ??
          '',
      date: json['date']?.toString() ?? json['created_at']?.toString() ?? '',
      totalPrice: num.tryParse(
            json['total_price']?.toString() ??
                json['price']?.toString() ??
                json['order_price']?.toString() ??
                '0',
          ) ??
          0,
      productImages: images,
    );
  }
}

