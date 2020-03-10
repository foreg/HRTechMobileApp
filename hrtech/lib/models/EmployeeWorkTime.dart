class EmployeeWorkTime {
  final Map<dynamic, double> data;

  EmployeeWorkTime({this.data});

  factory EmployeeWorkTime.fromJson(json) {
    var _data = new Map<dynamic, double>();
    if (json is! String) {
        json.forEach((k,v) {
        DateTime date = DateTime.tryParse(k);
        if (date == null)
          _data[k] = v;
        else
          _data[date] = v;
      });
    }    
    return EmployeeWorkTime(data: _data);
  }
}