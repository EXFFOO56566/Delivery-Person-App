import 'package:flutter/material.dart';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';
import 'package:active_flutter_delivery_app/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:active_flutter_delivery_app/screens/main.dart';
import 'package:active_flutter_delivery_app/screens/profile_edit.dart';
import 'package:active_flutter_delivery_app/screens/completed_delivery.dart';
import 'package:active_flutter_delivery_app/screens/pending.dart';
import 'package:active_flutter_delivery_app/screens/collection.dart';
import 'package:active_flutter_delivery_app/screens/cancelled_delivery.dart';
import 'package:active_flutter_delivery_app/screens/login.dart';

import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';
import 'package:active_flutter_delivery_app/app_config.dart';
import 'package:active_flutter_delivery_app/helpers/auth_helper.dart';
import 'package:active_flutter_delivery_app/custom/toast_component.dart';
import 'package:toast/toast.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {


  onTapLogout(context) async {
    AuthHelper().clearUserData();

    /*
    var logoutResponse = await AuthRepository()
            .getLogoutResponse();


    if(logoutResponse.result == true){
         ToastComponent.showDialog(logoutResponse.message, context,
                   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
         }
         */
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              is_logged_in.value == true
                  ? ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      AppConfig.BASE_PATH + "${avatar_original.value}",
                    ),
                  ),
                  title: Text("${user_name.value}"),
                  subtitle:
                  user_email.value != "" && user_email.value != null
                      ? Text("${user_email.value}")
                      : Text("${user_phone.value}"))
                  : Text('Not logged in',
                  style: TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1),
                      fontSize: 14)),
              Divider(),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/dashboard.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('Dashboard',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return Main();
                        }));
                  }),
              is_logged_in.value == true
                  ? ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/tick_circle.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('Completed Delivery',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CompletedDelivery(show_back_button: true);
                        }));
                  })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/clock_circle.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('Pending Delivery',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return Pending();
                        }));
                  })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/cross_circle.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('Cancelled Delivery',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CancelledDelivery(show_back_button: true);
                        }));
                  })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/dollar_circle.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('My Collection',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return Collection(show_back_button: true);
                        }));
                  })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/profile.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('Profile',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return Profile(show_back_button: true);
                        }));*/
                  })
                  : Container(),
              Divider(),
              is_logged_in.value == false
                  ? ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/login.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('Login',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                  })
                  : Container(),
              is_logged_in.value == true
                  ? ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Image.asset("assets/logout.png",
                      height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                  title: Text('Logout',
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 14)),
                  onTap: () {
                    onTapLogout(context);
                  })
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}


