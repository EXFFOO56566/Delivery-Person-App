import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:shared_value/shared_value.dart';
import 'package:active_flutter_delivery_app/screens/splash.dart';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';
import 'package:active_flutter_delivery_app/repositories/auth_repository.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  fetch_user() async{
    var userByTokenResponse =
    await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.value  = true;
      user_id.value = userByTokenResponse.id;
      user_name.value = userByTokenResponse.name;
      user_email.value = userByTokenResponse.email;
      user_phone.value = userByTokenResponse.phone;
      avatar_original.value = userByTokenResponse.avatar_original;
    }
  }
  access_token.load().whenComplete(() {
    fetch_user();
  });


  //set dummy login data --start
/*  fetch_dummy_user() async{
    await Future.delayed(const Duration(seconds: 1), (){
      is_logged_in.value  =  true;
      user_id.value =  132;
      user_name.value =  "Asad Hossain";
      user_email.value =  "asad@mail.com";
      user_phone.value =  "+001 8313566543";
      avatar_original.value =  "uploads/users/9jZHYk9eIk0DfDi2Od4wi4GIXRZfv9JDpqjceHhg.jpeg";
    });so
  }
  fetch_dummy_user();*/

  //set dummy login data -- end



  /*is_logged_in.load();
  user_id.load();
  avatar_original.load();
  user_name.load();
  user_email.load();
  user_phone.load();*/

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));


  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Active Ecommerce Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyTheme.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: MyTheme.accent_color,
        /*textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(fontSize: 12.0),
          )*/
        //
        // the below code is getting fonts from http
        textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1),
          bodyText2: GoogleFonts.sourceSansPro(
              textStyle: textTheme.bodyText2, fontSize: 12),
        ),
      ),
      home: Splash(),
      //home: Main(),
    );
  }
}


