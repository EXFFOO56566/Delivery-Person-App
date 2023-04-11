import 'package:flutter/material.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text = "@ ActiveItZone " + this_year; //this shows in the splash screen
  static String app_name = "Active eCommerce Delivery App"; //this shows in the splash screen

  //configure this
  static const bool HTTPS = true;

  //configure this
  //static const DOMAIN_PATH = "192.168.0.108/ecommerce_demo_three";
  //static const DOMAIN_PATH = "demo.activeitzone.com/ecommerce_flutter_demo";
  static const DOMAIN_PATH = "shopme.transferpam.com";

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PUBLIC_FOLDER = "public";
  static const String DELIVERY_PREFIX = "delivery-boy";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";

  //configure this if you are using amazon s3 like services
  //give direct link to file like https://[[bucketname]].s3.ap-southeast-1.amazonaws.com/
  //otherwise do not change anythink
  static const String BASE_PATH = "${RAW_BASE_URL}/${PUBLIC_FOLDER}/";
}
