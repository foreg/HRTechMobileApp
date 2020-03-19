class PayStats {
  final double pay;
  final double salary;
  final double totalHours;
  final double workHours;
  final bool error;

  PayStats({this.pay = 0, this.salary = 0, this.totalHours = 0, this.workHours = 0,this.error = false});

  factory PayStats.fromJson(json) {
    if (json is!String) {
      return PayStats(
        pay: double.parse(json['pay']) ?? null,
        salary: double.parse(json['salary']) ?? null,
        totalHours: double.parse(json['totalHours']) ?? null,
        workHours: double.parse(json['workHours']) ?? null,
      );
    }
    return PayStats(error: true);
  }
}