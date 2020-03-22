import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/PayStatsChart.dart';
import 'package:hrtech/Themes.dart';
import 'package:hrtech/models/PayStats.dart';
import 'package:shimmer/shimmer.dart';

class PayStatsPage extends StatefulWidget {
  @override
  _PayStatsPageState createState() => _PayStatsPageState();
}

class _PayStatsPageState extends State<PayStatsPage> {
  Future<PayStats> _payStats;
  PayStats _payStatsData;
  int _current = 0;
  List<bool> isSelected;
  bool updated = false;
  var textInfoGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    _payStats = ApiRequests.getEmployeePayStats('month', DateTime.now());
    isSelected = [false, true];
  }

  _update(Future<PayStats> futurePayStats, String step, DateTime startDate) {
    // _payStats = futurePayStats;
    updated = true;
    _payStats = ApiRequests.getEmployeePayStats(step, startDate);
    print(step);
    print(startDate);
  }

  _buildTextInfo(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[                            
                    Expanded(
                      child: AutoSizeText('Часов отработано:', style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                      ),
                    _payStatsData == null ? Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: AutoSizeText('123.45', style: CustomTextStyles.bodyText18White, group: textInfoGroup,),
                    ) : AutoSizeText(_payStatsData.workHours.toString(), style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[                            
                    Expanded(
                      child: AutoSizeText('Рабочих часов:', style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                      ),
                    _payStatsData == null ? Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: AutoSizeText('123.45', style: CustomTextStyles.bodyText18White, group: textInfoGroup,),
                    ) : AutoSizeText(_payStatsData.totalHours.toString(), style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[                            
                    Expanded(
                      child: AutoSizeText('Оклад:', style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                      ),
                    _payStatsData == null ? Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: AutoSizeText('123.45', style: CustomTextStyles.bodyText18White, group: textInfoGroup,),
                    ) : AutoSizeText(_payStatsData.salary.toString(), style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[                            
                    Expanded(
                      child: AutoSizeText('Итого:', style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                      ),
                    _payStatsData == null ? Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: AutoSizeText('123.45', style: CustomTextStyles.bodyText18White, group: textInfoGroup,),
                    ) : AutoSizeText(_payStatsData.pay.toString(), style: CustomTextStyles.bodyText18White, group: textInfoGroup,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStepPicker() {
    var size = MediaQuery.of(context).size;
    return Align(
      heightFactor: 1.0,
      alignment: Alignment.center,
      child: Container(
        // color: CustomColors.secondaryColor,
        decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), 
            topRight: Radius.circular(20.0)
          )
        ),
        child: ToggleButtons(
          borderWidth: 1,
          borderColor: CustomColors.backgroundColor,
          selectedBorderColor: CustomColors.backgroundColor,
          selectedColor: CustomColors.backgroundColor,
          fillColor: CustomColors.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), 
            topRight: Radius.circular(20.0)
          ),
          children: <Widget>[
            Container(
              width: (size.width - 3) / 2,
              child: Center(child: Text('Год', style: CustomTextStyles.bodyText18,))
            ),
            Container(
              width: (size.width - 3) / 2,
              child: Center(child: Text('Месяц', style: CustomTextStyles.bodyText18,))
            ),
          ], 
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
            });
          },
          isSelected: isSelected,
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, int itemIndex) {
    print('building $itemIndex');
    String step;
    switch (isSelected.indexOf(true)) {
      case 0: step = 'year'; break;
      case 1: step = 'month'; break;
    }
    return PayStatsChart(itemIndex: itemIndex, step: step, onRangeChangedCallback: _update,);
  }

  _buildChart(BuildContext context, PayStats asyncSnapshot) {
    return Expanded(
      flex: 13,
      child: CarouselSlider.builder(
        height: double.infinity,
        enableInfiniteScroll: false,
        // aspectRatio:  size.width / (size.height - 150-50-50), // 105 - высота нижнего меню, 50 - отступ с 2 сторон
        itemCount: 15,
        reverse: true,
        
        viewportFraction: 1.0,
        itemBuilder: (BuildContext context, int itemIndex) => _buildPage(context, itemIndex),
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }

  Column buildPage(BuildContext context, AsyncSnapshot<PayStats> asyncSnapshot) {
    // _payStatsData = PayStats(error: true);
    if (asyncSnapshot.connectionState == ConnectionState.done && asyncSnapshot.hasData && updated) {
      updated = false;
      _payStatsData = asyncSnapshot.data;
    }
    return Column(
    children: <Widget>[
      _buildTextInfo(context),
      buildStepPicker(),
      _buildChart(context, _payStatsData),
      SizedBox(
        height: 75,
      )
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
