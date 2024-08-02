import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'ConfirmedOrders.dart';

class ConfirmOrder extends StatefulWidget {
  final Map<String, dynamic> order;
  final int userId;

  const ConfirmOrder({Key? key, required this.order, required this.userId, required String userEmail}) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  Future<void> fetchUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    if (email != null) {
      setState(() {
        userEmail = email;
      });
    }
  }

  Future<void> confirmOrder(int orderId, bool isConfirmed) async {
    try {
      var url = Uri.parse('http://localhost/uberClone/driver_apis/confirmOrder.php');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'order_id': orderId,
          'confirmation': isConfirmed ? 'confirmed' : 'not-confirmed',
          'user_email': userEmail,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ConfirmedOrders()),
          );
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to update order');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to confirm order: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                userEmail,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(userEmail: userEmail)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Confirmed Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfirmedOrders()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userEmail.isNotEmpty) ...[
                  Text('User Email: $userEmail', style: TextStyle(fontSize: 16)),
                ],
                Text('Order ID: ${widget.order['order_id']}', style: TextStyle(fontSize: 16)),
                Text('Name: ${widget.order['fullName']}', style: TextStyle(fontSize: 16)),
                Text('Place: ${widget.order['curently_place']}', style: TextStyle(fontSize: 16)),
                Text('Category: ${widget.order['category']}', style: TextStyle(fontSize: 16)),
                Text('Phone: ${widget.order['phone']}', style: TextStyle(fontSize: 16)),
                Text('Destination: ${widget.order['destinaton']}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            int orderId = int.parse(widget.order['order_id']);
                            await confirmOrder(orderId, true);
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        child: Text('Confirm'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            int orderId = int.parse(widget.order['order_id']);
                            await confirmOrder(orderId, false);
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
