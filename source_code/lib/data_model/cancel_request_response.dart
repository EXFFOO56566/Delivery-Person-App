// To parse this JSON data, do
//
//     final cancelRequestResponse = cancelRequestResponseFromJson(jsonString);

import 'dart:convert';

CancelRequestResponse cancelRequestResponseFromJson(String str) => CancelRequestResponse.fromJson(json.decode(str));

String cancelRequestResponseToJson(CancelRequestResponse data) => json.encode(data.toJson());

class CancelRequestResponse {
  CancelRequestResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CancelRequestResponse.fromJson(Map<String, dynamic> json) => CancelRequestResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}