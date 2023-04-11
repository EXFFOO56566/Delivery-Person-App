import 'package:active_flutter_delivery_app/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_flutter_delivery_app/data_model/dashboard_summary_response.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';

class DashboardRepository {
  Future<DashboardSummaryResponse> getDashboardSummaryResponse() async {

    final response = await http.get("${AppConfig.BASE_URL}/${AppConfig.DELIVERY_PREFIX}/dashboard-summary/${user_id.value}",headers: { "Authorization": "Bearer ${access_token.value}"});

    /*print("body\n");
    print(response.body.toString());*/
    return dashboardSummaryResponseFromJson(response.body);
  }


}
