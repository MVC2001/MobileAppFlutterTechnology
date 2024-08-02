import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clientapp/screens/Auth.dart';

void main() {
  runApp(MaterialApp(
    home: Register(),
  ));
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? currentlyPlace;

  final List<String> locations = [
    'Mbezi_beach', 'Makongo', 'Tabata Mwisho', 'Bunju', 'Bagamoyo', 'Ubungo',
    'Kimara', 'Posta_mpya', 'Mwenge', 'Morocco', 'Mbagala_rangi_tatu', 'Sinza',
    'Mpakani', 'Kawe', 'Tangi_bovu', 'Goba', 'Aziz_ally', 'Uhasibu', 'Kigamboni',
    'Kariakoo', 'Buguruni', 'Taifa', 'Ilala_boma', 'Kigogo', 'Manzese'
  ];

  Future<void> registerUser(BuildContext context) async {
    final String fullName = fullNameController.text.trim();
    final String phone = phoneController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String city = cityController.text.trim();
    final String vehicleName = vehicleNameController.text.trim();
    final String licensePlate = licensePlateController.text.trim();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      var url = Uri.parse('http://localhost/uberClone/driver_apis/registration.php');
      var response = await http.post(
        url,
        body: {
          'fullName': fullName,
          'phone': phone,
          'currently_place': currentlyPlace,
          'email': email,
          'password': password,
          'city': city,
          'vehicle_name': vehicleName,
          'license_plate': licensePlate,
        },
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String message = data["message"];

        Fluttertoast.showToast(
          msg: message,
          textColor: Colors.black,
        );

        if (message == "Registration Successful") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Auth()),
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "An error occurred: ${response.reasonPhrase}",
          textColor: Colors.black,
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "An error occurred: $error",
        textColor: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Driver Registration Page"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 60.0),
                  buildTextField(fullNameController, 'Full Name', 'Enter your full name'),
                  SizedBox(height: 15),
                  buildTextField(phoneController, 'Phone', 'Enter your phone number', keyboardType: TextInputType.phone),
                  SizedBox(height: 15),
                  buildDropdown(),
                  SizedBox(height: 15),
                  buildTextField(emailController, 'Email', 'Enter your email', validator: validateEmail),
                  SizedBox(height: 15),
                  buildTextField(passwordController, 'Password', 'Enter secure password', obscureText: true),
                  SizedBox(height: 15),
                  buildTextField(cityController, 'City', 'Enter your city'),
                  SizedBox(height: 15),
                  buildTextField(vehicleNameController, 'Vehicle Name', 'Enter your vehicle name'),
                  SizedBox(height: 15),
                  buildTextField(licensePlateController, 'License Plate', 'Enter your license plate number'),
                  SizedBox(height: 15),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () => registerUser(context),
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, String hint,
      {bool obscureText = false, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue), // Label text color
          hintText: hint,
        ),
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDropdown() {
    return Container(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: currentlyPlace,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelText: 'Currently Place',
          labelStyle: TextStyle(color: Colors.blue), // Label text color
        ),
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
            return 'Please select your current place';
          }
          return null;
        },
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Invalid email';
    }
    return null;
  }
}
