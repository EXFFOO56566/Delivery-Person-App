import 'package:active_flutter_delivery_app/app_config.dart';
import 'package:active_flutter_delivery_app/data_model/profile_image_update_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_flutter_delivery_app/data_model/profile_update_response.dart';

import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {


  Future<ProfileUpdateResponse> getProfileUpdateResponse(
       @required String name,@required String password) async {

    var post_body = jsonEncode({"id":"${user_id.value}","name": "${name}", "password": "$password"});

    final response = await http.post("${AppConfig.BASE_URL}/profile/update",
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"},body: post_body );

    //print(response.body.toString());
    return profileUpdateResponseFromJson(response.body);
  }

  Future<ProfileImageUpdateResponse> getProfileImageUpdateResponse(
      @required String image,@required String filename) async {

    var post_body = jsonEncode({"id":"${user_id.value}","image": "${image}", "filename": "$filename"});
    //print(post_body.toString());

    final response = await http.post("${AppConfig.BASE_URL}/profile/update-image",
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.value}"},body: post_body );

    //print(response.body.toString());
    return profileImageUpdateResponseFromJson(response.body);
  }

}
