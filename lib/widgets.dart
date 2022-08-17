import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
const days = 30;

class SearchPage extends SearchDelegate {
  List history = [];
  void Function(int) onPress;

  SearchPage(this.history,this.onPress);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {

        close(context, null);
      },
    );
  }

  @override
  buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List newgfgList = history;

    final myList = query.isEmpty
        ? newgfgList
        : newgfgList
        .where((element) =>
        element.name.toString().toLowerCase().contains(query))
        .toList();

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Colors.white,
                  Theme.of(context).scaffoldBackgroundColor,
                ])),
        child: myList.isNotEmpty
            ? Container(


          decoration: BoxDecoration(

            color: Colors.white,
          ),
          child: ListView.builder(
              itemBuilder: (context, position) {
                final stock = myList[position];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8),

                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/${stock.iso3}.png"),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      var index = history.indexWhere((element) =>
                      element.name == stock.name);
                      print(index.toString());
                    onPress(index);
                    },
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        stock.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                );
              },
              itemCount: myList.length),
        )
            :Container(

          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30)),
            color: Colors.white,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Can't found currency containing $query. \n Try with different one",
                style: TextStyle(
                    fontSize: 24
                ),),
            ),
          ),
        ));
  }
}

Widget buildShimmer(BuildContext context, height, color) {
  return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 3),
      child: Container(
        height: height,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/money.jpg",
              ),
              opacity: 0.1),
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(20),
      ),
      baseColor: color,
      highlightColor: Colors.grey);
}