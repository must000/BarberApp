import 'dart:convert';

class BarberModel {
  final String email;
  final String name;
  final String lasiName;
  final String phone;
  final String typebarber;
  final String shopname;
  final String shoprecommend;
  final String dayopen;
  final String timeopen;
  final String timeclose;
  final String lat;
  final String lng;
  final String districtl;
  final String subDistrict;
  final String addressdetails;
  BarberModel({
    required this.email,
    required this.name,
    required this.lasiName,
    required this.phone,
    required this.typebarber,
    required this.shopname,
    required this.shoprecommend,
    required this.dayopen,
    required this.timeopen,
    required this.timeclose,
    required this.lat,
    required this.lng,
    required this.districtl,
    required this.subDistrict,
    required this.addressdetails,
  });

  BarberModel copyWith({
    String? email,
    String? name,
    String? lasiName,
    String? phone,
    String? typebarber,
    String? shopname,
    String? shoprecommend,
    String? dayopen,
    String? timeopen,
    String? timeclose,
    String? lat,
    String? lng,
    String? districtl,
    String? subDistrict,
    String? addressdetails,
  }) {
    return BarberModel(
      email: email ?? this.email,
      name: name ?? this.name,
      lasiName: lasiName ?? this.lasiName,
      phone: phone ?? this.phone,
      typebarber: typebarber ?? this.typebarber,
      shopname: shopname ?? this.shopname,
      shoprecommend: shoprecommend ?? this.shoprecommend,
      dayopen: dayopen ?? this.dayopen,
      timeopen: timeopen ?? this.timeopen,
      timeclose: timeclose ?? this.timeclose,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      districtl: districtl ?? this.districtl,
      subDistrict: subDistrict ?? this.subDistrict,
      addressdetails: addressdetails ?? this.addressdetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'lasiName': lasiName,
      'phone': phone,
      'typebarber': typebarber,
      'shopname': shopname,
      'shoprecommend': shoprecommend,
      'dayopen': dayopen,
      'timeopen': timeopen,
      'timeclose': timeclose,
      'lat': lat,
      'lng': lng,
      'districtl': districtl,
      'subDistrict': subDistrict,
      'addressdetails': addressdetails,
    };
  }

  factory BarberModel.fromMap(Map<String, dynamic> map) {
    return BarberModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      lasiName: map['lasiName'] ?? '',
      phone: map['phone'] ?? '',
      typebarber: map['typebarber'] ?? '',
      shopname: map['shopname'] ?? '',
      shoprecommend: map['shoprecommend'] ?? '',
      dayopen: map['dayopen'] ?? '',
      timeopen: map['timeopen'] ?? '',
      timeclose: map['timeclose'] ?? '',
      lat: map['lat'] ?? '',
      lng: map['lng'] ?? '',
      districtl: map['districtl'] ?? '',
      subDistrict: map['subDistrict'] ?? '',
      addressdetails: map['addressdetails'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BarberModel.fromJson(String source) => BarberModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BarberModel(email: $email, name: $name, lasiName: $lasiName, phone: $phone, typebarber: $typebarber, shopname: $shopname, shoprecommend: $shoprecommend, dayopen: $dayopen, timeopen: $timeopen, timeclose: $timeclose, lat: $lat, lng: $lng, districtl: $districtl, subDistrict: $subDistrict, addressdetails: $addressdetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BarberModel &&
      other.email == email &&
      other.name == name &&
      other.lasiName == lasiName &&
      other.phone == phone &&
      other.typebarber == typebarber &&
      other.shopname == shopname &&
      other.shoprecommend == shoprecommend &&
      other.dayopen == dayopen &&
      other.timeopen == timeopen &&
      other.timeclose == timeclose &&
      other.lat == lat &&
      other.lng == lng &&
      other.districtl == districtl &&
      other.subDistrict == subDistrict &&
      other.addressdetails == addressdetails;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      lasiName.hashCode ^
      phone.hashCode ^
      typebarber.hashCode ^
      shopname.hashCode ^
      shoprecommend.hashCode ^
      dayopen.hashCode ^
      timeopen.hashCode ^
      timeclose.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      districtl.hashCode ^
      subDistrict.hashCode ^
      addressdetails.hashCode;
  }
}
