class CarModelItem {
  final int id;
  final String name;

  const CarModelItem({
    required this.id,
    required this.name,
  });

  factory CarModelItem.fromJson(Map<String, dynamic> json) {
    return CarModelItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  static const List<CarModelItem> defaultModels = [
    CarModelItem(id: 1, name: 'موديل 2020'),
    CarModelItem(id: 2, name: 'موديل 2021'),
    CarModelItem(id: 3, name: 'موديل 2022'),
    CarModelItem(id: 4, name: 'موديل 2023'),
    CarModelItem(id: 5, name: 'موديل 2024'),
    CarModelItem(id: 6, name: 'موديل 2025'),
    CarModelItem(id: 7, name: 'موديل 2026'),
  ];
}
