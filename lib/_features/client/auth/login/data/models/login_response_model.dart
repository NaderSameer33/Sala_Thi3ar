class LoginResponseModel {
  final String? status;
  final String? message;
  final UserData? data;

  LoginResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString() ?? json['msg']?.toString(),
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UserData {
  final int? id;
  final String? fullname;
  final String? phone;
  final String? email;
  final String? image;
  final int? isBan;
  final bool? isActive;
  final int? unreadNotifications;
  final String? userType;
  final String? token;
  final dynamic country;
  final CityModel? city;
  final String? identityNumber;
  final int? userCartCount;

  UserData({
    this.id,
    this.fullname,
    this.phone,
    this.email,
    this.image,
    this.isBan,
    this.isActive,
    this.unreadNotifications,
    this.userType,
    this.token,
    this.country,
    this.city,
    this.identityNumber,
    this.userCartCount,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      fullname: json['fullname']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      image: json['image']?.toString(),
      isBan: json['is_ban'] is int ? json['is_ban'] : int.tryParse(json['is_ban']?.toString() ?? ''),
      isActive: json['is_active'] is bool
          ? json['is_active']
          : (json['is_active'] == 1 || json['is_active'] == '1'),
      unreadNotifications: json['unread_notifications'] is int
          ? json['unread_notifications']
          : int.tryParse(json['unread_notifications']?.toString() ?? ''),
      userType: json['user_type']?.toString(),
      token: json['token']?.toString(),
      country: json['country'],
      city: json['city'] != null ? CityModel.fromJson(json['city']) : null,
      identityNumber: json['identity_number']?.toString(),
      userCartCount: json['user_cart_count'] is int
          ? json['user_cart_count']
          : int.tryParse(json['user_cart_count']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'email': email,
      'image': image,
      'is_ban': isBan,
      'is_active': isActive,
      'unread_notifications': unreadNotifications,
      'user_type': userType,
      'token': token,
      'country': country,
      'city': city?.toJson(),
      'identity_number': identityNumber,
      'user_cart_count': userCartCount,
    };
  }
}

class CityModel {
  final String? id;
  final String? name;

  CityModel({
    this.id,
    this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
