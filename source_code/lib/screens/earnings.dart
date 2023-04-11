import 'package:flutter/material.dart';
import 'package:active_flutter_delivery_app/helpers/sortable.dart';
import 'package:active_flutter_delivery_app/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_flutter_delivery_app/ui_sections/drawer.dart';
import 'package:active_flutter_delivery_app/repositories/delivery_repository.dart';
import 'package:active_flutter_delivery_app/helpers/shimmer_helper.dart';
import 'package:active_flutter_delivery_app/screens/order_details.dart';


class Earnings extends StatefulWidget {
  Earnings({
    Key key,
    this.show_back_button = false,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  bool show_back_button;

  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
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
  String _today_date = ". . .";
  String _yesterday_date = ". . .";
  String _today_earning = ". . .";
  String _yesterday_earning = ". . .";

  String _defaultDateKey = '';
  String _defaultPaymentTypeKey = '';

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();

    fetchAll();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchList();
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

  fetchAll() {
    fetchSummary();
    fetchList();
  }

  fetchSummary() async {
    var earningSummaryResponse =
        await DeliveryRepository().getEarningSummaryResponse();

    if (earningSummaryResponse != null) {
       _today_date = earningSummaryResponse.today_date.toString();
       _yesterday_date = earningSummaryResponse.yesterday_date.toString();
       _today_earning = earningSummaryResponse.today_earning.toString();
       _yesterday_earning =
          earningSummaryResponse.yesterday_earning.toString();
      setState(() {});
    }
  }

  fetchList() async {
    var listResponse = await DeliveryRepository().getEarningResponse(
      page: _page,
    );
    //print("or:"+orderResponse.toJson().toString());
    _list.addAll(listResponse.data);
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

    _today_date = ". . .";
    _yesterday_date = ". . .";
    _today_earning = ". . .";
    _yesterday_earning = ". . .";

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
    fetchAll();
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
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _xcrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        buildList(),
                        Container(
                          height: 100,
                        )
                      ]),
                    )
                  ],
                ),
              ),

              Align(alignment: Alignment.center, child: buildLoadingContainer())
            ],
          )),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                    color: MyTheme.blue,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                        child: Text(
                          "Today",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          _today_earning,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        _today_date,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                  color: MyTheme.grey_153,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                      child: Text(
                        "Yesterday",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        _yesterday_earning,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      _yesterday_date,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(171.0),
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
            "Earnings",
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
      return SingleChildScrollView(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return OrderDetails(id:_list[index].order_id,);
                        }));
                  },
                  child: buildListItem(index),
                ));
          },
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
                  child: Text(
                    _list[index].order_code,
                    style: TextStyle(
                        color: MyTheme.grey_153,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
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
                        _list[index].earning,
                        style: TextStyle(
                            color: MyTheme.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
