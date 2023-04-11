import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:active_flutter_delivery_app/screens/on_the_way_delivery.dart';
import 'package:active_flutter_delivery_app/screens/picked_delivery.dart';
import 'package:active_flutter_delivery_app/screens/assigned_delivery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class Pending extends StatefulWidget {

  Pending({Key key,  this.index = 0}) : super(key: key);

  int index;

  @override
  _PendingState createState() => _PendingState(given_index: this.index);
}

class _PendingState extends State<Pending> {

  _PendingState({this.given_index});
  int given_index;

  int _currentIndex ;
  var _children = [
    OnTheWayDelivery(show_back_button: true,),
    PickedDelivery(show_back_button: true,),
    AssignedDelivery(show_back_button: true,),
  ];

  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();

    _currentIndex = given_index;

  }

  onPop(value) {

  }

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //specify the location of the FAB
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white.withOpacity(0.8),
            fixedColor: Theme
                .of(context)
                .accentColor,
            unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/human_run.png",
                    color: _currentIndex == 0
                        ? MyTheme.red
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "On the Way",
                      style: TextStyle(fontSize: 12,color: _currentIndex == 0
                          ? MyTheme.red
                          : Color.fromRGBO(153, 153, 153, 1),),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/press.png",
                    color: _currentIndex == 1
                        ? MyTheme.golden
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Picked",
                      style: TextStyle(fontSize: 12,color: _currentIndex == 1
                      ? MyTheme.golden
                          : Color.fromRGBO(153, 153, 153, 1),),
                    ),
                  )),

              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/sandclock.png",
                    color: _currentIndex == 2
                        ? MyTheme.blue
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Assigned",
                      style: TextStyle(fontSize: 12,color: _currentIndex == 2
                          ? MyTheme.blue
                          : Color.fromRGBO(153, 153, 153, 1),),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
