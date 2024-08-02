import 'package:clientapp/screens/Register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'HomePage.dart';

void main() {
  runApp(Auth());
}

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> loginUser(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      var url = Uri.parse('http://localhost/uberClone/driver_apis/login.php');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "Success") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('user_id', data['user_id']);
          prefs.setString('user_email', data['email']);

          Fluttertoast.showToast(
            msg: "Login Successful",
            textColor: Colors.black,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userEmail: '',)),
          );
        } else {
          Fluttertoast.showToast(
            msg: data['message'] ?? "Unknown error occurred",
            textColor: Colors.black,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to connect to server",
          textColor: Colors.black,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Exception occurred: $error",
        textColor: Colors.black,
      );
      print("Exception occurred: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "DRIVER APP",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 10.0,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 150,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.blue),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.blue),
                        hintText: 'Enter valid email id as abc@gmail.com',
                        hintStyle: TextStyle(color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.blue),
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.blue),
                        hintText: 'Enter secure password',
                        hintStyle: TextStyle(color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ),
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
                      onPressed: () => loginUser(context),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
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
}
