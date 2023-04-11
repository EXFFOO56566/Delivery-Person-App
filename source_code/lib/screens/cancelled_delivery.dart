import 'package:flutter/material.dart';
import 'package:active_flutter_delivery_app/helpers/sortable.dart';
import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_flutter_delivery_app/ui_sections/drawer.dart';
import 'package:active_flutter_delivery_app/repositories/delivery_repository.dart';
import 'package:active_flutter_delivery_app/helpers/shimmer_helper.dart';
import 'package:active_flutter_delivery_app/screens/order_details.dart';


class CancelledDelivery extends StatefulWidget {
  CancelledDelivery({Key key, this.show_back_button = false}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  bool show_back_button;

  @override
  _CancelledDeliveryState createState() => _CancelledDeliveryState();
}

class _CancelledDeliveryState extends State<CancelledDelivery> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();

  List<Sortable> _datewiseSortList = Sortable.getDatewiseSortList();
  List<Sortable> _paymentTypeSortList = Sortable.getPaymentTypeSortList();

  Sortable _selectedDate;
  Sortable _selectedPaymentType;

  List<DropdownMenuItem<Sortable>> _dropdownDatewiseSortItems;
  List<DropdownMenuItem<Sortable>> _dropdownPaymentTypeSortItems;

  //init
  List<dynamic> _list = [];
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;

  String _defaultDateKey = '';
  String _defaultPaymentTypeKey = '';

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
    fetchData();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  init() {
    _dropdownDatewiseSortItems = buildDropdownItems(_datewiseSortList);

    _dropdownPaymentTypeSortItems = buildDropdownItems(_paymentTypeSortList);

    initSortableDefaults();
  }

  initSortableDefaults() {
    for (int x = 0; x < _dropdownDatewiseSortItems.length; x++) {
      if (_dropdownDatewiseSortItems[x].value.option_key == _defaultDateKey) {
        _selectedDate = _dropdownDatewiseSortItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownPaymentTypeSortItems.length; x++) {
      if (_dropdownPaymentTypeSortItems[x].value.option_key ==
          _defaultPaymentTypeKey) {
        _selectedPaymentType = _dropdownPaymentTypeSortItems[x].value;
      }
    }

    setState(() {});
  }

  List<DropdownMenuItem<Sortable>> buildDropdownItems(List _paymentStatusList) {
    List<DropdownMenuItem<Sortable>> items = List();
    for (Sortable item in _paymentStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  fetchData() async {
    var listResponse = await DeliveryRepository().getDeliveryListResponse(
        page: _page,
        type: "cancelled",
        date_range: _selectedDate.option_key,
        payment_type: _selectedPaymentType.option_key);
    //print("or:"+orderResponse.toJson().toString());
    _list.addAll(listResponse.orders);
    _isInitial = false;
    _totalData = listResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _list.clear();
    _isInitial = true;
    _page = 1;
    _totalData = 0;
    _showLoadingContainer = false;
    setState(() {});
  }

  resetFilterKeys() {
    _defaultDateKey = '';
    _defaultPaymentTypeKey = '';

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    resetFilterKeys();
    initSortableDefaults();
    fetchData();
  }

  onPop(value) {
    reset();
    resetFilterKeys();
    initSortableDefaults();
    fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.show_back_button,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          key: _scaffoldKey,
          drawer: MainDrawer(),
          body: Stack(
            children: [
              buildList(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: buildLoadingContainer())
            ],
          )),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: new DropdownButton<Sortable>(
              icon: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                "All",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedDate,
              items: _dropdownDatewiseSortItems,
              onChanged: (Sortable selectedFilter) {
                setState(() {
                  _selectedDate = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),

          //Spacer(),

          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: new DropdownButton<Sortable>(
              icon: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                "All",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedPaymentType,
              items: _dropdownPaymentTypeSortItems,
              onChanged: (Sortable selectedFilter) {
                setState(() {
                  _selectedPaymentType = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(104.0),
      child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            new Container(),
          ],
          elevation: 0.0,
          titleSpacing: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Column(
              children: [
                Padding(
                  padding: MediaQuery.of(context).viewPadding.top >
                          30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                      ? const EdgeInsets.only(top: 36.0)
                      : const EdgeInsets.only(top: 14.0),
                  child: buildTopAppBarContainer(),
                ),
                buildBottomAppBar(context)
              ],
            ),
          )),
    );
  }

  Container buildTopAppBarContainer() {
    return Container(
      child: Row(
        children: [
          widget.show_back_button
              ? Builder(
                  builder: (context) => IconButton(
                      icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                      onPressed: () {
                        return Navigator.of(context).pop();
                      }),
                )
              : Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 12.0),
                      child: Container(
                        child: Image.asset(
                          'assets/hamburger.png',
                          height: 16,
                          //color: MyTheme.dark_grey,
                          color: MyTheme.dark_grey,
                        ),
                      ),
                    ),
                  ),
                ),
          Text(
            "Cancelled Delivery",
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
        ],
      ),
    );
  }

  buildList() {
    if (_isInitial && _list.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_list.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _list.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: buildListItem(index));
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(child: Text("No data is available"));
    } else {
      return Container(); // should never be happening
    }
  }

  buildListItem(int index) {
    return Column(
      children: [
        Card(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order Code",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Text(
                        _list[index].code,
                        style: TextStyle(
                            color: MyTheme.red,
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
                      Text(_list[index].date,
                          style: TextStyle(
                              color: MyTheme.font_grey, fontSize: 13)),
                      Spacer(),
                      Text(
                        _list[index].grand_total,
                        style: TextStyle(
                            color: MyTheme.red,
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
                            _list[index].payment_type,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 13),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: buildPaymentStatusCheckContainer(
                                _list[index].payment_status),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 4.0, right: 4.0, top: 4.0, bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: MyTheme.textfield_grey, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(6.0))),
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
                            id: _list[index].id,
                          );
                        })).then((value) {
                      onPop(value);
                    });
                  },
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: MyTheme.textfield_grey, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                child: FlatButton(
                  minWidth: (MediaQuery.of(context).size.width - 36) / 2,
                  //height: 50,
                  color: MyTheme.red_disabled,
                  splashColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.clear,
                          size: 14,
                          color: MyTheme.white,
                        ),
                      ),
                      Text(
                        "Delivered",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  onPressed: () {
                    //onPressedLogin();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _list.length
            ? "No More Items"
            : "Loading More Items ..."),
      ),
    );
  }
}
