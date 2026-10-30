class UserProfileCity {
  final int id;
  final String name;

  const UserProfileCity({
    required this.id,
    required this.name,
  });

  factory UserProfileCity.fromJson(Map<String, dynamic> json) {
    return UserProfileCity(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class UserProfileModel {
  final int id;
  final String fullname;
  final String phone;
  final String image;
  final UserProfileCity? city;
  final int isVip;

  const UserProfileModel({
    required this.id,
    required this.fullname,
    required this.phone,
    required this.image,
    this.city,
    this.isVip = 0,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullname: json['fullname']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      city: json['city'] != null && json['city'] is Map<String, dynamic>
          ? UserProfileCity.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      isVip: json['is_vip'] is int
          ? json['is_vip'] as int
          : int.tryParse(json['is_vip']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'image': image,
      'city': city?.toJson(),
      'is_vip': isVip,
    };
  }

  static const dummy = UserProfileModel(
    id: 1,
    fullname: 'محمد علي',
    phone: '+96654787856',
    image: '',
    city: UserProfileCity(id: 1, name: 'الرياض'),
    isVip: 0,
  );
}

