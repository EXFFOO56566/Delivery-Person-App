import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_flutter_delivery_app/screens/order_details.dart';

class SingleOrderMap extends StatefulWidget {
  SingleOrderMap({Key key, this.order, this.color = Colors.black54})
      : super(key: key);
  final order;
  Color color;

  @override
  _SingleOrderMapState createState() => _SingleOrderMapState();
}

class _SingleOrderMapState extends State<SingleOrderMap> {

   static LatLng _kMapCenter =
   LatLng(0,0);

  bool location_initialized = false;
  BitmapDescriptor customIcon;

  @override
  void initState() {
    //status bar transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
    initLocation();
    setCustomMarker();
    onPressCenterMap();
  }

  initLocation() {
    _kMapCenter = LatLng(widget.order.lat, widget.order.lang);

    CameraPosition _kInitialPosition =
        CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0.0, bearing: 0);
    location_initialized = true;
    print(widget.order.lat);
    setState(() {});
  }

  void setCustomMarker() async {
    print('dd');
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/delivery_map_icon.png');
    setState(() {});
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
          markerId: MarkerId(widget.order.id.toString()),
          position: _kMapCenter,
          infoWindow: InfoWindow(title: widget.order.code),
          icon: customIcon),
    };
  }

  GoogleMapController _controller;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);


  }

  onPressCenterMap() async {
    _controller.moveCamera(CameraUpdate.newLatLng(_kMapCenter));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          buildMapSection(),
          buildBackArrow(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildBottomContainer(),
          )
        ],
      ),
    );
  }

  buildBackArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () {
            return Navigator.of(context).pop();
          }),
    );
  }

  buildMapSection() {
    return Container(
      height: (MediaQuery.of(context).size.height - 184) + 10,
      child: location_initialized
          ? GoogleMap(
              initialCameraPosition: CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0.0, bearing: 0),
              myLocationEnabled: true,
              trafficEnabled: true,
              markers: _createMarker(),
              onMapCreated: _onMapCreated,
            )
          : Container(
              height: (MediaQuery.of(context).size.height - 184) + 10,
              child: Center(
                child: Text(
                  "Loading Map . . .",
                  style: TextStyle(color: Colors.red),
                ),
              )),
    );
  }

  buildBottomContainer() {
    return Container(
      height: 184,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.red,
            blurRadius: 4,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: MyTheme.white, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Code",
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        Text(
                          widget.order.code,
                          style: TextStyle(
                              color: widget.color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Text(widget.order.date,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 13)),
                        Spacer(),
                        Text(
                          widget.order.grand_total,
                          style: TextStyle(
                              color: widget.color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Status",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.order.payment_type,
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 13),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: buildPaymentStatusCheckContainer(
                                  widget.order.payment_status),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 4.0, right: 4.0, top: 4.0, bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0))),
                    child: FlatButton(
                      minWidth: (MediaQuery.of(context).size.width - 36) / 2,
                      //height: 50,
                      color: MyTheme.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.assignment_outlined,
                              size: 14,
                              color: MyTheme.font_grey,
                            ),
                          ),
                          Text(
                            "View Details",
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return OrderDetails(
                            id: widget.order.id,
                          );
                        })).then((value) {});
                      },
                    ),
                  ),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0))),
                    child: FlatButton(
                      minWidth: (MediaQuery.of(context).size.width - 36) / 2,
                      //height: 50,
                      color: MyTheme.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.fullscreen,
                              size: 14,
                              color: MyTheme.font_grey,
                            ),
                          ),
                          Text(
                            "Center Location",
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      onPressed: () {
                        onPressCenterMap();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            payment_status == "paid" ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }
}
