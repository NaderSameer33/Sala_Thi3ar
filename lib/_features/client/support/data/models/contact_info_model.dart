class ContactInfoModel {
  final String phone;
  final String email;
  final String whatsapp;
  final double lat;
  final double lng;
  final String location;

  const ContactInfoModel({
    this.phone = '',
    this.email = '',
    this.whatsapp = '',
    this.lat = 24.7136,
    this.lng = 46.6753,
    this.location = '',
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString() ?? '',
      lat: (json['lat'] is num)
          ? (json['lat'] as num).toDouble()
          : double.tryParse(json['lat']?.toString() ?? '24.7136') ?? 24.7136,
      lng: (json['lng'] is num)
          ? (json['lng'] as num).toDouble()
          : double.tryParse(json['lng']?.toString() ?? '46.6753') ?? 46.6753,
      location: json['location']?.toString() ?? '',
    );
  }
}

