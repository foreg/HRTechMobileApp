import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/ChartCard.dart';
import 'package:hrtech/Preloader.dart';
import 'package:hrtech/models/EmployeeWorkTime.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class WorkTimeChart extends StatefulWidget {
  final int itemIndex;
  final String step;

  const WorkTimeChart({Key key, this.itemIndex, this.step}) : super(key: key);
  @override
  State<StatefulWidget> createState() => WorkTimeChartState();
}

class WorkTimeChartState extends State<WorkTimeChart> {
  final List<double> placeholderData = [7,8,7,6,8,8,6,7,8,7,7,8,7,6,8,8,6,7,8,7,7,8,7,6,8,8,6,7,8,7,6,8];
  final List<double> placeholderDataYear = [136,152,168, 175, 135, 167, 184, 168, 176, 176, 159, 183];
  final List<String> weekNamesAbbr = ['ПН','ВТ','СР','ЧТ','ПТ','СБ','ВС'];
  final List<String> monthNamesAbbr = ['Я','Ф','М','А','М','И','И','А','С','О','Н','Д'];
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = Duration(milliseconds: 250);
  final dateUtility = DateUtil();

  double intervalY;
  double rotateAngle;
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
        intervalY = 4;
        rotateAngle = 0;
        catdTitle = DateFormat('d MMMM y', 'ru').format(rangeStart) + ' - ' + DateFormat('d MMMM y', 'ru').format(rangeStart.add(Duration(days: 7)));
        break;
      case 'month':
        intervalY = 4;
        rotateAngle = 270;
        catdTitle = DateFormat('MMM y', 'ru').format(rangeStart);
        break;
      case 'year':
        intervalY = 40;
        rotateAngle = 0;
        catdTitle = DateFormat('y', 'ru').format(rangeStart);
        break;
    }
    var child;
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
       child = BarChart(
        mainBarData(snapshot.data),
        swapAnimationDuration: animDuration,
      );
    }
    else {
      child = Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: BarChart(
          mainBarData(null),
          swapAnimationDuration: animDuration,
        ),
      );
    }
    return ChartCard(catdTitle: catdTitle, child: child);
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
        list = List<double>.generate(columnsCount, (i) => employeeWorkTime == null ? placeholderData[i] : 0.0);
        employeeWorkTime?.data?.forEach((k,v) {
          list[k.weekday - 1] = v;
        });
        break;
      case 'month':
        width = 10;
        columnsCount = dateUtility.daysInMonth(rangeStart.month, rangeStart.year);
        list = List<double>.generate(columnsCount, (i) => employeeWorkTime == null ? placeholderData[i] : 0.0);
        employeeWorkTime?.data?.forEach((k,v) {
          list[int.parse(k)] = v;
        });
        break;
      case 'year':
        columnsCount = 12;
        list = List<double>.generate(columnsCount, (i) => employeeWorkTime == null ? placeholderDataYear[i] : 0.0);
        employeeWorkTime?.data?.forEach((k,v) {
          list[int.parse(k)] = v;
        });
        break;
    }
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
          }
        ),
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
          // rotateAngle: rotateAngle,
          showTitles: true,
          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          margin: 16,
          getTitles: (double value) {
            switch (widget.step) {
              case 'week':
                return weekNamesAbbr[value.toInt()];
                break;
              case 'month':
                return value == 0.0 || value.toInt() % 7 == 0 ? (value.toInt() + 1).toString() : '';
                break;
              case 'year':
                return monthNamesAbbr[value.toInt()];
                break;
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle( color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 16),
          margin: 16,
          reservedSize: 14,
          getTitles: (value) {
            return value.toInt().toString();
          },
          interval: intervalY
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