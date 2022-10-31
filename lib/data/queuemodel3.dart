import 'dart:convert';

class QueueModel3 {
  String idQueue;
  String nameHairdresser;
  String time;
  double price;
  String status;
  QueueModel3({
    required this.idQueue,
    required this.nameHairdresser,
    required this.time,
    required this.price,
    required this.status,
  });

  QueueModel3 copyWith({
    String? idQueue,
    String? nameHairdresser,
    String? time,
    double? price,
    String? status,
  }) {
    return QueueModel3(
      idQueue: idQueue ?? this.idQueue,
      nameHairdresser: nameHairdresser ?? this.nameHairdresser,
      time: time ?? this.time,
      price: price ?? this.price,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idQueue': idQueue,
      'nameHairdresser': nameHairdresser,
      'time': time,
      'price': price,
      'status': status,
    };
  }

  factory QueueModel3.fromMap(Map<String, dynamic> map) {
    return QueueModel3(
      idQueue: map['idQueue'] ?? '',
      nameHairdresser: map['nameHairdresser'] ?? '',
      time: map['time'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel3.fromJson(String source) => QueueModel3.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QueueModel3(idQueue: $idQueue, nameHairdresser: $nameHairdresser, time: $time, price: $price, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QueueModel3 &&
      other.idQueue == idQueue &&
      other.nameHairdresser == nameHairdresser &&
      other.time == time &&
      other.price == price &&
      other.status == status;
  }

  @override
  int get hashCode {
    return idQueue.hashCode ^
      nameHairdresser.hashCode ^
      time.hashCode ^
      price.hashCode ^
      status.hashCode;
  }
}
