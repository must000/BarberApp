import 'dart:convert';


class BreakTimeModel {
String day;
String time;
  BreakTimeModel({
    required this.day,
    required this.time,
  });

  BreakTimeModel copyWith({
    String? day,
    String? time,
  }) {
    return BreakTimeModel(
      day: day ?? this.day,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'time': time,
    };
  }

  factory BreakTimeModel.fromMap(Map<String, dynamic> map) {
    return BreakTimeModel(
      day: map['day'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BreakTimeModel.fromJson(String source) => BreakTimeModel.fromMap(json.decode(source));

  @override
  String toString() => 'BreakTimeModel(day: $day, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BreakTimeModel &&
      other.day == day &&
      other.time == time;
  }

  @override
  int get hashCode => day.hashCode ^ time.hashCode;
}
