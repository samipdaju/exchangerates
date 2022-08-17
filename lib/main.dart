import 'package:flutter/material.dart';
import 'package:stock/graph.dart';
import 'package:stock/splash.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff1A1D1F),
        cardColor:  Color(0xffD9F0C4),

        primarySwatch: Colors.blue,
      ),
      initialRoute: "splash",

      routes: {
        "splash":(context)=>HomePage(),

        // "/":(context)=> HomePage()

      },
    );
  }
}

