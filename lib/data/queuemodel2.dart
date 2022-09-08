import 'dart:convert';

import 'package:barber/data/queuemodel.dart';

class QueueModel2 {
  DateTime timestart;
  DateTime timeend;
  QueueModel2({
    required this.timestart,
    required this.timeend,
  });

  QueueModel2 copyWith({
    DateTime? timestart,
    DateTime? timeend,
  }) {
    return QueueModel2(
      timestart: timestart ?? this.timestart,
      timeend: timeend ?? this.timeend,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestart': timestart.millisecondsSinceEpoch,
      'timeend': timeend.millisecondsSinceEpoch,
    };
  }

  factory QueueModel2.fromMap(Map<String, dynamic> map) {
    return QueueModel2(
      timestart: DateTime.fromMillisecondsSinceEpoch(map['timestart']),
      timeend: DateTime.fromMillisecondsSinceEpoch(map['timeend']),
    );
  }

  String toJson() => json.encode(toMap());

  factory QueueModel2.fromJson(String source) => QueueModel2.fromMap(json.decode(source));

  @override
  String toString() => 'QueueModel2(timestart: $timestart, timeend: $timeend)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QueueModel2 &&
      other.timestart == timestart &&
      other.timeend == timeend;
  }

  @override
  int get hashCode => timestart.hashCode ^ timeend.hashCode;
}
