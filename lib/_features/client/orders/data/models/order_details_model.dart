import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import 'order_model.dart';

class OrderProductItemModel {
  final int id;
  final String title;
  final String imageUrl;
  final num price;
  final num amount;

  const OrderProductItemModel({
    required this.id,
    this.title = '',
    this.imageUrl = '',
    this.price = 0,
    this.amount = 1,
  });

  factory OrderProductItemModel.fromJson(Map<String, dynamic> json) {
    return OrderProductItemModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['name']?.toString() ??
          json['title']?.toString() ??
          json['product_name']?.toString() ??
          '',
      imageUrl: json['url']?.toString() ??
          json['image']?.toString() ??
          json['product_image']?.toString() ??
          json['image_url']?.toString() ??
          '',
      price: num.tryParse(json['price']?.toString() ?? '0') ?? 0,
      amount: num.tryParse(json['amount']?.toString() ?? json['qty']?.toString() ?? '1') ?? 1,
    );
  }
}

class OrderDetailsModel {
  final int id;
  final String status;
  final String statusTranslated;
  final String date;
  final num orderPrice;
  final num deliveryPrice;
  final num totalPrice;
  final String payType;
  final String addressTitle;
  final String addressDescription;
  final String addressLocation;
  final double lat;
  final double lng;
  final List<OrderProductItemModel> products;

  const OrderDetailsModel({
    required this.id,
    this.status = '',
    this.statusTranslated = '',
    this.date = '',
    this.orderPrice = 0,
    this.deliveryPrice = 0,
    this.totalPrice = 0,
    this.payType = 'visa',
    this.addressTitle = 'المنزل',
    this.addressDescription = 'شقة 40',
    this.addressLocation = 'شارع العليا الرياض 12521 السعودية',
    this.lat = 24.7136,
    this.lng = 46.6753,
    this.products = const [],
  });

  bool get isCanceled =>
      status.toLowerCase().contains('cancel') ||
      status.toLowerCase().contains('reject') ||
      statusTranslated.contains('ملغي') ||
      statusTranslated.contains('مرفوض');

  bool get isFinished =>
      status.toLowerCase().contains('finish') ||
      status.toLowerCase().contains('complete') ||
      status.toLowerCase().contains('done') ||
      statusTranslated.contains('منتهي') ||
      statusTranslated.contains('مكتمل');

  bool get isInWay =>
      status.toLowerCase().contains('way') ||
      status.toLowerCase().contains('deliver') ||
      statusTranslated.contains('الطريق') ||
      statusTranslated.contains('توصيل');

  bool get isPending =>
      status.toLowerCase().contains('pend') ||
      status.toLowerCase().contains('wait') ||
      statusTranslated.contains('موافقة') ||
      statusTranslated.contains('انتظار') ||
      (!isCanceled && !isFinished && !isInWay);

  String get statusTitle {
    if (statusTranslated.isNotEmpty) return statusTranslated;
    if (isCanceled) return 'طلب ملغي';
    if (isFinished) return 'منتهي';
    if (isInWay) return 'في الطريق';
    return 'بإنتظار الموافقة';
  }

  Color get statusTextColor {
    if (isCanceled) return AppColors.red;
    if (isInWay) return const Color(0xFF2196F3);
    if (isFinished) return AppColors.textSecondary;
    return AppColors.primary;
  }

  Color get statusBackgroundColor {
    if (isCanceled) return AppColors.redLight;
    if (isInWay) return const Color(0xFFE3F2FD);
    if (isFinished) return const Color(0xFFF3F3F3);
    return AppColors.primaryTint;
  }

  factory OrderDetailsModel.fromOrderModel(OrderModel order) {
    return OrderDetailsModel(
      id: order.id,
      status: order.status,
      statusTranslated: order.statusTranslated,
      date: order.date,
      orderPrice: order.totalPrice > 40 ? order.totalPrice - 40 : order.totalPrice,
      deliveryPrice: 40,
      totalPrice: order.totalPrice,
      payType: 'visa',
      addressTitle: 'المنزل',
      addressDescription: 'شقة 40',
      addressLocation: 'شارع العليا الرياض 12521 السعودية',
      products: order.productImages
          .asMap()
          .entries
          .map(
            (e) => OrderProductItemModel(
              id: e.key + 1,
              title: 'منتج ${e.key + 1}',
              imageUrl: e.value,
              price: 15,
              amount: 1,
            ),
          )
          .toList(),
    );
  }

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final productsList = <OrderProductItemModel>[];
    final rawProducts = json['products'] ?? json['items'] ?? json['order_products'];
    if (rawProducts is List) {
      for (final p in rawProducts) {
        if (p is Map<String, dynamic>) {
          productsList.add(OrderProductItemModel.fromJson(p));
        }
      }
    }

    final addressJson = json['address'];
    String addrTitle = 'المنزل';
    String addrDesc = '';
    String addrLoc = '';
    double addrLat = 24.7136;
    double addrLng = 46.6753;

    if (addressJson is Map<String, dynamic>) {
      addrTitle = addressJson['type']?.toString() ?? 'المنزل';
      addrDesc = addressJson['description']?.toString() ?? addressJson['notes']?.toString() ?? '';
      addrLoc = addressJson['location']?.toString() ?? addressJson['address']?.toString() ?? '';
      addrLat = double.tryParse(addressJson['lat']?.toString() ?? '24.7136') ?? 24.7136;
      addrLng = double.tryParse(addressJson['lng']?.toString() ?? '46.6753') ?? 46.6753;
    }

    final total = num.tryParse(
          json['total_price']?.toString() ??
              json['price']?.toString() ??
              json['order_total']?.toString() ??
              '0',
        ) ??
        0;

    final delivery = num.tryParse(
          json['delivery_price']?.toString() ??
              json['delivery_cost']?.toString() ??
              json['shipping_price']?.toString() ??
              '40',
        ) ??
        40;

    final orderP = num.tryParse(
          json['order_price']?.toString() ??
              json['products_price']?.toString() ??
              (total > delivery ? (total - delivery).toString() : total.toString()),
        ) ??
        (total > delivery ? total - delivery : total);

    return OrderDetailsModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '',
      statusTranslated: json['status_translated']?.toString() ??
          json['status_text']?.toString() ??
          json['status_ar']?.toString() ??
          '',
      date: json['date']?.toString() ?? json['created_at']?.toString() ?? '',
      orderPrice: orderP,
      deliveryPrice: delivery,
      totalPrice: total > 0 ? total : orderP + delivery,
      payType: json['pay_type']?.toString() ?? json['payment_type']?.toString() ?? 'visa',
      addressTitle: addrTitle.isNotEmpty ? addrTitle : 'المنزل',
      addressDescription: addrDesc.isNotEmpty ? addrDesc : 'شقة 40',
      addressLocation: addrLoc.isNotEmpty ? addrLoc : 'شارع العليا الرياض 12521 السعودية',
      lat: addrLat,
      lng: addrLng,
      products: productsList,
    );
  }
}

