import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stock/home.dart';
import 'package:stock/model/brain.dart';
import 'package:stock/model/exchangemodal.dart';

class Splash extends StatefulWidget {

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
   StockBrain stockBrain = StockBrain();
   ExchangeLogic logic = ExchangeLogic();
bool load = false;

List list = [1,2,3,4,5,6];
showmessage(){
  setState(() {
    load = true;
  });
}
  @override
  void initState() {
    initialize();
    // TODO: implement initState
    super.initState();
  }
  initialize()async{
try{
  sleep(Duration(seconds: 1));
  // var result = await  logic.getAPi();
  SchedulerBinding.instance?.addPostFrameCallback((_) {

    // add your code here.

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>  HomePage(),
      ),
    );
  });
} catch(e){
  showmessage();
}


Future.delayed(Duration(seconds: 5),showmessage());





 }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(

            children: [
              Positioned(
                top: MediaQuery.of(context).size.height/3,
                  left: 50,
                  child: Container(
                    height: 300,
                      child: Image.asset("assets/stock.png"))),
              Positioned(
                top: MediaQuery.of(context).size.height/1.3,
                left: 30,
                child: Visibility(visible: load,
                  child: Container(

                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    child: Text("Unstable connection. Please Try again later"),
                    color: Colors.black26,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
