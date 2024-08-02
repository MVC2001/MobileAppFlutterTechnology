import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Auth.dart';
import 'ConfirmOrder.dart';
import 'ConfirmedOrders.dart';
import 'PasswordResetPage.dart';

class HomePage extends StatelessWidget {
  final String appTitle = 'CURRENTLY ORDERS';

  const HomePage({Key? key, required String userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> orders = [];
  String userEmail = '';
  int userId = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchOrders();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    int? id = prefs.getInt('user_id');
    if (email != null && id != null) {
      setState(() {
        userEmail = email;
        userId = id;
      });
    }
  }

  Future<void> fetchOrders() async {
    var url = Uri.parse('http://localhost/uberClone/driver_apis/get_orders.php');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            orders = data['data'];
            isLoading = false;
          });
        } else {
          print("Failed to fetch orders: ${data['message']}");
        }
      } else {
        print("Failed to fetch orders: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void _acceptOrder(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmOrder(order: order, userId: userId, userEmail: '',)),
    ).then((value) {
      if (value == true) {
        fetchOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              orders.isEmpty
                  ? Text('No orders found.')
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(children: [
                              TableCell(
                                  child: Text('Name',
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text('FromPlace',
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text('Category',
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text('Phone',
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text('Destination',
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text('Action',
                                      style: TextStyle(
                                          color: Colors.blue))),
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Text(
                                      orders[index]['fullName'],
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text(
                                      orders[index]
                                      ['currently_place'],
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text(
                                      orders[index]['category'],
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text(
                                      orders[index]['phone'],
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: Text(
                                      orders[index]
                                      ['destination'],
                                      style: TextStyle(
                                          color: Colors.blue))),
                              TableCell(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _acceptOrder(orders[index]);
                                    },
                                    child: Text('Accept'),
                                  )),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                accountName: Text(
                  "DRIVER MENU",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("driver@gmail.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.face_unlock_outlined),
              title: const Text('Change password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordResetPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Confirmed orders'),
              onTap: () {
                // Ensure userId is not null when navigating to ConfirmedOrders
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmedOrders()),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App info'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Auth()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
