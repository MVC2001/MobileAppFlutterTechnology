import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmedOrders extends StatefulWidget {
  @override
  _ConfirmedOrdersState createState() => _ConfirmedOrdersState();
}

class _ConfirmedOrdersState extends State<ConfirmedOrders> {
  List<dynamic> confirmedOrders = [];
  List<dynamic> filteredOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConfirmedOrders();
  }

  Future<void> fetchConfirmedOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0; // Retrieve user_id from SharedPreferences

    var url = Uri.parse('http://localhost/uberClone/driver_apis/get_confirmed_orders.php');

    try {
      var response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            confirmedOrders = data['data'];
            filteredOrders = confirmedOrders;
            isLoading = false;
          });
        } else {
          Fluttertoast.showToast(
            msg: data['message'] ?? "Failed to fetch orders",
            textColor: Colors.black,
          );
          setState(() {
            isLoading = false;
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch orders",
          textColor: Colors.black,
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error occurred: $e",
        textColor: Colors.black,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterOrders(String category, String place) {
    setState(() {
      filteredOrders = confirmedOrders.where((order) {
        final orderCategory = order['category'].toString().toLowerCase();
        final orderPlace = order['currently_place'].toString().toLowerCase();
        return orderCategory.contains(category) && orderPlace.contains(place);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmed Orders'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchConfirmedOrders();
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by Category',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (value) {
                          filterOrders(value.toLowerCase(), '');
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by Place',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (value) {
                          filterOrders('', value.toLowerCase());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        'Category: ${filteredOrders[index]['category']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${filteredOrders[index]['fullName']}'),
                          Text('Phone Number: ${filteredOrders[index]['phone']}'),
                          Text('Current-Place: ${filteredOrders[index]['currently_place']}'),
                          Text('Destination: ${filteredOrders[index]['destination']}'),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
