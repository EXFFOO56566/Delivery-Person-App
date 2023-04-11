import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';
import 'package:active_flutter_delivery_app/screens/main.dart';
import 'package:active_flutter_delivery_app/screens/login.dart';
class AuthHelper {
  setUserData(loginResponse) {
    if (loginResponse.result == true) {
      is_logged_in.value = true;
      access_token.value = loginResponse.access_token;
      user_id.value = loginResponse.user.id;
      user_name.value = loginResponse.user.name;
      user_email.value = loginResponse.user.email;
      user_phone.value = loginResponse.user.phone;
      avatar_original.value = loginResponse.user.avatar_original;

    }
  }

  clearUserData() {
      is_logged_in.value = false;
      access_token.value = "";
      user_id.value = 0;
      user_name.value = "";
      user_email.value = "";
      user_phone.value = "";
      avatar_original.value = "";
  }

  ifNotLoggedIn(context) async {
    if (is_logged_in.value == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  ifLoggedIn(context) async {
    if (is_logged_in.value == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }
}
