import 'cart_item_model.dart';

class CartDataModel {
  final List<CartItemModel> items;
  final num totalPriceBeforeDiscount;
  final num totalDiscount;
  final num totalPriceWithVat;
  final num deliveryCost;
  final num freeDeliveryPrice;
  final num vat;
  final int isVip;
  final num? vipDiscountPercentage;
  final num? minVipPrice;
  final String vipMessage;
  final String status;
  final String message;

  const CartDataModel({
    required this.items,
    required this.totalPriceBeforeDiscount,
    required this.totalDiscount,
    required this.totalPriceWithVat,
    required this.deliveryCost,
    required this.freeDeliveryPrice,
    required this.vat,
    required this.isVip,
    this.vipDiscountPercentage,
    this.minVipPrice,
    required this.vipMessage,
    required this.status,
    required this.message,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final itemsList = <CartItemModel>[];
    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          itemsList.add(CartItemModel.fromJson(item));
        }
      }
    }

    return CartDataModel(
      items: itemsList,
      totalPriceBeforeDiscount: (json['total_price_before_discount'] as num?) ?? 0,
      totalDiscount: (json['total_discount'] as num?) ?? 0,
      totalPriceWithVat: (json['total_price_with_vat'] as num?) ?? 0,
      deliveryCost: (json['delivery_cost'] as num?) ?? 0,
      freeDeliveryPrice: (json['free_delivery_price'] as num?) ?? 0,
      vat: (json['vat'] as num?) ?? 0,
      isVip: (json['is_vip'] as num?)?.toInt() ?? 0,
      vipDiscountPercentage: json['vip_discount_percentage'] as num?,
      minVipPrice: json['min_vip_price'] as num?,
      vipMessage: json['vip_message']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  String get formattedSubtotal {
    return totalPriceBeforeDiscount % 1 == 0
        ? totalPriceBeforeDiscount.toInt().toString()
        : totalPriceBeforeDiscount.toStringAsFixed(2);
  }

  String get formattedDiscount {
    return totalDiscount % 1 == 0
        ? totalDiscount.toInt().toString()
        : totalDiscount.toStringAsFixed(2);
  }

  String get formattedTotal {
    return totalPriceWithVat % 1 == 0
        ? totalPriceWithVat.toInt().toString()
        : totalPriceWithVat.toStringAsFixed(2);
  }

  CartDataModel copyWith({
    List<CartItemModel>? items,
    num? totalPriceBeforeDiscount,
    num? totalDiscount,
    num? totalPriceWithVat,
    num? deliveryCost,
    num? freeDeliveryPrice,
    num? vat,
    int? isVip,
    num? vipDiscountPercentage,
    num? minVipPrice,
    String? vipMessage,
    String? status,
    String? message,
  }) {
    return CartDataModel(
      items: items ?? this.items,
      totalPriceBeforeDiscount:
          totalPriceBeforeDiscount ?? this.totalPriceBeforeDiscount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalPriceWithVat: totalPriceWithVat ?? this.totalPriceWithVat,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      freeDeliveryPrice: freeDeliveryPrice ?? this.freeDeliveryPrice,
      vat: vat ?? this.vat,
      isVip: isVip ?? this.isVip,
      vipDiscountPercentage:
          vipDiscountPercentage ?? this.vipDiscountPercentage,
      minVipPrice: minVipPrice ?? this.minVipPrice,
      vipMessage: vipMessage ?? this.vipMessage,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

