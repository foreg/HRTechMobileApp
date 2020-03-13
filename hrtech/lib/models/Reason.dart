class Reason {
  final int id;
  final String name;

  Reason({this.id, this.name});

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      id: json['id'] ?? null,
      name: json['name'] ?? null,
    );
  }
}