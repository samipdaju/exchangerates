class Stock {
  var companyName;
  var maxPrice;
  var minPrice;
  var totalTraded;
  var amount;
  var difference;
  var noOfTransactions;

  Stock(
      {this.companyName,
      this.minPrice,
      this.amount,
      this.difference,
      this.maxPrice,
      this.noOfTransactions,
      this.totalTraded});
}
