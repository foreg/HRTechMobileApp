import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/ChartCard.dart';
import 'package:hrtech/Indicator.dart';
import 'package:hrtech/Preloader.dart';
import 'package:hrtech/Themes.dart';
import 'package:hrtech/models/EmployeeWorkTime.dart';
import 'package:hrtech/models/PayStats.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';


class PayStatsChart extends StatefulWidget {
  final int itemIndex;
  final String step;
  final OnRangeChangedCallback onRangeChangedCallback;

  const PayStatsChart({Key key, this.itemIndex, this.step, this.onRangeChangedCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PayStatsChartState();
}

class PayStatsChartState extends State<PayStatsChart> {
  final List<double> placeholderData = [7,8,7,6,8,8,6,7,8,7,7,8,7,6,8,8,6,7,8,7,7,8,7,6,8,8,6,7,8,7,6,8];
  final List<double> placeholderDataYear = [136,152,168, 175, 135, 167, 184, 168, 176, 176, 159, 183];
  final List<String> weekNamesAbbr = ['ПН','ВТ','СР','ЧТ','ПТ','СБ','ВС'];
  final List<String> monthNamesAbbr = ['Я','Ф','М','А','М','И','И','А','С','О','Н','Д'];
  final Duration animDuration = Duration(milliseconds: 250);
  final dateUtility = DateUtil();

  double intervalY;
  double rotateAngle;
  DateTime now;
  DateTime rangeStart;

  Future<PayStats> _employeePayStats;

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
      case 'month':
        rangeStart = new DateTime(now.year, now.month - widget.itemIndex, now.day);
        break;
      case 'year':
        rangeStart = new DateTime(now.year - widget.itemIndex, now.month, now.day);
        break;
    }
    _employeePayStats = ApiRequests.getEmployeePayStats(widget.step, rangeStart);
    widget.onRangeChangedCallback(_employeePayStats, widget.step, rangeStart);
  }

  //TODO при увеличении масштаба показывать самый левый столбик (год-месяц показывать январь, месяц-неделя показывать первую неделю)
  // при уменьшении показывать внутри (неделя-месяц показывать месяц начальной даты, месяц-год показывать тот год)

  Widget buildChart(AsyncSnapshot<PayStats> snapshot) {
    String catdTitle = "";
    switch (widget.step) {
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
    dynamic child = Container();
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      if (snapshot.data.error) {
        child = Center(child: Text('Нет данных', style: CustomTextStyles.bodyText18,),);
      }
      else {
        child = Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse.touchInput is FlLongPressEnd ||
                          pieTouchResponse.touchInput is FlPanEnd) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse.touchedSectionIndex;
                      }
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: showingSections(snapshot.data)
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: CustomColors.primaryColor,
                  text: 'Отработано',
                  textStyle: CustomTextStyles.bodyText14,
                  isSquare: true,
                ),
                SizedBox(
                  width: 16,
                ),
                Indicator(
                  color: CustomColors.primaryColorAccent,
                  text: 'Осталось',
                  textStyle: CustomTextStyles.bodyText14,
                  isSquare: true,
                ),
              ]
            ),
          ],
        );
      }
    }
    else {
      child = Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
              setState(() {
                if (pieTouchResponse.touchInput is FlLongPressEnd ||
                    pieTouchResponse.touchInput is FlPanEnd) {
                  touchedIndex = -1;
                } else {
                  touchedIndex = pieTouchResponse.touchedSectionIndex;
                }
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(null)
          ),
        ),
      );
    }
    return ChartCard(cardTitle: catdTitle, child: child, cardSubTitle: 'История выплат',);
  }

  List<PieChartSectionData> showingSections(PayStats payStats) {
    if (payStats == null) {
      return [
        PieChartSectionData(
          titlePositionPercentageOffset: 0.6,
          color: CustomColors.primaryColorAccent,
          value: 100,
          title: 'Загрузка',
          radius: 90,
          titleStyle:CustomTextStyles.bodyText18Bold
        ),
        PieChartSectionData(
          titlePositionPercentageOffset: 0.6,
          color: CustomColors.primaryColorAccent,
          value: 200,
          title: 'Загрузка',
          radius: 90,
          titleStyle:CustomTextStyles.bodyText18Bold
        )
      ];
    }
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 100 : 90;
      switch (i) {
        case 0:
          return PieChartSectionData(
            titlePositionPercentageOffset: 0.6,
            color: CustomColors.primaryColorAccent,
            value: payStats.totalHours - payStats.workHours,
            title: isTouched ? (payStats.totalHours - payStats.workHours).toString() + ' ч.':
              (100 - payStats.workHours / payStats.totalHours * 100).toStringAsPrecision(2) + '%',
            radius: radius,
            titleStyle: isTouched ? CustomTextStyles.bodyText20Bold : CustomTextStyles.bodyText18Bold
          );
        case 1:
          return PieChartSectionData(
            color: CustomColors.primaryColor,
            value: payStats.workHours,
            title: isTouched ? payStats.workHours.toString() + ' ч.':
              (payStats.workHours / payStats.totalHours * 100).toStringAsPrecision(2) + '%',
            radius: radius,
            titleStyle: isTouched ? CustomTextStyles.bodyText20Bold : CustomTextStyles.bodyText18Bold
          );
        default:
          return null;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _employeePayStats,
      builder: (context, snapshot) => buildChart(snapshot),
    );
  }
}

typedef OnRangeChangedCallback(Future<PayStats> futurePayStats, String step, DateTime startDate);