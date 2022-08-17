import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stock/model/logic.dart';
import 'package:stock/model/mod.dart';
import 'package:stock/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class Overall extends StatefulWidget {
  String name;
  List<Rates> currencyList;

  Overall(this.name, this.currencyList);

  @override
  OverallState createState() => OverallState();
}

class OverallState extends State<Overall> {
  late String name;

  late List<Rates> stockList;
  late List<Rates> currencyList;
  late String indianRupee;

  late List<Rates> us;

  List values = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400];
  late TooltipBehavior tooltip;
  bool load = true;
  List currencies = [];

  @override
  void initState() {
    tooltip = TooltipBehavior(enable: true);
    initialize(value,value1);

    // TODO: implement initState
    super.initState();
  }

  initialize(names,names1) async {
    setState(() {
      load = true;
    });
   name = widget.name;
    currencyList = widget.currencyList;

    stockList = await Logic().getApiForDates(names1,30);


    us = await Logic().getApiForDates(names,30);
    print(stockList.length);

    setState(() {
      load = false;
    });
  }
  String value1= "Australian Dollar";
  String value = "U.S. Dollar";

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> getDropDownItems() {
      List<DropdownMenuItem<String>> dropDownItems = [];

      for (int i = 0; i < currencyList.length; i++) {
        dropDownItems.add(DropdownMenuItem(
          child: Text(currencyList[i].name),
          value: currencyList[i].name,
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
                        child: Text("                            ",
                          style: TextStyle(
                              fontSize: 24
                          ),),
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
                        color: Colors.white
                    ),
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       CircleAvatar(
                //         radius: 25.0,
                //         backgroundImage:
                //         AssetImage("assets/${stockList[0].iso3}.png"),
                //       ),
                //       SizedBox(
                //         width: 20,
                //       ),
                //       Text(
                //         stockList[0].name,
                //         style: TextStyle(fontSize: 25, color: Colors.white),
                //       )
                //     ],
                //   ),
                // ),
                Card(

                  elevation: 14,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "Currency 1:",
                            style: TextStyle(fontSize: 20),
                          ),
                          DropdownButton(
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            underline: Container(),
                            value: value1,
                            onChanged: (newValue) {
                              setState(() {
                                value1 = newValue.toString();


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
                Card(

                  elevation: 14,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Currency 2:",
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
                InkWell(
                  onTap: (){
                   initialize(value, value1);
                  },
                  child: Container(
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.green,
               ),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
                    margin: EdgeInsets.all(10),
                    child: Text("Compare",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24
                    ),),

                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Expanded(


                  child: SfCartesianChart(

                    primaryXAxis: CategoryAxis(


                      majorGridLines: const MajorGridLines(width: 0),
                      majorTickLines:
                      MajorTickLines(size: 5),


                      axisLine: const AxisLine(width: 0),
                      multiLevelLabelStyle: MultiLevelLabelStyle(
                      ),
                    ),


                    primaryYAxis: NumericAxis(

                        majorGridLines: const MajorGridLines(width: 1),
                        //   minimum: num.parse(rate.buy)-5,
                        // maximum: num.parse(rate.buy)+5,
                        minimum: num.parse(stockList[days-1].buy)-num.parse(us[days-1].buy)>0?num.parse(us[days-1].buy) - 10:num.parse(stockList[days-1].buy)-10,
                        maximum: num.parse(stockList[days-1].buy)-num.parse(us[days-1].buy)>0?num.parse(stockList[days-1].buy) + 10:num.parse(us[days-1].buy)+10,
                        interval: 10),
                    borderColor: Colors.blue,
                    tooltipBehavior: tooltip,
                    series: <ChartSeries>[


                      SplineSeries<Rates, dynamic>(
                        yValueMapper: (Rates data, _) => num.parse(data.sell),

                        xAxisName: "Date",
                        yAxisName: "Rates",
                        dataSource: stockList,
                        xValueMapper: (Rates data, _) => data.date,

                        name: stockList[0].name,

                      ),

                      SplineSeries<Rates, dynamic>(
                        xAxisName: "Date",
                        yAxisName: "Rates",
                        dataSource: us,
                        xValueMapper: (Rates data, _) => data.date,
                        yValueMapper: (Rates data, _) =>
                            num.parse(data.sell),
                        name: us[0].name,
                        color: Colors.green,

                      ),
                    ],
                  ),


                ),

              ],
            ),
            Positioned(
              right: 10,
              top: 180,
              child: Column(
                children: [
                  Container(


                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,

                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.circle,
                                color: Colors.blue,),
                              Text("${stockList[0].iso3}= ${stockList[days-1].sell}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold

                                ),),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle,
                                color: Colors.green,),
                              Text("${us[0].iso3}= ${us[days-1].sell}", style: TextStyle(
                                fontSize: 20,
                                  fontWeight: FontWeight.bold

                              ),),
                            ],
                          ),
                        ],
                      )
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
