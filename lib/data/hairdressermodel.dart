import 'dart:convert';

class HairdresserModel {
  String hairdresserID;
  String email;
  String idCode;
  String name;
  String lastname;
  String serviceID;
  String barberStatus;
  String phone;
  HairdresserModel({
    required this.hairdresserID,
    required this.email,
    required this.idCode,
    required this.name,
    required this.lastname,
    required this.serviceID,
    required this.barberStatus,
    required this.phone,
  });

  HairdresserModel copyWith({
    String? hairdresserID,
    String? email,
    String? idCode,
    String? name,
    String? lastname,
    String? serviceID,
    String? barberStatus,
    String? phone,
  }) {
    return HairdresserModel(
      hairdresserID: hairdresserID ?? this.hairdresserID,
      email: email ?? this.email,
      idCode: idCode ?? this.idCode,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      serviceID: serviceID ?? this.serviceID,
      barberStatus: barberStatus ?? this.barberStatus,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hairdresserID': hairdresserID,
      'email': email,
      'idCode': idCode,
      'name': name,
      'lastname': lastname,
      'serviceID': serviceID,
      'barberStatus': barberStatus,
      'phone': phone,
    };
  }

  factory HairdresserModel.fromMap(Map<String, dynamic> map) {
    return HairdresserModel(
      hairdresserID: map['hairdresserID'] ?? '',
      email: map['email'] ?? '',
      idCode: map['idCode'] ?? '',
      name: map['name'] ?? '',
      lastname: map['lastname'] ?? '',
      serviceID: map['serviceID'] ?? '',
      barberStatus: map['barberStatus'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HairdresserModel.fromJson(String source) => HairdresserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HairdresserModel(hairdresserID: $hairdresserID, email: $email, idCode: $idCode, name: $name, lastname: $lastname, serviceID: $serviceID, barberStatus: $barberStatus, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HairdresserModel &&
      other.hairdresserID == hairdresserID &&
      other.email == email &&
      other.idCode == idCode &&
      other.name == name &&
      other.lastname == lastname &&
      other.serviceID == serviceID &&
      other.barberStatus == barberStatus &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return hairdresserID.hashCode ^
      email.hashCode ^
      idCode.hashCode ^
      name.hashCode ^
      lastname.hashCode ^
      serviceID.hashCode ^
      barberStatus.hashCode ^
      phone.hashCode;
  }
}
