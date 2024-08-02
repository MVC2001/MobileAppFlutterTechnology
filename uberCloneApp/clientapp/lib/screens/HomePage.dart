import 'package:clientapp/screens/PasswordResetPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// PasswordResetPage and Auth should be defined in their respective files.

import 'auth.dart'; // Import the Auth page

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? currentlyPlace;
  String? destination;

  final List<String> locations = [
    'Mbezi_beach', 'Makongo', 'Tabata Mwisho', 'Bunju', 'Bagamoyo', 'Ubungo',
    'Kimara', 'Posta_mpya', 'Mwenge', 'Morocco', 'Mbagala_rangi_tatu', 'Sinza',
    'Mpakani', 'Kawe', 'Tangi_bovu', 'Goba', 'Aziz_ally', 'Uhasibu', 'Kigamboni',
    'Kariakoo', 'Buguruni', 'Taifa', 'Ilala_boma', 'Kigogo', 'Manzese'
  ];

  Future<void> placeOrder() async {
    var url = Uri.parse('http://localhost/uberClone/apis/placeOrder.php');

    var orderData = {
      'category': categoryController.text,
      'fullName': fullNameController.text,
      'currently_place': currentlyPlace,
      'phone': phoneController.text,
      'destination': destination,
    };

    try {
      var response = await http.post(url, body: orderData);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          showSuccessDialog(data['message']);
          _formKey.currentState?.reset();
        } else {
          showErrorDialog(data['message'] ?? "Failed to place order");
        }
      } else {
        showErrorDialog("Failed to place order with status code: ${response.statusCode}");
      }
    } catch (e) {
      if (e is FormatException) {
        showErrorDialog("Invalid JSON format");
      } else {
        showErrorDialog("Error occurred: $e");
      }
    }
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
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

  void showErrorDialog(String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.lock_reset),
              title: Text('Password Reset'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordResetPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/vehclemg.png'),
              Text(
                'Place Order Now',
                style: TextStyle(fontSize: 20.0, color: Colors.blue),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: categoryController,
                        decoration: InputDecoration(labelText: 'Category'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter category';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(labelText: 'Full Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(labelText: 'Contact/Phone number'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: currentlyPlace,
                        decoration: InputDecoration(labelText: 'Current Place'),
                        items: locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            currentlyPlace = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select current place';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: destination,
                        decoration: InputDecoration(labelText: 'Destination'),
                        items: locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            destination = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select destination';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            placeOrder();
                          }
                        },
                        child: Text('Submit Order'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PlaceOrder(),
  ));
}
