import 'package:flutter/material.dart';
import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:active_flutter_delivery_app/app_config.dart';
import 'package:flutter/services.dart';
import 'package:active_flutter_delivery_app/custom/input_decorations.dart';
import 'package:active_flutter_delivery_app/custom/intl_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_flutter_delivery_app/addon_config.dart';
import 'package:active_flutter_delivery_app/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_flutter_delivery_app/repositories/auth_repository.dart';
import 'package:active_flutter_delivery_app/helpers/auth_helper.dart';
import 'package:active_flutter_delivery_app/screens/main.dart';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US',dialCode: "+1");
  String _phone = "";

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    /*if (is_logged_in.value == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }*/
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog("Enter email", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog("Enter phone number", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password == "") {
      ToastComponent.showDialog("Enter password", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : _phone, password);

    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      //print('dd');
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      AuthHelper().setUserData(loginResponse);
      if(is_logged_in.value == true){

        Future.delayed(const Duration(seconds: 1), (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
        });




      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: MyTheme.splash_login_screen_color,
        body: buildBody(context),
      ),
    );

  }


  buildBody(context){
    final _screen_width = MediaQuery.of(context).size.width * (1);
    return Stack(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: _screen_width * (3/4),
          child:Image.asset("assets/splash_login_background_logo.png",color: Color.fromRGBO(225,225,225, .1),),
        ),

      ),
      Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(top: 75,),
                 child: Container(width:75,child: Image.asset("assets/delivery_app_logo.png")),
              ),

              Padding(
                padding: const EdgeInsets.only(top:20,bottom: 0.0,),
                child: Text(
                  "Login to ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:0,bottom: 50.0,),
                child: Text(
                  AppConfig.app_name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),

              Container(
                width: _screen_width * (3 / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        _login_by == "email" ? "Email" : "Phone",
                        style: TextStyle(
                            color: MyTheme.golden,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (_login_by == "email")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              child: TextField(
                                style: TextStyle(color: Colors.white70),
                                controller: _emailController,
                                autofocus: false,
                                decoration:
                                InputDecorations.buildInputDecoration_1(
                                    hint_text: "johndoe@example.com"),
                              ),
                            ),
                            AddonConfig.otp_addon_installed
                                ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _login_by = "phone";
                                });
                              },
                              child: Text(
                                "or, Login with a phone number",
                                style: TextStyle(
                                    color: MyTheme.golden,
                                    fontStyle: FontStyle.italic,
                                    decoration:
                                    TextDecoration.underline),
                              ),
                            )
                                : Container()
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              child: CustomInternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  setState(() {
                                    _phone = number.phoneNumber;
                                  });
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle:
                                TextStyle(color: MyTheme.font_grey),
                                textStyle: TextStyle(color: Colors.white54),
                                initialValue: phoneCode,
                                textFieldController: _phoneNumberController,
                                formatInput: true,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                inputDecoration: InputDecorations
                                    .buildInputDecoration_phone(
                                    hint_text: "01710 333 558"),
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _login_by = "email";
                                });
                              },
                              child: Text(
                                "or, Login with an email",
                                style: TextStyle(
                                    color: MyTheme.golden,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        "Password",
                        style: TextStyle(
                            color: MyTheme.golden,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 36,
                            child: TextField(
                              controller: _passwordController,
                              autofocus: false,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(color: Colors.white70),
                              decoration:
                              InputDecorations.buildInputDecoration_1(
                                  hint_text: "• • • • • • • •"),
                            ),
                          ),
                          /*GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return PasswordForget();
                                  }));
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: MyTheme.golden,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline),
                            ),
                          )*/
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: MyTheme.textfield_grey, width: 1),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(12.0))),
                        child: FlatButton(
                          minWidth: MediaQuery.of(context).size.width,
                          //height: 50,
                          color: MyTheme.golden,
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            onPressedLogin();
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Padding(padding: const EdgeInsets.only(top: 10,),
                child: Text("If you are finding any problem while logging in ",style: TextStyle(fontSize: 14,color:Colors.cyanAccent ),),
              ),
              Padding(padding: const EdgeInsets.only(top: 0,),
                child: Text("please contact the admin",style: TextStyle(fontSize: 14,color:Colors.cyanAccent ),),
              ),

            ],
          ),
        ),
      )

    ],);
  }
}
