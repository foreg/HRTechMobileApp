import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hrtech/Themes.dart';
import 'package:hrtech/WorkTimeChart.dart';

class WorkTime extends StatefulWidget {
  @override
  _WorkTimeState createState() => _WorkTimeState();
}

class _WorkTimeState extends State<WorkTime> {
  int _current = 0;
  List<bool> isSelected;

  @override
  void initState(){
    super.initState();
    isSelected = [false, false, true];
  }


  Widget buildCarouselSlider(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      flex: 1,
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

  Widget _buildPage(BuildContext context, int itemIndex) {
    print('building $itemIndex');
    String step;
    switch (isSelected.indexOf(true)) {
      case 0: step = 'year'; break;
      case 2: step = 'week'; break;
      case 1: step = 'month'; break;
    }
    return WorkTimeChart(itemIndex: itemIndex, step: step);
  }

  Row buildDots() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<int>.generate(15, (i) => i).map( (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)
            ),
          );
        }).toList(),
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
              width: (size.width - 4) / 3,
              child: Center(child: Text('Год', style: CustomTextStyles.bodyText18,))
            ),
            Container(
              width: (size.width - 4) / 3,
              child: Center(child: Text('Месяц', style: CustomTextStyles.bodyText18,))
            ),
            Container(
              width: (size.width - 4) / 3,
              child: Center(child: Text('Неделя', style: CustomTextStyles.bodyText18,))
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

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        buildStepPicker(),
        buildCarouselSlider(context),
        const SizedBox(
          height: 75,
        ),
        //buildDots()
      ],
    );
  }
}