// To parse this JSON data, do
//
//     final deliveryStatusChangeResponse = deliveryStatusChangeResponseFromJson(jsonString);

import 'dart:convert';

DeliveryStatusChangeResponse deliveryStatusChangeResponseFromJson(String str) => DeliveryStatusChangeResponse.fromJson(json.decode(str));

String deliveryStatusChangeResponseToJson(DeliveryStatusChangeResponse data) => json.encode(data.toJson());

class DeliveryStatusChangeResponse {
  DeliveryStatusChangeResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory DeliveryStatusChangeResponse.fromJson(Map<String, dynamic> json) => DeliveryStatusChangeResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}