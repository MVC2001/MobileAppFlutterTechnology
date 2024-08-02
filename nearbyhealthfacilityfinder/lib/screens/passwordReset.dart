import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _updatePassword(BuildContext context) async {
    final String email = _emailController.text;
    final String currentPassword = _currentPasswordController.text;
    final String newPassword = _newPasswordController.text;

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/update-passwordv1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Password updated successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password updated successfully'),
      ));
      // Navigate back to the dashboard or wherever you want
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      // Unauthorized or incorrect current password
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unauthorized or incorrect current password'),
      ));
    } else {
      // Other errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update password: ${response.statusCode}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updatePassword(context);
              },
              child: Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}
