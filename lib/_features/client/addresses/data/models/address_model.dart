class AddressModel {
  final int id;
  final String type;
  final double lat;
  final double lng;
  final String location;
  final String description;
  final bool isDefault;
  final String phone;

  const AddressModel({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
    required this.location,
    required this.description,
    this.isDefault = false,
    required this.phone,
  });

  bool get isHome => type.toLowerCase() == 'home' || type == 'المنزل';

  String get typeDisplayName => isHome ? 'المنزل' : 'العمل';

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      type: json['type']?.toString() ?? 'home',
      lat: (json['lat'] is num)
          ? (json['lat'] as num).toDouble()
          : double.tryParse(json['lat']?.toString() ?? '0.0') ?? 0.0,
      lng: (json['lng'] is num)
          ? (json['lng'] as num).toDouble()
          : double.tryParse(json['lng']?.toString() ?? '0.0') ?? 0.0,
      location: json['location']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isDefault: json['is_default'] is bool
          ? json['is_default'] as bool
          : (json['is_default'] == 1 || json['is_default'] == '1'),
      phone: json['phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'lat': lat,
      'lng': lng,
      'location': location,
      'description': description,
      'is_default': isDefault,
      'phone': phone,
    };
  }

  static const dummy = AddressModel(
    id: 1,
    type: 'home',
    lat: 31.0259453,
    lng: 31.3650866,
    location: '119 طريق الملك عبدالعزيز',
    description: 'الوصف',
    isDefault: true,
    phone: '052284536827',
  );
}

