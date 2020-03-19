import 'package:flutter/material.dart';
import 'package:hrtech/CustomTimerPainter.dart';
import 'package:hrtech/Themes.dart';
import 'package:hrtech/models/ClockInOut.dart';

class CustomTimer extends StatefulWidget {
  ClockInOut clockInOut;
  OnTapCallback onTapCallback;

  CustomTimer({this.clockInOut, this.onTapCallback});
  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer>
    with TickerProviderStateMixin {
  AnimationController controller;
  Duration duration = Duration(hours: 8);

  String get timerString {
    Duration duration = controller.duration * controller.value;
    if (duration.inHours <= 0) {
      return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: duration,
    );
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => _onTap(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.center,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: CustomPaint(
                              painter: CustomTimerPainter(
                                animation: controller,
                                backgroundColor: CustomColors.secondaryColor,
                                color: CustomColors.primaryColor,
                              )
                            ),
                          ),
                          Align(
                            alignment: FractionalOffset.center,                            
                            child: getInsideCircleText(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // AnimatedBuilder(
                //   animation: controller,
                //   builder: (context, child) {
                //     return FloatingActionButton.extended(
                //       onPressed: () {
                //         if (controller.isAnimating)
                //           controller.stop();
                //         else {
                //           controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
                //         }
                //       },
                //       icon: Icon(controller.isAnimating ? Icons.pause : Icons.play_arrow),
                //       label: Text(controller.isAnimating ? "Pause" : "Play"));
                //   }
                // ),
              ],
            ),
          ),
        );
      }
    );
  }

  _onTap() {
    widget.onTapCallback();
    if (controller.isAnimating)
      controller.stop();
    // else {
    //   // controller.forward();
    //   controller.forward(from: controller.value == 1.0 ? 0.0 : controller.value);
    // }
  }

  Widget getInsideCircleText() {
    if (widget.clockInOut == null) {
      return Container();
    }
    if (widget.clockInOut.type) {
      controller.stop();
      var start = DateTime.now().difference(widget.clockInOut.checkTime).inMicroseconds / duration.inMicroseconds;
      controller.value = start;
      controller.forward(from: controller.value);
      return Text(timerString, style: CustomTextStyles.headerText96Inversed);
    }
    return Text('Начать работать', style: CustomTextStyles.headerText36Inversed);
  }
}

typedef void OnTapCallback();