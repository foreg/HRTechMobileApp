import 'package:flutter/material.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/models/PayStats.dart';
import 'package:shimmer/shimmer.dart';

class PayStatsPage extends StatefulWidget {
  @override
  _PayStatsPageState createState() => _PayStatsPageState();
}

class _PayStatsPageState extends State<PayStatsPage> {
  Future<PayStats> _payStats;
  PayStats _payStatsData;

  @override
  void initState() {
    super.initState();
    _payStats = ApiRequests.getEmployeePayStats('month', DateTime(2020, 2, 20));
  }

  _buildTextInfo(BuildContext context, PayStats data) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[                            
                  Expanded(
                    child: Text('Часов отработано:')
                    ),
                  data == null ? Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Text('123.45'),
                  ) : Text(data.workHours.toString())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[                            
                  Expanded(
                    child: Text('Рабочих часов:')
                    ),
                  data == null ? Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Text('123.45'),
                  ) : Text(data.totalHours.toString())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[                            
                  Expanded(
                    child: Text('Оклад:')
                    ),
                  data == null ? Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Text('123.45'),
                  ) : Text(data.salary.toString())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[                            
                  Expanded(
                    child: Text('Итого:')
                    ),
                  data == null ? Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Text('123.45'),
                  ) : Text(data.pay.toString())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildChart(BuildContext context, AsyncSnapshot<PayStats> asyncSnapshot) {
    
  }

  Column buildPage(BuildContext context, AsyncSnapshot<PayStats> asyncSnapshot) {
    if (asyncSnapshot.connectionState == ConnectionState.done && asyncSnapshot.hasData) {
      _payStatsData = asyncSnapshot.data;
    }
    return Column(
    children: <Widget>[
      _buildTextInfo(context, _payStatsData),
      Expanded(
        flex: 13,
        child: Container(color: Colors.red)
      ),
      Expanded(
        flex: 2,
        child: Container()
      ),
    ],
  );
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _payStats,
      builder: (context, snapshot) => buildPage(context, snapshot),
    );
  }
}
