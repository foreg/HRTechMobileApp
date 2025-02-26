class ClockInOut {
  final int id;
  final bool type;
  final DateTime checkTime;

  ClockInOut({this.id, this.type, this.checkTime});

  factory ClockInOut.fromJson(dynamic json) {
    if (json is! String) {
      return ClockInOut(
        id: json['id'] ?? null,
        type: json['type'] ?? null,
        checkTime: DateTime.parse(json['checkTime'].substring(0, json['checkTime'].indexOf('Z'))) ?? null,
      );
    }
    return ClockInOut(type: false);
  }
}