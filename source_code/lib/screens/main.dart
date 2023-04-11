import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:active_flutter_delivery_app/screens/home.dart';
import 'package:active_flutter_delivery_app/screens/completed_delivery.dart';
import 'package:active_flutter_delivery_app/screens/earnings.dart';
import 'package:active_flutter_delivery_app/screens/profile_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:active_flutter_delivery_app/screens/login.dart';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  var _children = [
    Home(),
    CompletedDelivery(),
    Earnings(),
    ProfileEdit()
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


  }

  onPop(value) {

  }

  @override
  Widget build(BuildContext context) {
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
                    "assets/dashboard.png",
                    color: _currentIndex == 0
                        ? Theme
                        .of(context)
                        .accentColor
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/delivery.png",
                    color: _currentIndex == 1
                        ? Theme
                        .of(context)
                        .accentColor
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "My Delivery",
                      style: TextStyle(fontSize: 12),
                    ),
                  )),

              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/earnings.png",
                    color: _currentIndex == 2
                        ? Theme
                        .of(context)
                        .accentColor
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "My Earnings",
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/profile.png",
                    color: _currentIndex == 3
                        ? Theme
                        .of(context)
                        .accentColor
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Profile",
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
