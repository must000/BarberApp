import 'dart:convert';

class QueueModel {
  DateTime datetime;
  String idUser;
  String emailBarber;
  String idService;
  String nameService;
  String detailService;
  QueueModel({
    required this.datetime,
    required this.idUser,
    required this.emailBarber,
    required this.idService,
    required this.nameService,
    required this.detailService,
  });

  QueueModel copyWith({
    DateTime? datetime,
    String? idUser,
    String? emailBarber,
    String? idService,
    String? nameService,
    String? detailService,
  }) {
    return QueueModel(
      datetime: datetime ?? this.datetime,
      idUser: idUser ?? this.idUser,
      emailBarber: emailBarber ?? this.emailBarber,
      idService: idService ?? this.idService,
      nameService: nameService ?? this.nameService,
      detailService: detailService ?? this.detailService,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'datetime': datetime.millisecondsSinceEpoch,
      'idUser': idUser,
      'emailBarber': emailBarber,
      'idService': idService,
      'nameService': nameService,
      'detailService': detailService,
    };
  }

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    return QueueModel(
      datetime: DateTime.fromMillisecondsSinceEpoch(map['datetime']),
      idUser: map['idUser'] ?? '',
      emailBarber: map['emailBarber'] ?? '',
      idService: map['idService'] ?? '',
      nameService: map['nameService'] ?? '',
      detailService: map['detailService'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel.fromJson(String source) => QueueModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QueueModel(datetime: $datetime, idUser: $idUser, emailBarber: $emailBarber, idService: $idService, nameService: $nameService, detailService: $detailService)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QueueModel &&
      other.datetime == datetime &&
      other.idUser == idUser &&
      other.emailBarber == emailBarber &&
      other.idService == idService &&
      other.nameService == nameService &&
      other.detailService == detailService;
  }

  @override
  int get hashCode {
    return datetime.hashCode ^
      idUser.hashCode ^
      emailBarber.hashCode ^
      idService.hashCode ^
      nameService.hashCode ^
      detailService.hashCode;
  }
}
