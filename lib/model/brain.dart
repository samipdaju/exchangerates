import 'dart:convert';

import 'package:http/http.dart';
import 'package:stock/model/stockModel.dart';

class StockBrain {

  final Stock stock = Stock();
  String baseUrl = "https://nepse-data-api.herokuapp.com/data/todaysprice";

  Future<List<Stock>> getApi() async {
    Response response;
    Uri url = Uri.parse(baseUrl);
    response = await get(url);
    response.statusCode;
    print(response.body);
    var result = jsonDecode(response.body);
    print(result[0]["companyName"]);


    List<Stock > stockList =[];

    for(int i=0 ;i< result.length;i ++)  {
      stockList.add(Stock(
        companyName: result[i]["companyName"],
        minPrice: result[i]["minPrice"],
        maxPrice: result[i]["maxPrice"],
        amount: result[i]["amount"],
        noOfTransactions:result[i]["noOfTransactions"] ,
        totalTraded:result[i]["totalTraded"] ,
          difference:result[i]["difference"]
      ));
    }


    print(result);
    return stockList;

  }


}
