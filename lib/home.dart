import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stock/model/brain.dart';
import 'package:stock/model/exchangemodal.dart';
import 'package:stock/model/overall.dart';
import 'package:stock/model/stockModel.dart';
import 'package:stock/widgets.dart';

import 'graph.dart';
import 'model/logic.dart';
import 'model/mod.dart';

List stockss = [1, 2, 3, 4, 5];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final ScrollController _controller = ScrollController();
final double _height = 200.0;

void _animateToIndex(int index) {
  _controller.animateTo(
    index * _height,
    duration: Duration(seconds: 2),
    curve: Curves.fastOutSlowIn,
  );
}

class _HomePageState extends State<HomePage> {
  StockBrain stockBrain = StockBrain();
  ExchangeLogic exchangeLogic = ExchangeLogic();
  Logic logic = Logic();

  bool load = true;
  String value = "Name";

  late List<Rates> stockLists;

  stockList(value) {
    if (value == "Name") {
      stockLists.sort((a, b) {
        return ((a.name).compareTo((b.name)));
      });
    } else if (value == "Highest Growth") {
      stockLists.sort((a, b) {
        return (num.parse(a.buy) - num.parse(a.sell))
            .compareTo((num.parse(b.buy) - num.parse(b.sell)));
      });
    } else if (value == "Price") {
      stockLists.sort((a, b) {
        return (num.parse(b.buy) / b.unit)
            .compareTo((num.parse(a.buy) / a.unit));
      });
    }

    return stockLists;
  }

  bool loading = false;
  DateTime dateTime = DateTime.now();
  List<Widget> list = [];

  Widget checkConnection() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(30)),
      child: Text(
        "Check your internet connection",
        style: TextStyle(color: Colors.white),
      ),
      padding: EdgeInsets.all(20),
    );
  }

  showMessage() {
    setState(() {
      loading = true;
    });
  }

  lists(stockLists) {
    for (int i = 0; i < stockLists.length; i++) {
      list.add(Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stockLists[i].name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  stockLists[i].buy,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "(${(num.parse(stockLists[i].buy) - num.parse(stockLists[i].sell)).toStringAsFixed(2)})",
                  style: TextStyle(
                    color: ((num.parse(stockLists[i].buy) -
                                num.parse(stockLists[i].sell))) <
                            0
                        ? Colors.red
                        : Colors.greenAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )));
    }
    return list;
  }

  @override
  void initState() {
    initialize();
    // TODO: implement initState
    super.initState();
  }

  initialize() async {
    stockLists = (await logic
        .getApi()
        .whenComplete(() {})
        .timeout(Duration(seconds: 15), onTimeout: () {
      setState(() {
        loading = true;
      });
      throw TimeoutException('Can\'t connect in 10 seconds.');
    }))!.cast<Rates>();
    setState(() {
      load = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // stockLists = stockList();
    List sortingWay = ["Name", "Price", "Highest Growth"];
    List<DropdownMenuItem<String>> getDropDownItems() {
      List<DropdownMenuItem<String>> dropDownItems = [];

      for (int i = 0; i < sortingWay.length; i++) {
        dropDownItems.add(DropdownMenuItem(
          child: Text(sortingWay[i]),
          value: sortingWay[i],
        ));
      }

      return dropDownItems;
    }

    return Scaffold(
        drawer: Drawer(
          elevation: 10,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).cardColor,
                      Colors.white,
                      Theme.of(context).cardColor
                    ]),
              ),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DrawerHead(

                      icon: Icons.home,
                      title: "Return to home Page",
                      function: (){},
                    ),
                  ),
                  DrawerHead(
                    icon: Icons.graphic_eq,
                    title: "Compare all the rates",
                    function: (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => Overall("Australian Dollar",stockLists)
                          // Graph(stock: stock,),
                        ),
                      );
                    },
                  ),
                  DrawerHead(
                    icon: Icons.search,
                    title: "Search by name",
                    function: (){
                      Navigator.pop(context);
                      showSearch(context: context, delegate: SearchPage(stockLists,_animateToIndex));
                    },
                  ),
                  DrawerHead(
                    icon: Icons.people,
                    title: "Check your Profile",
                    function: (){
                      Navigator.pop(context);
                    },
                  ),
                  DrawerHead(
                    icon: Icons.coronavirus,
                    title: "Check out gold value",
                    function: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              )),
        ),
        backgroundColor: Color(0xfff1A1D1F),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Currency Rates",
                    style: TextStyle(fontSize: 30),
                  ),
                ]),
              ),
              InkWell(
                child: Icon(
                  Icons.search,
                  size: 28,
                ),
                onTap: () {
                  !load
                      ? showSearch(
                          context: context, delegate: SearchPage(stockLists,_animateToIndex))
                      : {};
                },
              )
            ],
          ),
          backgroundColor: Color(0xfff1A1D1F),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "${DateFormat('MM/DD/yyyy').format(DateTime.now())}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Card(
                          color: num.parse(DateFormat('hh').format(
                                    DateTime.now(),
                                  )) >
                                  4
                              ? Colors.red
                              : Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StreamBuilder(
                              stream:
                                  Stream.periodic(const Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                return Center(
                                  child: Text(
                                    DateFormat('hh:mm:ss ').format(
                                      DateTime.now(),
                                    ),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              !load
                  ? Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white60,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlayInterval: Duration(seconds: 1),
                          autoPlayAnimationDuration: Duration(seconds: 1),
                          aspectRatio: 16 / 9,
                          initialPage: 1,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,

                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: lists(stockLists),
                      ),
                    )
                  : Shimmer.fromColors(
                      child: Container(
                        color: Colors.white,
                        height: 70,
                        width: double.infinity,
                      ),
                      baseColor: Colors.white60,
                      highlightColor: Colors.white),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(top: 20, bottom: 0),
                  decoration: BoxDecoration(
                      color: Color(0xffD9F0C4),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "Click for detailed view",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            // shrinkWrap: true,
                            //   physics: NeverScrollableScrollPhysics(),
                            controller: _controller,
                            itemCount: load ? 5 : stockLists.length,
                            itemBuilder: (context, position) {
                              var stock = load
                                  ? stockss[position]
                                  : stockLists[position];
                              return !load
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) => MyHomePage(stock,stockLists)
                                                // Graph(stock: stock,),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        // alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black38,
                                                spreadRadius: 1)
                                          ],
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/${stock.iso3}.png"),
                                              fit: BoxFit.fill,
                                              opacity: 0.25),
                                          color: Color(0xFF0C1947),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 25),
                                              padding: EdgeInsets.only(top: 10),
                                              // alignment: Alignment.centerLeft,
                                              child: Text(
                                                stock.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Price: "
                                                  "${stock.sell}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "Unit: "
                                                  "${stock.unit}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Rise:  ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24),
                                                ),
                                                Text(
                                                  "(${(num.parse(stock.buy) - num.parse(stock.sell)).toStringAsFixed(2)})",
                                                  style: TextStyle(
                                                      color: (num.parse(stock
                                                                      .buy) -
                                                                  num.parse(stock
                                                                      .sell)) <
                                                              0
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : buildShimmer(
                                      context, 100.0, Color(0xFF0C1947));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Positioned(
              top: 140,
              left: 20,
              child: load
                  ? Shimmer.fromColors(
                      direction: ShimmerDirection.ltr,
                      period: Duration(seconds: 3),
                      child: Container(
                        height: 50,
                        width: 250,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      baseColor: Colors.white,
                      highlightColor: Colors.grey)
                  : Card(
                      elevation: 14,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Sort by: ",
                                style: TextStyle(fontSize: 20),
                              ),
                              DropdownButton(
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                underline: Container(),
                                value: value,
                                onChanged: (newValue) {
                                  setState(() {
                                    value = newValue.toString();
                                    stockList(value);
                                  });
                                },
                                items: getDropDownItems(),
                                icon:
                                    Icon(Icons.arrow_drop_down_circle_outlined),
                              ),
                            ],
                          )),
                      color: Colors.white,
                    ),
            ),
            loading
                ? Positioned(
                    bottom: 40,
                    left: 80,
                    child: checkConnection(),
                  )
                : Container()
          ],
        )));
  }
}

class DrawerHead extends StatelessWidget {
  final IconData icon;
  void Function() function;
  String title;

  DrawerHead({required this.icon, required this.title,required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
        onTap:

                function

      ),
    );
  }
}


