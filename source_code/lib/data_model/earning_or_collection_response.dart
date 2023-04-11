// To parse this JSON data, do
//
//     final earningOrCollectionResponse = earningOrCollectionResponseFromJson(jsonString);

import 'dart:convert';

EarningOrCollectionResponse earningOrCollectionResponseFromJson(String str) => EarningOrCollectionResponse.fromJson(json.decode(str));

String earningOrCollectionResponseToJson(EarningOrCollectionResponse data) => json.encode(data.toJson());

class EarningOrCollectionResponse {
  EarningOrCollectionResponse({
    this.data,
    this.meta,
    this.success,
    this.status,
  });

  List<Datum> data;
  Meta meta;
  bool success;
  int status;

  factory EarningOrCollectionResponse.fromJson(Map<String, dynamic> json) => EarningOrCollectionResponse(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
    "success": success,
    "status": status,
  };
}

class Datum {
  Datum({
    this.id,
    this.deliver_boy_id,
    this.order_id,
    this.order_code,
    this.delivery_status,
    this.paymentType,
    this.earning,
    this.collection,
    this.date,
  });

  int id;
  int deliver_boy_id;
  int order_id;
  String order_code;
  String delivery_status;
  String paymentType;
  String earning;
  String collection;
  String date;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    deliver_boy_id: json["delivery_boy_id"],
    order_id: json["order_id"],
    order_code: json["order_code"],
    delivery_status: json["delivery_status"],
    paymentType: json["payment_type"],
    earning: json["earning"],
    collection: json["collection"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "delivery_boy_id": deliver_boy_id,
    "order_id": order_id,
    "order_code": order_code,
    "delivery_status": delivery_status,
    "payment_type": paymentType,
    "earning": earning,
    "collection": collection,
    "date": date,
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}
