import 'dart:convert';
import 'dart:math';
import 'package:stock/widgets.dart';

import 'mod.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:stock/model/stockModel.dart';

class Logic {


  getApi() async {
    var today = DateFormat('yyyy-MM-dd').format(
        DateTime.now());

    var fourDaysAgo = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: 4)));
    var url = Uri.parse(
        "https://www.nrb.org.np/api/forex/v1/rates?from=$fourDaysAgo&to=$today&per_page=100&page=1");

    Response response;
    response = await get(url);

    print(response.statusCode);
    print(response.body);

    var result = jsonDecode(response.body);
   
//
//
//     List<Rates> rates = [];
//     List<Payload>payload = [];
//
//
//     try {
//       for (int i = 0; i < result["data"]["payload"][0]["rates"].length; i++) {
//         for (int k = 0; k < result["data"]["payload"].length; i++) {
//           var j = result["data"]["payload"].length - 1;
//
//
//           // rates.add(Rates(
//           //     date:
//           //     result["data"]["payload"][j]["date"],
//           //
//           //     sell: result["data"]["payload"][k]["rates"][i]["sell"],
//           //     buy: result["data"]["payload"][k]["rates"][i]["buy"],
//           //     name: result["data"]["payload"][k]["rates"][i]["currency"]["name"],
//           //     iso3: result["data"]["payload"][k]["rates"][i]["currency"]["iso3"],
//           //     unit: result["data"]["payload"][k]["rates"][i]["currency"]["unit"]
//           // ));
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//
//
//     for (int i = 0; i < result["data"]["payload"].length; i++) {
//       payload.add(
//           Payload(
//               date: result["data"]["payload"][i]["date"],
//               rates: rates
//           ));
//     }
//
//
//     Currency currency = Currency(
//       payload: payload,
//     );
//
//
// var newRates = payload[4].rates;
//
//
//
//     newRates?.sort((a, b){
//       return ((a.name)
//           .compareTo((b.name)));
//     });


    List matchesList = result["data"]["payload"][0]["rates"];
    List<Rates> matches = matchesList
        .map((dynamic item) => Rates.fromJson(item))
        .toList();

    print(matches);
    print("Length");
    print(matches.length);
    for(int i=0;i<21;i++){
      print(i);
    }
    return matches;



    // return newRates;
  }

  Future<List<Rates>> getApiForDates(currencyName,days) async {
    var today = DateFormat('yyyy-MM-dd').format(
        DateTime.now());
    var fourDaysAgo = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: days)));


    var url = Uri.parse(
        "https://www.nrb.org.np/api/forex/v1/rates?from=$fourDaysAgo&to=$today&per_page=100&page=1");
    print("DAtessss");
    Response response;
    response = await get(url);

    print(response.statusCode);
    print(response.body);

    var result = jsonDecode(response.body);


    List<Rates> rates = [];
    List<Payload>payload = [];
    ;


    try {
      for (int i = 0; i <
          result["data"]["payload"][0]["rates"].length; i++) {
        for (int j = 0; j < result["data"]["payload"].length; j++) {
          // rates.add(Rates(
          //     date: result["data"]["payload"][j]["date"],
          //     sell: result["data"]["payload"][j]["rates"][i]["sell"],
          //     buy: result["data"]["payload"][j]["rates"][i]["buy"],
          //     name: result["data"]["payload"][j]["rates"][i]["currency"]["name"],
          //     iso3: result["data"]["payload"][j]["rates"][i]["currency"]["iso3"],
          //     unit: result["data"]["payload"][j]["rates"][i]["currency"]["unit"]
          // ));
        }
      }
    } catch (e) {
      print(e);
    }


    for (int i = 0; i < result["data"]["payload"].length; i++) {
      payload.add(Payload(
          date: result["data"]["payload"][i]["date"],
          rates: rates
      ));
    }


    Currency currency = Currency(
      payload: payload,
    );

    List<Rates> returnedList = [];

    var newRates = payload[payload.length - 1].rates;

    print(result);

    for (int i = 0; i < rates.length; i++) {
      if (newRates![i].name == currencyName) {
        // returnedList.add(
        //     Rates(
        //         buy: newRates![i].buy,
        //         sell: newRates[i].sell,
        //         unit: newRates[i].unit,
        //         name: newRates[i].name,
        //         iso3: newRates[i].iso3,
        //         date: newRates[i].date
        //     ));
      }
    }


    return returnedList;
  }
}