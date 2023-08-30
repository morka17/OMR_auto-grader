import 'dart:convert';


class Record {
  final DateTime data;
  final String matno;
  final int correct;
  final int bad;
  final String grade;
  Record({
    required this.data,
    required this.matno,
    required this.correct,
    required this.bad,
    required this.grade,
  });

  Record copyWith({
    DateTime? data,
    String? matno,
    int? correct,
    int? bad,
    String? grade,
  }) {
    return Record(
      data: data ?? this.data,
      matno: matno ?? this.matno,
      correct: correct ?? this.correct,
      bad: bad ?? this.bad,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.millisecondsSinceEpoch,
      'matno': matno,
      'correct': correct,
      'bad': bad,
      'grade': grade,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      data: DateTime.fromMillisecondsSinceEpoch(map['data']),
      matno: map['matno'] ?? '',
      correct: map['correct']?.toInt() ?? 0,
      bad: map['bad']?.toInt() ?? 0,
      grade: map['grade'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Record.fromJson(String source) => Record.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Record(data: $data, matno: $matno, correct: $correct, bad: $bad, grade: $grade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Record &&
      other.data == data &&
      other.matno == matno &&
      other.correct == correct &&
      other.bad == bad &&
      other.grade == grade;
  }

  @override
  int get hashCode {
    return data.hashCode ^
      matno.hashCode ^
      correct.hashCode ^
      bad.hashCode ^
      grade.hashCode;
  }
}
