import 'package:active_flutter_delivery_app/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:active_flutter_delivery_app/data_model/order_detail_response.dart';
import 'package:active_flutter_delivery_app/data_model/order_item_response.dart';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';

class OrderRepository {


  Future<OrderDetailResponse> getOrderDetails(
      {@required int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-details/" +
        id.toString();


    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderDetailResponseFromJson(response.body);
  }

  Future<OrderItemResponse> getOrderItems(
      {@required int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-items/" +
        id.toString();


    final response = await http.get(url);
    //print("url:" +url.toString());
    return orderItemlResponseFromJson(response.body);
  }
}
