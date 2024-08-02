import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmedOrders extends StatefulWidget {
  @override
  _ConfirmedOrdersState createState() => _ConfirmedOrdersState();
}

class _ConfirmedOrdersState extends State<ConfirmedOrders> {
  List<dynamic> confirmedOrders = [];
  List<dynamic> filteredOrders = [];
  bool isLoading = true;
  TextEditingController categoryController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchConfirmedOrders();
  }

  Future<void> fetchConfirmedOrders() async {
    var url = Uri.parse('http://localhost/uberClone/apis/get_confirmed_orders.php');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            confirmedOrders = data['data'];
            filteredOrders = confirmedOrders;
            isLoading = false;
          });
        } else {
          showErrorMessage(data['message'] ?? "Failed to fetch confirmed orders");
        }
      } else {
        showErrorMessage("Failed to fetch confirmed orders");
      }
    } catch (e) {
      showErrorMessage("Error occurred: $e");
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void filterOrders() {
    String category = categoryController.text.toLowerCase();
    String place = placeController.text.toLowerCase();
    setState(() {
      filteredOrders = confirmedOrders.where((order) {
        final orderCategory = order['category'].toLowerCase();
        final orderPlace = order['curently_place'].toLowerCase();
        return orderCategory.contains(category) && orderPlace.contains(place);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All orders here'),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      hintText: 'Search by Category',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      filterOrders();
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: placeController,
                    decoration: InputDecoration(
                      hintText: 'Search by Place',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      filterOrders();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                filteredOrders.isEmpty
                    ? Text('No confirmed orders found.')
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.blue,
                      child: Column(
                        children: [
                          Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Name', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Place', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Category', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Destination', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Status', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(filteredOrders[index]['fullName'], style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(filteredOrders[index]['curently_place'], style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(filteredOrders[index]['category'], style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(filteredOrders[index]['destination'], style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                TableCell(
                                  child: filteredOrders[index]['confirmation'] == 'confirmed'
                                      ? Icon(Icons.check, color: Colors.white)
                                      : Icon(Icons.close, color: Colors.white),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
