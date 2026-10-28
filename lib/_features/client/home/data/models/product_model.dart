class ProductUnitModel {
  final int id;
  final String name;
  final String type;

  const ProductUnitModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    return ProductUnitModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}

class ProductImageModel {
  final String name;
  final String url;

  const ProductImageModel({
    required this.name,
    required this.url,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class ProductModel {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String code;
  final double priceBeforeDiscount;
  final double price;
  final double discount;
  final int amount;
  final int isActive;
  final bool isFavorite;
  final ProductUnitModel? unit;
  final List<ProductImageModel> images;
  final String mainImage;
  final String createdAt;

  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.code,
    required this.priceBeforeDiscount,
    required this.price,
    required this.discount,
    required this.amount,
    required this.isActive,
    required this.isFavorite,
    this.unit,
    required this.images,
    required this.mainImage,
    required this.createdAt,
  });

  bool get hasDiscount => discount > 0 && priceBeforeDiscount > price;

  int get discountPercent => (discount * 100).round();

  String get formattedPrice {
    if (price % 1 == 0) {
      return price.toInt().toString();
    }
    return price.toStringAsFixed(1);
  }

  String get formattedPriceBeforeDiscount {
    if (priceBeforeDiscount % 1 == 0) {
      return priceBeforeDiscount.toInt().toString();
    }
    return priceBeforeDiscount.toStringAsFixed(1);
  }

  String get unitName => unit?.name ?? '';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['images'] as List<dynamic>?)
            ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final unitMap = json['unit'] is Map<String, dynamic>
        ? json['unit'] as Map<String, dynamic>
        : null;

    final isFav = json['is_favorite'];
    final bool favoriteBool;
    if (isFav is bool) {
      favoriteBool = isFav;
    } else if (isFav is num) {
      favoriteBool = isFav == 1;
    } else {
      favoriteBool = false;
    }

    return ProductModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      categoryId: json['category_id'] is int
          ? json['category_id'] as int
          : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      priceBeforeDiscount:
          (json['price_before_discount'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      amount: json['amount'] is int
          ? json['amount'] as int
          : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      isActive: json['is_active'] is int
          ? json['is_active'] as int
          : int.tryParse(json['is_active']?.toString() ?? '1') ?? 1,
      isFavorite: favoriteBool,
      unit: unitMap != null ? ProductUnitModel.fromJson(unitMap) : null,
      images: imagesList,
      mainImage: json['main_image']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'code': code,
      'price_before_discount': priceBeforeDiscount,
      'price': price,
      'discount': discount,
      'amount': amount,
      'is_active': isActive,
      'is_favorite': isFavorite,
      'unit': unit?.toJson(),
      'images': images.map((e) => e.toJson()).toList(),
      'main_image': mainImage,
      'created_at': createdAt,
    };
  }
}

class ProductResponseModel {
  final List<ProductModel> data;
  final String status;
  final String message;
  final int userCartCount;
  final double maxPrice;
  final double minPrice;

  const ProductResponseModel({
    required this.data,
    required this.status,
    required this.message,
    required this.userCartCount,
    required this.maxPrice,
    required this.minPrice,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return ProductResponseModel(
      data: list
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      userCartCount: json['user_cart_count'] is int
          ? json['user_cart_count'] as int
          : int.tryParse(json['user_cart_count']?.toString() ?? '0') ?? 0,
      maxPrice: (json['max_price'] as num?)?.toDouble() ?? 0.0,
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
