import 'package:flutter/material.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/models/PayStats.dart';

class PayStatsPage extends StatefulWidget {
  @override
  _PayStatsPageState createState() => _PayStatsPageState();
}

class _PayStatsPageState extends State<PayStatsPage> {
  Future<PayStats> _payStats;

  @override
  void initState() {
    super.initState();
    _payStats = ApiRequests.getEmployeePayStats();
  }

  _buildTextInfo(BuildContext context, AsyncSnapshot<PayStats> asyncSnapshot) {
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
                  Text('123.45')
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
                  Text('123.45')
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
                  Text('123.45')
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
                  Text('123.45')
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
    return Column(
    children: <Widget>[
      _buildTextInfo(context, asyncSnapshot),
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
