// To parse this JSON data, do
//
//     final earningSummaryResponse = earningSummaryResponseFromJson(jsonString);

import 'dart:convert';

EarningSummaryResponse earningSummaryResponseFromJson(String str) => EarningSummaryResponse.fromJson(json.decode(str));

String earningSummaryResponseToJson(EarningSummaryResponse data) => json.encode(data.toJson());

class EarningSummaryResponse {
  EarningSummaryResponse({
    this.today_date,
    this.today_earning,
    this.yesterday_date,
    this.yesterday_earning,
  });

  String today_date;
  String today_earning;
  String yesterday_date;
  String yesterday_earning;

  factory EarningSummaryResponse.fromJson(Map<String, dynamic> json) => EarningSummaryResponse(
    today_date: json["today_date"],
    today_earning: json["today_earning"],
    yesterday_date: json["yesterday_date"],
    yesterday_earning: json["yesterday_earning"],
  );

  Map<String, dynamic> toJson() => {
    "today_date": today_date,
    "today_earning": today_earning,
    "yesterday_date": yesterday_date,
    "yesterday_earning": yesterday_earning,
  };
}
