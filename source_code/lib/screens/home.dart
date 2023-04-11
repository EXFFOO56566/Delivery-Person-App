import 'package:flutter/material.dart';
import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:active_flutter_delivery_app/helpers/connectivity_helper.dart';
import 'package:active_flutter_delivery_app/ui_sections/drawer.dart';
import 'package:active_flutter_delivery_app/screens/completed_delivery.dart';
import 'package:active_flutter_delivery_app/screens/cancelled_delivery.dart';
import 'package:active_flutter_delivery_app/screens/collection.dart';
import 'package:active_flutter_delivery_app/screens/earnings.dart';
import 'package:active_flutter_delivery_app/screens/pending.dart';
import 'package:active_flutter_delivery_app/helpers/auth_helper.dart';
import 'package:active_flutter_delivery_app/repositories/dashboard_repository.dart';
import 'package:active_flutter_delivery_app/screens/login.dart';
import 'package:active_flutter_delivery_app/helpers/shared_value_helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _mainScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //init
  String _completed_delivery = ". . .";
  String _pending_delivery = ". . .";
  String _total_collection = ". . .";
  String _total_earning = ". . .";
  String _cancelled = ". . .";
  String _on_the_way = ". . .";
  String _picked = ". . .";
  String _assigned = ". . .";

  @override
  void initState() {
    // TODO: implement initState


    super.initState();

    ConnectivityHelper().abortIfNotConnected(context, onPop);

   /* if (is_logged_in.value == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }*/
    fetchSummary();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  fetchSummary() async {
    var dashboardSummaryResponse =
    await DashboardRepository().getDashboardSummaryResponse();

    if (dashboardSummaryResponse != null) {
      _completed_delivery = dashboardSummaryResponse.completed_delivery.toString();
      _pending_delivery = dashboardSummaryResponse.pending_delivery.toString();
      _total_collection = dashboardSummaryResponse.total_collection;
      _total_earning = dashboardSummaryResponse.total_earning;
      _cancelled = dashboardSummaryResponse.cancelled.toString();
      _on_the_way = dashboardSummaryResponse.on_the_way.toString();
      _picked = dashboardSummaryResponse.picked.toString();
      _assigned = dashboardSummaryResponse.assigned.toString();
      setState(() {});
    }
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchSummary();
  }

  reset() {
    _completed_delivery = ". . .";
    _pending_delivery = ". . .";
    _total_collection = ". . .";
    _total_earning = ". . .";
    _cancelled = ". . .";
    _on_the_way = ". . .";
    _picked = ". . .";
    _assigned = ". . .";
    
    setState(() {
      
    });
  }

  onPop(value) {
    ConnectivityHelper().abortIfNotConnected(context, onPop);
    reset();
    fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(context),
        key: _scaffoldKey,
        drawer: MainDrawer(),
        body: buildBody(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Builder(
          builder: (context) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
            child: Container(
              child: Image.asset(
                "assets/hamburger.png",
                height: 16,
                //color: MyTheme.dark_grey,
                color: MyTheme.grey_153,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        "Dashboard",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      backgroundColor: Color.fromRGBO(39, 38, 43, 1),
      actions: <Widget>[],
    );
  }

  buildBody(context) {
    return RefreshIndicator(
      color: MyTheme.accent_color,
      backgroundColor: Colors.white,
      onRefresh: _onPageRefresh,
      child: CustomScrollView(
        controller: _mainScrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              buildTopContainer(),
              buildSecondContainer(),
              buildHomeMenuRow(context)
            ]),
          ),
        ],
      ),
    );
  }

  buildTopContainer() {
    return Container(
      width: double.infinity,
      height: 350,
      color: Color.fromRGBO(39, 38, 43, 1),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CompletedDelivery(
                        show_back_button: true,
                      );
                    })).then((value) {
                      onPop(value);
                    });
                  },
                  child: Container(
                    height: 145,
                    width: 170,
                    decoration: BoxDecoration(
                        color: MyTheme.lime,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/delivery_moving.png",
                                color: Colors.grey.shade300,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Completed Delivery",
                            style: TextStyle(color: Colors.grey.shade300),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _completed_delivery,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Pending();
                    })).then((value) {
                      onPop(value);
                    });
                  },
                  child: Container(
                    height: 145,
                    width: 170,
                    decoration: BoxDecoration(
                        color: MyTheme.red,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/clock.png",
                                color: Colors.grey.shade300,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Pending Delivery",
                            style: TextStyle(color: Colors.grey.shade300),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _pending_delivery,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Collection(
                        show_back_button: true,
                      );
                    })).then((value) {
                      onPop(value);
                    });
                  },
                  child: Container(
                    height: 145,
                    width: 170,
                    decoration: BoxDecoration(
                        color: MyTheme.orange,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/delivery_moving.png",
                                color: Colors.grey.shade300,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Total Collected",
                            style: TextStyle(color: Colors.grey.shade300),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _total_collection,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Earnings(
                        show_back_button: true,
                      );
                    })).then((value) {
                      onPop(value);
                    });
                  },
                  child: Container(
                    height: 145,
                    width: 170,
                    decoration: BoxDecoration(
                        color: MyTheme.blue,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                "assets/dollar.png",
                                color: Colors.grey.shade300,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Earnings",
                            style: TextStyle(color: Colors.grey.shade300),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _total_earning,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildSecondContainer() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CancelledDelivery(show_back_button: true);
        }));
      },
      child: Container(
        width: double.infinity,
        height: 70,
        color: MyTheme.red,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                height: 28,
                width: 28,
                child: Image.asset(
                  "assets/cross_in_a_box.png",
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Cancelled Delivery",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: Text(
                _cancelled,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildHomeMenuRow(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Pending(
                  index: 0,
                );
              })).then((value) {
                onPop(value);
              });
            },
            child: Column(
              children: [
                Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: MyTheme.red,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        "assets/human_run.png",
                        color: Colors.white,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "On The Way (${_on_the_way})",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: MyTheme.red,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Pending(
                  index: 1,
                );
              })).then((value) {
                onPop(value);
              });
            },
            child: Column(
              children: [
                Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: MyTheme.golden,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        "assets/press.png",
                        color: Colors.white,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Picked (${_picked})",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: MyTheme.golden,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Pending(
                  index: 2,
                );
              })).then((value) {
                onPop(value);
              });
            },
            child: Column(
              children: [
                Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: MyTheme.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        "assets/sandclock.png",
                        color: Colors.white,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Assigned (${_assigned})",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: MyTheme.blue,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
