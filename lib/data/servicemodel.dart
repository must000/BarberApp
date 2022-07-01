import 'dart:convert';

class ServiceModel {
   String id;
  String name;
  String detail;
  double time;
  double price;
  ServiceModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.time,
    required this.price,
  });

  ServiceModel copyWith({
    String? id,
    String? name,
    String? detail,
    double? time,
    double? price,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      detail: detail ?? this.detail,
      time: time ?? this.time,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'time': time,
      'price': price,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      detail: map['detail'] ?? '',
      time: map['time']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceModel.fromJson(String source) => ServiceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceModel(id: $id, name: $name, detail: $detail, time: $time, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ServiceModel &&
      other.id == id &&
      other.name == name &&
      other.detail == detail &&
      other.time == time &&
      other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      detail.hashCode ^
      time.hashCode ^
      price.hashCode;
  }
}
