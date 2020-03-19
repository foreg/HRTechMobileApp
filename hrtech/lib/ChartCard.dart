import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/Themes.dart';

class ChartCard extends StatelessWidget {
  final String cardTitle;
  final String cardSubTitle;
  final Widget child;

  const ChartCard({Key key, this.cardTitle, this.cardSubTitle, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0), 
          bottomRight: Radius.circular(20.0)
        )
      ),
      color: CustomColors.secondaryColor,
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
                  cardTitle,
                  style: CustomTextStyles.headerText24Bold,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  cardSubTitle,
                  style: CustomTextStyles.bodyText18,
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: child,
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}