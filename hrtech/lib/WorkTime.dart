import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hrtech/BarChart.dart';

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


  CarouselSlider buildCarouselSlider(BuildContext context) {
    return CarouselSlider.builder(
      enableInfiniteScroll: false,
      aspectRatio: 1.0,
      itemCount: 15,
      reverse: true,
      
      viewportFraction: 1.0,
      itemBuilder: (BuildContext context, int itemIndex) => _buildPage(context, itemIndex),
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: WorkTimeChart(itemIndex: itemIndex, step: step),
    );
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
    return Align(
      alignment: Alignment.centerRight,
      child: ToggleButtons(
        children: <Widget>[
          Text('Год'),
          Text('Месяц'),
          Text('Неделя'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildStepPicker(),
        buildCarouselSlider(context),
        //buildDots()
      ],
    );
  }
}