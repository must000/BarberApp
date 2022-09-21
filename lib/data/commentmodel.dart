import 'dart:convert';

class CommentModel {
  String comment;
  int score;
  CommentModel({
    required this.comment,
    required this.score,
  });

  CommentModel copyWith({
    String? comment,
    int? score,
  }) {
    return CommentModel(
      comment: comment ?? this.comment,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'score': score,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      comment: map['comment'] ?? '',
      score: map['score']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source));

  @override
  String toString() => 'CommentModel(comment: $comment, score: $score)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CommentModel &&
      other.comment == comment &&
      other.score == score;
  }

  @override
  int get hashCode => comment.hashCode ^ score.hashCode;
}
