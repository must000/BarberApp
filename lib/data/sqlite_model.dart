import 'dart:convert';

class SQLiteModel {
  final int? id;
  final String email;
  SQLiteModel({
    this.id,
    required this.email,
  });

  SQLiteModel copyWith({
    int? id,
    String? email,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id']?.toInt(),
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) => SQLiteModel.fromMap(json.decode(source));

  @override
  String toString() => 'SQLiteModel(id: $id, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SQLiteModel &&
      other.id == id &&
      other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
