import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/Routes.dart';
import 'package:hrtech/Themes.dart';
import 'package:hrtech/models/Reason.dart';

class ExplanationLetter extends StatefulWidget {
  @override
  _ExplanationLetterState createState() => _ExplanationLetterState();
}

class _ExplanationLetterState extends State<ExplanationLetter> {
  int selectedReason = 0;
  // List<String> data = ['sfrgh', 'wef'];
  Future<List<Reason>> _reasons;
  List<Reason> originalReasons;
  List<String> data;

  final myController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<DirectSelectItemState> directSelectItemStateKey = GlobalKey();
  final GlobalKey<DirectSelectContainerState> directSelectContainerKey = GlobalKey();

  @override
  void initState() {
    _reasons = ApiRequests.getReasons();
    super.initState();
  }

  DirectSelectItem<String> _getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        // key: ValueKey(new DateTime.now()),
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value, style: CustomTextStyles.bodyText18,);
        });
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  _showHint() {
    final snackBar = SnackBar(content: Text('Удерживайте и потяните вместо касания'));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _send(context) {
    var reasonId = originalReasons.firstWhere((r) => r.name == data[selectedReason]).id;
    ApiRequests.addExplanationLetter(myController.text, reasonId).then( (_) {
      Routes.home(context);
    });
  }

  DirectSelectContainer buildDirectSelectContainer(BuildContext context, AsyncSnapshot<List<Reason>> snapshot) {
    // data = ['1', '2'];
    
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      // data = null;
      originalReasons = snapshot.data;
      data = snapshot.data.map((r) => r.name).toList();
    }
    return DirectSelectContainer(
      key: directSelectContainerKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              // SizedBox(height: 20.0),
              Container(
                // padding: const EdgeInsets.only(left: 8.0),
                alignment: AlignmentDirectional.centerStart,
                // margin: EdgeInsets.only(left: 4),
                child: Column(
                  children: <Widget>[
                    Text('Создание объяснительной', style: CustomTextStyles.headerText26White)
                  ],
                )
              ),
              SizedBox(height: 40.0),
              Container(
                // padding: const EdgeInsets.only(left: 8.0),
                alignment: AlignmentDirectional.centerStart,
                // margin: EdgeInsets.only(left: 4),
                child: Text('Выберите причину:', style: CustomTextStyles.bodyText18White,)
              ),
              SizedBox(height: 8.0),
              Container(
                // decoration: _getShadowDecoration(),
                child: Card(
                  color: CustomColors.secondaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          child: DirectSelectList<String>(
                            key: ValueKey(new DateTime.now()),
                            values: data == null ? ['Список причин загружается..'] : data,
                            defaultItemIndex: selectedReason,
                            itemBuilder: (String value) => _getDropDownMenuItem(value),
                            focusedItemDecoration: _getDslDecoration(),
                            onItemSelectedListener: (item, index, context) {
                              setState(() {
                                selectedReason = index;
                              });
                            },
                            onUserTappedListener: () => _showHint(),
                            ),
                          padding: EdgeInsets.only(left: 22))
                        ),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.arrow_drop_down, color: CustomColors.backgroundColor,),
                      )
                    ],
                  )
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                // padding: const EdgeInsets.only(left: 8.0),
                alignment: AlignmentDirectional.centerStart,
                // margin: EdgeInsets.only(left: 4),
                child: Text('Опишите подробнее:', style: CustomTextStyles.bodyText18White,)
              ),
              SizedBox(height: 8.0),
              Container(
                // padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                alignment: AlignmentDirectional.centerStart,
                // margin: EdgeInsets.only(left: 4),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                        color: CustomColors.primaryColor
                      )
                    ),
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                        width: 2,
                        color: CustomColors.primaryColor
                      )
                    ),
                    filled: true,
                    fillColor: CustomColors.secondaryColor,
                    // border: InputBorder.none,
                  ),
                  style: CustomTextStyles.bodyText18,
                  cursorColor: CustomColors.primaryColor,
                  keyboardType: TextInputType.multiline,
                  maxLines: 13,
                )
              ),
              SizedBox(height: 50.0),
              GestureDetector(
                onTap: () => _send(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    color: CustomColors.primaryColor,
                    height: 70,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Center(
                      child: Text('Написать объяснительную', style: CustomTextStyles.bodyText20Bold,),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      key: scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0.0,
        title: new Text('Назад', style: CustomTextStyles.bodyText20,),
        backgroundColor: CustomColors.secondaryColor,
      ),
      body: FutureBuilder(
        future: _reasons,
        builder: (context, snapshot) => buildDirectSelectContainer(context, snapshot)),
    );
  }
}
