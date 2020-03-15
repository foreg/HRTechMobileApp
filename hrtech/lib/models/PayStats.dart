class PayStats {
  final double pay;
  final double salary;
  final double totalHours;
  final double workHours;

  PayStats({this.pay, this.salary, this.totalHours, this.workHours,});

  factory PayStats.fromJson(json) {
    if (json is!String) {
      return PayStats(
        pay: json['pay'] ?? null,
        salary: json['salary'] ?? null,
        totalHours: json['totalHours'] ?? null,
        workHours: json['workHours'] ?? null,
      );
    }    
  }
}