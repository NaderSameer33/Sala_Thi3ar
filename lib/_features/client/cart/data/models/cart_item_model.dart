class CartItemModel {
  final int id;
  final String title;
  final String image;
  final int amount;
  final num priceBeforeDiscount;
  final num discount;
  final num price;
  final int remainingAmount;

  const CartItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.amount,
    required this.priceBeforeDiscount,
    required this.discount,
    required this.price,
    required this.remainingAmount,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 1,
      priceBeforeDiscount: (json['price_before_discount'] as num?) ?? 0,
      discount: (json['discount'] as num?) ?? 0,
      price: (json['price'] as num?) ?? 0,
      remainingAmount: (json['remaining_amount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'amount': amount,
      'price_before_discount': priceBeforeDiscount,
      'discount': discount,
      'price': price,
      'remaining_amount': remainingAmount,
    };
  }

  CartItemModel copyWith({
    int? id,
    String? title,
    String? image,
    int? amount,
    num? priceBeforeDiscount,
    num? discount,
    num? price,
    int? remainingAmount,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      amount: amount ?? this.amount,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      discount: discount ?? this.discount,
      price: price ?? this.price,
      remainingAmount: remainingAmount ?? this.remainingAmount,
    );
  }

  String get formattedPrice {
    return price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
  }

  String get formattedPriceBeforeDiscount {
    return priceBeforeDiscount % 1 == 0
        ? priceBeforeDiscount.toInt().toString()
        : priceBeforeDiscount.toStringAsFixed(2);
  }

  bool get hasDiscount => discount > 0;
}

