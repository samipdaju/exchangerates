import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stock/model/logic.dart';
import 'package:stock/model/mod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'model/stockModel.dart';

class MyHomePage extends StatefulWidget {
  Rates rate;
  List<Rates> currencyList;

  MyHomePage(this.rate, this.currencyList);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late String name;
  late Rates rate;
  late List<Rates> stockList;
  late List<Rates> currencyList;
  late String indianRupee;

  late List<Rates> us;

  List values = [5, 10, 20, 30, 60, 90, 100];
  late TooltipBehavior tooltip;
  bool load = true;
  List currencies = [];

  @override
  void initState() {
    tooltip = TooltipBehavior(enable: true);
    initialize(value, 30);

    // TODO: implement initState
    super.initState();
  }

  maxim() {
    if (value <= 30) {
      return 1;
    } else {
      return 30;
    }
  }

  interval() {
    if (value <= 30) {
      return 1;
    } else {
      return 30;
    }
  }

  List sellingValues = [];
  late var minimum;
  late var maximum;

  initialize(name, days) async {
    setState(() {
      load = true;
    });
    rate = widget.rate;
    currencyList = widget.currencyList;
    stockList = await Logic().getApiForDates(rate.name, days);

    us = await Logic().getApiForDates(name, days);
    print(stockList.length);
    for (int i = 0; i < stockList.length; i++) {
      sellingValues.add(num.parse(stockList[i].sell));
    }
    minimum = sellingValues.reduce((curr, next) => curr > next ? curr : next);
    maximum = sellingValues.reduce((curr, next) => curr < next ? curr : next);

    setState(() {
      load = false;
    });
  }

  int value = 30;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> getDropDownItems() {
      List<DropdownMenuItem<int>> dropDownItems = [];

      for (int i = 0; i < values.length; i++) {
        dropDownItems.add(DropdownMenuItem(
          child: Text(values[i].toString()),
          value: values[i],
        ));
      }

      return dropDownItems;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('GRAPH REPRESENTATION'),
        ),
        body: load
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Shimmer.fromColors(
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundImage:
                                AssetImage("assets/${rate.iso3}.png"),
                          ),
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                              // padding: EdgeInsets.all(10),
                              child: Text(
                                "                            ",
                                style: TextStyle(fontSize: 24),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Shimmer.fromColors(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        ),
                        baseColor: Colors.grey,
                        highlightColor: Colors.white),
                  ),
                ],
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(10),

                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                              color: Colors.grey,
                                offset: Offset(4,4)
                              ), BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(-2,-2)
                              )

                            ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25.0,
                                backgroundImage:
                                    AssetImage("assets/${rate.iso3}.png"),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                rate.name,
                                style:
                                    TextStyle(fontSize: 25, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Card(
                            elevation: 14,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Last $value Days",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton(
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      underline: Container(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          value = (newValue) as int;
                                          initialize(rate.name, value);
                                        });
                                      },
                                      items: getDropDownItems(),
                                      icon: Icon(Icons
                                          .arrow_drop_down_circle_outlined),
                                    ),
                                  ],
                                )),
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(4, 4),
                                  spreadRadius: 2
                                ),
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(-2, -2),
                                )
                              ]),
                          child: SfCartesianChart(
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePanning: true,
                            ),
                            primaryXAxis: CategoryAxis(
                              visibleMinimum: maxim().toDouble(),
                              visibleMaximum: value.toDouble(),
                              isVisible: true,
                              majorGridLines: const MajorGridLines(width: 0),
                              majorTickLines: MajorTickLines(size: 5),
                              axisLine: const AxisLine(width: 0),
                              multiLevelLabelStyle: MultiLevelLabelStyle(),
                            ),
                            primaryYAxis: NumericAxis(
                                majorGridLines: const MajorGridLines(width: 1),
                                minimum: minimum + 1,
                                maximum: maximum - 1,
                                interval: 1),

                            tooltipBehavior: tooltip,
                            series: <ChartSeries>[
                              SplineSeries<Rates, dynamic>(
                                yValueMapper: (Rates data, _) =>
                                    num.parse(data.sell),

                                // gradient: LinearGradient(colors: [
                                // Colors.green,
                                // Colors.yellow,
                                // Colors.red,
                                // Colors.red,
                                // ]),
                                xAxisName: "Date",
                                yAxisName: "Rates",
                                dataSource: stockList,
                                xValueMapper: (Rates data, _) => (data.date),

                                name: rate.name,
                                // markerSettings: MarkerSettings(isVisible:true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    top: 125,
                    child: Column(
                      children: [
                        // Container(
                        //
                        //
                        // decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        // color: Colors.white,
                        //
                        // ),
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        //
                        // child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // children: [
                        // Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // children: [
                        // Icon(Icons.circle,
                        // color: Colors.red,),
                        // Text("${rate.name}",
                        // style: TextStyle(
                        // fontSize: 18,
                        //
                        // ),),
                        // ],
                        // ),
                        // Row(
                        // children: [
                        // Icon(Icons.circle,
                        // color: Colors.green,),
                        // Text("${us[0].name}", style: TextStyle(
                        // fontSize: 20,
                        //
                        // ),),
                        // ],
                        // ),
                        // ],
                        // )
                        // ),
                      ],
                    ),
                  )
                ],
              ));
  }
}
