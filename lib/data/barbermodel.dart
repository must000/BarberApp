import 'dart:convert';

import 'package:flutter/foundation.dart';

class BarberModel {
  final String email;
  String name;
  String lasiName;
  String phone;
  String typebarber;
  String shopname;
  String shoprecommend;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;
  String geoHasher;
  String lat;
  String lng;
  String districtl;
  String subDistrict;
  String addressdetails;
  String url;
  double score;
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
    required this.geoHasher,
    required this.lat,
    required this.lng,
    required this.districtl,
    required this.subDistrict,
    required this.addressdetails,
    required this.url,
    required this.score,
  });

  BarberModel copyWith({
    String? email,
    String? name,
    String? lasiName,
    String? phone,
    String? typebarber,
    String? shopname,
    String? shoprecommend,
    Map<String, dynamic>? dayopen,
    String? timeopen,
    String? timeclose,
    String? geoHasher,
    String? lat,
    String? lng,
    String? districtl,
    String? subDistrict,
    String? addressdetails,
    String? url,
    double? score,
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
      geoHasher: geoHasher ?? this.geoHasher,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      districtl: districtl ?? this.districtl,
      subDistrict: subDistrict ?? this.subDistrict,
      addressdetails: addressdetails ?? this.addressdetails,
      url: url ?? this.url,
      score: score ?? this.score,
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
      'geoHasher': geoHasher,
      'lat': lat,
      'lng': lng,
      'districtl': districtl,
      'subDistrict': subDistrict,
      'addressdetails': addressdetails,
      'url': url,
      'score': score,
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
      dayopen: Map<String, dynamic>.from(map['dayopen']),
      timeopen: map['timeopen'] ?? '',
      timeclose: map['timeclose'] ?? '',
      geoHasher: map['geoHasher'] ?? '',
      lat: map['lat'] ?? '',
      lng: map['lng'] ?? '',
      districtl: map['districtl'] ?? '',
      subDistrict: map['subDistrict'] ?? '',
      addressdetails: map['addressdetails'] ?? '',
      url: map['url'] ?? '',
      score: map['score']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BarberModel.fromJson(String source) =>
      BarberModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BarberModel(email: $email, name: $name, lasiName: $lasiName, phone: $phone, typebarber: $typebarber, shopname: $shopname, shoprecommend: $shoprecommend, dayopen: $dayopen, timeopen: $timeopen, timeclose: $timeclose, geoHasher: $geoHasher, lat: $lat, lng: $lng, districtl: $districtl, subDistrict: $subDistrict, addressdetails: $addressdetails, url: $url, score: $score)';
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
        mapEquals(other.dayopen, dayopen) &&
        other.timeopen == timeopen &&
        other.timeclose == timeclose &&
        other.geoHasher == geoHasher &&
        other.lat == lat &&
        other.lng == lng &&
        other.districtl == districtl &&
        other.subDistrict == subDistrict &&
        other.addressdetails == addressdetails &&
        other.url == url &&
        other.score == score;
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
        geoHasher.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        districtl.hashCode ^
        subDistrict.hashCode ^
        addressdetails.hashCode ^
        url.hashCode ^
        score.hashCode;
  }
}
