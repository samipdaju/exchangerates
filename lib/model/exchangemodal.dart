
import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:stock/model/stockModel.dart';

import 'mod.dart';

class ExchangeLogic{

  Future<List<Stock>> getAPi()async{

    var today = DateFormat('yyyy-MM-dd').format(
        DateTime.now());

    var fourDaysAgo = DateFormat('yyyy-MM-dd').format(
        DateTime.now());
    var url = Uri.parse("https://www.nrb.org.np/api/forex/v1/rates?from=2022-01-27&to=$today&per_page=100&page=1");
print(url);
    Response response;
    response = await get(url) ;

    print(response.statusCode);
    print(response.body);

    var result = jsonDecode(response.body);

    List<Stock> exchanges = [];


    for (int i =0; i< result["data"]["payload"][0]["rates"].length; i++){

      exchanges.add(Stock(

          companyName: result["data"]["payload"][0]["rates"][i]["currency"]["name"],
          minPrice: result["data"]["payload"][0]["rates"][i]["currency"]["unit"],
          maxPrice: result["data"]["payload"][0]["rates"][i]["buy"],
          difference: result["data"]["payload"][0]["rates"][i]["sell"],
        amount:  result["data"]["payload"][0]["rates"][i]["currency"]["iso3"]




      ));

    }


    print(result);

    exchanges.sort((a, b){
      return ((a.companyName)
          .compareTo((b.companyName)));
    });

    return exchanges;

  }

  }