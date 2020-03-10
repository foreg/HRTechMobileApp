import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/Preloader.dart';
import 'package:hrtech/models/EmployeeWorkTime.dart';
import 'package:intl/intl.dart';

class WorkTimeChart extends StatefulWidget {
  final int itemIndex;
  final String step;

  const WorkTimeChart({Key key, this.itemIndex, this.step}) : super(key: key);
  @override
  State<StatefulWidget> createState() => WorkTimeChartState();
}

class WorkTimeChartState extends State<WorkTimeChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = Duration(milliseconds: 250);
  final dateUtility = DateUtil();

  DateTime now;
  DateTime rangeStart;

  Future<EmployeeWorkTime> _employeeWorkTime;

  int touchedIndex;

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.step != oldWidget.step)
      updateData(isStepChanged: true);
  }

  void updateData({bool isStepChanged = false}) {
    now = DateTime.now();
    switch (widget.step) {
      case 'week':
        rangeStart = now.subtract(Duration(days: 7 * widget.itemIndex + now.weekday - 1));
        break;
      case 'month':
        rangeStart = new DateTime(now.year, now.month - widget.itemIndex, now.day);
        break;
      case 'year':
        rangeStart = new DateTime(now.year - widget.itemIndex, now.month, now.day);
        break;
    }
    _employeeWorkTime = ApiRequests.getEmployeeWorkTime(widget.step, rangeStart);
  }

  //TODO при увеличении масштаба показывать самый левый столбик (год-месяц показывать январь, месяц-неделя показывать первую неделю)
  // при уменьшении показывать внутри (неделя-месяц показывать месяц начальной даты, месяц-год показывать тот год)

  Widget buildChart(AsyncSnapshot snapshot) {
    String catdTitle = "";
    switch (widget.step) {
      case 'week':
        catdTitle = DateFormat('d MMMM y', 'ru').format(rangeStart) + ' - ' + DateFormat('d MMMM y', 'ru').format(rangeStart.add(Duration(days: 7)));
        break;
      case 'month':
        catdTitle = DateFormat('MMM y', 'ru').format(rangeStart);
        break;
      case 'year':
        catdTitle = DateFormat('y', 'ru').format(rangeStart);
        break;
    }
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) { 
      return AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: const Color(0xff81e5cd),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AutoSizeText(
                      catdTitle,
                      style: TextStyle(
                        color: const Color(0xff0f4a3c), fontSize: 24, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'График рабочего времени',
                      style: TextStyle(
                          color: const Color(0xff379982), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          mainBarData(snapshot.data),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return Preloader();
    }
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 10,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(EmployeeWorkTime employeeWorkTime) {
    List<double> list;
    int columnsCount;
    double width = 22;
    switch (widget.step) {
      case 'week':
        columnsCount = 7;
        list = List<double>.generate(columnsCount, (i) => 0.0);
          employeeWorkTime.data.forEach((k,v) {
            list[k.weekday - 1] = v;
          });
        break;
      case 'month':
        width = 10;
        columnsCount = dateUtility.daysInMonth(rangeStart.month, rangeStart.year);
        list = List<double>.generate(columnsCount, (i) => 0.0);
          employeeWorkTime.data.forEach((k,v) {
            list[int.parse(k)] = v;
          });
        break;
      case 'year':
        columnsCount = 12;
        list = List<double>.generate(columnsCount, (i) => 0.0);
          employeeWorkTime.data.forEach((k,v) {
            list[int.parse(k)] = v;
          });
        break;
    }
    var x = 1;
    return List.generate(columnsCount, (i) {
        return makeGroupData(i, list[i], isTouched: i == touchedIndex, width: width);
      }
    );
  }

  BarChartData mainBarData(EmployeeWorkTime employeeWorkTime) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  (rod.y).toString(), TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'ПН';
              case 1:
                return 'ВТ';
              case 2:
                return 'СР';
              case 3:
                return 'ЧТ';
              case 4:
                return 'ПТ';
              case 5:
                return 'СБ';
              case 6:
                return 'ВС';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle( color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
          margin: 32,
          reservedSize: 14,
          getTitles: (value) {
            if (value == 0) {
              return '0';
            } else if (value == 4) {
              return '4';
            } else if (value == 8) {
              return '8';
            } else if (value == 10) {
              return '10';
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(employeeWorkTime),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _employeeWorkTime,
      builder: (context, snapshot) => buildChart(snapshot),
    );
  }
}