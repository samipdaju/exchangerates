class Currency {
  List<Payload>? payload;

  Currency({this.payload});
}

class Payload {
  var date;
  List<Rates>? rates;

  Payload({this.date, this.rates});

}

class Rates {
  var date;
  var iso3;
  var buy;
  var sell;
  var name;
  var unit;

  Rates(this.iso3, this.buy, this.sell, this.name, this.unit, this.date);


  factory Rates.fromJson(Map<String, dynamic> json) {
    return Rates(json["date"], json["iso3"],json["buy"], json["sell"],json["name"], json["unit"]);
  }
}
