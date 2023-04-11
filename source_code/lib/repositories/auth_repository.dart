import 'package:active_flutter_delivery_app/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_flutter_delivery_app/data_model/login_response.dart';
import 'package:active_flutter_delivery_app/data_model/logout_response.dart';
import 'package:active_flutter_delivery_app/data_model/user_by_token.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    var post_body = jsonEncode({"user_type": "delivery_boy","email": "${email}", "password": "$password"});

    final response = await http.post("${AppConfig.BASE_URL}/auth/login",
        headers: {"Content-Type": "application/json","X-Requested-With":"XMLHttpRequest"}, body: post_body);
    print(response.body);
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/auth/logout",
      headers: {
        "Authorization": "Bearer ${access_token.value}"
      },
    );



    return logoutResponseFromJson(response.body);
  }


  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.value}"});

    final response = await http.post(
        "${AppConfig.BASE_URL}/get-user-by-access_token",
        headers: {"Content-Type": "application/json"},
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }
}
