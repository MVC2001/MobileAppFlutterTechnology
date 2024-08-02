import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: PasswordResetPage(),
  ));
}

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> resetPassword(BuildContext context) async {
    final String email = emailController.text.trim();
    final String oldPassword = oldPasswordController.text.trim();
    final String newPassword = newPasswordController.text.trim();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      var url = Uri.parse('http://localhost/uberClone/apis/reset_password.php');
      var response = await http.post(
        url,
        body: {
          'email': email,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String message = data;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Password Reset"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (message == "Password reset successful") {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(context, "An error occurred: ${response.reasonPhrase}");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, "An error occurred: $error");
    }
  }

  void showErrorDialog(BuildContext context, String message) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Password Reset Page"),
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
                        child: Image.asset('assets/images/flutter-logo.png'),
                      ),
                    ),
                  ),
                  buildTextField(emailController, 'Email', 'Enter your email', validator: validateEmail),
                  SizedBox(height: 15),
                  buildTextField(oldPasswordController, 'Old Password', 'Enter your old password', obscureText: true),
                  SizedBox(height: 15),
                  buildTextField(newPasswordController, 'New Password', 'Enter your new password', obscureText: true),
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
                      onPressed: () => resetPassword(context),
                      child: Text(
                        'Reset Password',
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

  Widget buildTextField(TextEditingController controller, String label, String hint, {bool obscureText = false, String? Function(String?)? validator}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Invalid email';
    }
    return null;
  }
}
