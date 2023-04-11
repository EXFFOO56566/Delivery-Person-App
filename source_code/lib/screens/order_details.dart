import 'package:flutter/material.dart';
import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:active_flutter_delivery_app/repositories/order_repository.dart';
import 'package:active_flutter_delivery_app/helpers/shimmer_helper.dart';
import 'package:active_flutter_delivery_app/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_flutter_delivery_app/repositories/delivery_repository.dart';
import 'package:active_flutter_delivery_app/services/calls_and_messages_service.dart';


class OrderDetails extends StatefulWidget {
  int id;

  OrderDetails(
      {Key key,
      this.id,
      this.show_additional_section = false,
      })
      : super(key: key);

  final bool show_additional_section;

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScrollController _mainScrollController = ScrollController();
  var _steps = ['pending', 'confirmed', 'on_delivery', 'delivered'];
  final CallsAndMessagesService _callsAndMessagesService =
      CallsAndMessagesService();

  //init
  int _stepIndex = 0;
  var _orderDetails = null;
  List<dynamic> _orderedItemList = [];
  bool _orderItemsInit = false;

  @override
  void initState() {
    fetchAll();
    super.initState();

    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    //print(widget.id);
    fetchOrderDetails();
    fetchOrderedItems();
  }

  fetchOrderDetails() async {
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.detailed_orders.length > 0) {
      _orderDetails = orderDetailsResponse.detailed_orders[0];
      setStepIndex(_orderDetails.delivery_status);
    }

    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
        await OrderRepository().getOrderItems(id: widget.id);
    _orderedItemList.addAll(orderItemResponse.ordered_items);
    _orderItemsInit = true;

    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderedItemList.clear();
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPressCancel() {
    if (_orderDetails.cancel_request == true) {
      ToastComponent.showDialog("Cancel request is already send", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      return;
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  "Are you sure to request cancellation ?",
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  color: MyTheme.red,
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirmCancel();
                  },
                ),
              ],
            ));
  }

  onConfirmCancel() async {
    var cancelRequestResponse =
        await DeliveryRepository().getCancelRequestResponse(widget.id);

    if (cancelRequestResponse.result == true) {
      ToastComponent.showDialog(cancelRequestResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      reset();
      fetchAll();
    } else {
      ToastComponent.showDialog(cancelRequestResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  onPressMarkDelivered(){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.only(
              top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
          content: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Are you sure to mark this as delivered ?",
              maxLines: 3,
              style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
            ),
          ),
          actions: [
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: MyTheme.medium_grey),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              color: MyTheme.red,
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
                onConfirmMarkDelivered();
              },
            ),
          ],
        ));
  }

  onConfirmMarkDelivered() async{
    var deliveryStatusChangeResponse =
    await DeliveryRepository().getDeliveryStatusChangeResponse(status: "delivered",order_id: widget.id);

    if (deliveryStatusChangeResponse.result == true) {
      ToastComponent.showDialog(deliveryStatusChangeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      reset();
      fetchAll();
    } else {
      ToastComponent.showDialog(deliveryStatusChangeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        color: MyTheme.red,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _orderDetails != null
                      ? buildTimeLineTiles()
                      : buildTimeLineShimmer()),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _orderDetails != null
                    ? buildOrderDetailsTopCard()
                    : ShimmerHelper().buildBasicShimmer(height: 150.0),
              ),
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              Center(
                child: Text(
                  "Ordered Product",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _orderedItemList.length == 0 && _orderItemsInit
                      ? ShimmerHelper().buildBasicShimmer(height: 100.0)
                      : (_orderedItemList.length > 0
                          ? buildOrderdProductList()
                          : Container(
                              height: 100,
                              child: Text(
                                "No items are ordered",
                                style: TextStyle(color: MyTheme.font_grey),
                              ),
                            )))
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 75,
                    ),
                    buildBottomSection()
                  ],
                ),
              ),
              widget.show_additional_section
                  ? buildAdditionalSection()
                  : Container()
            ]))
          ],
        ),
      ),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            "SUB TOTAL",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.subtotal,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            "TAX",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.tax,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            "SHIPPING COST",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.shipping_cost,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            "DISCOUNT",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.coupon_discount,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            "GRAND TOTAL",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.grand_total,
                          style: TextStyle(
                              color: MyTheme.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildAdditionalSection() {
    if(_orderDetails!= null){
      print(_orderDetails.id);
      print(_orderDetails.delivery_status);
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _orderDetails != null
          ? (_orderDetails.delivery_status == "delivered" ||
                  _orderDetails.delivery_status == "cancelled"
              ? Container()
              : Column(
                  children: [
                    Container(
                      //height: 36,
                      width: (MediaQuery.of(context).size.width - 32),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(247, 189, 168, 1),
                          border: Border.all(color: MyTheme.red, width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _orderDetails.cancel_request == false
                            ? Row(
                                children: [
                                  Text(
                                    "Amount to Collect",
                                    style: TextStyle(
                                        color: MyTheme.red,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Text(
                                    _orderDetails.grand_total,
                                    style: TextStyle(
                                        color: MyTheme.red,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            : Center(
                                child: Text(
                                  "Requested for cancellation",
                                  style: TextStyle(
                                      color: MyTheme.red,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 32) *
                                (1 / 3),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: MyTheme.textfield_grey, width: 1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  topRight: const Radius.circular(0.0),
                                  bottomRight: const Radius.circular(0.0),
                                )),
                            child: FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              //height: 50,
                              color: _orderDetails.cancel_request == false
                                  ? MyTheme.red
                                  : MyTheme.red_disabled,
                              splashColor: _orderDetails.cancel_request == false
                                  ? MyTheme.light_grey
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(0.0),
                                bottomRight: const Radius.circular(0.0),
                              )),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressCancel();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 32) *
                                (2 / 3),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: MyTheme.textfield_grey, width: 1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(0.0),
                                  bottomLeft: const Radius.circular(0.0),
                                  topRight: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                )),
                            child: FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              //height: 50,
                              color: Color.fromRGBO(247, 189, 168, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(0.0),
                                bottomLeft: const Radius.circular(0.0),
                                topRight: const Radius.circular(8.0),
                                bottomRight: const Radius.circular(8.0),
                              )),
                              child: Text(
                                "Mark as delivered",
                                style: TextStyle(
                                    color: MyTheme.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressMarkDelivered();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  buildTimeLineTiles() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            isFirst: true,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Order placed",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Confirmed",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "On Delivery",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 3
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            isLast: true,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Delivered",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 3 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 3
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 3
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
        ],
      ),
    );
  }

  Card buildOrderDetailsTopCard() {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Order Code",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Shipping Method",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails.code,
                    style: TextStyle(
                        color: MyTheme.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.shipping_type_string,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Order Date",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Payment Method",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails.date,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.payment_type,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Payment Status",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Delivery Status",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails.payment_status_string,
                      style: TextStyle(
                        color: MyTheme.grey_153,
                      ),
                    ),
                  ),
                  buildPaymentStatusCheckContainer(
                      _orderDetails.payment_status),
                  Spacer(),
                  Text(
                    _orderDetails.delivery_status_string,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Shipping Address",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Total Amount",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - (32.0)) / 2,
                    // (total_screen_width - padding)/2
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _orderDetails.shipping_address.name != null
                            ? Text(
                                "Name: ${_orderDetails.shipping_address.name}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              )
                            : Container(),
                        _orderDetails.shipping_address.email != null
                            ? Text(
                                "Email: ${_orderDetails.shipping_address.email}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              )
                            : Container(),
                        Text(
                          "Address: ${_orderDetails.shipping_address.address}",
                          maxLines: 3,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          "City: ${_orderDetails.shipping_address.city}",
                          maxLines: 3,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          "Country: ${_orderDetails.shipping_address.country}",
                          maxLines: 3,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          "Phone: ${_orderDetails.shipping_address.phone}",
                          maxLines: 3,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          "Postal code: ${_orderDetails.shipping_address.postal_code}",
                          maxLines: 3,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.grand_total,
                    style: TextStyle(
                        color: MyTheme.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            _orderDetails.shipping_address.phone != null &&
                    _orderDetails.shipping_address.phone != ""
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          "Call to " + _orderDetails.shipping_address.phone,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: RaisedButton(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                              size: 18,
                            ),
                            shape: CircleBorder(
                              side: new BorderSide(
                                  color: MyTheme.light_grey, width: 1.0),
                            ),
                            color: MyTheme.red,
                            onPressed: () {
                              _callsAndMessagesService
                                  .call(_orderDetails.shipping_address.phone);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Card buildOrderedProductItemsCard(index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _orderedItemList[index].product_name,
                maxLines: 2,
                style: TextStyle(
                  color: MyTheme.font_grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderedItemList[index].quantity.toString() + " x ",
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  _orderedItemList[index].variation != "" &&
                          _orderedItemList[index].variation != null
                      ? Text(
                          _orderedItemList[index].variation,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "item",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                  Spacer(),
                  Text(
                    _orderedItemList[index].price,
                    style: TextStyle(
                        color: MyTheme.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildOrderdProductList() {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _orderedItemList.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: buildOrderedProductItemsCard(index),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Order Details",
        style: TextStyle(fontSize: 16, color: MyTheme.red),
      ),
      elevation: 0.0,
      titleSpacing: 0,
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
