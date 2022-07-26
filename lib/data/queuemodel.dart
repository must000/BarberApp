import 'dart:convert';

class QueueModel {
    DateTime datetime;
  String idUser;
  String emailBarber;
  QueueModel({
    required this.datetime,
    required this.idUser,
    required this.emailBarber,
  });

  QueueModel copyWith({
    DateTime? datetime,
    String? idUser,
    String? emailBarber,
  }) {
    return QueueModel(
      datetime: datetime ?? this.datetime,
      idUser: idUser ?? this.idUser,
      emailBarber: emailBarber ?? this.emailBarber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'datetime': datetime.millisecondsSinceEpoch,
      'idUser': idUser,
      'emailBarber': emailBarber,
    };
  }

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    return QueueModel(
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime']),
      idUser: map['idUser'] ?? '',
      emailBarber: map['emailBarber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source));

  @override
  String toString() => 'QueueModel(datetime: $datetime, idUser: $idUser, emailBarber: $emailBarber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QueueModel &&
      other.datetime == datetime &&
      other.idUser == idUser &&
      other.emailBarber == emailBarber;
  }

  @override
  int get hashCode => datetime.hashCode ^ idUser.hashCode ^ emailBarber.hashCode;
}
